const assert=require('assert'),fs=require('fs'),vm=require('vm'),Core=require('../src/core.js');
let c=new Core();c.duration=10000;c.reset();for(let i=0;i<20000;i++){const h=c.command(i%16);assert(c.lo>=0&&c.hi<=10000&&c.hi>c.lo);assert(c.division>=1&&c.division<=16);if(h&&h.lo!==undefined)assert(h.pos>=h.lo&&h.pos<h.hi);}
let a=new Core(),b=new Core();for(let i=0;i<500;i++)assert.deepEqual(a.advance(),b.advance());a.holdPercent=0;a.pool.fill(0);assert(!a.randomize());a.pool[2]=1;assert(a.randomize());assert(a.steps.every(x=>x===2));
console.log('PASS: command bounds, seed repeatability, 20000 commands, random pool');
let messages=[],scheduled=[];const controls={};
function Task(fn,self){this.fn=()=>fn.call(self);this.repeat=()=>{};this.cancel=()=>{this.cancelled=true;};this.schedule=()=>scheduled.push(this.fn);}
let song={is_playing:0,tempo:120,current_song_time:0},bufferMs=3000;
const nodes={20:{canonical_parent:['id',100]},100:{devices:['id',10,'id',20]},10:{class_name:'OriginalSimpler',sample:['id',30]},30:{file_path:'/samples/test name.wav',sample_rate:48000,length:480000,start_marker:48000,end_marker:192000}};
function LiveAPI(cb,path){this.id=path==='this_device'?20:Number(path.split(' ')[1]);this.get=k=>{const obj=path==='live_set'?song:nodes[this.id];if(!obj||!(k in obj))throw Error('Missing property '+k);return Array.isArray(obj[k])?obj[k]:[obj[k]];};}
const ctx={Compass:Core,include(){},jsarguments:['compass.js','unique-buffer'],Buffer:function(){this.framecount=()=>bufferMs*48;this.length=()=>bufferMs;this.channelcount=()=>1;this.peek=()=>.2;},Task,LiveAPI,outlet(...args){messages.push(args);},notifyclients(){},arrayfromargs(args){return Array.from(args);},patcher:{getnamed(id){return {message(...a){controls[id]=a;}}}},console,Date,Math,JSON,isFinite};
vm.createContext(ctx);vm.runInContext(fs.readFileSync('src/compass.js','utf8'),ctx);
ctx.initialize();assert.equal(ctx.loadPhase,'fade');assert(!messages.some(m=>m[1]==='load'));ctx.gateended();assert.deepEqual(messages.filter(m=>m[1]==='load').pop(),[0,'load','/samples/test name.wav',1000,3000]);ctx.loaded();assert(ctx.loadedOK);assert.equal(ctx.core.duration,3000);assert(messages.some(m=>m[1]==='channels'&&m[2]===1));assert(messages.some(m=>m[1]==='start'&&m[3]==='startloop'));
const loads=messages.filter(m=>m[1]==='load').length;ctx.scan();assert.equal(ctx.loadPhase,'');assert.equal(messages.filter(m=>m[1]==='load').length,loads);
ctx.freeplay(1);ctx.tick();assert(ctx.wasRunning);assert(ctx.busy);ctx.transition({lo:100,hi:400,rate:-1,pos:350,seek:true});assert(ctx.queued);ctx.ended(0);assert(ctx.busy&&ctx.queued);ctx.ended(1);assert(ctx.busy&&!ctx.queued);ctx.ended(0);ctx.ended(1);assert(!ctx.busy);
ctx.volume(-60);ctx.enable(0);ctx.tick();ctx.enable(1);ctx.tick();assert.equal(messages.filter(m=>m[1]==='master').pop()[2],0);
// Marker change imports only the selected range, including paths containing spaces.
nodes[30].end_marker=120000;bufferMs=1500;ctx.scan();assert(!ctx.loadedOK);ctx.gateended();assert.deepEqual(messages.filter(m=>m[1]==='load').pop().slice(2),['/samples/test name.wav',1000,1500]);ctx.loaded();assert.equal(ctx.core.duration,1500);
// Replacement during an unfinished read cannot unmute stale sample data.
nodes[30].file_path='/samples/new.wav';ctx.scan();ctx.gateended();nodes[30].file_path='/samples/newest.wav';ctx.loaded();assert(!ctx.loadedOK);assert.equal(ctx.loadPhase,'read');assert.equal(messages.filter(m=>m[1]==='load').pop()[2],'/samples/newest.wav');ctx.loaded();assert(ctx.loadedOK);
// Removing the source mutes immediately, then prevents old data from becoming ready.
nodes[100].devices=['id',20];ctx.scan();assert(!ctx.loadedOK);assert.equal(messages.filter(m=>m[1]==='master').pop()[2],0);nodes[100].devices=['id',10,'id',20];ctx.scan();ctx.gateended();nodes[100].devices=['id',20];ctx.loaded();assert(!ctx.loadedOK);
// Rack chain lookup, nearest preceding Simpler, empty sample, state restoration and cleanup.
nodes[100].devices=['id',10,'id',11,'id',20];nodes[11]={class_name:'OriginalSimpler',sample:['id',31]};nodes[31]={...nodes[30],file_path:'/samples/nearest.wav'};assert.equal(ctx.findSample().path,'/samples/nearest.wav');nodes[11].sample=['id',0];ctx.scan();assert(!ctx.loadedOK);nodes[11].sample=['id',31];ctx.reload();ctx.gateended();ctx.loaded();assert(ctx.loadedOK);
ctx.freeplay(0);ctx.tick();assert(!ctx.wasRunning);song.is_playing=1;ctx.tick();assert(ctx.wasRunning);song.current_song_time=.25;ctx.tick();assert(ctx.core.index>=1);
const saved=ctx.getvalueof()[0];assert(!('file' in JSON.parse(saved)));ctx.setvalueof(saved);assert(ctx.requestedSignature.includes('/samples/nearest.wav'));ctx.notifydeleted();assert(ctx.scanTask.cancelled);
console.log('PASS: mocked Live API nearest Simpler, marker offsets, replacement races, removal/empty-source mute, restore, transport and fade handshake');
// Per-step fades must not latch into Hold, alter Output dB, or retain a previous ramp.
ctx.gateended();ctx.loaded();ctx.volume(-12);ctx.core.count=4;ctx.core.baseDivision=4;ctx.core.steps=[14,0,15,0];ctx.wasRunning=false;ctx.lastBeat=null;song.is_playing=1;song.tempo=120;song.current_song_time=0;
function env(){return messages.filter(m=>m[1]==='stepenv').pop().slice(2);}
ctx.tick();assert.deepEqual(env(),[1,0,125]);assert.equal(ctx.db,-12);
song.current_song_time=.25;ctx.tick();assert.deepEqual(env(),[1,1,125]);
song.current_song_time=.5;ctx.tick();assert.deepEqual(env(),[0,1,125]);
song.current_song_time=.75;ctx.tick();assert.deepEqual(env(),[1,1,125]);
ctx.core.steps=[14,14,15,15];song.current_song_time=0;ctx.tick();assert.deepEqual(env(),[1,0,125]);song.current_song_time=.25;ctx.tick();assert.deepEqual(env(),[1,0,125]);song.current_song_time=.5;ctx.tick();assert.deepEqual(env(),[0,1,125]);song.current_song_time=.75;ctx.tick();assert.deepEqual(env(),[0,1,125]);
// Clock changes change fade length; tempo changes retime the remaining beat fraction.
ctx.core.steps=[9,14,0,0];song.current_song_time=0;ctx.tick();assert.equal(ctx.core.division,8);song.current_song_time=.125;ctx.tick();assert.deepEqual(env(),[1,0,62.5]);song.tempo=60;song.current_song_time=.1875;ctx.tick();assert.deepEqual(env(),[.5,0,62.5]);
ctx.reset();assert.deepEqual(env(),[1,1,0]);assert.equal(ctx.db,-12);
assert.equal(ctx.core.fadeValue(14,0),1);assert.equal(ctx.core.fadeValue(14,1),0);assert.equal(ctx.core.fadeValue(15,0),0);assert.equal(ctx.core.fadeValue(15,1),1);assert.equal(ctx.core.fadeValue(0,1),1);
console.log('PASS: fade endpoints, Hold restores full gain, consecutive fades restart, unchanged master volume, clock/tempo retiming and reset');
const defaults=new Core();
assert.deepEqual(defaults.steps,[1,14,9,2,13,14,0,10,9,14,10,15,10,14,1,10]);
assert.deepEqual(defaults.pool,[0,100,100,0,0,100,100,100,100,100,100,0,0,100,100,100]);
let weighted=new Core();weighted.holdPercent=0;weighted.pool.fill(0);weighted.pool[1]=100;weighted.pool[2]=50;let counts=[0,0];
for(let trial=0;trial<10000;trial++){assert(weighted.randomize());for(const command of weighted.steps){assert(command===1||command===2);counts[command-1]++;}}
assert(Math.abs(counts[0]/(counts[0]+counts[1])-2/3)<.01);
weighted.pool.fill(0);let before=JSON.stringify(weighted);assert.equal(weighted.randomize(),false);assert.equal(JSON.stringify(weighted),before);
ctx.pool(1,37.5);assert.equal(ctx.core.pool[1],37.5);ctx.pool(2,200);assert.equal(ctx.core.pool[2],100);ctx.pool(3,-5);assert.equal(ctx.core.pool[3],0);
const weightedSaved=ctx.getvalueof()[0];assert.equal(JSON.parse(weightedSaved).version,5);ctx.pool(1,0);ctx.setvalueof(weightedSaved);assert.equal(ctx.core.pool[1],37.5);
ctx.setvalueof(JSON.stringify({version:2,steps:defaults.steps,pool:[1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0],seed:1234}));assert.deepEqual(Array.from(ctx.core.pool),[0,0,100,0,100,0,100,0,100,0,100,0,100,0,100,0]);
console.log('PASS: screenshot defaults, 160000 weighted draws (100:50), 0% exclusion, empty-pool no-op, clamping, fractional weight save/restore, legacy migration');
// Every active length and integer percentage must have an exact quota, not a Bernoulli chance.
for(let length=1;length<=16;length++)for(let percent=0;percent<=100;percent++){
 const quota=new Core();quota.count=length;quota.holdPercent=percent;
 const inactive=quota.steps.slice(length);assert(quota.randomize());
 assert.equal(quota.steps.slice(0,length).filter(x=>x===0).length,Math.round(length*percent/100));
 assert.deepEqual(quota.steps.slice(length),inactive);
}
const allHold=new Core();allHold.pool.fill(0);allHold.holdPercent=100;assert(allHold.randomize());assert(allHold.steps.every(x=>x===0));
allHold.holdPercent=25;const noPoolState=JSON.stringify(allHold);assert(!allHold.randomize());assert.equal(JSON.stringify(allHold),noPoolState);
const positions=new Set();const shuffled=new Core();shuffled.holdPercent=25;
for(let i=0;i<100;i++){assert(shuffled.randomize());positions.add(shuffled.steps.map((x,j)=>x===0?j:-1).filter(x=>x>=0).join(','));}assert(positions.size>50);
ctx.holdpercent(50);ctx.steps(8);assert.equal(ctx.core.holdCount(),4);assert.equal(controls['hold-count'][1],'NEXT 4/8');
const holdSaved=ctx.getvalueof()[0];ctx.holdpercent(0);ctx.setvalueof(holdSaved);assert.equal(ctx.core.holdPercent,50);
ctx.setvalueof(JSON.stringify({version:3,pool:defaults.pool,steps:defaults.steps,seed:1234}));assert.equal(ctx.core.holdPercent,25);
console.log('PASS: exact Hold quotas for all 16 lengths x 101 percentages, inactive-step preservation, shuffled placement, 100% with empty pool, HOLD state restore/migration and count label');
// Model native line~ target/time semantics, then verify the controller never resets its current value.
let timeMs=0,rampStart=0,rampFrom=1,rampTo=1,rampDuration=0;
function rateNow(){const t=rampDuration?Math.min(1,(timeMs-rampStart)/rampDuration):1;return rampFrom+(rampTo-rampFrom)*t;}
const originalOutlet=ctx.outlet;
ctx.outlet=function(...args){if(args[1]==='rate'){assert.equal(args.length,4);const current=rateNow();rampFrom=current;rampTo=args[2];rampDuration=args[3];rampStart=timeMs;}originalOutlet(...args);};
ctx.loadedOK=true;ctx.loadPhase='';ctx.rateGoal=1;ctx.core.rate=1;ctx.rateslope(1000);ctx.busy=true;
const waitingHead={lo:0,hi:100,rate:1,pos:10,seek:true};ctx.queued=waitingHead;
const seeksBefore=messages.filter(m=>m[1]==='seek').length;
ctx.playCommand(ctx.core.command(3));assert.equal(rateNow(),1);timeMs=250;assert.equal(rateNow(),1.25);
ctx.playCommand(ctx.core.command(4));assert.equal(rateNow(),1.25);assert.equal(ctx.queued,waitingHead);timeMs=750;assert.equal(rateNow(),1.125);
const rampsBefore=messages.filter(m=>m[1]==='rate').length;ctx.playCommand(ctx.core.command(1));assert.equal(messages.filter(m=>m[1]==='rate').length,rampsBefore);
// Reversal changes head direction, never the shared magnitude; queued position survives.
ctx.playCommand(ctx.core.command(2));assert.equal(rateNow(),1.125);assert.equal(waitingHead.rate,-1);
timeMs=1750;assert.equal(rateNow(),1);
assert.equal(messages.filter(m=>m[1]==='seek').length,seeksBefore);
ctx.playCommand(ctx.core.command(1));assert.equal(waitingHead.rate,1);
ctx.busy=false;ctx.queued=null;ctx.lastConfig={lo:0,hi:100,rate:1};ctx.phase[ctx.activeHead]=.4;
const rateCount=messages.filter(m=>m[1]==='rate').length;
ctx.playCommand(ctx.core.command(2));assert(ctx.busy);assert.equal(ctx.lastConfig.pos,40);
assert.equal(messages.filter(m=>m[1]==='direction').pop()[3],-1);
assert.equal(messages.filter(m=>m[1]==='rate').length,rateCount);
ctx.ended(0);ctx.ended(1);
ctx.playCommand(ctx.core.command(7));ctx.configure(1,waitingHead);assert.equal(messages.filter(m=>m[1]==='rate').length,rateCount);
ctx.rateslope(0);ctx.playCommand(ctx.core.command(3));assert.equal(rateNow(),2);
// Every rate command preserves direction; Forward/Reverse preserve pitch target.
for(const direction of [-1,1]){
 const speedCore=new Core();speedCore.rate=direction;
 for(let i=0;i<10000;i++){speedCore.command(3+i%3);assert.equal(Math.sign(speedCore.rate),direction);assert([.5,1,2].includes(Math.abs(speedCore.rate)));}
 speedCore.rate=direction*2;speedCore.command(1);assert.equal(speedCore.rate,2);speedCore.command(2);assert.equal(speedCore.rate,-2);
}
ctx.rateslope(1234);ctx.slopeadjust(10);assert.equal(ctx.rateSlope,1244);assert.deepEqual(controls.rateslope,['set',1244]);ctx.slopeadjust(-10);assert.equal(ctx.rateSlope,1234);
ctx.rateslope(0);ctx.slopeadjust(-10);assert.equal(ctx.rateSlope,0);ctx.rateslope(10000);ctx.slopeadjust(10);assert.equal(ctx.rateSlope,10000);
ctx.rateslope(10001);assert.equal(ctx.rateSlope,10000);ctx.rateslope(-1);assert.equal(ctx.rateSlope,0);
ctx.rateslope(1234);const slopeSaved=ctx.getvalueof()[0];ctx.rateslope(0);ctx.setvalueof(slopeSaved);assert.equal(ctx.rateSlope,1234);
ctx.setvalueof(JSON.stringify({version:4,steps:defaults.steps,pool:defaults.pool,holdPercent:25,seed:1234}));assert.equal(ctx.rateSlope,0);
console.log('PASS: slope mid-ramp retarget continuity model, positive magnitude only, crossfaded direction changes, rate commands do not seek or wait, fine UI increments, position changes preserve ramp, zero time, limits and state migration');
