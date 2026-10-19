"""Structural checks of real generated patch and AMXD, not a Max runtime."""
import hashlib
import json
from pathlib import Path
import re
import sys
sys.path.insert(0, str(Path(__file__).resolve().parents[1] / 'tools'))
from amxd_container import frozen_amxd, unpack_frozen
ROOT = Path(__file__).resolve().parents[1]
blob = (ROOT/'dist/OctaScenes-v0.1.amxd').read_bytes()
kind, entries = unpack_frozen(blob)
assert kind == b'aaaa'
assert frozen_amxd(entries,kind) == blob
assert [e.name for e in entries] == ['OctaScenes.amxd','octascenes.js','scene-core.js']
for e in entries[1:]: assert e.data == (ROOT/'src'/e.name).read_bytes()
patch = json.loads(entries[0].data.rstrip(b'\0'))['patcher']
assert patch['appversion']['major'] == 8
assert patch['openinpresentation'] == 1
assert patch['project']['amxdtype'] == 0x61616161
assert patch['openrect'][3] == 169
count = {'boxes':0,'lines':0,'remotes':0,'persistent_bindings':0}
def visit(p):
    boxes = {b['box']['id']:b['box'] for b in p['boxes']}
    assert len(boxes) == len(p['boxes'])
    for line in p['lines']:
        src,out = line['patchline']['source'];dst,port=line['patchline']['destination']
        assert src in boxes and dst in boxes
        assert out < boxes[src].get('numoutlets',1), (src,out)
        assert port < boxes[dst].get('numinlets',1), (dst,port)
        count['lines']+=1
    for b in boxes.values():
        count['boxes']+=1
        if b.get('presentation'):
            x,y,w,h=b['presentation_rect'];assert 0<=y and y+h<=169 and x+w<=1100
        if b.get('text')=='live.remote~':count['remotes']+=1
        if b.get('text')=='live.observer id':
            assert b['saved_object_attributes']['_persistence']==1
            count['persistent_bindings']+=1
        assert 'v8 ' not in b.get('text','')
        if 'patcher' in b:visit(b['patcher'])
visit(patch)
assert count['remotes']==count['persistent_bindings']==32
boxes={b['box']['id']:b['box'] for b in patch['boxes']}
lines=[(tuple(l['patchline']['source']),tuple(l['patchline']['destination'])) for l in patch['lines']]
for port in (0,1):assert (('audio-in',port),('audio-out',port)) in lines
for i in range(16):
    assert boxes[f'scene_{i}']['parameter_enable']==1
    assert boxes[f'scene_{i}']['mode']==0
for i in range(32):
    p=boxes[f'remote-slot-{i}']['patcher']
    lines2=[(tuple(l['patchline']['source']),tuple(l['patchline']['destination'])) for l in p['lines']]
    assert (('target-unpack',1),('remote',0)) in lines2
    assert (('target-id',0),('remote',1)) in lines2
    assert (('map-id',0),('identity',1)) in lines2
    assert (('release-id',0),('remote',1)) in lines2
    assert not any(src[0]=='release-id' and dst[0]=='identity' for src,dst in lines2)
pattr=boxes['scene-data']['saved_object_attributes']
assert pattr['parameter_enable']==1
pattr_value=boxes['scene-data']['saved_attribute_attributes']['valueof']
assert pattr_value['parameter_type']==3 and pattr_value['parameter_invisible']==1
source=(ROOT/'src/octascenes.js').read_text()
handlers=set(re.findall(r'^function (\w+)\(',source,re.M))
for name in ['enable','mode','edit','scene','xfade','a','b','slot','map','unmap','focus','clearlock','clearscene','copy','paste','binding','initialize','deviceactive','getvalueof','setvalueof']:
    assert name in handlers,name
assert 'include("scene-core.js")' in source
names={p[0] for k,p in patch['parameters'].items() if k not in ('parameterbanks','inherited_shortname')}
for bank in patch['parameters']['parameterbanks'].values():
    assert all(p=='-' or p in names for p in bank['parameters'])
print('PASS frozen Audio Effect, embedded source, 32 ownership/persistence bridges, 16 scene buttons, graph, MIDI banks and presentation bounds')
print(json.dumps(count,indent=2))
