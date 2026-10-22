#pragma once
#include <algorithm>
#include <cmath>
#include <cstdint>
#include <cstring>
#include <fstream>
#include <memory>
#include <stdexcept>
#include <string>
#include <vector>
namespace compass {
struct Sample {
  double rate = 48000;
  std::vector<float> left, right;
  std::string path;
  size_t size() const { return left.size(); }
  static std::unique_ptr<Sample> load(const std::string &path) {
    std::ifstream f(path, std::ios::binary | std::ios::ate);
    if (!f)
      throw std::runtime_error("Cannot open sample. Locate the original WAV or AIFF.");
    auto length = f.tellg();
    if (length < 12 || length > 128 * 1024 * 1024)
      throw std::runtime_error("Invalid file or larger than 128 MB.");
    std::vector<uint8_t> b(static_cast<size_t>(length));
    f.seekg(0);
    if (!f.read(reinterpret_cast<char *>(b.data()), b.size()))
      throw std::runtime_error("Cannot read sample.");
    auto match = [&](size_t p, const char *x) {
      return p + 4 <= b.size() && std::memcmp(b.data() + p, x, 4) == 0;
    };
    bool wav = match(0, "RIFF") && match(8, "WAVE"),
         aiff = match(0, "FORM") && (match(8, "AIFF") || match(8, "AIFC"));
    if (!wav && !aiff)
      throw std::runtime_error("Use PCM WAV / AIFF, or floating-point WAV.");
    auto number = [&](size_t p, unsigned bytes, bool little) -> uint64_t {
      if (p > b.size() || bytes > b.size() - p)
        throw std::runtime_error("Truncated audio file.");
      uint64_t n = 0;
      for (unsigned i = 0; i < bytes; ++i)
        n = (n << 8) | b[p + (little ? bytes - 1 - i : i)];
      return n;
    };
    size_t end = size_t(number(4, 4, wav)) + 8;
    if (end > b.size() || end < 12)
      throw std::runtime_error("Truncated audio container.");
    size_t fmt = 0, fmtSize = 0, data = 0, dataSize = 0;
    for (size_t p = 12; p + 8 <= end;) {
      size_t n = size_t(number(p + 4, 4, wav));
      if (n > end - p - 8)
        throw std::runtime_error("Truncated audio chunk.");
      if ((wav && match(p, "fmt ")) || (aiff && match(p, "COMM"))) {
        fmt = p + 8;
        fmtSize = n;
      }
      if ((wav && match(p, "data")) || (aiff && match(p, "SSND"))) {
        data = p + 8;
        dataSize = n;
      }
      p += 8 + n + (n & 1);
    }
    if (!fmt || !data)
      throw std::runtime_error("Missing audio format or data.");
    unsigned channels = 0, bits = 0, stride = 0;
    double rate = 0;
    bool floating = false, little = wav;
    size_t frames = 0;
    if (wav) {
      if (fmtSize < 16)
        throw std::runtime_error("Invalid WAV header.");
      unsigned format = unsigned(number(fmt, 2, true));
      channels = unsigned(number(fmt + 2, 2, true));
      rate = double(number(fmt + 4, 4, true));
      stride = unsigned(number(fmt + 12, 2, true));
      bits = unsigned(number(fmt + 14, 2, true));
      if (format == 65534 && fmtSize >= 40) {
        static const uint8_t guidTail[] = {0, 0, 0,    0, 0x10, 0,    0x80,
                                           0, 0, 0xaa, 0, 0x38, 0x9b, 0x71};
        if (std::memcmp(b.data() + fmt + 26, guidTail, 14) != 0 ||
            number(fmt + 18, 2, true) != bits)
          throw std::runtime_error("Unsupported extensible WAV format.");
        format = unsigned(number(fmt + 24, 2, true));
      }
      if (format != 1 && format != 3)
        throw std::runtime_error("Compressed WAV is unsupported. Export PCM WAV.");
      floating = format == 3;
    } else {
      if (fmtSize < 18 || dataSize < 8)
        throw std::runtime_error("Invalid AIFF header.");
      channels = unsigned(number(fmt, 2, false));
      frames = size_t(number(fmt + 2, 4, false));
      bits = unsigned(number(fmt + 6, 2, false));
      unsigned exponent = unsigned(number(fmt + 8, 2, false));
      uint64_t mantissa = number(fmt + 10, 8, false);
      if (exponent & 0x8000)
        throw std::runtime_error("Invalid AIFF rate.");
      rate = std::ldexp(double(mantissa), int(exponent) - 16383 - 63);
      if (match(8, "AIFC")) {
        if (fmtSize < 22)
          throw std::runtime_error("Invalid AIFC header.");
        if (match(fmt + 18, "sowt"))
          little = true;
        else if (match(fmt + 18, "fl32") || match(fmt + 18, "FL32")) {
          floating = true;
          bits = 32;
        } else if (match(fmt + 18, "fl64") || match(fmt + 18, "FL64")) {
          floating = true;
          bits = 64;
        } else if (!match(fmt + 18, "NONE"))
          throw std::runtime_error("Compressed AIFF is unsupported.");
      }
      size_t offset = size_t(number(data, 4, false));
      if (offset > dataSize - 8)
        throw std::runtime_error("Invalid AIFF offset.");
      data += 8 + offset;
      dataSize -= 8 + offset;
      stride = channels * ((bits + 7) / 8);
    }
    if (channels < 1 || channels > 2 || !std::isfinite(rate) || rate < 8000 || rate > 384000 ||
        (floating ? (bits != 32 && bits != 64)
                  : (bits != 8 && bits != 16 && bits != 24 && bits != 32)) ||
        stride != channels * (bits / 8))
      throw std::runtime_error("Use mono/stereo PCM 8/16/24/32-bit or float 32/64-bit, 8-384 kHz.");
    if (wav)
      frames = dataSize / stride;
    if (frames < 32 || frames > dataSize / stride)
      throw std::runtime_error("Invalid sample length (minimum 32 frames).");
    auto s = std::unique_ptr<Sample>(new Sample);
    s->rate = rate;
    s->path = path;
    s->left.resize(frames);
    s->right.resize(frames);
    for (size_t i = 0; i < frames; ++i) {
      float values[2]{};
      for (unsigned c = 0; c < channels; ++c) {
        uint64_t raw = number(data + i * stride + c * (bits / 8), bits / 8, little);
        double value;
        if (floating) {
          if (bits == 32) {
            uint32_t n = uint32_t(raw);
            float x;
            std::memcpy(&x, &n, 4);
            value = x;
          } else {
            double x;
            std::memcpy(&x, &raw, 8);
            value = x;
          }
        } else if (wav && bits == 8)
          value = (int(raw) - 128) / 128.;
        else {
          int64_t n = int64_t(raw);
          if (raw & (uint64_t(1) << (bits - 1)))
            n -= int64_t(uint64_t(1) << bits);
          value = double(n) / double(uint64_t(1) << (bits - 1));
        }
        values[c] = std::isfinite(value) ? float(std::max(-1., std::min(1., value))) : 0;
      }
      s->left[i] = values[0];
      s->right[i] = values[channels - 1];
    }
    return s;
  }
};
} // namespace compass
