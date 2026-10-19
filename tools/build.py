#!/usr/bin/env python3
"""Build one frozen Max 8 Audio Effect with both legacy-JS dependencies."""
import hashlib
import json
from pathlib import Path
from amxd_container import Entry, frozen_amxd, unpack_frozen
from build_patcher import build

ROOT = Path(__file__).resolve().parents[1]
DIST = ROOT / 'dist'
DIST.mkdir(exist_ok=True)
patch = build()
patch_bytes = (json.dumps(patch, indent=2, ensure_ascii=False) + '\n').encode('utf-8')
(DIST / 'OctaScenes.maxpat').write_bytes(patch_bytes)
entries = [Entry('OctaScenes.amxd', patch_bytes + b'\0', b'JSON', 17)]
for name in ('octascenes.js', 'scene-core.js'):
    entries.append(Entry(name, (ROOT / 'src' / name).read_bytes()))
    (DIST / name).write_bytes(entries[-1].data)
blob = frozen_amxd(entries)
kind, readback = unpack_frozen(blob)
assert kind == b'aaaa' and readback == entries
path = DIST / 'OctaScenes-v0.1.1.amxd'
path.write_bytes(blob)
print(f'{path}: {len(blob)} bytes, SHA256 {hashlib.sha256(blob).hexdigest()}')
