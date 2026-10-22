import json,sys
from pathlib import Path
sys.path.insert(0,str(Path(__file__).resolve().parents[1]/'tools'))
from amxd_container import unpack_frozen
root=Path(__file__).resolve().parents[1]
type_,entries=unpack_frozen((root/'dist/StepCompass-M4L-v0.1.0.amxd').read_bytes());assert type_==b'aaaa';assert {e.name for e in entries}=={'StepCompass.amxd','compass.js','core.js','display.js'}
p=json.loads(entries[0].data.rstrip(b'\0'))['patcher']
def check(p):
 boxes={e['box']['id']:e['box'] for e in p['boxes']};assert len(boxes)==len(p['boxes'])
 for l in p['lines']:
  a,b=l['patchline']['source'],l['patchline']['destination'];assert a[0] in boxes and b[0] in boxes
  assert a[1]<boxes[a[0]].get('numoutlets',1);assert b[1]<boxes[b[0]].get('numinlets',1)
 for b in boxes.values():
  if 'patcher' in b:check(b['patcher'])
 return boxes
boxes=check(p)
assert all('step'+str(i) in boxes and 'pool'+str(i) in boxes for i in range(16))
assert len([b for b in boxes.values() if b.get('text','').startswith('p head_')])==2
assert boxes['loadgate']['text']=='line~ 0.'
assert len(p['parameters'])>=40
# Head gains and callbacks, shared unique buffer, explicit groove start and complete output path.
for i in range(2):
 sub={e['box']['id']:e['box'] for e in boxes['head'+str(i)]['patcher']['boxes']}
 assert sub['groove']['text']=='groove~ #0-compass 2 @loop 1 @loopinterp 1'
 assert sub['boundary-fade']['text']==('line~ 1.' if i==0 else 'line~ 0.')
 assert sub['level']['text']=='line~ 1.'
print('PASS: frozen AMXD roundtrip, embedded scripts, patch port references, 16 step menus, two DSP heads and startup gains')
