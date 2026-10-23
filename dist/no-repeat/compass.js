autowatch=0;inlets=1;outlets=2;include('core.js');
var core=new Compass(),name=jsarguments[1],buffer=new Buffer(name),song=null,own=null,task=null,scanTask=null,ready=false,enabled=1,free=1,deviceOn=1;
var file='',wanted=null,pendingSource=null,requestedSignature='',loadPhase='',loadedOK=false,loadTimeout=null,freeBeat=0,lastWall=0,lastBeat=null,nextBeat=0,wasRunning=false;
var rateSlope=50,rateGoal=1,rateActual=1;
var currentFade=0,fadeStart=0,fadeEnd=0,previousTempo=120;
var tickCount=0,smooth=20,db=-6,activeHead=0,busy=false,acks=[false,false],queued=null,phase=[0,0],lastConfig=null,frameLength=0,channels=1;
function ui(id,v){var o=this.patcher.getnamed(id);if(o)o.message('set',v);}
function text(id,v){ui(id,String(v));}
function status(s){text('status',s);}
function clip(x,a,b){x=Number(x);return isFinite(x)?Math.max(a,Math.min(b,x)):a;}
function scalar(key){var v=song.get(key);return Number(v instanceof Array?v[0]:v);}
function initialize(){if(ready)return;try{song=new LiveAPI(null,'live_set');own=new LiveAPI(null,'this_device');}catch(e){status('Open in Ableton Live 11 with Max for Live.');return;}
 ready=true;outlet(0,'bind',String(name));task=new Task(tick,this);task.interval=10;task.repeat();syncUI();
 scanTask=new Task(scan,this);scanTask.interval=500;scanTask.repeat();scan();}
function holdHint(){text('hold-count','NEXT '+core.holdCount()+'/'+core.count);}
function syncUI(){for(var i=0;i<16;i++){ui('step'+i,core.steps[i]);if(i>0&&i<14)ui('pool'+i,core.pool[i]);}ui('rateslope',rateSlope);ui('holdpercent',core.holdPercent);ui('seed',core.seed);holdHint();}
function value(api,key){var a=api.get(key);return a instanceof Array?a[0]:a;}
function objectId(a){for(var i=0;i<a.length-1;i++)if(a[i]==='id')return Number(a[i+1]);return Number(a[0])||0;}
function ids(a){var r=[];for(var i=0;i<a.length-1;i++)if(a[i]==='id')r.push(Number(a[++i]));return r;}
function findSample(){
 var parent=new LiveAPI(null,'id '+objectId(own.get('canonical_parent'))),list=ids(parent.get('devices')),idx=list.indexOf(Number(own.id)),simpler=null;
 for(var i=idx-1;i>=0;i--){var dev=new LiveAPI(null,'id '+list[i]);if(String(value(dev,'class_name'))==='OriginalSimpler'){simpler=dev;break;}}
 if(!simpler)throw Error('Place StepCompass after Simpler in the same track or rack chain.');
 var sid=objectId(simpler.get('sample'));if(!sid)throw Error('Drop a sample into Simpler.');
 var sample=new LiveAPI(null,'id '+sid),path=String(value(sample,'file_path')||''),rate=Number(value(sample,'sample_rate')),length=Number(value(sample,'length'));
 var start=Number(value(sample,'start_marker')),end=Number(value(sample,'end_marker'));
 if(!path||!isFinite(rate)||rate<=0||!isFinite(length)||length<32)throw Error('Simpler sample is unavailable.');
 if(!isFinite(start))start=0;if(!isFinite(end))end=length;
 start=clip(start,0,length-1);end=clip(end,start+1,length);
 if(end-start<32)throw Error('Simpler region is too short (minimum 32 frames).');
 return {path:path,start:start/rate*1000,duration:(end-start)/rate*1000,signature:[simpler.id,sid,path,start,end,rate].join('|')};
}
function silence(){fadeReset();loadedOK=false;wasRunning=false;outlet(0,'master',0,20);}
function scan(){if(!ready)return;try{var source=findSample();if(source.signature!==requestedSignature){requestedSignature=source.signature;wanted=source;if(!loadPhase)beginLoad();}}
 catch(e){requestedSignature='';wanted=null;silence();status(String(e.message||e));}}
function reload(){requestedSignature='';scan();}
function beginLoad(){silence();loadPhase='fade';queued=null;outlet(0,'loadgate',0,30);status('Reading Simpler sample...');}
function gateended(){if(loadPhase!=='fade')return;if(!wanted){loadPhase='';return;}
 loadPhase='read';pendingSource=wanted;wanted=null;file=pendingSource.path;
 outlet(0,'clear');outlet(0,'load',file,pendingSource.start,pendingSource.duration);
 if(loadTimeout)loadTimeout.cancel();loadTimeout=new Task(function(){if(loadPhase==='read'){loadPhase='';silence();status('Sample load failed. Check Simpler and press RELOAD.');if(wanted)beginLoad();}},this);loadTimeout.schedule(10000);}
