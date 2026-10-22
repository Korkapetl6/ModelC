autowatch=0;inlets=1;outlets=2;include('core.js');
var core=new Compass(),name=jsarguments[1],buffer=new Buffer(name),song=null,task=null,ready=false,enabled=1,free=0,deviceOn=1;
var file='',wanted='',loadPhase='',loadedOK=false,loadTimeout=null,freeBeat=0,lastWall=0,lastBeat=null,nextBeat=0,wasRunning=false;
var tickCount=0,smooth=20,db=-6,activeHead=0,busy=false,acks=[false,false],queued=null,phase=[0,0],lastConfig=null,frameLength=0,channels=1;
function ui(id,v){var o=this.patcher.getnamed(id);if(o)o.message('set',v);}
function text(id,v){ui(id,String(v));}
function status(s){text('status',s);}
function clip(x,a,b){x=Number(x);return isFinite(x)?Math.max(a,Math.min(b,x)):a;}
function scalar(key){var v=song.get(key);return Number(v instanceof Array?v[0]:v);}
function initialize(){if(ready)return;try{song=new LiveAPI(null,'live_set');}catch(e){status('Open in Ableton Live 11 with Max for Live.');return;}
 ready=true;outlet(0,'bind',String(name));task=new Task(tick,this);task.interval=10;task.repeat();syncUI();if(file)load(file);else status('LOAD SAMPLE: WAV / AIFF. Then Live transport or FREE PLAY.');}
function syncUI(){for(var i=0;i<16;i++){ui('step'+i,core.steps[i]);ui('pool'+i,core.pool[i]);}ui('seed',core.seed);}
function choose(){outlet(0,'choose');}
function load(){var p=arrayfromargs(arguments).join(' ');if(!p)return;wanted=p;if(loadPhase)return;beginLoad();}
function beginLoad(){loadedOK=false;loadPhase='fade';queued=null;wasRunning=false;outlet(0,'loadgate',0,30);status('Loading sample...');}
function gateended(){if(loadPhase!=='fade')return;loadPhase='read';file=wanted;wanted='';notifyclients();outlet(0,'load',file);if(loadTimeout)loadTimeout.cancel();loadTimeout=new Task(function(){if(loadPhase==='read'){loadPhase='';loadedOK=false;status('Load failed. Try a PCM WAV or AIFF file.');if(wanted)beginLoad();}},this);loadTimeout.schedule(10000);}
function loaded(){if(loadPhase!=='read')return;if(loadTimeout)loadTimeout.cancel();var f=Number(buffer.framecount()),ms=Number(buffer.length());
 loadPhase='';if(!isFinite(ms)||ms<=0||f<32){loadedOK=false;status('Empty or unsupported sample.');if(wanted)beginLoad();return;}
 core.duration=ms;frameLength=f;channels=buffer.channelcount()>1?2:1;outlet(0,'channels',channels);outlet(0,'bind',String(name));
 queued=null;var initial=core.reset();configure(0,initial);configure(1,initial);lastConfig=core.head(core.lo);loadedOK=true;lastBeat=null;wasRunning=false;
 var wave=[];for(var i=0;i<200;i++){var p=Math.floor(i*f/200),v=buffer.peek(1,p,1);wave.push(Math.abs(Number(v)||0));}outlet(1,'wave',wave);
 status(file.split(/[\\/]/).pop()+' | '+(ms/1000).toFixed(2)+' s | sample ready');
 if(wanted){loadPhase='fade';gateended();}else outlet(0,'loadgate',1,30);}
function configure(i,h){outlet(0,'bounds',i,h.lo,h.hi);outlet(0,'edge',i,1/Math.max(.000001,Math.min(.24,smooth*Math.abs(h.rate)/(h.hi-h.lo))),0);outlet(0,'rate',i,h.rate,0);outlet(0,'start',i,'startloop');outlet(0,'seek',i,h.pos);}
function transition(h){if(!loadedOK||loadPhase)return;if(busy){queued=h;return;}
 if(!h.seek&&lastConfig)h.pos=lastConfig.lo+phase[activeHead]*(lastConfig.hi-lastConfig.lo);
 h.pos=clip(h.pos,h.lo,h.hi-.01);var next=1-activeHead;configure(next,h);busy=true;acks=[true,true];outlet(0,'fade',next,1,smooth);outlet(0,'fade',activeHead,0,smooth);activeHead=next;lastConfig=h;}
