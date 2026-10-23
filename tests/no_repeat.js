const assert=require('assert'),fs=require('fs'),vm=require('vm'),C=require('../dist/no-repeat/core.js');
function zone(c,p){return Math.min(15,Math.floor((p-c.start*c.duration)/((c.end-c.start)*c.duration/16)));}
let c=new C();c.duration=16000;c.steps.fill(0);c.reset();
assert.equal(c.advance(100),null);let h=c.advance(150);assert(h.seek);assert.notEqual(zone(c,h.pos),0);
assert.equal(c.hi-c.lo,16000);
// Distinct starts should continue naturally without an injected seek.
c.reset();assert.equal(c.advance(100),null);assert.equal(c.advance(1500),null);
// Small loops move intact, never outside the selected source region.
c.start=.2;c.end=.8;c.reset();c.lo=4000;c.hi=4040;
c.advance(4010);h=c.advance(4010);assert(h.seek);assert.equal(c.hi-c.lo,40);assert(c.lo>=3200&&c.hi<=12800);assert(h.pos>=c.lo&&h.pos<c.hi);
// Actual chosen starts differ even for repeated Home, random positions, random steps and reverse.
for(const cmd of [0,2,3,6,7,8,11,13]){
 c=new C();c.duration=23000;c.start=.1;c.end=.9;c.steps.fill(cmd);c.reset();let previous=-1,cursor=c.lo;
 for(let i=0;i<2000;i++){
  h=c.advance(cursor);let p=h&&h.seek?h.pos:cursor;let z=zone(c,p);
  assert.notEqual(z,previous);assert(p>=c.start*c.duration&&p<c.end*c.duration);
  previous=z;cursor=p;assert(c.safeElapsed<=4+1e-7);
 }
}
// Safe window survives the extra seeks: four beats at full speed, then recovery.
c=new C();c.steps.fill(11);for(let i=0;i<64;i++)c.advance(0);c.advance(0);assert.equal(c.division,1);assert.equal(c.safeRest,1);
// Controller reads the active head's real phase and seeds phase correctly on every seek.
const messages=[];
const ctx={Compass:C,include(){},jsarguments:['compass.js','test'],Buffer:function(){},outlet(...a){messages.push(a);},Math,Number,isFinite};
vm.createContext(ctx);vm.runInContext(fs.readFileSync('dist/no-repeat/compass.js','utf8'),ctx);
ctx.lastConfig={lo:100,hi:500};ctx.activeHead=1;ctx.phase[1]=.25;assert.equal(ctx.stepCursor(),200);
ctx.queued={seek:true,pos:350};assert.equal(ctx.stepCursor(),350);ctx.queued=null;
ctx.configure(1,{lo:100,hi:500,pos:300,rate:1});assert.equal(ctx.phase[1],.5);assert.equal(ctx.stepCursor(),300);
assert(fs.readFileSync('dist/no-repeat/compass.js','utf8').includes('h=core.advance(stepCursor());'));
console.log('PASS: zone exclusion, natural continuation, short-loop length/range, 16000 repeated commands, Safe recovery and controller phase/cursor wiring');
