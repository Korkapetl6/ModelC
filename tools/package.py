#!/usr/bin/env python3
"""Package the current built device and source tree, without older releases."""
from pathlib import Path
import json,zipfile,hashlib,shutil
root=Path(__file__).resolve().parents[1]
version='0.1.3'
p=root/'dist/VALIDATION.json';v=json.loads(p.read_text());v['version']=version
v['tests']['native_clip_output_and_filter_meter']='passed'
v['observed_in_previous_version']='User confirmed audio in 0.1.2; gain 0.175 was too quiet.'
v['tests']['controller_mock_live_api']=16
v['tests']['six_voice_trims_and_db_output']='passed'
v['remaining']=['Verify new gain controls and expanded panel in Live','Actual Live Set save and reopen']
p.write_text(json.dumps(v,indent=2)+'\n')
names=['README.md','LICENSE','Makefile','.gitignore']
for d in ['src','tools','tests','upstream']:
 names += [str(p.relative_to(root)) for p in sorted((root/d).rglob('*')) if p.is_file() and '__pycache__' not in p.parts]
names += ['dist/'+n for n in ['Barcode-for-Simpler-v'+version+'.amxd','Barcode-for-Simpler.maxpat','barcode.js','barcode-core.js','barcode-display.js','VALIDATION.json','test-results.txt']]
data={n:(root/n).read_bytes() for n in names}
data['PACKAGE-SHA256SUMS.txt']=''.join(hashlib.sha256(b).hexdigest()+'  '+n+'\n' for n,b in sorted(data.items())).encode()
zip_path=root/('dist/Barcode-for-Simpler-v'+version+'-complete.zip')
with zipfile.ZipFile(zip_path,'w',zipfile.ZIP_DEFLATED) as z:
 for n,b in data.items():z.writestr('Barcode-for-Simpler/'+n,b)
with zipfile.ZipFile(zip_path) as z:
 assert z.testzip() is None
 for n,b in data.items():assert z.read('Barcode-for-Simpler/'+n)==b
files=[zip_path,root/('dist/Barcode-for-Simpler-v'+version+'.amxd')]
(root/'dist/SHA256SUMS.txt').write_text(''.join(hashlib.sha256(p.read_bytes()).hexdigest()+'  '+p.name+'\n' for p in files))
print('Verified complete source archive and AMXD checksums')
