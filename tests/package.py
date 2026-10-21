import json,sys
from pathlib import Path
root=Path(__file__).resolve().parents[1];sys.path.insert(0,str(root/'tools'))
from amxd_container import unpack_frozen
kind,entries=unpack_frozen((root/'dist/Barcode-for-Simpler-v0.1.0.amxd').read_bytes())
assert kind==b'aaaa'
assert [e.name for e in entries]==['Barcode-for-Simpler.amxd','barcode.js','barcode-core.js','barcode-display.js']
for e in entries[1:]:assert e.data==(root/'src'/e.name).read_bytes()
patch=json.loads(entries[0].data.rstrip(b'\0'))['patcher']
objects=[]
def validate(p):
 boxes={e['box']['id']:e['box'] for e in p['boxes']}
 assert len(boxes)==len(p['boxes'])
 for e in p['lines']:
  wire=e['patchline'];src,out=wire['source'];dst,inp=wire['destination']
  assert src in boxes and dst in boxes
  assert 0<=out<boxes[src].get('numoutlets',1),(src,out)
  assert 0<=inp<boxes[dst].get('numinlets',1),(dst,inp)
 for b in boxes.values():
  objects.append(b)
  if 'patcher' in b:validate(b['patcher'])
 return boxes
boxes=validate(patch)
assert sum(b.get('text','').startswith('groove~ #0-barcode 2') for b in objects)==6
assert sum(b.get('text')=='selector~ 2 1' for b in objects)==6
assert not any(b.get('text','').startswith('record~') for b in objects)
assert boxes['buffer']['numoutlets']==2
assert any(e['patchline']['source']==['buffer',1] and e['patchline']['destination']==['loaded',0] for e in patch['lines'])
assert boxes['engine']['text']=='js barcode.js #0-barcode'
assert 'parameter_type' in boxes['data']['saved_attribute_attributes']['valueof']
assert boxes['data']['saved_attribute_attributes']['valueof']['parameter_type']==3
for b in objects:
 if b.get('presentation'):
  x,y,w,h=b['presentation_rect'];assert x>=0 and y>=0 and x+w<=1100 and y+h<=169,(b['id'],x,y,w,h)
print('PASS AMXD readback, embedded sources, all patch connections/ports, six stereo players, mono duplication, instance-local buffer, presentation bounds and persistent state')
print('Max/MSP runtime and Live UI/audio have NOT been executed by this test.')
