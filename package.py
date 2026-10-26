from pathlib import Path
import hashlib,json,zipfile
ROOT=Path(__file__).resolve().parent
assert json.loads((ROOT/'dist/validation.json').read_text())['passed']
files=['README.md','build_model.py','render_preview.py','validate_mesh.py','requirements.txt','package.py','dist/water-block-150mm.stl','dist/water-block-150mm.glb','dist/preview.png','dist/preview-glass.png','dist/model-info.json','dist/validation.json']
for n in files:assert (ROOT/n).is_file(),n
archive=ROOT/'dist/water-block-150mm-complete.zip'
with zipfile.ZipFile(archive,'w',zipfile.ZIP_DEFLATED) as z:
 for n in files:z.write(ROOT/n,'water-block-stl/'+n)
with zipfile.ZipFile(archive) as z:assert z.testzip() is None
(ROOT/'dist/SHA256SUMS.txt').write_text(''.join(hashlib.sha256(p.read_bytes()).hexdigest()+'  '+p.name+'\n' for p in [ROOT/'dist/water-block-150mm.stl',archive]))
print('ZIP verified:',archive.stat().st_size,'bytes')
