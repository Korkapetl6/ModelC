/* Test the actual legacy-js controller in a deterministic Max/Live API model.
 * Models remote ownership and native-value release, deferred Tasks, persistent
 * observer bindings, parameter deletion and automation. Not a Max runtime test.
 */
const assert = require('assert');
const fs = require('fs');
const path = require('path');
const vm = require('vm');
const Core = require('../src/scene-core.js');
const source = fs.readFileSync(path.join(__dirname, '../src/octascenes.js'), 'utf8');
let passed = 0;
function test(name, fn) { fn(); passed++; console.log('PASS ' + name); }
function harness() {
  let now = 1000, queue = [], selected = 0, notifications = 0;
  const parameters = {}, outputs = [], statuses = [], boxes = {}, nativeWrites = [];
  function param(id, value, opts={}) {
    parameters[id] = Object.assign({id, value, native:value, min:0, max:1, is_quantized:0,
      automation_state:0, is_enabled:1, name:'Parameter '+id, type:'DeviceParameter',
      path:'live_set tracks 0 devices 0 parameters '+id, remote:false},opts);
  }
  param(101,.8); param(102,.2); param(103,0,{max:3,is_quantized:1});
  function Task(fn, ctx) { this.fn=fn;this.ctx=ctx;this.active=false;this.interval=0;this.repeating=false; }
  Task.prototype.schedule=function(ms) { this.active=true;queue.push({at:now+ms,task:this}); };
  Task.prototype.cancel=function(){this.active=false;};
  Task.prototype.repeat=function(){this.repeating=true;this.schedule(this.interval);};
  function advance(ms) {
    const until=now+ms; let iterations=0;
    while (true) {
      queue.sort((a,b)=>a.at-b.at); const event=queue[0];
      if(!event||event.at>until) break;
      queue.shift(); now=event.at;
      if(event.task.active){
        if(!event.task.repeating)event.task.active=false;
        event.task.fn.call(event.task.ctx);
        if(event.task.repeating&&event.task.active)event.task.schedule(event.task.interval);
      }
      assert(++iterations<20000,'task loop');
    }
    now=until;
  }
  function LiveAPI(cb, p) {this._id = p==='this_device'?900:p==='live_set view selected_parameter'?selected:Number(String(p).replace('id ',''));}
  Object.defineProperty(LiveAPI.prototype,'id',{get(){return this._id===900?900:parameters[this._id]?this._id:0;}});
  Object.defineProperty(LiveAPI.prototype,'type',{get(){return parameters[this._id]?.type||'Device';}});
  Object.defineProperty(LiveAPI.prototype,'path',{get(){return '"'+(this._id===900?'live_set tracks 1 devices 0':parameters[this._id]?.path||'')+'"';}});
  LiveAPI.prototype.get=function(key){const p=parameters[this._id];if(!p)throw Error('missing');return [p[key]];};
  LiveAPI.prototype.set=function(key,value){
    const p=parameters[this._id];assert(p,'write missing');assert(!p.remote,'native write while remote owns target');
    assert.equal(key,'value'); assert(value>=p.min&&value<=p.max,'range');
    p.native=p.value=value;nativeWrites.push([p.id,value]);
  };
  LiveAPI.prototype.call=function(){};
  const context={SceneCore:Core,Task,LiveAPI,Date:{now:()=>now},include(){},arrayfromargs:a=>Array.from(a),
    notifyclients(){notifications++;},post(){},error(){},
    patcher:{getnamed(name){return boxes[name]||(boxes[name]={messages:[],message(...args){this.messages.push(args);}});}},
    outlet(port,...args){
      outputs.push([port,...args]); if(port===1){statuses.push(args[0]);return;}
      if(port!==0)return;
      const [command,slot,id,value]=args;
      if(command==='target') {const p=parameters[id];assert(p,'target missing');p.remote=true;p.value=value;}
      if(command==='release') {
        const id=context.bindings[slot],p=parameters[id];if(p){p.remote=false;p.value=p.native;}
      }
    }};
  vm.createContext(context);vm.runInContext(source,context,{filename:'octascenes.js'});
  // LiveAPI .get arrays cross the vm boundary: use VM arrays as real Max does.
  context.scalar=v=>Array.isArray(v)?v[0]:v;
  function setup() {
    const c=new Core();
    for(const [slot,id] of [[0,101],[1,102],[2,103]]) {
      const p=parameters[id];c.setMapping(slot,{key:'m'+slot,label:p.name,min:p.min,max:p.max,quantized:!!p.is_quantized});
      context.binding(slot,id);
    }
    let base=c.getBase();base[0]=.8;base[1]=.2;base[2]=0;c.setBase(base);
    c.setLock(0,0,.1);c.setLock(1,1,.9);c.setLock(2,2,1);
    context.setvalueof(JSON.stringify({format:'OctaScenes',version:1,core:c.exportState(),performance:{enabled:false,mode:0,scene:0,a:0,b:1,x:0,slot:0}}));
    context.initialize();advance(200);return c;
  }
  return {c:context,parameters,outputs,statuses,boxes,nativeWrites,advance,setup,param,
    select:id=>{selected=id;},notifications:()=>notifications};
}
test('DIRECT recall restores previous scene-only parameter; fade ignored in DIRECT',()=>{
  const h=harness();h.setup();h.c.enable(1);assert.equal(h.parameters[101].value,.1);
  h.c.scene(1);assert.equal(h.parameters[101].value,.8);assert.equal(h.parameters[102].value,.9);
  h.c.xfade(127);assert.equal(h.parameters[102].value,.9);
});
test('MORPH sparse interpolation, integer stepping and unowned parameter',()=>{
  const h=harness();h.setup();h.c.mode(1);h.c.enable(1);h.c.xfade(63.5);
  assert(Math.abs(h.parameters[101].value-.45)<1e-8);assert(Math.abs(h.parameters[102].value-.55)<1e-8);
  assert.equal(h.parameters[103].remote,false);
  h.c.a(2);h.c.b(3);h.c.xfade(63.5);assert.equal(h.parameters[103].value,2);
});
test('OFF restores native base after ownership release, quick ON does not capture scene',()=>{
  const h=harness();h.setup();h.c.enable(1);h.c.enable(0);h.c.enable(1);h.advance(100);
  assert.equal(h.c.core.getBase()[0],.8);assert.equal(h.parameters[101].value,.1);
  h.c.enable(0);h.advance(100);assert.equal(h.parameters[101].value,.8);assert(!h.parameters[101].remote);
});
test('EDIT initializes selected scene without spurious locks then records knob changes',()=>{
  const h=harness();h.setup();h.c.enable(1);h.c.edit(1);h.advance(250);
  assert.equal(h.c.core.getScene(0).locks[1],null);assert.equal(h.parameters[101].value,.1);
  h.parameters[102].value=h.parameters[102].native=.65;h.advance(60);
  assert.equal(h.c.core.getScene(0).locks[1],.65);assert.equal(h.c.core.getBase()[1],.2);
  h.c.edit(0);h.advance(100);assert.equal(h.parameters[102].value,.65);
  h.c.enable(0);h.advance(100);assert.equal(h.parameters[102].value,.2);
});
test('EDIT refuses automated parameters without changing their automation or native values',()=>{
  const h=harness();h.setup();h.parameters[102].automation_state=1;h.c.enable(1);h.c.edit(1);
  assert.equal(h.c.editing,false);h.c.enable(0);h.advance(100);
  assert(!h.nativeWrites.some(([id])=>id===102));
});
test('rapid EDIT scene selection and exit cancels all stale initialization tasks',()=>{
  const h=harness();h.setup();h.c.enable(1);h.c.edit(1);h.c.scene(1);h.c.scene(0);h.c.edit(0);h.advance(300);
  assert.equal(h.parameters[101].value,.1);assert.equal(h.parameters[102].value,.2);
  assert.equal(h.c.core.getScene(0).locks[1],null);
});
test('clear lock and scene return to base; copy is independent',()=>{
  const h=harness();h.setup();h.c.enable(1);h.c.copy();h.c.scene(4);h.c.paste();
  assert.equal(h.parameters[101].value,.1);h.c.clearlock();assert.equal(h.parameters[101].value,.8);
  assert.equal(h.c.core.getScene(0).locks[0],.1);h.c.scene(1);h.c.clearscene();assert.equal(h.parameters[102].value,.2);
});
test('persistent observer ID restores same mapping across a changed runtime ID',()=>{
  const h=harness();h.setup();h.c.enable(1);const saved=h.c.getvalueof()[0];
  assert(!saved.includes('"id"'));const n=harness();n.param(501,.7);n.c.binding(0,501);n.c.binding(1,102);n.c.binding(2,103);
  n.c.setvalueof(saved);n.c.initialize();n.advance(200);assert.equal(n.parameters[501].value,.1);assert.equal(n.c.core.getBase()[0],.8);
});
test('saved data rejects corruption atomically and unresolved/mismatched targets remain free',()=>{
  const h=harness();h.setup();const before=h.c.getvalueof()[0];h.c.setvalueof('{bad');assert.equal(h.c.getvalueof()[0],before);
  h.param(601,.2,{max:5});h.c.binding(0,601);h.c.enable(1);assert.equal(h.parameters[601].remote,false);
});
test('deleting mapped target releases reference without erasing stored locks',()=>{
  const h=harness();h.setup();h.c.enable(1);delete h.parameters[101];h.advance(1000);
  assert.equal(h.c.refs[0],null);assert.equal(h.c.core.getScene(0).locks[0],.1);
});
test('MAP arms while OFF, excludes own parameters and rejects duplicate mappings',()=>{
  const h=harness();h.setup();h.c.slot(3);h.select(101);h.c.map();
  h.param(901,.5,{path:'live_set tracks 1 devices 0 parameters 1'});h.select(901);h.advance(60);assert(h.c.mapArmed);
  h.select(102);h.advance(60);assert.equal(h.c.mapArmed,false);assert.equal(h.c.core.getMapping(3),null);
  h.c.map();h.param(104,.3,{name:'New Cutoff'});h.select(104);h.advance(60);assert.equal(h.c.core.getBase()[3],.3);
  h.c.enable(1);h.c.unmap();assert(h.c.core.getMapping(3));h.c.enable(0);h.advance(100);h.c.unmap();assert.equal(h.c.core.getMapping(3),null);
});
test('native device bypass releases ownership and resumes without recapturing base',()=>{
  const h=harness();h.setup();h.c.enable(1);h.c.deviceactive(0);h.advance(100);assert.equal(h.parameters[101].value,.8);assert(!h.parameters[101].remote);
  h.c.edit(1);assert.equal(h.c.editing,false);h.c.deviceactive(1);assert.equal(h.parameters[101].value,.1);assert.equal(h.c.core.getBase()[0],.8);
});
test('MORPH leaving edited but unlocked targets restores base; pending restore cannot overwrite new claim',()=>{
  const h=harness();h.setup();h.c.mode(1);h.c.enable(1);h.c.edit(1);h.advance(250);
  h.c.edit(0);h.c.a(2);h.c.b(2);h.advance(100);assert.equal(h.parameters[103].value,3);
  assert.equal(h.parameters[101].value,.8);assert.equal(h.parameters[102].value,.2);
});
test('remapping a copied slot cannot paste stale values into its new target',()=>{
  const h=harness();h.setup();h.c.copy();h.c.slot(0);h.c.unmap();h.c.map();h.param(104,.3);h.select(104);h.advance(60);
  h.c.scene(3);h.c.paste();assert.equal(h.c.core.getScene(3).locks[0],null);
});
test('data changes notify pattr, teardown cancels tasks and releases all targets',()=>{
  const h=harness();h.setup();h.c.enable(1);h.advance(60);assert(h.notifications()>0);
  h.c.freebang();h.advance(2000);assert(!h.parameters[101].remote);assert(!h.parameters[102].remote);
});
test('scene selection has persistent label and background independent of momentary button value',()=>{
  const h=harness();h.setup();h.c.scene(1);
  const last=(name,attribute)=>h.boxes[name].messages.filter(m=>m[0]===attribute).slice(-1)[0];
  assert.equal(last('scene_1','text')[1],'>2');
  assert.equal(last('scene_1','texton')[1],'>2');
  assert.equal(last('scene_0','text')[1],'1');
  assert.notDeepEqual(last('scene_1','activebgcolor'),last('scene_0','activebgcolor'));
  assert(last('detail','set')[1].startsWith('Scene 2 |'));
  h.c.scene(1);assert.equal(last('scene_1','text')[1],'>2');
});
test('selected parameter detail shows target and observed Live value in actual units',()=>{
  const h=harness();h.setup();h.c.enable(1);h.c.scene(1);
  const detail=h.boxes.detail.messages.filter(m=>m[0]==='set').slice(-1)[0][1];
  assert(detail.includes('Target 0.8'));assert(detail.includes('Live 0.8'));
});
console.log('\n'+passed+' controller tests passed (simulated Max/Live API).');
