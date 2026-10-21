import json,sys
from pathlib import Path
root=Path(__file__).resolve().parents[1];sys.path.insert(0,str(root/'tools'))
from amxd_container import unpack_frozen
kind,entries=unpack_frozen((root/'dist/Barcode-for-Simpler-v0.1.3.amxd').read_bytes())
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
  x,y,w,h=b['presentation_rect'];assert x>=0 and y>=0 and x+w<=1480 and y+h<=169,(b['id'],x,y,w,h)
print('PASS AMXD readback, embedded sources, all patch connections/ports, six stereo players, mono duplication, instance-local buffer, presentation bounds and persistent state')
print('Max/MSP runtime and Live UI/audio have NOT been executed by this test.')

for i in range(6):
 assert any(e['patchline']['source']==['protocol',10] and e['patchline']['destination']==['voice'+str(i),6] for e in patch['lines'])
 assert any(e['patchline']['source']==['start-route',i] and e['patchline']['destination']==['voice'+str(i),7] for e in patch['lines'])
 sub=boxes['voice'+str(i)]['patcher']
 assert any(e['patchline']['source']==['set-buffer',0] and e['patchline']['destination']==['groove',0] for e in sub['lines'])
print('PASS explicit parent buffer binding and startloop command routes for all six voices')

# Explicitly reject the non-Max audio expression object from 0.1.0/0.1.1.
assert not any(b.get('text','').startswith('expr~') for b in objects)
for ch in range(2):
 assert boxes['limit'+str(ch)]['text']=='clip~ -0.98 0.98'
 assert boxes['limit'+str(ch)]['numinlets']==3
 assert any(e['patchline']['source']==['amp'+str(ch),0] and e['patchline']['destination']==['limit'+str(ch),0] for e in patch['lines'])
 assert any(e['patchline']['source']==['limit'+str(ch),0] and e['patchline']['destination']==['output',ch] for e in patch['lines'])
assert any(e['patchline']['source']==['filter0',0] and e['patchline']['destination']==['filtermeter',0] for e in patch['lines'])
print('PASS native clip~ output in both channels; reject expr~ and verify filter meter connection')

for i in range(6):
 b=boxes['gain'+str(i)];assert b['maxclass']=='live.dial' and b['parameter_enable']==1
 spec=b['saved_attribute_attributes']['valueof'];assert spec['parameter_initial']==[100] and spec['parameter_mmax']==200
 assert any(e['patchline']['source']==['trim-route',i] and e['patchline']['destination']==['voice'+str(i),8] for e in patch['lines'])
 sub=boxes['voice'+str(i)]['patcher']
 assert any(e['patchline']['source']==['trim',0] and e['patchline']['destination']==['effective-level',1] for e in sub['lines'])
assert boxes['volume']['saved_attribute_attributes']['valueof']['parameter_initial']==[0]
assert boxes['volume']['saved_attribute_attributes']['valueof']['parameter_unitstyle']==4
print('PASS six persistent automatable gain knobs, independent smoothed DSP trims, dB master and layout bounds')
