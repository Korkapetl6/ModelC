#!/usr/bin/env python3
import json,hashlib
from pathlib import Path
from build_patcher import build
from amxd_container import Entry,frozen_amxd,unpack_frozen
ROOT=Path(__file__).resolve().parents[1]
dist=ROOT/'dist';dist.mkdir(exist_ok=True)
patch=(json.dumps(build(),indent=2)+'\n').encode()
(dist/'Barcode-for-Simpler.maxpat').write_bytes(patch)
entries=[Entry('Barcode-for-Simpler.amxd',patch+b'\0',b'JSON',17)]
for name in ['barcode.js','barcode-core.js','barcode-display.js']:
 data=(ROOT/'src'/name).read_bytes();entries.append(Entry(name,data));(dist/name).write_bytes(data)
blob=frozen_amxd(entries)
assert unpack_frozen(blob)==(b'aaaa',entries)
name='Barcode-for-Simpler-v0.1.3.amxd';(dist/name).write_bytes(blob)
print(name,len(blob),'bytes SHA256',hashlib.sha256(blob).hexdigest())
