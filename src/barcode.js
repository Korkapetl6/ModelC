/* Barcode for Simpler / Max 8 legacy JS. MIT; see LICENSE and upstream/barcode.lua. */
autowatch=0;inlets=1;outlets=2;
include('barcode-core.js');
var core=new BarcodeCore(Math.floor(Math.random()*4294967296)),ready=false,active=true,enabled=1,freeze=0,reverse=1,sync=0,follow=1;
var hostRate=48000;
var master=.7,cutoff=18000,resonance=.2,rateSlew=1,panSlew=1,levelSlew=1;
var selectedVoice=0,selectedParam=0,tempo=120,playing=false;
var sampleReady=false,loading=false,signature='',pending=null,desired=null,seconds=1,startOffset=0;
var scanTask=null,tickTask=null,loadTask=null,timeoutTask=null,apiOwn=null,apiSong=null;
var bufferName=jsarguments[1],buffer=new Buffer(bufferName),lastRows=[];
function scalar(api,key){var a=api.get(key);return a instanceof Array?a[0]:a;}
function objectId(a){for(var i=0;i<a.length-1;i++)if(a[i]==='id')return Number(a[i+1]);return Number(a[0])||0;}
function ids(a){var r=[];for(var i=0;i<a.length-1;i++)if(a[i]==='id')r.push(Number(a[++i]));return r;}
function text(id,s){var o=this.patcher.getnamed(id);if(o)o.message('set',String(s));}
function ui(id,value){var o=this.patcher.getnamed(id);if(o)o.message('set',value);}
function status(s){text('status',s);}
function cancel(t){if(t)t.cancel();}
function audioState(){
 var wet=enabled&&active&&sampleReady&&!loading&&(!follow||playing);
 outlet(0,'master',wet?master*.25:0,30);
 outlet(0,'dry',!enabled||!active?1:0,30);
}
function initialize(){
 if(ready)return;
 try{apiOwn=new LiveAPI(null,'this_device');apiSong=new LiveAPI(null,'live_set');}
 catch(e){status('Live API unavailable. Open this device in Live 11.');return;}
 ready=true;audioState();editor();
 tickTask=new Task(tick,this);tickTask.interval=250;tickTask.repeat();
 scanTask=new Task(scan,this);scanTask.interval=1000;scanTask.repeat();
 scan();updateFilter();
}
function findSample(){
 var parent=new LiveAPI(null,'id '+objectId(apiOwn.get('canonical_parent'))),list=ids(parent.get('devices'));
 var own=Number(apiOwn.id),idx=list.indexOf(own),simpler=null;
 for(var i=idx-1;i>=0;i--){var dev=new LiveAPI(null,'id '+list[i]);if(String(scalar(dev,'class_name'))==='OriginalSimpler'){simpler=dev;break;}}
 if(!simpler)throw Error('Place Barcode after Simpler, in the same device chain.');
 var sid=objectId(simpler.get('sample'));if(!sid)throw Error('Drop a sample into Simpler.');
 var sm=new LiveAPI(null,'id '+sid),path=String(scalar(sm,'file_path')||'');
 var sr=Number(scalar(sm,'sample_rate')),len=Number(scalar(sm,'length'));
 var start=Number(scalar(sm,'start_marker')),end=Number(scalar(sm,'end_marker'));
 if(!path||!isFinite(sr)||sr<=0||!isFinite(len)||len<2)throw Error('Simpler sample is unavailable.');
 if(!isFinite(start))start=0;if(!isFinite(end))end=len;
 start=Math.max(0,Math.min(len-1,start));end=Math.max(start+1,Math.min(len,end));
 return {path:path,rate:sr,start:start/sr,duration:Math.min(60,(end-start)/sr),signature:[sid,path,start,end,sr].join('|')};
}
function scan(){
 if(!ready)return;
 try{
  desired=findSample();
  if(!loading&&desired.signature!==signature)loadSample(desired);
 }catch(e){
  desired=null;sampleReady=false;signature='';audioState();status(String(e.message||e));
 }
}
function loadSample(s){
 loading=true;sampleReady=false;pending=s;audioState();status('Loading: '+s.path.split(/[\\/]/).pop());
 cancel(loadTask);cancel(timeoutTask);
 loadTask=new Task(function(){
  // Let the output fade finish before replacing the shared audio buffer.
  // Max buffer~ replace arguments are filename, offset(ms), duration(ms).
  outlet(0,'load',s.path,s.start*1000,s.duration*1000);
 },this);loadTask.schedule(40);
 timeoutTask=new Task(function(){
  if(loading){sampleReady=false;audioState();status('Sample load failed or timed out. Check the file; press Reload.');}
 },this);timeoutTask.schedule(10000);
}
function loaded(){
 if(!loading||!pending)return;
 cancel(timeoutTask);
 try{
  var frames=Number(buffer.framecount());
  if(!isFinite(frames)||frames<2)throw Error('Empty or unsupported audio file.');
  // buffer~ preserves the source sample rate; we loaded only the requested region.
  seconds=Math.min(pending.duration,frames/pending.rate);
  outlet(0,'channels',Number(buffer.channelcount())>1?2:1);
  startOffset=0;signature=pending.signature;loading=false;
  sampleReady=!!desired&&desired.signature===signature;
  core.time=0;
  lastRows=core.tick(seconds,tempo,sync,freeze,reverse,false);sendRows();
  for(var i=0;i<6;i++)outlet(0,'seek',i,lastRows[i].start*1000);
  if(sampleReady)status(pending.path.split(/[\\/]/).pop()+' | '+seconds.toFixed(2)+' s | '+(follow?'Follows Live transport':'Free playback'));
  audioState();
  if(desired&&desired.signature!==signature)loadSample(desired);
 }catch(e){loading=false;sampleReady=false;signature='';status('Load error: '+e.message);audioState();}
}
function sendRows(){
 var draw=[master,selectedVoice];
 for(var i=0;i<lastRows.length;i++){
  var v=lastRows[i],angle=(v.pan+1)*Math.PI/4;
  outlet(0,'bounds',i,v.start*1000,v.end*1000);
  outlet(0,'rate',i,(enabled&&active&&(!follow||playing))?v.rate:0,rateSlew*1000);
  // Independent level/pan ramps are applied separately in the audio patch.
  outlet(0,'level',i,v.level,levelSlew*1000);
  outlet(0,'pan',i,Math.cos(angle),Math.sin(angle),panSlew*1000);
  draw.push(v.level,v.pan,v.rate,v.start/seconds,v.end/seconds,0);
 }
 outlet(1,['data'].concat(draw));
}
function tick(){
 if(!ready)return;
 try{tempo=Number(scalar(apiSong,'tempo'))||120;playing=Number(scalar(apiSong,'is_playing'))!==0;}catch(e){playing=false;}
 if(sampleReady&&!loading){
  lastRows=core.tick(seconds,tempo,sync,freeze||!active||!enabled||(follow&&!playing),reverse,true);sendRows();
 }
 audioState();
}
function samplerate(x){if(isFinite(Number(x))&&Number(x)>=8000){hostRate=Number(x);updateFilter();}}
function updateFilter(){
 var f=Math.min(cutoff,hostRate*.45),q=.5+12*resonance*resonance;
 var w=2*Math.PI*f/hostRate,c=Math.cos(w),a=Math.sin(w)/(2*q),n=1+a;
 // Max biquad~ order: feedforward a0,a1,a2 then feedback b1,b2.
 outlet(0,'filter',(1-c)/2/n,(1-c)/n,(1-c)/2/n,-2*c/n,(1-a)/n);
}
function enable(x){enabled=Number(x)!==0;audioState();}
function deviceactive(x){active=Number(x)!==0;audioState();}
function lfofreeze(x){freeze=Number(x)!==0;tick();}
function allowreverse(x){reverse=Number(x)!==0;tick();}
function bpmsync(x){sync=Number(x)!==0;tick();}
function transport(x){follow=Number(x)!==0;audioState();}
function volume(x){master=Math.max(0,Math.min(1,Number(x)||0));audioState();}
function filterfreq(x){cutoff=Math.max(20,Math.min(20000,Number(x)||20));updateFilter();}
function filterres(x){resonance=Math.max(0,Math.min(.85,Number(x)||0));updateFilter();}
function rateslew(x){rateSlew=Math.max(.01,Math.min(30,Number(x)||.01));}
function panslew(x){panSlew=Math.max(.01,Math.min(30,Number(x)||.01));}
function levelslew(x){levelSlew=Math.max(.01,Math.min(30,Number(x)||.01));}
function voice(x){selectedVoice=Math.max(0,Math.min(5,Math.round(Number(x))-1));editor();sendRows();}
function parameter(x){selectedParam=Math.max(0,Math.min(5,Math.round(Number(x))));editor();}
function editor(){
 var v=core.voice[selectedVoice],o=this.patcher.getnamed('bias');
 var lo=selectedParam===2?-6:(selectedParam===4?-1:(selectedParam===5?0:-2));
 var hi=selectedParam===2?6:(selectedParam===4?0:(selectedParam===5?1:2));
 if(o){o.message('minimum',lo);o.message('maximum',hi);o.message('set',v.bias[selectedParam]);}
 ui('period',v.period[selectedParam]);ui('voice',selectedVoice+1);ui('parameter',selectedParam);
 text('edit-label','Voice '+(selectedVoice+1)+' / '+['Level','Pan','Rate','Direction','Loop start','Loop end'][selectedParam]);
}
function bias(x){core.edit(selectedVoice,selectedParam,Number(x),null);notifyclients();refreshValues();}
function period(x){core.edit(selectedVoice,selectedParam,null,Number(x));notifyclients();refreshValues();}
function refreshValues(){if(sampleReady&&!loading){lastRows=core.tick(seconds,tempo,sync,freeze,reverse,false);sendRows();}}
function reload(){
 // Explicit retry. Muting precedes replacement; no script ever changes Simpler.
 cancel(loadTask);cancel(timeoutTask);loading=false;sampleReady=false;signature='';audioState();scan();
}
function resetvoices(){core=new BarcodeCore(Math.floor(Math.random()*4294967296));editor();notifyclients();refreshValues();}
function getvalueof(){return [JSON.stringify({format:'BarcodeSimpler',version:1,core:core.exportState(),voice:selectedVoice,param:selectedParam})];}
function setvalueof(){
 var a=arrayfromargs(arguments);if(!a.length||!a[0])return;
 try{var s=JSON.parse(String(a[0]));if(s.format!=='BarcodeSimpler'||s.version!==1)throw Error('Unknown state');
  core=BarcodeCore.fromState(s.core);selectedVoice=Math.max(0,Math.min(5,Math.round(Number(s.voice)||0)));selectedParam=Math.max(0,Math.min(5,Math.round(Number(s.param)||0)));
  editor();refreshValues();
 }catch(e){status('Saved settings rejected: '+e.message);}
}
function notifydeleted(){cancel(scanTask);cancel(tickTask);cancel(loadTask);cancel(timeoutTask);ready=false;}
