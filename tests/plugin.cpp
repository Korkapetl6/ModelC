#include "../plugin/Plugin.cpp"
#include <cassert>
#include <iostream>
namespace DISTRHO {
extern double d_nextSampleRate;
extern uint32_t d_nextBufferSize;
} // namespace DISTRHO
int main() {
  using namespace compass;
  DISTRHO::d_nextSampleRate = 48000;
  DISTRHO::d_nextBufferSize = 128;
  DISTRHO::StepCompassPlugin p;
  float l[128]{}, r[128]{};
  float *out[] = {l, r};
  p.setParameterValue(FreePlay, 1);
  p.setState("sample", "build/fixture16_2.wav");
  double sum = 0;
  for (int n = 0; n < 200; ++n) {
    p.run(nullptr, out, 128, nullptr, 0);
    for (float x : l) {
      assert(std::isfinite(x));
      sum += std::abs(x);
    }
  }
  assert(sum > 1 && p.getParameterValue(Loaded) == 1);
  assert(p.getState("sample") == "build/fixture16_2.wav");
  // Reload while the audio callback runs. This exercises pending/retired ownership.
  std::atomic<bool> done{false};
  std::thread audio([&] {
    while (!done) {
      p.run(nullptr, out, 128, nullptr, 0);
      for (float x : l)
        assert(std::isfinite(x));
    }
  });
  for (int i = 0; i < 80; ++i) {
    p.setState("sample", i % 2 ? "build/fixture24_1.aiff" : "build/fixture16_2.wav");
    p.setParameterValue(Step0, i % CommandCount);
  }
  done = true;
  audio.join();
  for (int n = 0; n < 30; ++n) {
    p.run(nullptr, out, 128, nullptr, 0);
    std::this_thread::sleep_for(std::chrono::milliseconds(1));
  }
  p.setState("sample", "build/not-present.wav");
  for (int n = 0; n < 200; ++n)
    p.run(nullptr, out, 128, nullptr, 0);
  assert(p.getParameterValue(Loaded) == 0);
  for (float x : l)
    assert(x == 0);
  std::cout << "PASS: plugin output, state, concurrent reloads, missing sample silence\n";
}
