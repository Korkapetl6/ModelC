#pragma once
#include <algorithm>
#include <cmath>
namespace compass {
enum Command {
  Hold,
  Forward,
  Reverse,
  RateUp,
  RateDown,
  RateRandom,
  Start,
  Position,
  Loop,
  ClockUp,
  ClockDown,
  ClockFast,
  ClockSlow,
  StepRandom,
  PanLeft,
  PanRight,
  CommandCount
};
static const char *const commandNames[] = {
    "Hold",          "Forward",     "Reverse",     "Rate +",   "Rate -",  "Rate random",
    "Loop start",    "Position",    "Loop random", "Clock +",  "Clock -", "Clock fastest",
    "Clock slowest", "Step random", "Pan left",    "Pan right"};
static const char *const commandShort[] = {"--",   "FWD",   "REV",   "R+",   "R-", "R?",
                                           "HOME", "POS?",  "LOOP?", "C+",   "C-", "C16",
                                           "C1",   "STEP?", "PAN L", "PAN R"};
enum Param {
  RegionStart,
  RegionEnd,
  Smooth,
  Output,
  Steps,
  Division,
  FreePlay,
  Seed,
  Reset,
  Step0,
  Pool0 = Step0 + 16,
  ActiveStep = Pool0 + CommandCount,
  ActiveRate,
  ActiveDivision,
  Playhead,
  Loaded,
  Count
};
struct Spec {
  const char *name;
  const char *symbol;
  float min, max, initial;
  bool integer;
};
static const Spec specs[] = {{"Region start", "region_start", 0, 99.9f, 0, false},
                             {"Region end", "region_end", .1f, 100, 100, false},
                             {"Crossfade ms", "crossfade", 1, 100, 20, false},
                             {"Output dB", "output", -60, 6, -6, false},
                             {"Steps", "steps", 1, 16, 16, true},
                             {"Clock division", "division", 0, 4, 2, true},
                             {"Free play", "free_play", 0, 1, 0, true},
                             {"Random seed", "seed", 1, 65535, 1234, true},
                             {"Reset trigger", "reset", 0, 65535, 0, true}};
inline float sanitize(unsigned id, float v) {
  if (!std::isfinite(v))
    v = 0;
  if (id < Step0) {
    const auto &s = specs[id];
    v = std::max(s.min, std::min(s.max, v));
    return s.integer ? std::round(v) : v;
  }
  if (id < Pool0)
    return std::round(std::max(0.f, std::min(float(CommandCount - 1), v)));
  return v >= .5f ? 1.f : 0.f;
}
inline float initial(unsigned id) {
  return id < Step0 ? specs[id].initial
                    : (id == Step0 ? Forward : (id >= Pool0 && id < ActiveStep ? 1 : 0));
}
inline unsigned randomNext(unsigned &s) {
  s ^= s << 13;
  s ^= s >> 17;
  s ^= s << 5;
  return s;
}
} // namespace compass
