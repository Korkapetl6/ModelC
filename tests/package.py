import json,sys
from pathlib import Path
sys.path.insert(0,str(Path(__file__).resolve().parents[1]/'tools'))
from amxd_container import unpack_frozen
root=Path(__file__).resolve().parents[1]
type_,entries=unpack_frozen((root/'dist/StepCompass-M4L-v0.1.11.amxd').read_bytes());assert type_==b'aaaa';assert {e.name for e in entries}=={'StepCompass.amxd','compass.js','core.js','display.js'}
p=json.loads(entries[0].data.rstrip(b'\0'))['patcher']
def check(p):
 boxes={e['box']['id']:e['box'] for e in p['boxes']};assert len(boxes)==len(p['boxes'])
 for l in p['lines']:
  a,b=l['patchline']['source'],l['patchline']['destination'];assert a[0] in boxes and b[0] in boxes
  assert a[1]<boxes[a[0]].get('numoutlets',1);assert b[1]<boxes[b[0]].get('numinlets',1)
 for cls in ('inlet','outlet'):
  ports=sorted((b for b in boxes.values() if b['maxclass']==cls),key=lambda b:b['patching_rect'][0])
  assert [b.get('index') for b in ports]==list(range(1,len(ports)+1)), 'Physical '+cls+' order differs from declared indices'
 for b in boxes.values():
  if 'patcher' in b:
   child=check(b['patcher'])
   assert sum(x['maxclass']=='inlet' for x in child.values())==b['numinlets']
   assert sum(x['maxclass']=='outlet' for x in child.values())==b['numoutlets']
 return boxes
boxes=check(p)
assert all('step'+str(i) in boxes for i in range(16))
assert all('pool'+str(i) in boxes for i in range(1,16))
assert 'pool0' not in boxes
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
assert boxes['envmessage']['text']=='$1, $2 $3'
assert boxes['envline']['text']=='line~ 1.'
assert boxes['stepenv']['text']=='rampsmooth~ 64 64'
for i in range(16):
 enum=boxes['step'+str(i)]['saved_attribute_attributes']['valueof']['parameter_enum']
 assert enum[14:]==['Fade out','Fade in']
assert not any(b.get('text','').startswith('route ') and ' pan ' in b['text'] for b in boxes.values())
lines=[l['patchline'] for l in p['lines']]
for ch in range(2):
 assert any(l['source']==['stepenv',0] and l['destination']==['amp'+str(ch)+'stepenv',1] for l in lines)
 assert any(l['source']==['amp'+str(ch)+'stepenv',0] and l['destination']==['output',ch] for l in lines)
print('PASS: fade command labels, resetting native line~ envelope and smoothed stereo output wiring')
expected_steps=[1,14,9,2,13,14,0,10,9,14,10,15,10,14,1,10]
for i in range(16):
 assert boxes['step'+str(i)]['saved_attribute_attributes']['valueof']['parameter_initial']==[expected_steps[i]]
 if i==0:continue
 control=boxes['pool'+str(i)];assert control['maxclass']=='live.numbox'
 params=control['saved_attribute_attributes']['valueof'];assert params['parameter_mmin']==0 and params['parameter_mmax']==100
 assert params['parameter_initial']==[0 if i in (3,4,11,12) else 100]
assert boxes['freeplay']['saved_attribute_attributes']['valueof']['parameter_initial']==[1]
assert boxes['seed']['saved_attribute_attributes']['valueof']['parameter_initial']==[1234]
assert boxes['holdpercent']['saved_attribute_attributes']['valueof']['parameter_initial']==[25]
assert boxes['holdpercent']['saved_attribute_attributes']['valueof']['parameter_unitstyle']==5
assert all(boxes['pool'+str(i)]['saved_attribute_attributes']['valueof']['parameter_unitstyle']==1 for i in range(1,16))
print('PASS: separate HOLD % control, 15 unitless command weights, screenshot UI defaults and Free Play enabled')
slope=boxes['rateslope']
assert slope['maxclass']=='number' and slope['minimum']==0 and slope['maximum']==10000
assert boxes['slope-minuscmd']['text']=='slopeadjust -10'
assert boxes['slope-pluscmd']['text']=='slopeadjust 10'
assert boxes['rate-glide']['text']=='line~ 1.'
for i in range(2):
 assert any(l['source']==['rate-glide',0] and l['destination']==['head'+str(i),0] for l in lines)
 sub=boxes['head'+str(i)]['patcher']
 assert not any(e['box']['id']=='speed' for e in sub['boxes'])
 assert any(e['patchline']['source']==['in0',0] and e['patchline']['destination']==['signed-rate',0] for e in sub['lines'])
 assert any(e['patchline']['source']==['direction-in',0] and e['patchline']['destination']==['signed-rate',1] for e in sub['lines'])
 assert any(e['patchline']['source']==['signed-rate',0] and e['patchline']['destination']==['groove',0] for e in sub['lines'])
 assert any(l['source']==['directionroute',i] and l['destination']==['head'+str(i),11] for l in lines)
assert 'rateroute' not in boxes
assert any(l['source']==['rate-glide',0] and l['destination']==['rate-meter',0] for l in lines)
print('PASS: one native audio-rate glide shared by both stereo heads, integer entry and fine adjustment buttons, rate feedback and no competing per-head rate sources')
assert boxes['preset-menu']['maxclass']=='umenu'
assert len([x for x in boxes['preset-menu']['items'] if x!=','])==10
assert boxes['preset-load-cmd']['text']=='loadpreset'
assert p['openrect'][3]==169
for b in boxes.values():
 if b.get('presentation'):
  x,y,w,h=b['presentation_rect'];assert y>=0 and y+h<=169, b['id']+' falls outside Live panel'
assert boxes['display']['presentation_rect'][1]+boxes['display']['presentation_rect'][3]<=boxes['preset-menu']['presentation_rect'][1]
assert any(l['source']==['preset-load',0] and l['destination']==['preset-load-cmd',0] for l in lines)
print('PASS: 10-choice preset menu, explicit LOAD button and all controls within standard Live panel')
