# Attribution

StepCompass is an independent C++ sample player and command sequencer inspired by the idea of
[Compass for norns by Olivier Creurer](https://github.com/oliviercreurer/compass).
It is not an official Compass release, a Lua interpreter, or a port of softcut.
No Compass Lua, artwork, SuperCollider code, or sample assets are included.

- New application/DSP/UI code: MIT, see LICENSE.
- DISTRHO Plugin Framework: ISC, commit `4238e1c7f0351bbe488d79f0899c540543ac7583`.
  Fetch via scripts/bootstrap.sh. Bundled framework components retain their own notices
  (NanoVG: zlib, Pugl: ISC, DejaVu Sans: font license).
- AudioFile by Adam Stark: MIT, commit `4554279566c19602a14868b58551f23fe5c5fb53`.
  `third_party/AudioFile.h` is used only to generate test fixtures, not in the plugin binary.
  See third_party/AudioFile-LICENSE.
- No sample content is redistributed. Bring your own WAV / AIFF.
