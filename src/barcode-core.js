/* Barcode sample player: adapted from Zachary Scholl's barcode v0.12.0 (MIT).
 * Native Max playback replaces norns softcut; recording/sharing are omitted.
 */
var BarcodeCore = (function () {
    var rates=[0.125,0.25,0.5,1,2,4], bases=[[.6,.6,1,1,.1,.05],[.4,.5,.6,.7,.8,.8],[4,1,2,3,5,6]];
    function clamp(x,a,b){return Math.max(a,Math.min(b,x));}
    function finite(x){return typeof x==='number'&&isFinite(x);}
    function Core(seed){
        this.seed=(seed===undefined?1234567:seed)>>>0;this.time=0;this.voice=[];
        for(var i=0;i<6;i++){
            var v={bias:[0,0,0,0,0,0],period:[],phase:[],lfo:[1,1,1,2,0,1]};
            for(var j=0;j<6;j++){
                v.phase[j]=Math.floor(this.random()*61);
                v.period[j]=j===2?0:(j===1?10+Math.floor(this.random()*11):20+Math.floor(this.random()*21));
            }
            this.voice.push(v);
        }
    }
    Core.prototype.random=function(){this.seed=(1664525*this.seed+1013904223)>>>0;return this.seed/4294967296;};
    Core.prototype.edit=function(v,p,bias,period){
        if(v<0||v>=6||p<0||p>=6)return;
        var lo=p===2?-6:(p===4?-1:(p===5?0:-2)),hi=p===2?6:(p===4?0:(p===5?1:2));
        if(finite(bias))this.voice[v].bias[p]=clamp(bias,lo,hi);
        if(finite(period))this.voice[v].period[p]=clamp(period,0,50);
    };
    Core.prototype.tick=function(duration,tempo,sync,freeze,reverse,advance){
        duration=finite(duration)?Math.max(.001,duration):1;
        tempo=finite(tempo)?clamp(tempo,20,999):120;
        if(!freeze&&advance!==false){this.time+=.25;if(this.time>60)this.time=0;}
        var result=[],beat=60/tempo;
        for(var i=0;i<6;i++){
            var v=this.voice[i],l=v.lfo,b=v.bias;
            if(!freeze)for(var j=0;j<6;j++){
                var per=v.period[j]*(sync?beat:1),off=v.phase[j]*(sync?beat:1);
                var x=per===0?1:Math.sin(2*Math.PI*this.time/per+off);
                l[j]=(j===0||j===2)?Math.abs(x):(j===3?1+x:x);
            }
            var level=clamp(bases[0][i]*l[0]+b[0],0,1),pan=clamp(bases[1][i]*l[1]+b[1],-1,1);
            var ri=clamp(Math.round(bases[2][i]*l[2]+b[2]),1,6)-1;
            var dir=clamp(-1+l[3]+b[3],-1,1)<.5?-1:1;if(!reverse)dir=1;
            var start=clamp((l[4]/2+1/3+b[4])*duration,0,duration*2/3);
            var end=clamp(start+(l[5]/2+2/3+b[5])*duration,duration/8,duration);
            // File bounds and a nonzero loop take precedence over softcut's padded buffer.
            end=Math.min(duration,Math.max(start+Math.min(.01,duration/8),end));
            result.push({level:level,pan:pan,rate:rates[ri]*dir,start:start,end:end});
        }
        return result;
    };
    Core.prototype.exportState=function(){return JSON.parse(JSON.stringify({seed:this.seed,time:this.time,voice:this.voice}));};
    Core.fromState=function(s){
        if(!s||!s.voice||s.voice.length!==6||!finite(s.time)||s.time<0||s.time>60)throw Error('Invalid Barcode state');
        var c=new Core(1);c.time=s.time;c.seed=s.seed>>>0;
        for(var i=0;i<6;i++){
            var v=s.voice[i];
            for(var k=0;k<4;k++){
                var key=['bias','period','phase','lfo'][k];
                if(!v[key]||v[key].length!==6)throw Error('Invalid voice');
                for(var j=0;j<6;j++)if(!finite(v[key][j]))throw Error('Invalid value');
            }
            c.voice[i].phase=v.phase.map(function(x){return clamp(x,0,60);});
            c.voice[i].lfo=v.lfo.map(function(x){return clamp(x,-1,2);});
            for(var p=0;p<6;p++)c.edit(i,p,v.bias[p],v.period[p]);
        }
        return c;
    };
    return Core;
}());
if(typeof module!=='undefined')module.exports=BarcodeCore;
