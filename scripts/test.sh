#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
mkdir -p build
flags=(-std=c++17 -O1 -g -fsanitize=address,undefined -fno-omit-frame-pointer -fno-strict-aliasing -Isrc)
"${CXX:-c++}" "${flags[@]}" tests/dsp.cpp -o build/dsp-test
./build/dsp-test
"${CXX:-c++}" "${flags[@]}" -pthread -DDGL_USE_FILE_BROWSER -Iplugin -Ithird_party/DPF/distrho tests/plugin.cpp third_party/DPF/distrho/src/DistrhoPlugin.cpp -o build/plugin-test
./build/plugin-test
