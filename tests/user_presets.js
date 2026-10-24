const assert=require('assert'),fs=require('fs'),vm=require('vm');
const folder=process.argv[2]||'dist/no-repeat';
const C=require('../'+folder+'/core.js');
function device(){
 const controls={},messages=[];
 const ctx={Compass:C,include(){},jsarguments:['compass.js','test'],Buffer:function(){},outlet(...a){messages.push(a);},notifyclients(){},arrayfromargs(a){return Array.from(a);},patcher:{getnamed(id){return {message(...a){controls[id]=a;}}}},Math,JSON,Number,isFinite};
 vm.createContext(ctx);vm.runInContext(fs.readFileSync(folder+'/compass.js','utf8'),ctx);return {ctx,controls};
}
const first=device(),a=first.ctx;
a.presetselect(0);a.savepreset();assert.equal(a.selectedPreset,10);assert(a.userPresets[0]);
const expected=[];
for(let i=0;i<10;i++){
 a.core.steps=Array.from({length:16},(_,j)=>(j+i)%14);a.core.pool=Array.from({length:16},(_,j)=>j===0||j>=14?0:j*3.25);
 a.core.count=7+i;a.core.baseDivision=1<<(i%5);a.core.seed=2000+i;a.core.holdPercent=12.5+i;
 a.core.start=.125;a.core.end=.875;a.rateSlope=50+i;a.smooth=21.5;a.db=-7.25;
 a.presetselect(i+10);a.savepreset();expected.push(JSON.stringify(a.userPresets[i]));
}
const saved=a.getvalueof()[0];assert.equal(JSON.parse(saved).version,6);
a.core.steps[0]=99;assert.notEqual(a.userPresets[9].steps[0],99);
a.presetselect(1);a.savepreset();assert.equal(a.selectedPreset,1);assert.equal(JSON.stringify(a.userPresets[9]),expected[9]);
// New JS instance, not just reusing the same in-memory bank.
const second=device(),b=second.ctx;b.setvalueof(saved);assert.equal(b.selectedPreset,19);
for(let i=0;i<10;i++){
 assert.equal(JSON.stringify(b.userPresets[i]),expected[i]);b.presetselect(i+10);b.loadpreset();
 const p=JSON.parse(expected[i]);assert.deepEqual(Array.from(b.core.steps),p.steps);assert.deepEqual(Array.from(b.core.pool),p.pool);
 assert.equal(b.core.count,p.count);assert.equal(b.core.baseDivision,1<<p.clock);assert.equal(b.core.seed,p.seed);
 assert.equal(b.core.holdPercent,p.hold);assert.equal(b.core.start,p.start);assert.equal(b.core.end,p.end);
 assert.equal(b.rateSlope,p.slope);assert.equal(b.smooth,p.smooth);assert.equal(b.db,p.db);
 assert.deepEqual(second.controls.volume,['float',-7.25]);assert.deepEqual(second.controls.regionstart,['float',12.5]);
}
b.core.steps[0]=13;assert.equal(JSON.stringify(b.userPresets[9]),expected[9]);
b.presetselect(19);b.savepreset();assert.equal(b.userPresets[9].steps[0],13);
// Empty slot is a no-op; old sets still restore their pattern with an empty user bank.
b.setvalueof(JSON.stringify({version:5,steps:Array(16).fill(1),pool:Array(16).fill(0),seed:1234,rateSlope:50,holdPercent:25}));
assert(b.userPresets.every(x=>x===null));b.presetselect(10);b.loadpreset();assert(b.core.steps.every(x=>x===1));
console.log('PASS: '+folder+' ten-slot bank persisted into fresh instance; full parameter recall, decimals, copy isolation, explicit overwrite, full-bank protection, empty slot and legacy restore');
