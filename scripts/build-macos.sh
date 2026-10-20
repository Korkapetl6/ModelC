#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
[ "$(uname -s)" = Darwin ] || { echo 'Run this script on macOS with Xcode Command Line Tools.'; exit 1; }
./scripts/bootstrap.sh
export MACOSX_DEPLOYMENT_TARGET=10.15
make -C plugin vst3 -j2 CXXFLAGS='-arch x86_64 -fno-fast-math' LDFLAGS='-arch x86_64' DPF_TARGET_DIR="$PWD/bin" DPF_BUILD_DIR="$PWD/build/plugin"
mkdir -p bin/BeadsTable.vst3/Contents/Resources/Licenses
cp LICENSE THIRD_PARTY.md bin/BeadsTable.vst3/Contents/Resources/Licenses/
cp third_party/DPF/LICENSE bin/BeadsTable.vst3/Contents/Resources/Licenses/DPF.txt
cp third_party/DPF/dgl/src/nanovg/LICENSE.txt bin/BeadsTable.vst3/Contents/Resources/Licenses/NanoVG.txt
cp third_party/DPF/dgl/src/pugl-upstream/COPYING bin/BeadsTable.vst3/Contents/Resources/Licenses/Pugl.txt
cp third_party/DPF/dgl/src/resources/LICENSE-DejaVuSans.ttf.txt bin/BeadsTable.vst3/Contents/Resources/Licenses/
# Preserve Mutable's full author and MIT notices, in addition to attribution.
sed -n '1,24p' third_party/mutable/beads/dsp/wavetable_voice.h > bin/BeadsTable.vst3/Contents/Resources/Licenses/Mutable.txt
codesign --force --deep --sign - bin/BeadsTable.vst3
codesign --verify --deep --strict bin/BeadsTable.vst3
file bin/BeadsTable.vst3/Contents/MacOS/BeadsTable
mkdir -p release
cp README.md release/README.md
cp THIRD_PARTY.md release/THIRD_PARTY.md
ditto -c -k --sequesterRsrc --keepParent bin/BeadsTable.vst3 release/BeadsTable-0.1.0-macOS-Intel.vst3.zip
shasum -a 256 release/*.zip > release/SHA256SUMS