function loaded(){if(loadPhase!=='read'||!pendingSource)return;if(loadTimeout)loadTimeout.cancel();
 // Recheck the source before unmuting: Simpler may have changed or been removed during the read.
 var current=null;try{current=findSample();}catch(e){loadPhase='';wanted=null;requestedSignature='';silence();status(String(e.message||e));return;}
 if(current.signature!==pendingSource.signature){wanted=current;requestedSignature=current.signature;loadPhase='fade';gateended();return;}
 wanted=null;loadPhase='';var f=Number(buffer.framecount()),ms=Math.min(Number(buffer.length()),pendingSource.duration);
 if(!isFinite(ms)||ms<=0||f<32){silence();status('Empty or unsupported sample. Press RELOAD.');return;}
 core.duration=ms;frameLength=f;channels=buffer.channelcount()>1?2:1;outlet(0,'channels',channels);outlet(0,'bind',String(name));
 queued=null;var initial=core.reset();rateGoal=1;rateActual=1;outlet(0,'rate',1,0);configure(0,initial);configure(1,initial);lastConfig=core.head(core.lo);loadedOK=true;lastBeat=null;wasRunning=false;
 var wave=[];for(var i=0;i<200;i++){var p=Math.floor(i*f/200),v=buffer.peek(1,p,1);wave.push(Math.abs(Number(v)||0));}outlet(1,'wave',wave);
 status(file.split(/[\\/]/).pop()+' | Simpler '+(pendingSource.start/1000).toFixed(2)+'–'+((pendingSource.start+ms)/1000).toFixed(2)+' s | ready');outlet(0,'loadgate',1,30);}
function configure(i,h){phase[i]=clip((h.pos-h.lo)/(h.hi-h.lo),0,1);outlet(0,'direction',i,h.rate<0?-1:1);outlet(0,'bounds',i,h.lo,h.hi);outlet(0,'edge',i,1/Math.max(.000001,Math.min(.24,smooth*Math.abs(h.rate)/(h.hi-h.lo))),0);outlet(0,'start',i,'startloop');outlet(0,'seek',i,h.pos);}
// One audio-rate line~ is shared by both heads. Retargeting starts at its actual current output.
function rateslope(x){rateSlope=Math.round(clip(x,0,10000));notifyclients();}
function slopeadjust(x){rateslope(rateSlope+Number(x));ui('rateslope',rateSlope);}
function ratevalue(x){rateActual=clip(x,.5,2);}
function playCommand(h){
 if(!loadedOK||loadPhase)return;
 var magnitude=Math.abs(h.rate);
 if(magnitude!==rateGoal){rateGoal=magnitude;outlet(0,'rate',rateGoal,rateSlope);}
 // Speed never crosses zero. Direction changes use the idle head and a crossfade.
 if(h.seek===false){
  if(queued){queued.rate=h.rate;return;}
  if(lastConfig&&(h.rate<0)===(lastConfig.rate<0))return;
 }
 transition(h);
}
function transition(h){if(!loadedOK||loadPhase)return;if(busy){queued=h;return;}
 if(!h.seek&&lastConfig)h.pos=lastConfig.lo+phase[activeHead]*(lastConfig.hi-lastConfig.lo);
 h.pos=clip(h.pos,h.lo,h.hi-.01);var next=1-activeHead;configure(next,h);busy=true;acks=[true,true];outlet(0,'fade',next,1,smooth);outlet(0,'fade',activeHead,0,smooth);activeHead=next;lastConfig=h;}
