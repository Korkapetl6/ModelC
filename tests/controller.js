const assert=require('assert'),fs=require('fs'),vm=require('vm');
function setup(){
 const output=[],messages=[],tasks=[];let frames=480000,channels=2;
 const db={1:{canonical_parent:['id',10]},10:{devices:['id',2,'id',1]},2:{class_name:['OriginalSimpler'],sample:['id',3]},3:{file_path:['/tmp/a sample.wav'],sample_rate:[48000],length:[480000],start_marker:[0],end_marker:[480000]},99:{tempo:[120],is_playing:[1]}};
 const ctx={console,Math,JSON,isFinite,Number,String,Array,Error,jsarguments:['barcode.js','test-buffer'],autowatch:0,
  arrayfromargs:a=>Array.from(a),notifyclients:()=>{},outlet:(...a)=>output.push(a),
  patcher:{getnamed:id=>({message:(...args)=>messages.push([id,...args])})},
  Buffer:function(){this.framecount=()=>frames;this.channelcount=()=>channels;},
  LiveAPI:function(cb,path){this.id=path==='this_device'?1:path==='live_set'?99:Number(path.split(' ')[1]);this.get=key=>{if(!db[this.id]||!(key in db[this.id]))throw Error('missing '+key);return db[this.id][key];};},
  Task:function(fn,owner){this.cancel=()=>this.cancelled=true;this.repeat=()=>{};this.schedule=()=>{this.cancelled=false;tasks.push(()=>{if(!this.cancelled)fn.call(owner);});};}
 };
 vm.createContext(ctx);ctx.include=name=>vm.runInContext(fs.readFileSync(__dirname+'/../src/'+name,'utf8'),ctx);
 vm.runInContext(fs.readFileSync(__dirname+'/../src/barcode.js','utf8'),ctx);
 return {ctx,db,output,messages,tasks,setFrames:n=>frames=n,setChannels:n=>channels=n};
}
let n=0;function test(name,fn){fn();console.log('PASS '+name);n++;}
test('nearest preceding Simpler and exact path including spaces',()=>{
 const {ctx,tasks,output}=setup();ctx.initialize();assert(ctx.loading);tasks[0]();
 const load=output.find(x=>x[1]==='load');assert.deepStrictEqual(load,[0,'load','/tmp/a sample.wav',0,10000]);
});
test('sample completion enables six voices, stereo channel selection and seeks',()=>{
 const {ctx,output}=setup();ctx.initialize();ctx.loaded();ctx.tick();assert(ctx.sampleReady);
 assert.equal(output.filter(x=>x[1]==='seek').length,6);assert(output.some(x=>x[1]==='channels'&&x[2]===2));assert(output.some(x=>x[1]==='master'&&x[2]>0));
});
test('mono uses channel one for both output paths',()=>{const s=setup();s.setChannels(1);s.ctx.initialize();s.ctx.loaded();assert(s.output.some(x=>x[1]==='channels'&&x[2]===1));});
test('trim markers and 60-second import cap',()=>{
 const s=setup();s.db[3].length=[48000*200];s.db[3].start_marker=[48000*10];s.db[3].end_marker=[48000*150];s.ctx.initialize();s.tasks[0]();
 assert.deepStrictEqual(s.output.find(x=>x[1]==='load'),[0,'load','/tmp/a sample.wav',10000,60000]);
});
test('sample replacement is queued until previous load completes',()=>{
 const s=setup();s.ctx.initialize();s.db[3].file_path=['/tmp/b.wav'];s.ctx.scan();assert.equal(s.ctx.pending.path,'/tmp/a sample.wav');
 s.ctx.loaded();assert(s.ctx.loading);assert.equal(s.ctx.pending.path,'/tmp/b.wav');assert(!s.ctx.sampleReady);
});
test('Simpler removal stops wet audio without reusing stale sample',()=>{
 const s=setup();s.ctx.initialize();s.ctx.loaded();s.db[10].devices=['id',1];s.ctx.scan();assert(!s.ctx.sampleReady);
 assert(s.output.filter(x=>x[1]==='master').slice(-1)[0][2]===0);
});
test('empty load stays silent and reports error',()=>{const s=setup();s.ctx.initialize();s.setFrames(0);s.ctx.loaded();assert(!s.ctx.sampleReady);assert(s.messages.some(x=>String(x[2]).includes('Load error')));});
test('failed read timeout remains muted',()=>{const s=setup();s.ctx.initialize();s.tasks[1]();assert(!s.ctx.sampleReady);assert(s.messages.some(x=>String(x[2]).includes('timed out')));});
test('transport, free playback and bypass are distinct',()=>{
 const s=setup();s.db[99].is_playing=[0];s.ctx.initialize();s.ctx.loaded();s.ctx.tick();
 assert.equal(s.output.filter(x=>x[1]==='master').slice(-1)[0][2],0);
 s.ctx.transport(0);s.ctx.tick();assert(s.output.filter(x=>x[1]==='master').slice(-1)[0][2]>0);
 s.ctx.enable(0);assert.equal(s.output.filter(x=>x[1]==='dry').slice(-1)[0][2],1);
});
test('pattr state restores bias and phase without persisting Live IDs',()=>{
 const a=setup();a.ctx.voice(3);a.ctx.parameter(2);a.ctx.bias(4);a.ctx.period(9);
 const json=a.ctx.getvalueof()[0],b=setup();b.ctx.setvalueof(json);assert.equal(b.ctx.core.voice[2].bias[2],4);assert.equal(b.ctx.core.voice[2].period[2],9);
 assert(!json.includes('file_path'));assert(!json.includes('signature'));
});
test('device inactive mutes wet and does not advance LFO time',()=>{
 const s=setup();s.ctx.initialize();s.ctx.loaded();s.ctx.deviceactive(0);let time=s.ctx.core.time;s.ctx.tick();assert.equal(s.ctx.core.time,time);
 assert.equal(s.output.filter(x=>x[1]==='master').slice(-1)[0][2],0);
});
test('low-pass coefficients stay stable at all UI extremes and sample rates',()=>{
 const s=setup();
 for(const sr of [8000,22050,44100,48000,96000])for(const f of [20,1000,20000])for(const r of [0,.2,.85]){
  s.ctx.samplerate(sr);s.ctx.filterfreq(f);s.ctx.filterres(r);
  const a=s.output.filter(x=>x[1]==='filter').slice(-1)[0].slice(2);
  assert(a.every(Number.isFinite));const b1=a[3],b2=a[4];
  // Jury stability conditions for 1 + b1 z^-1 + b2 z^-2.
  assert(Math.abs(b2)<1);assert(1+b1+b2>0);assert(1-b1+b2>0);
 }
});

console.log(n+' controller tests passed (mock Live API; not Max runtime)');