function ended(i){i=Number(i);if(!busy||!acks[i])return;acks[i]=false;if(!acks[0]&&!acks[1]){busy=false;if(queued){var h=queued;queued=null;transition(h);}}}
function position(i,x){phase[Number(i)]=clip(x,0,1);}
function pan(x){outlet(0,'pan',Math.min(1,1-x),Math.min(1,1+x),15);}
function tick(){if(!ready)return;var now=Date.now(),dt=lastWall?Math.min(.1,(now-lastWall)/1000):0;lastWall=now;
 var playing=false,beat=0,tempo=120;try{playing=!!scalar('is_playing');tempo=scalar('tempo');beat=scalar('current_song_time');}catch(e){return;}
 if(free&&!playing){freeBeat+=dt*tempo/60;beat=freeBeat;}
 var run=!!(loadedOK&&!loadPhase&&enabled&&deviceOn&&(playing||free));
 if(run&&!wasRunning){var h=core.reset();h.seek=true;transition(h);pan(0);nextBeat=beat;lastBeat=beat;}
 if(run&&lastBeat!==null&&(beat<lastBeat-.02||beat-lastBeat>.5)){h=core.reset();h.seek=true;transition(h);nextBeat=beat;}
 if(run){var ticks=0;while(beat+1e-8>=nextBeat&&ticks++<32){h=core.advance();if(h){if(h.lo!==undefined)transition(h);pan(core.pan);}nextBeat+=1/core.division;}}
 if(run!==wasRunning){outlet(0,'master',run&&db>-60?Math.pow(10,db/20):0,20);wasRunning=run;}
 lastBeat=beat;if(++tickCount%5!==0)return;outlet(1,'state',core.index,core.count,core.start,core.end,core.division,core.rate,run?1:0);
 text('playing','Step '+(core.index+1)+' | '+core.rate+'x | '+core.division+'/beat'+(run?' | PLAY':' | STOP'));
}
function step(i,x){core.steps[clip(i,0,15)|0]=clip(x,0,15)|0;notifyclients();}
function pool(i,x){core.pool[clip(i,0,15)|0]=Number(x)?1:0;notifyclients();}
function steps(x){core.count=clip(x,1,16)|0;notifyclients();}
function division(x){core.baseDivision=1<<(clip(x,0,4)|0);core.division=core.baseDivision;notifyclients();}
function seed(x){core.seed=clip(x,1,65535)|0;core.rng=core.seed;notifyclients();}
function regionstart(x){core.start=Math.min(clip(x,0,99.9)/100,core.end-.001);reset();notifyclients();}
function regionend(x){core.end=Math.max(clip(x,.1,100)/100,core.start+.001);reset();notifyclients();}
function smoothing(x){smooth=clip(x,1,100);}
function volume(x){db=clip(x,-60,6);outlet(0,'master',wasRunning&&db>-60?Math.pow(10,db/20):0,20);}
function freeplay(x){free=Number(x)?1:0;}
function enable(x){enabled=Number(x)?1:0;}
function deviceactive(x){deviceOn=Number(x)?1:0;}
function reset(){var h=core.reset();h.seek=true;transition(h);pan(0);if(lastBeat!==null)nextBeat=lastBeat;}
function publish(id,v){var o=this.patcher.getnamed(id);if(o)o.message('int',v);}
function randomize(){if(!core.randomize()){status('Random pool is empty. Enable a command.');return;}for(var i=0;i<16;i++)publish('step'+i,core.steps[i]);publish('seed',core.seed);notifyclients();reset();}
function getvalueof(){return [JSON.stringify({version:1,file:file,steps:core.steps,pool:core.pool,seed:core.seed})];}
function setvalueof(){try{var s=JSON.parse(arrayfromargs(arguments).join(' '));if(s.version!==1)return;if(typeof s.file==='string')file=s.file;
 for(var i=0;i<16;i++){if(s.steps&&s.steps.length===16)core.steps[i]=clip(s.steps[i],0,15)|0;if(s.pool&&s.pool.length===16)core.pool[i]=s.pool[i]?1:0;}core.seed=clip(s.seed,1,65535)|0;syncUI();if(ready&&file)load(file);}catch(e){status('Could not restore saved sample state.');}}
function notifydeleted(){if(task)task.cancel();if(loadTimeout)loadTimeout.cancel();}
