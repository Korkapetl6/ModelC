from pathlib import Path
import hashlib,json,zipfile
ROOT=Path(__file__).resolve().parent
DIST=ROOT/'dist'
report=json.loads((DIST/'validation-v1.json').read_text())
assert report['passed'], 'Mesh validation must pass before packaging'
stl=DIST/'lemon-peel-180x76mm-v1.stl'
assert report['sha256']==hashlib.sha256(stl.read_bytes()).hexdigest(), 'Validation is stale'
files=['README.md','requirements.txt','build_model.py','validate_mesh.py','render_preview.py','package.py',
'dist/lemon-peel-180x76mm-v1.stl','dist/lemon-peel-180x76mm-v1.glb',
'dist/preview-yellow.png','dist/preview-pith.png','dist/model-info-v1.json','dist/validation-v1.json']
archive=DIST/'lemon-peel-180x76mm-v1-complete.zip'
with zipfile.ZipFile(archive,'w',zipfile.ZIP_DEFLATED,compresslevel=6) as z:
 for name in files:z.write(ROOT/name,'lemon-peel-stl-v1/'+name)
with zipfile.ZipFile(archive) as z:assert z.testzip() is None
(DIST/'SHA256SUMS.txt').write_text(''.join(hashlib.sha256(p.read_bytes()).hexdigest()+'  '+p.name+'\n' for p in [stl,archive]))
print('ZIP verified:',archive.stat().st_size,'bytes')
