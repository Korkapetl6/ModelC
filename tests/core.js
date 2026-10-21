const assert=require('assert');const Core=require('../src/barcode-core.js');
let n=0;function test(name,fn){fn();console.log('PASS '+name);n++;}
test('same seed reproduces all 36 LFOs',()=>assert.deepStrictEqual(new Core(5).exportState(),new Core(5).exportState()));
test('default rate distribution matches barcode',()=>{
 const rows=new Core().tick(10,120,false,false,false);assert.deepStrictEqual(rows.map(x=>x.rate),[1,.125,.25,.5,2,4]);
});
test('all audio controls remain bounded at extreme durations, biases and tempos',()=>{
 const c=new Core();
 for(const d of [.001,.05,1,60])for(const bpm of [20,120,999])for(const b of [-100,100]){
  for(let v=0;v<6;v++)for(let p=0;p<6;p++)c.edit(v,p,b,p===2?0:.1);
  for(let t=0;t<100;t++)for(const r of c.tick(d,bpm,true,false,true)){
   assert(r.level>=0&&r.level<=1);assert(r.pan>=-1&&r.pan<=1);assert([.125,.25,.5,1,2,4].includes(Math.abs(r.rate)));
   assert(r.start>=0&&r.end>r.start&&r.end<=d+1e-9);
  }
 }
});
test('freeze stops LFOs but allows bias edits',()=>{
 const c=new Core(),a=c.tick(20,120,false,false,true),time=c.time;
 for(let i=0;i<20;i++)assert.deepStrictEqual(c.tick(20,120,false,true,true),a);
 assert.equal(c.time,time);c.edit(0,0,2,null);assert.equal(c.tick(20,120,false,true,true)[0].level,1);
});
test('reverse disable and parameter period zero',()=>{
 const c=new Core();for(let i=0;i<6;i++)for(let p=0;p<6;p++)c.edit(i,p,null,0);
 assert(c.tick(10,120,true,false,false).every(x=>x.rate>0));
 assert(c.voice.every(v=>v.lfo[0]===1&&v.lfo[2]===1));
});
test('tempo sync matches original formula including phase scaling',()=>{
 const c=new Core();c.voice[0].period[1]=10;c.voice[0].phase[1]=2;
 const r=c.tick(10,120,true,false,true);assert(Math.abs(r[0].pan-.4*Math.sin(2*Math.PI*.25/5+1))<1e-12);
});
test('original 60-second LFO counter wrap',()=>{const c=new Core();for(let i=0;i<241;i++)c.tick(10,120,false,false,true);assert.equal(c.time,0);});
test('saved modulation state roundtrips exactly',()=>{
 const c=new Core(99);c.edit(3,2,4,18);for(let i=0;i<20;i++)c.tick(10,110,true,false,true);
 const restored=Core.fromState(c.exportState());assert.deepStrictEqual(restored.tick(10,110,true,true,true),c.tick(10,110,true,true,true));
});
test('invalid saved state rejected',()=>{assert.throws(()=>Core.fromState({}));const c=new Core().exportState();c.voice[1].bias[0]=null;assert.throws(()=>Core.fromState(c));});
console.log(n+' core tests passed');
