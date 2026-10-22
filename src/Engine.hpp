#pragma once
#include "Parameters.hpp"
#include "Sample.hpp"
#include <array>
#include <cstdint>
namespace compass {
struct Head {
  double pos = 0, lo = 0, hi = 32, rate = 1, smooth = 20;
};
class Engine {
  const Sample *sample = nullptr;
  double sr = 48000;
  Head head, old, pending;
  bool fading = false, queued = false;
  double fade = 1, fadeInc = 1;
  double beatLeft = 0, regionLo = 0, regionHi = 32, gain = 0, gate = 0, pan = 0, targetPan = 0;
  unsigned rng = 1234;
  int step = -1, division = 4;
  bool wasPlaying = false;
  uint64_t expectedFrame = 0;
  std::array<float, ActiveStep> params{};
  double unit() { return double(randomNext(rng)) / 4294967296.0; }
  double read(const std::vector<float> &v, double p) const {
    p = std::max(0.0, std::min(double(v.size() - 1), p));
    size_t i = size_t(p);
    double f = p - i;
    return v[i] * (1 - f) + v[std::min(i + 1, v.size() - 1)] * f;
  }
  double seam(const Head &h) const {
    return std::min((h.hi - h.lo) * .24,
                    h.smooth * .001 * sample->rate * std::max(.5, std::abs(h.rate)));
  }
  double value(const Head &h, const std::vector<float> &v) const {
    const double n = std::max(1.0, seam(h));
    if (h.rate >= 0 && h.pos >= h.hi - n) {
      double t = (h.pos - (h.hi - n)) / n;
      return read(v, h.pos) * (1 - t) + read(v, h.lo + h.pos - (h.hi - n)) * t;
    }
    if (h.rate < 0 && h.pos < h.lo + n) {
      double t = (h.lo + n - h.pos) / n;
      return read(v, h.pos) * (1 - t) + read(v, h.hi - n + (h.pos - h.lo)) * t;
    }
    return read(v, h.pos);
  }
  void advance(Head &h) {
    h.pos += h.rate * sample->rate / sr;
    const double n = std::max(1.0, seam(h)), period = h.hi - h.lo - n;
    if (h.rate >= 0 && h.pos >= h.hi)
      h.pos = h.lo + n + std::fmod(h.pos - h.hi, period);
    if (h.rate < 0 && h.pos < h.lo) {
      double d = std::fmod(h.lo - h.pos, period);
      h.pos = h.hi - n - d;
    }
    h.pos = std::max(h.lo, std::min(h.hi - 1e-7, h.pos));
  }
  void transition(Head h) {
    h.smooth = params[Smooth];
    h.pos = std::max(h.lo, std::min(h.hi - 1e-7, h.pos));
    if (fading) {
      pending = h;
      queued = true;
      return;
    }
    old = head;
    head = h;
    fade = 0;
    fadeInc = 1 / std::max(1.0, sr * params[Smooth] * .001);
    fading = true;
  }

public:
  Engine() {
    for (unsigned i = 0; i < ActiveStep; ++i)
      params[i] = initial(i);
  }
  void sampleRate(double x) { sr = std::max(8000.0, x); }
  void attach(const Sample *s) {
    sample = s;
    gate = 0;
    // A new file cannot inherit heads or queued regions from the previous buffer.
    const bool playing = wasPlaying;
    wasPlaying = false;
    reset();
    wasPlaying = playing;
  }
  void reset() {
    rng = unsigned(params[Seed]);
    step = -1;
    division = 1 << int(params[Division]);
    beatLeft = 0;
    targetPan = 0;
    if (!wasPlaying)
      pan = 0;
    computeRegion();
    Head h{regionLo, regionLo, regionHi, 1, params[Smooth]};
    if (sample && wasPlaying)
      transition(h);
    else {
      head = old = h;
      queued = false;
      fading = false;
      fade = 1;
    }
  }
  void computeRegion() {
    const double length = sample ? double(sample->size()) : 32;
    regionLo = std::min(length - 32, length * params[RegionStart] * .01);
    regionHi = std::max(regionLo + 32, std::min(length, length * params[RegionEnd] * .01));
  }
  void parameter(unsigned id, float v) {
    if (id >= ActiveStep)
      return;
    v = sanitize(id, v);
    if (params[id] == v)
      return;
    params[id] = v;
    if (id == RegionStart || id == RegionEnd) {
      computeRegion();
      Head h = head;
      h.lo = regionLo;
      h.hi = regionHi;
      h.pos = std::max(h.lo, std::min(h.hi - 1, h.pos));
      transition(h);
    }
    if (id == Smooth)
      transition(head);
    if (id == Division)
      division = 1 << int(v);
    if (id == Seed)
      rng = unsigned(v);
    if (id == Reset)
      reset();
  }
  void command(int cmd) {
    Head h = queued ? pending : head;
    static constexpr double rates[] = {-2, -1, -.5, .5, 1, 2};
    int index = 0;
    for (int i = 0; i < 6; ++i)
      if (std::abs(rates[i] - h.rate) < 1e-6)
        index = i;
    switch (cmd) {
    case Forward:
      h.rate = 1;
      break;
    case Reverse:
      h.rate = -1;
      break;
    case RateUp:
      h.rate = rates[std::min(index + 1, 5)];
      break;
    case RateDown:
      h.rate = rates[std::max(index - 1, 0)];
      break;
    case RateRandom:
      h.rate = rates[randomNext(rng) % 6];
      break;
    case Start:
      h.pos = h.rate >= 0 ? h.lo : h.hi - 1;
      break;
    case Position:
      h.pos = h.lo + unit() * (h.hi - h.lo - 1);
      break;
    case Loop: {
      double minLength =
          std::min(regionHi - regionLo, std::max(32.0, sample ? sample->rate * .04 : 32.0));
      h.lo = regionLo + unit() * std::max(0.0, regionHi - regionLo - minLength);
      h.hi = h.lo + minLength + unit() * std::max(0.0, regionHi - h.lo - minLength);
      h.pos = h.rate >= 0 ? h.lo : h.hi - 1;
      break;
    }
    case ClockUp:
      division = std::min(16, division * 2);
      return;
    case ClockDown:
      division = std::max(1, division / 2);
      return;
    case ClockFast:
      division = 16;
      return;
    case ClockSlow:
      division = 1;
      return;
    case StepRandom:
      step = int(randomNext(rng) % unsigned(params[Steps]));
      return;
    case PanLeft:
      targetPan = -unit() * .8;
      return;
    case PanRight:
      targetPan = unit() * .8;
      return;
    default:
      return;
    }
    transition(h);
  }
  void render(float *l, float *r, unsigned frames, bool hostPlaying, uint64_t hostFrame,
              double bpm) {
    bool playing = hostPlaying || params[FreePlay] > .5f;
    if (!std::isfinite(bpm) || bpm < 20 || bpm > 400)
      bpm = 120;
    if (playing && (!wasPlaying || (hostPlaying && hostFrame != expectedFrame)))
      reset();
    wasPlaying = playing;
    expectedFrame = hostFrame + frames;
    double beatDelta = bpm / (60 * sr), slew = 1 - std::exp(-1 / (sr * .005));
    double targetGain = params[Output] <= -60 ? 0 : std::pow(10., params[Output] / 20.);
    for (unsigned i = 0; i < frames; ++i) {
      gain += (targetGain - gain) * slew;
      gate += ((playing && sample ? 1. : 0.) - gate) * slew;
      pan += (targetPan - pan) * slew;
      l[i] = r[i] = 0;
      if (!sample)
        continue;
      if (playing) {
        if (beatLeft <= 1e-10) {
          step = (step + 1) % int(params[Steps]);
          command(int(params[Step0 + step]));
          beatLeft += 1. / division;
        }
        beatLeft -= beatDelta;
      }
      double a = value(head, sample->left), b = value(head, sample->right);
      if (fading) {
        a = a * fade + value(old, sample->left) * (1 - fade);
        b = b * fade + value(old, sample->right) * (1 - fade);
        advance(old);
        fade = std::min(1., fade + fadeInc);
        if (fade >= 1) {
          fading = false;
        }
      }
      advance(head);
      l[i] = float(a * gain * gate * (pan > 0 ? 1 - pan : 1));
      r[i] = float(b * gain * gate * (pan < 0 ? 1 + pan : 1));
      if (!fading && queued) {
        Head h = pending;
        queued = false;
        transition(h);
      }
    }
  }
  int activeStep() const { return step; }
  int clockDivision() const { return division; }
  double rate() const { return head.rate; }
  double position() const { return sample ? head.pos / sample->size() : 0; }
  double loopStart() const { return head.lo; }
  double loopEnd() const { return head.hi; }
};
} // namespace compass
