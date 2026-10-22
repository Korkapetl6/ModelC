#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
[ "$(uname -s)" = Darwin ] || { echo 'Run on macOS with Xcode Command Line Tools.'; exit 1; }
./scripts/bootstrap.sh
export MACOSX_DEPLOYMENT_TARGET=10.15
make -C plugin vst3 -j2 CXXFLAGS='-arch x86_64 -fno-fast-math' LDFLAGS='-arch x86_64' DPF_TARGET_DIR="$PWD/bin" DPF_BUILD_DIR="$PWD/build/plugin"
bundle=bin/StepCompass.vst3
mkdir -p "$bundle/Contents/Resources/Licenses"
cp LICENSE THIRD_PARTY.md "$bundle/Contents/Resources/Licenses/"
cp third_party/DPF/LICENSE "$bundle/Contents/Resources/Licenses/DPF.txt"
cp third_party/DPF/dgl/src/nanovg/LICENSE.txt "$bundle/Contents/Resources/Licenses/NanoVG.txt"
cp third_party/DPF/dgl/src/pugl-upstream/COPYING "$bundle/Contents/Resources/Licenses/Pugl.txt"
cp third_party/DPF/dgl/src/resources/LICENSE-DejaVuSans.ttf.txt "$bundle/Contents/Resources/Licenses/"
codesign --force --deep --sign - "$bundle"
codesign --verify --deep --strict "$bundle"
file "$bundle/Contents/MacOS/StepCompass"
lipo -verify_arch x86_64 "$bundle/Contents/MacOS/StepCompass"
mkdir -p release
cp README.md THIRD_PARTY.md release/
ditto -c -k --sequesterRsrc --keepParent "$bundle" release/StepCompass-0.1.0-macOS-Intel.vst3.zip
python3 - <<'PY'
from pathlib import Path
from zipfile import ZipFile, ZIP_DEFLATED
root=Path('.')
with ZipFile('release/StepCompass-0.1.0-source.zip','w',ZIP_DEFLATED) as z:
 for name in ['README.md','THIRD_PARTY.md','LICENSE','plugin','src','scripts','tests','.github','third_party/AudioFile.h','third_party/AudioFile-LICENSE']:
  p=root/name
  for f in ([p] if p.is_file() else sorted(p.rglob('*'))):
   if f.is_file():z.write(f,Path('StepCompass')/f)
PY
shasum -a 256 release/*.zip > release/SHA256SUMS
