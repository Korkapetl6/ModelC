const assert=require('assert'),fs=require('fs'),vm=require('vm'),Core=require('../src/core.js');
let c=new Core();c.duration=10000;c.reset();for(let i=0;i<20000;i++){const h=c.command(i%16);assert(c.lo>=0&&c.hi<=10000&&c.hi>c.lo);assert(c.division>=1&&c.division<=16);if(h&&h.lo!==undefined)assert(h.pos>=h.lo&&h.pos<h.hi);}
let a=new Core(),b=new Core();for(let i=0;i<500;i++)assert.deepEqual(a.advance(),b.advance());a.pool.fill(0);assert(!a.randomize());a.pool[2]=1;assert(a.randomize());assert(a.steps.every(x=>x===2));
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
