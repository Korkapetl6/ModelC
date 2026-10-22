#include "DistrhoUI.hpp"
#include "Drop.hpp"
#include "Parameters.hpp"
#include "Sample.hpp"
#include <array>
#include <cstdio>
START_NAMESPACE_DISTRHO
class StepCompassUI : public UI {
  std::array<float, compass::Count> v{};
  std::array<float, 456> peaks{};
  std::string status = "Load or drop a WAV / AIFF sample. Then press Play in Live.";
  bool hasWave = false;
  int selected = 0, drag = -1;
  float originY = 0, originValue = 0;
  void *drop = nullptr;
  void label(float x, float y, const char *text, float size = 13) {
    fontSize(size);
    fillColor(218, 228, 229);
    this->text(x, y, text, nullptr);
  }
  void box(float x, float y, float w, float h, bool active = false) {
    beginPath();
    roundedRect(x, y, w, h, 5);
    fillColor(active ? 62 : 40, active ? 125 : 47, active ? 112 : 54);
    fill();
  }
  void change(unsigned id, float x) {
    v[id] = compass::sanitize(id, x);
    setParameterValue(id, v[id]);
    repaint();
  }
  void clickChange(unsigned id, float x) {
    editParameter(id, true);
    change(id, x);
    editParameter(id, false);
  }
  static void dropped(void *self, const char *path) {
    static_cast<StepCompassUI *>(self)->choose(path);
  }
  void choose(const char *path) {
    if (!path || !*path)
      return;
    setState("sample", path);
    stateChanged("sample", path);
  }
  void randomize() {
    unsigned seed = unsigned(v[compass::Seed]);
    compass::randomNext(seed);
    seed = 1 + seed % 65535;
    clickChange(compass::Seed, float(seed));
    std::array<int, compass::CommandCount> pool{};
    int count = 0;
    for (int i = 0; i < compass::CommandCount; ++i)
      if (v[compass::Pool0 + i] > .5f)
        pool[count++] = i;
    if (!count) {
      status = "Random pool is empty. Enable at least one command below.";
      repaint();
      return;
    }
    for (int i = 0; i < 16; ++i)
      clickChange(compass::Step0 + i, float(pool[compass::randomNext(seed) % count]));
  }

public:
  StepCompassUI() : UI(960, 540) {
    loadSharedResources();
    for (unsigned i = 0; i < compass::Count; ++i)
      v[i] = compass::initial(i);
    drop = installDrop(getWindow().getNativeWindowHandle(), this, dropped);
  }
  ~StepCompassUI() override { removeDrop(drop); }
  void parameterChanged(uint32_t id, float x) override {
    if (id < compass::Count) {
      v[id] = id < compass::ActiveStep ? compass::sanitize(id, x) : (std::isfinite(x) ? x : 0);
      repaint();
    }
  }
  void stateChanged(const char *key, const char *path) override {
    if (std::strcmp(key, "sample"))
      return;
    hasWave = false;
    peaks.fill(0);
    if (!path || !*path) {
      status = "Load a WAV / AIFF sample.";
      repaint();
      return;
    }
    try {
      auto s = compass::Sample::load(path);
      for (unsigned i = 0; i < peaks.size(); ++i) {
        size_t a = i * s->size() / peaks.size(),
               b = std::max(a + 1, (i + 1) * s->size() / peaks.size());
        for (size_t j = a; j < std::min(b, s->size()); ++j)
          peaks[i] = std::max(peaks[i], std::max(std::abs(s->left[j]), std::abs(s->right[j])));
      }
      std::string name = path;
      auto n = name.find_last_of("/\\");
      if (n != std::string::npos)
        name = name.substr(n + 1);
      if (name.size() > 66)
        name = name.substr(0, 63) + "...";
      char detail[80];
      std::snprintf(detail, sizeof detail, " | %.2f s | %.0f Hz", s->size() / s->rate, s->rate);
      status = name + detail;
      hasWave = true;
    } catch (const std::exception &e) {
      status = e.what();
    }
    repaint();
  }
  void uiFileBrowserSelected(const char *name) override { choose(name); }
  void onNanoDisplay() override {
    using namespace compass;
    fontFace(NANOVG_DEJAVU_SANS_TTF);
    beginPath();
    rect(0, 0, 960, 540);
    fillColor(20, 24, 29);
    fill();
    label(24, 36, "STEP COMPASS", 24);
    label(24, 58, "Sample command sequencer / v0.1.0", 12);
    box(444, 20, 104, 32, v[FreePlay] > .5f);
    label(454, 41, v[FreePlay] > .5f ? "FREE PLAY" : "LIVE PLAY");
    box(560, 20, 110, 32);
    label(572, 41, "RANDOMIZE");
    box(682, 20, 92, 32);
    label(700, 41, "RESET");
    box(786, 20, 150, 32);
    label(810, 41, "LOAD SAMPLE");
    label(24, 83, status.c_str(), 12);
    box(24, 94, 912, 104);
    beginPath();
    for (unsigned i = 0; i < peaks.size(); ++i) {
      float x = 25 + 2 * i, y = std::max(.5f, peaks[i] * 46);
      moveTo(x, 146 - y);
      lineTo(x, 146 + y);
    }
    strokeColor(123, 158, 157);
    strokeWidth(1);
    stroke();
    float lo = 24 + 9.12f * v[RegionStart], hi = 24 + 9.12f * v[RegionEnd];
    beginPath();
    rect(lo, 94, std::max(1.f, hi - lo), 104);
    fillColor(80, 220, 180, 25);
    fill();
    beginPath();
    moveTo(lo, 94);
    lineTo(lo, 198);
    moveTo(hi, 94);
    lineTo(hi, 198);
    strokeColor(79, 218, 181);
    strokeWidth(2);
    stroke();
    if (hasWave && v[Loaded] > .5f) {
      float x = 24 + 9.12f * v[Playhead];
      beginPath();
      moveTo(x, 94);
      lineTo(x, 198);
      strokeColor(240, 240, 215);
      strokeWidth(1);
      stroke();
    }
    char info[180];
    std::snprintf(info, sizeof info,
                  "Click waveform near either region edge to move it.   Playing step: %.0f   Rate: "
                  "%.1fx   Clock: %.0f / beat",
                  v[ActiveStep], v[ActiveRate], v[ActiveDivision]);
    label(24, 216, info, 12);
    for (int i = 0; i < 16; ++i) {
      float x = 24 + i * 57;
      bool active = int(v[ActiveStep]) == i + 1;
      box(x, 230, 52, 62, i == selected);
      if (active) {
        beginPath();
        roundedRect(x + 1, 231, 50, 60, 5);
        strokeColor(100, 255, 190);
        strokeWidth(2);
        stroke();
      }
      char s[8];
      std::snprintf(s, sizeof s, "%02d", i + 1);
      label(x + 7, 250, s, 12);
      label(x + 4, 278, commandShort[int(v[Step0 + i])], 11);
      if (i >= int(v[Steps])) {
        beginPath();
        rect(x, 230, 52, 62);
        fillColor(20, 24, 29, 170);
        fill();
      }
    }
    std::snprintf(info, sizeof info,
                  "Editing step %d: click a command below. Right-click a step to clear it. Small "
                  "squares select the random pool.",
                  selected + 1);
    label(24, 316, info, 12);
    for (int i = 0; i < CommandCount; ++i) {
      float x = 24 + (i % 8) * 114, y = 330 + (i / 8) * 48;
      box(x, y, 108, 40, int(v[Step0 + selected]) == i);
      label(x + 7, y + 17, commandNames[i], 11);
      box(x + 7, y + 23, 10, 10, v[Pool0 + i] > .5f);
      if (v[Pool0 + i] > .5f) {
        beginPath();
        rect(x + 9, y + 25, 6, 6);
        fillColor(100, 255, 190);
        fill();
      }
      label(x + 22, y + 32, "random pool", 9);
    }
    const int ids[] = {RegionStart, RegionEnd, Smooth, Output, Steps, Division, Seed};
    for (int i = 0; i < 7; ++i) {
      unsigned id = ids[i];
      float x = 24 + i * 131;
      box(x, 444, 122, 62);
      label(x + 8, 462, specs[id].name, 11);
      if (id == Division)
        std::snprintf(info, sizeof info, "1/%d beat", 1 << int(v[id]));
      else
        std::snprintf(info, sizeof info, id == Steps || id == Seed ? "%.0f" : "%.1f", v[id]);
      label(x + 8, 490, info, 18);
    }
    label(24, 527,
          "Drag values vertically. WAV / AIFF mono or stereo. No MIDI notes needed. Save the "
          "sample with your Live project.",
          11);
  }
  bool onMouse(const MouseEvent &e) override {
    using namespace compass;
    float x = e.pos.getX(), y = e.pos.getY();
    if (!e.press) {
      if (drag >= 0) {
        editParameter(drag, false);
        drag = -1;
        return true;
      }
      return false;
    }
    if (x >= 24 && x < 936 && y >= 230 && y <= 292) {
      selected = std::min(15, int((x - 24) / 57));
      if (e.button == DGL_NAMESPACE::kMouseButtonRight)
        clickChange(Step0 + selected, Hold);
      repaint();
      return true;
    }
    if (e.button != DGL_NAMESPACE::kMouseButtonLeft)
      return false;
    if (y >= 20 && y <= 52) {
      if (x >= 444 && x < 548)
        clickChange(FreePlay, 1 - v[FreePlay]);
      else if (x >= 560 && x < 670)
        randomize();
      else if (x >= 682 && x < 774)
        clickChange(Reset, int(v[Reset] + 1) % 65536);
      else if (x >= 786 && x < 936)
        openFileBrowser();
      else
        return false;
      return true;
    }
    if (x >= 24 && x < 936 && y >= 330 && y < 418) {
      int row = int((y - 330) / 48), col = int((x - 24) / 114), cmd = row * 8 + col;
      float localY = y - (330 + row * 48);
      if (localY > 40)
        return false;
      if (localY >= 22)
        clickChange(Pool0 + cmd, 1 - v[Pool0 + cmd]);
      else
        clickChange(Step0 + selected, cmd);
      return true;
    }
    if (x >= 24 && x < 936 && y >= 94 && y <= 198) {
      float p = (x - 24) / 9.12f;
      drag = std::abs(p - v[RegionStart]) < std::abs(p - v[RegionEnd]) ? RegionStart : RegionEnd;
      editParameter(drag, true);
      change(drag, drag == RegionStart ? std::min(p, v[RegionEnd] - .1f)
                                       : std::max(p, v[RegionStart] + .1f));
      originY = y;
      originValue = v[drag];
      return true;
    }
    if (x >= 24 && x < 936 && y >= 444 && y <= 506) {
      const int ids[] = {RegionStart, RegionEnd, Smooth, Output, Steps, Division, Seed};
      int i = int((x - 24) / 131);
      if (i >= 7)
        return false;
      drag = ids[i];
      originY = y;
      originValue = v[drag];
      editParameter(drag, true);
      return true;
    }
    return false;
  }
  bool onMotion(const MotionEvent &e) override {
    if (drag < 0)
      return false;
    const auto &s = compass::specs[drag];
    float value = originValue + (originY - e.pos.getY()) * (s.max - s.min) / 200;
    if (drag == compass::RegionStart)
      value = std::min(value, v[compass::RegionEnd] - .1f);
    if (drag == compass::RegionEnd)
      value = std::max(value, v[compass::RegionStart] + .1f);
    change(drag, value);
    return true;
  }
};
UI *createUI() {
  return new StepCompassUI;
}
END_NAMESPACE_DISTRHO
