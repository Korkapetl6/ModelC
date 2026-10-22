#include "../third_party/AudioFile.h"
#include "Engine.hpp"
#include <cassert>
#include <iostream>
#include <limits>
using namespace compass;
Sample constant(size_t n = 48000) {
  Sample s;
  s.left.assign(n, .5f);
  s.right.assign(n, -.25f);
  return s;
}
void block(Engine &e, unsigned n = 128, bool play = true, uint64_t frame = 0, double bpm = 120) {
  std::vector<float> l(n), r(n);
  e.render(l.data(), r.data(), n, play, frame, bpm);
  for (unsigned i = 0; i < n; ++i) {
    assert(std::isfinite(l[i]) && std::isfinite(r[i]));
    assert(std::abs(l[i]) <= 2.01 && std::abs(r[i]) <= 2.01);
  }
}
int main() {
  // WAV / AIFF, mono duplication, channel order, different rates, invalid chunks.
  for (auto format : {AudioFileFormat::Wave, AudioFileFormat::Aiff})
    for (int bits : {8, 16, 24, 32})
      for (int channels : {1, 2}) {
        AudioFile<float> a;
        a.setAudioBufferSize(channels, 400);
        a.setSampleRate(44100);
        a.setBitDepth(bits);
        for (int i = 0; i < 400; ++i) {
          a.samples[0][i] = .5f;
          if (channels == 2)
            a.samples[1][i] = -.25f;
        }
        std::string file = "build/fixture" + std::to_string(bits) + "_" + std::to_string(channels) +
                           (format == AudioFileFormat::Wave ? ".wav" : ".aiff");
        assert(a.save(file, format));
        auto s = Sample::load(file);
        assert(s->rate == 44100 && s->size() == 400);
        assert(std::abs(s->left[123] - .5) < .01);
        assert(std::abs(s->right[123] - (channels == 2 ? -.25 : .5)) < .01);
      }
  {
    std::ifstream in("build/fixture16_2.wav", std::ios::binary);
    std::vector<char> bytes((std::istreambuf_iterator<char>(in)), {});
    for (size_t n = 0; n < bytes.size(); n += 13) {
      std::ofstream out("build/truncated.wav", std::ios::binary);
      out.write(bytes.data(), n);
      out.close();
      bool threw = false;
      try {
        Sample::load("build/truncated.wav");
      } catch (...) {
        threw = true;
      }
      assert(threw);
    }
  }
  std::cout << "PASS: 16 WAV/AIFF format fixtures, channels, rate and truncated-file rejection\n";
  Sample s = constant();
  Engine e;
  e.attach(&s);
  float l[48000]{}, r[48000]{};
  e.render(l, r, 48000, false, 0, 120);
  for (float x : l)
    assert(x == 0);
  e.parameter(FreePlay, 1);
  e.render(l, r, 48000, false, 0, 120);
  assert(std::abs(l[47999] - .5 * std::pow(10., -6. / 20)) < 1e-5);
  assert(r[47999] < 0);
  e.parameter(FreePlay, 0);
  e.render(l, r, 48000, false, 0, 120);
  assert(std::abs(l[47999]) < 1e-7);
  std::cout << "PASS: stopped silence, Free Play, output gain and stereo preservation\n";
  Engine clock;
  clock.attach(&s);
  block(clock, 1, true, 0);
  assert(clock.activeStep() == 0);
  block(clock, 5999, true, 1);
  block(clock, 1, true, 6000);
  assert(clock.activeStep() == 1);
  block(clock, 1, true, 0);
  assert(clock.activeStep() == 0); // transport seek resets
  clock.parameter(Step0, ClockFast);
  clock.reset();
  block(clock, 1, true, 0);
  assert(clock.clockDivision() == 16);
  std::cout << "PASS: tempo clock, 1/4-beat spacing, transport seek and clock commands\n";
  // A ramp has a discontinuity of nearly 2 at the seam without overlap.
  Sample ramp;
  for (int i = 0; i < 4800; ++i) {
    ramp.left.push_back(float(i) / 2400 - 1);
    ramp.right.push_back(ramp.left.back());
  }
  for (double sr : {44100., 48000., 96000.})
    for (int direction : {Forward, Reverse}) {
      Engine x;
      x.sampleRate(sr);
      x.parameter(Output, 0);
      x.parameter(Smooth, 20);
      x.attach(&ramp);
      x.parameter(Step0, direction);
      std::vector<float> a(static_cast<size_t>(sr), 0), b(a.size());
      x.render(a.data(), b.data(), a.size(), true, 0, 120);
      double maxJump = 0;
      for (size_t i = size_t(sr * .1); i < a.size(); ++i)
        maxJump = std::max(maxJump, double(std::abs(a[i] - a[i - 1])));
      assert(maxJump < .02);
    }
  std::cout << "PASS: forward/reverse loop seam jumps <0.02 at 44.1/48/96 kHz (ramp fixture)\n";
  // Automation, short loops, repeated transitions, all commands and malformed controls.
  unsigned rng = 8923;
  for (double sr : {44100., 48000., 96000.}) {
    Engine x;
    x.sampleRate(sr);
    x.attach(&ramp);
    uint64_t f = 0;
    for (int n = 0; n < 1500; ++n) {
      x.parameter(RegionStart, float(randomNext(rng) % 10000) / 100);
      x.parameter(RegionEnd, float(randomNext(rng) % 10000) / 100);
      x.parameter(Smooth, 1 + randomNext(rng) % 100);
      x.command(n % CommandCount);
      block(x, 64, true, f, 20 + randomNext(rng) % 381);
      f += 64;
      assert(x.loopStart() >= 0 && x.loopEnd() <= ramp.size());
    }
    x.parameter(Smooth, std::numeric_limits<float>::quiet_NaN());
    x.parameter(Steps, std::numeric_limits<float>::infinity());
    block(x);
  }
  {
    Engine reload;
    reload.attach(&s);
    block(reload);
    reload.command(Reverse);
    Sample tiny = constant(32);
    reload.attach(&tiny);
    assert(reload.loopStart() == 0 && reload.loopEnd() == 32 && reload.rate() == 1);
    block(reload, 128, true, 128);
    assert(reload.loopEnd() == 32);
    std::cout << "PASS: new short sample discards old heads and queued regions\n";
  }
  Engine a, b;
  a.attach(&ramp);
  b.attach(&ramp);
  for (int i = 0; i < 16; ++i) {
    a.parameter(Step0 + i, i);
    b.parameter(Step0 + i, i);
  }
  std::vector<float> a1(48000), a2(48000), b1(48000), b2(48000);
  a.render(a1.data(), a2.data(), 48000, true, 0, 140);
  b.render(b1.data(), b2.data(), 48000, true, 0, 140);
  assert(a1 == b1 && a2 == b2);
  std::cout << "PASS: 4500 automation/command blocks, bounds, finite output, deterministic seed\n";
}
