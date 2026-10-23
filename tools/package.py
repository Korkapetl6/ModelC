from pathlib import Path
import hashlib,zipfile
r=Path(__file__).resolve().parents[1]
files=[p for p in r.rglob('*') if p.is_file() and '.git' not in p.parts and '__pycache__' not in p.parts and p.suffix not in ('.zip','.pyc') and p.name!='SHA256SUMS.txt' and (not p.name.startswith('StepCompass-M4L-v') or p.name=='StepCompass-M4L-v0.1.11.amxd')]
archive=r/'dist/StepCompass-M4L-v0.1.11-complete.zip'
with zipfile.ZipFile(archive,'w',zipfile.ZIP_DEFLATED) as z:
 for p in sorted(files):z.write(p,Path('StepCompass-M4L')/p.relative_to(r))
with zipfile.ZipFile(archive) as z:assert z.testzip() is None
(r/'dist/SHA256SUMS.txt').write_text(''.join(hashlib.sha256(p.read_bytes()).hexdigest()+'  '+p.name+'\n' for p in [r/'dist/StepCompass-M4L-v0.1.11.amxd',archive]))
print('Complete ZIP and checksums verified')