function ended(i){i=Number(i);if(!busy||!acks[i])return;acks[i]=false;if(!acks[0]&&!acks[1]){busy=false;if(queued){var h=queued;queued=null;transition(h);}}}
function position(i,x){phase[Number(i)]=clip(x,0,1);}
function fadeReset(){currentFade=0;outlet(0,'stepenv',1,1,0);}
function stepEnvelope(command,start,end,beat,tempo){currentFade=command;fadeStart=start;fadeEnd=end;var phase=(beat-start)/Math.max(.000001,end-start);outlet(0,'stepenv',core.fadeValue(command,phase),core.fadeValue(command,1),Math.max(0,end-beat)*60000/Math.max(1,tempo));}
function tick(){if(!ready)return;var now=Date.now(),dt=lastWall?Math.min(.1,(now-lastWall)/1000):0;lastWall=now;
 var playing=false,beat=0,tempo=120;try{playing=!!scalar('is_playing');tempo=scalar('tempo');beat=scalar('current_song_time');}catch(e){return;}
 if(free&&!playing){freeBeat+=dt*tempo/60;beat=freeBeat;}
 var run=!!(loadedOK&&!loadPhase&&enabled&&deviceOn&&(playing||free));
 if(run&&!wasRunning){var h=core.reset();h.seek=true;playCommand(h);fadeReset();nextBeat=beat;lastBeat=beat;}
 if(run&&lastBeat!==null&&(beat<lastBeat-.02||beat-lastBeat>.5)){h=core.reset();h.seek=true;playCommand(h);nextBeat=beat;}
 if(run){var ticks=0;while(beat+1e-8>=nextBeat&&ticks++<32){h=core.advance(stepCursor());if(h&&h.lo!==undefined)playCommand(h);var end=nextBeat+1/core.division;stepEnvelope(h&&h.fade?h.fade:0,nextBeat,end,beat,tempo);nextBeat=end;}}
 if(run&&currentFade&&tempo!==previousTempo)stepEnvelope(currentFade,fadeStart,fadeEnd,beat,tempo);previousTempo=tempo;
 if(run!==wasRunning){outlet(0,'master',run&&db>-60?Math.pow(10,db/20):0,20);wasRunning=run;}
 lastBeat=beat;if(++tickCount%5!==0)return;outlet(1,'state',core.index,core.count,core.start,core.end,core.division,core.rate,run?1:0);
 text('playing','Step '+(core.index+1)+' | '+(core.rate<0?'-':'')+rateActual.toFixed(2)+'x'+(Math.abs(rateActual-rateGoal)>.01?' -> '+(core.rate<0?'-':'')+rateGoal+'x':'')+' | '+core.division+'/beat'+(core.safeRest>0?' | RECOVER':'')+(run?' | PLAY':' | STOP'));
}
function step(i,x){core.steps[clip(i,0,15)|0]=Number(x)>=14?0:clip(x,0,13)|0;notifyclients();}
function holdpercent(x){core.holdPercent=clip(x,0,100);holdHint();notifyclients();}
function pool(i,x){core.pool[clip(i,0,15)|0]=clip(x,0,100);notifyclients();}
function steps(x){core.count=clip(x,1,16)|0;holdHint();notifyclients();}
function division(x){core.baseDivision=1<<(clip(x,0,4)|0);core.division=core.baseDivision;notifyclients();}
function seed(x){core.seed=clip(x,1,65535)|0;core.rng=core.seed;notifyclients();}
function regionstart(x){core.start=Math.min(clip(x,0,99.9)/100,core.end-.001);reset();notifyclients();}
function regionend(x){core.end=Math.max(clip(x,.1,100)/100,core.start+.001);reset();notifyclients();}
function smoothing(x){smooth=clip(x,1,100);}
function volume(x){db=clip(x,-60,6);outlet(0,'master',wasRunning&&db>-60?Math.pow(10,db/20):0,20);}
function freeplay(x){free=Number(x)?1:0;}
function enable(x){enabled=Number(x)?1:0;}
function deviceactive(x){deviceOn=Number(x)?1:0;}
function reset(){var h=core.reset();h.seek=true;playCommand(h);fadeReset();if(lastBeat!==null)nextBeat=lastBeat;}
function publish(id,v){var o=this.patcher.getnamed(id);if(o)o.message('int',v);}
function randomize(){if(!core.randomize()){status('No command weights. Enable a command or set HOLD to 100%.');return;}for(var i=0;i<16;i++)publish('step'+i,core.steps[i]);publish('seed',core.seed);notifyclients();reset();status('Randomized: '+core.holdCount()+' Hold / '+core.count+' steps.');}
function getvalueof(){return [JSON.stringify({version:5,rateSlope:rateSlope,holdPercent:core.holdPercent,steps:core.steps,pool:core.pool,seed:core.seed})];}
function setvalueof(){try{var s=JSON.parse(arrayfromargs(arguments).join(' '));if(s.version!==1&&s.version!==2&&s.version!==3&&s.version!==4&&s.version!==5)return;rateSlope=s.version>=5?clip(s.rateSlope,0,10000):0;core.holdPercent=s.version>=4?clip(s.holdPercent,0,100):25;
 for(var i=0;i<16;i++){if(s.steps&&s.steps.length===16)core.steps[i]=Number(s.steps[i])>=14?0:clip(s.steps[i],0,13)|0;if(s.pool&&s.pool.length===16)core.pool[i]=s.version<3?(s.pool[i]?100:0):clip(s.pool[i],0,100);}core.pool[0]=0;core.pool[14]=0;core.pool[15]=0;core.seed=clip(s.seed,1,65535)|0;syncUI();if(ready)reload();}catch(e){status('Could not restore saved sample state.');}}
function notifydeleted(){if(task)task.cancel();if(scanTask)scanTask.cancel();if(loadTimeout)loadTimeout.cancel();}

var selectedPreset=0;
function presetselect(x){selectedPreset=clip(x,0,9)|0;}
function loadpreset(){
 var p=core.applyPreset(selectedPreset);if(!p)return;
 rateslope(p.slope);ui('rateslope',rateSlope);
 for(var i=0;i<16;i++)publish('step'+i,core.steps[i]);
 publish('steps',16);publish('division',p.clock);publish('seed',core.seed);
 reset();notifyclients();status('Preset: '+p.name+' | 16 steps | weights unchanged');
}

function stepCursor(){
 if(queued&&queued.seek)return queued.pos;
 if(lastConfig)return lastConfig.lo+phase[activeHead]*(lastConfig.hi-lastConfig.lo);
 return core.lo;
}
