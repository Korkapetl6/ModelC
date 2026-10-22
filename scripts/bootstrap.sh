#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
commit=4238e1c7f0351bbe488d79f0899c540543ac7583
if [ ! -d third_party/DPF/.git ]; then
 git clone https://github.com/DISTRHO/DPF.git third_party/DPF
fi
git -C third_party/DPF checkout --detach "$commit"
git -C third_party/DPF submodule update --init --recursive
