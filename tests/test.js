const assert=require('assert'),fs=require('fs'),vm=require('vm'),Core=require('../src/core.js');
let c=new Core();c.duration=10000;c.reset();for(let i=0;i<20000;i++){const h=c.command(i%16);assert(c.lo>=0&&c.hi<=10000&&c.hi>c.lo);assert(c.division>=1&&c.division<=16);if(h&&h.lo!==undefined)assert(h.pos>=h.lo&&h.pos<h.hi);}
let a=new Core(),b=new Core();for(let i=0;i<500;i++)assert.deepEqual(a.advance(),b.advance());a.pool.fill(0);assert(!a.randomize());a.pool[2]=1;assert(a.randomize());assert(a.steps.every(x=>x===2));
console.log('PASS: command bounds, seed repeatability, 20000 commands, random pool');
let messages=[],scheduled=[];const controls={};
function Task(fn,self){this.fn=()=>fn.call(self);this.repeat=()=>{};this.cancel=()=>{};this.schedule=()=>scheduled.push(this.fn);}
let song={is_playing:0,tempo:120,current_song_time:0};
const ctx={Compass:Core,include(){},jsarguments:['compass.js','unique-buffer'],Buffer:function(){this.framecount=()=>48000;this.length=()=>1000;this.channelcount=()=>1;this.peek=()=>.2;},Task,LiveAPI:function(){this.get=k=>[song[k]];},outlet(...args){messages.push(args);},notifyclients(){},arrayfromargs(args){return Array.from(args);},patcher:{getnamed(id){return {message(...a){controls[id]=a;}}}},console,Date,Math,JSON,isFinite};
vm.createContext(ctx);vm.runInContext(fs.readFileSync('src/compass.js','utf8'),ctx);
ctx.initialize();ctx.load('/samples/test name.wav');assert.equal(ctx.loadPhase,'fade');assert(!messages.some(m=>m[1]==='load'));ctx.gateended();assert(messages.some(m=>m[1]==='load'&&m[2]==='/samples/test name.wav'));ctx.loaded();assert(ctx.loadedOK);assert(messages.some(m=>m[1]==='channels'&&m[2]===1));assert(messages.some(m=>m[1]==='start'&&m[3]==='startloop'));
ctx.freeplay(1);ctx.tick();assert(ctx.wasRunning);assert(ctx.busy);ctx.transition({lo:100,hi:400,rate:-1,pos:350,seek:true});assert(ctx.queued);ctx.ended(0);assert(ctx.busy&&ctx.queued);ctx.ended(1);assert(ctx.busy&&!ctx.queued);ctx.ended(0);ctx.ended(1);assert(!ctx.busy);
ctx.volume(-60);ctx.enable(0);ctx.tick();ctx.enable(1);ctx.tick();assert.equal(messages.filter(m=>m[1]==='master').pop()[2],0);
ctx.load('/samples/new.wav');assert(!ctx.loadedOK);ctx.gateended();ctx.loaded();ctx.freeplay(0);ctx.tick();assert(!ctx.wasRunning);song.is_playing=1;ctx.tick();assert(ctx.wasRunning);song.current_song_time=.25;ctx.tick();assert(ctx.core.index>=1);
const saved=ctx.getvalueof()[0];ctx.setvalueof(saved);assert.equal(ctx.file,'/samples/new.wav');ctx.notifydeleted();
console.log('PASS: mocked Max/Live loading handshake, explicit start, stereo routing, both fade acknowledgments, mute, transport, state');
