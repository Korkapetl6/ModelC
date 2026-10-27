from pathlib import Path
import hashlib,json,zipfile
ROOT=Path(__file__).resolve().parent
assert json.loads((ROOT/'dist/validation-v3.json').read_text())['passed']
files=['README.md','build_model.py','render_preview.py','validate_mesh.py','requirements.txt','package.py','dist/water-slab-150mm-v3.stl','dist/water-slab-150mm-v3.glb','dist/preview-v3.png','dist/preview-glass-v3.png','dist/model-info-v3.json','dist/validation-v3.json']
for n in files:assert (ROOT/n).is_file(),n
archive=ROOT/'dist/water-slab-150mm-v3-complete.zip'
with zipfile.ZipFile(archive,'w',zipfile.ZIP_DEFLATED) as z:
 for n in files:z.write(ROOT/n,'water-block-stl-v3/'+n)
with zipfile.ZipFile(archive) as z:assert z.testzip() is None
(ROOT/'dist/SHA256SUMS-v3.txt').write_text(''.join(hashlib.sha256(p.read_bytes()).hexdigest()+'  '+p.name+'\n' for p in [ROOT/'dist/water-slab-150mm-v3.stl',archive]))
print('ZIP verified:',archive.stat().st_size,'bytes')
