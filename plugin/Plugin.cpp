#include "DistrhoPlugin.hpp"
#include "Engine.hpp"
#include <atomic>
#include <chrono>
#include <mutex>
#include <thread>
START_NAMESPACE_DISTRHO
class StepCompassPlugin : public Plugin {
  compass::Engine engine;
  std::array<std::atomic<float>, compass::Count> values;
  // Ownership: pending -> audio current -> retired -> non-audio deletion.
  // Audio never frees samples or reads files. A nonempty retired slot postpones a swap.
  std::atomic<compass::Sample *> pending{nullptr}, retired{nullptr};
  compass::Sample *current = nullptr;
  std::mutex stateMutex;
  std::string path;
  double loadGain = 1;
  std::atomic<bool> quitting{false};
  std::thread collector;

public:
  StepCompassPlugin() : Plugin(compass::Count, 0, 1) {
    for (unsigned i = 0; i < compass::Count; ++i)
      values[i] = compass::initial(i);
    engine.sampleRate(getSampleRate());
    collector = std::thread([this] {
      while (!quitting.load()) {
        delete retired.exchange(nullptr);
        std::this_thread::sleep_for(std::chrono::milliseconds(10));
      }
    });
  }
  ~StepCompassPlugin() override {
    quitting = true;
    collector.join();
    delete pending.load();
    delete retired.load();
    delete current;
  }
  const char *getLabel() const override { return "StepCompass"; }
  const char *getDescription() const override {
    return "Sample-only command sequencer. Independent implementation inspired by Compass for "
           "norns.";
  }
  const char *getMaker() const override { return "StepCompass contributors"; }
  const char *getLicense() const override { return "MIT / ISC"; }
  uint32_t getVersion() const override { return d_version(0, 1, 0); }
  void initAudioPort(bool input, uint32_t index, AudioPort &p) override {
    p.groupId = kPortGroupStereo;
    Plugin::initAudioPort(input, index, p);
  }
  void initParameter(uint32_t id, Parameter &p) override {
    using namespace compass;
    p.hints = kParameterIsAutomatable;
    if (id < Step0) {
      const auto &s = specs[id];
      p.name = s.name;
      p.symbol = s.symbol;
      p.ranges = {s.initial, s.min, s.max};
      if (s.integer)
        p.hints |= kParameterIsInteger;
    } else if (id < Pool0) {
      p.name = String("Step ") + String(id - Step0 + 1);
      p.symbol = String("step_") + String(id - Step0 + 1);
      p.ranges = {initial(id), 0, CommandCount - 1};
      p.hints |= kParameterIsInteger;
      p.enumValues.count = CommandCount;
      p.enumValues.restrictedMode = true;
      p.enumValues.values = new ParameterEnumerationValue[CommandCount];
      for (int i = 0; i < CommandCount; ++i) {
        p.enumValues.values[i].value = i;
        p.enumValues.values[i].label = commandNames[i];
      }
    } else if (id < ActiveStep) {
      p.name = String("Random pool: ") + commandNames[id - Pool0];
      p.symbol = String("pool_") + String(id - Pool0);
      p.ranges = {1, 0, 1};
      p.hints |= kParameterIsBoolean | kParameterIsInteger;
    } else {
      const char *names[] = {"Active step", "Active rate", "Active division", "Playhead",
                             "Sample ready"};
      const char *symbols[] = {"active_step", "active_rate", "active_division", "playhead",
                               "sample_ready"};
      p.name = names[id - ActiveStep];
      p.symbol = symbols[id - ActiveStep];
      p.hints = kParameterIsOutput;
      p.ranges = {0, -2, 100};
    }
  }
  float getParameterValue(uint32_t id) const override {
    return id < compass::Count ? values[id].load() : 0;
  }
  void setParameterValue(uint32_t id, float v) override {
    if (id < compass::ActiveStep)
      values[id] = compass::sanitize(id, v);
  }
  void initState(uint32_t, State &s) override {
    s.key = "sample";
    s.label = "Sample WAV / AIFF";
    s.hints = kStateIsFilenamePath;
  }
  String getState(const char *key) const override {
    return std::strcmp(key, "sample") == 0 ? const_cast<StepCompassPlugin *>(this)->savedPath()
                                           : String();
  }
  String savedPath() {
    std::lock_guard<std::mutex> lock(stateMutex);
    return String(path.c_str());
  }
  void setState(const char *key, const char *value) override {
    if (std::strcmp(key, "sample"))
      return;
    std::lock_guard<std::mutex> lock(stateMutex);
    std::unique_ptr<compass::Sample> s;
    try {
      if (value && *value)
        s = compass::Sample::load(value);
    } catch (const std::exception &) {
    }
    if (!s)
      s.reset(new compass::Sample);
    path = value ? value : "";
    delete retired.exchange(nullptr);
    delete pending.exchange(s.release());
  }
  void sampleRateChanged(double rate) override { engine.sampleRate(rate); }
  void activate() override {
    engine.sampleRate(getSampleRate());
    engine.reset();
  }
  void run(const float **, float **out, uint32_t frames, const MidiEvent *, uint32_t) override {
    for (unsigned i = 0; i < compass::ActiveStep; ++i)
      engine.parameter(i, values[i].load());
    if (pending.load() && loadGain <= 0 && !retired.load()) {
      if (auto *s = pending.exchange(nullptr)) {
        retired.store(current);
        current = s;
        engine.attach(s->size() ? s : nullptr);
        values[compass::Loaded] = s->size() ? 1 : 0;
      }
    }
    const auto &t = getTimePosition();
    engine.render(out[0], out[1], frames, t.playing, t.frame,
                  t.bbt.valid ? t.bbt.beatsPerMinute : 120);
    const bool replacing = pending.load() != nullptr;
    const double ramp = 1. / std::max(1., getSampleRate() * .02);
    for (unsigned i = 0; i < frames; ++i) {
      loadGain = std::max(0., std::min(1., loadGain + (replacing ? -ramp : ramp)));
      out[0][i] *= loadGain;
      out[1][i] *= loadGain;
    }
    values[compass::ActiveStep] = float(engine.activeStep() + 1);
    values[compass::ActiveRate] = float(engine.rate());
    values[compass::ActiveDivision] = float(engine.clockDivision());
    values[compass::Playhead] = float(engine.position() * 100);
  }
};
Plugin *createPlugin() {
  return new StepCompassPlugin;
}
END_NAMESPACE_DISTRHO
