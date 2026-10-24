import json,sys,subprocess
from pathlib import Path
root=Path(__file__).resolve().parents[1]
sys.path.insert(0,str(root/'tools'))
from amxd_container import unpack_frozen
_,entries=unpack_frozen((root/'dist/no-fades/StepCompass-M4L-NoFades-v0.1.15.amxd').read_bytes())
p=json.loads(entries[0].data.rstrip(b'\0'))['patcher']
b={e['box']['id']:e['box'] for e in p['boxes']}
assert 'pool14' not in b and 'pool15' not in b
for i in range(16):
 params=b['step'+str(i)]['saved_attribute_attributes']['valueof']
 assert len(params['parameter_enum'])==14 and params['parameter_initial'][0]<14
for e in entries[1:]:assert e.data==(root/'dist/no-fades'/e.name).read_bytes()
subprocess.run(['node','-e',"""
const assert=require('assert'),C=require('./dist/no-fades/core.js');const c=new C();
assert(c.steps.every(x=>x<14));for(const p of C.presets)assert(p.steps.every(x=>x<14));
c.pool.fill(100);for(let i=0;i<1000;i++){c.randomize();assert(c.steps.every(x=>x<14));}
assert.equal(c.command(14),null);assert.equal(c.command(15),null);assert.equal(c.fadeValue(14,.5),1);
"""],cwd=root,check=True)
print('PASS: No Fades frozen scripts, menus, defaults, presets, legacy fade no-op and 1000 randomizations')
