const assert=require('assert'),C=require('../dist/safe/core.js');
// Full speed remains available, but consecutive fastest commands cannot extend the window.
let c=new C();c.steps.fill(11);let beats=0;
for(let i=0;i<64;i++){c.advance();assert.equal(c.division,16);beats+=1/c.division;}
assert.equal(beats,4);let h=c.advance();assert.equal(c.division,1);assert.equal(h.rate,1);assert.equal(h.seek,false);assert.equal(c.safeRest,1);
c.advance();assert.equal(c.division,1);assert.equal(c.safeRest,0);c.advance();assert.equal(c.division,16);
// A rate excursion returns through the ordinary slope without seeking or changing direction.
c=new C();c.rate=-1;c.steps.fill(3);
for(let i=0;i<4;i++){c.advance();assert.equal(c.rate,-2);}
h=c.advance();assert.equal(c.rate,-1);assert.equal(h.rate,-1);assert.equal(h.seek,false);
c.advance();assert.equal(c.rate,-1);c.advance();assert.equal(c.rate,-2);
// Latching commands followed by Hold also expire; actual beats count despite index jumps.
c=new C();c.steps.fill(0);c.steps[0]=11;
for(let i=0;i<64;i++)c.advance();c.advance();assert.equal(c.division,1);
c=new C();c.steps=[11,13,3,9,13,2,5,13,10,11,13,4,9,13,1,13];
let recoveryCount=0;
for(let i=0;i<10000;i++){
 let before=c.safeElapsed;c.advance();assert(c.safeElapsed<=4+1e-7);
 if(before>=4-1e-8){assert.equal(c.division,1);assert.equal(Math.abs(c.rate),1);recoveryCount++;}
}
assert(recoveryCount>20);
for(let i=0;i<10;i++){c.applyPreset(i);c.reset();assert.equal(c.division,1);assert.equal(c.safeElapsed,0);assert.equal(c.safeRest,0);}
console.log('PASS: full-speed 4-beat window, 2-beat recovery, no timer extension, reverse-preserving rate reset without seek, held effects expire, 10000 random jumps, all preset starts');
