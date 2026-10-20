#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
mkdir -p build
"${CXX:-c++}" -std=c++17 -O1 -g -DTEST -fsanitize=address,undefined -fno-omit-frame-pointer -Isrc -Ithird_party/mutable tests/dsp.cpp third_party/mutable/beads/resources.cc third_party/mutable/stmlib/dsp/units.cc third_party/mutable/stmlib/utils/random.cc -o build/dsp-test
./build/dsp-test
if [ -d third_party/DPF/distrho ]; then
 "${CXX:-c++}" -std=c++17 -O1 -g -DTEST -fsanitize=address,undefined -fno-omit-frame-pointer -Iplugin -Isrc -Ithird_party/mutable -Ithird_party/DPF/distrho tests/plugin.cpp third_party/DPF/distrho/src/DistrhoPlugin.cpp third_party/mutable/beads/resources.cc third_party/mutable/stmlib/dsp/units.cc third_party/mutable/stmlib/utils/random.cc -o build/plugin-test
 ./build/plugin-test
else
 echo 'DPF adapter test requires ./scripts/bootstrap.sh' >&2
 exit 1
fi
