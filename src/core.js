/* Independent sample command sequencer. MIT. ES5 for Max 8. */
function Compass(){this.steps=[1,0,0,7,0,0,2,0,0,8,0,0,1,0,6,0];this.pool=[];for(var i=0;i<16;i++)this.pool.push(1);this.count=16;this.baseDivision=4;this.seed=1234;this.start=0;this.end=1;this.duration=1000;this.reset();}
Compass.prototype.random=function(){var s=this.rng|0;s^=s<<13;s^=s>>>17;s^=s<<5;this.rng=s>>>0;return this.rng/4294967296;};
Compass.prototype.reset=function(){this.rng=this.seed||1;this.index=-1;this.division=this.baseDivision;this.lo=this.start*this.duration;this.hi=Math.max(this.lo+1,this.end*this.duration);this.rate=1;return this.head(this.lo);};
Compass.prototype.head=function(p){return {lo:this.lo,hi:this.hi,rate:this.rate,pos:Math.max(this.lo,Math.min(this.hi-.01,p))};};
Compass.prototype.advance=function(){this.index=(this.index+1)%this.count;return this.command(this.steps[this.index]);};
Compass.prototype.command=function(c){var rates=[-2,-1,-.5,.5,1,2],p=null,i=rates.indexOf(this.rate);
 switch(c){case 1:this.rate=1;break;case 2:this.rate=-1;break;case 3:this.rate=rates[Math.min(5,i+1)];break;case 4:this.rate=rates[Math.max(0,i-1)];break;case 5:this.rate=rates[Math.floor(this.random()*6)];break;
 case 6:p=this.rate>0?this.lo:this.hi-.01;break;case 7:p=this.lo+this.random()*(this.hi-this.lo);break;
 case 8:var a=this.start*this.duration,b=this.end*this.duration,n=Math.min(b-a,40);this.lo=a+this.random()*Math.max(0,b-a-n);this.hi=this.lo+n+this.random()*Math.max(0,b-this.lo-n);p=this.rate>0?this.lo:this.hi-.01;break;
 case 9:this.division=Math.min(16,this.division*2);return null;case 10:this.division=Math.max(1,this.division/2);return null;case 11:this.division=16;return null;case 12:this.division=1;return null;case 13:this.index=Math.floor(this.random()*this.count);return null;
 case 14:return {fade:14};case 15:return {fade:15};default:return null;}
 var h=this.head(p===null?this.lo:p);h.seek=p!==null;return h;};
Compass.prototype.randomize=function(){var a=[];for(var i=0;i<16;i++)if(this.pool[i])a.push(i);if(!a.length)return false;this.seed=1+Math.floor(this.random()*65534);this.rng=this.seed;for(i=0;i<16;i++)this.steps[i]=a[Math.floor(this.random()*a.length)];return true;};
Compass.prototype.fadeValue=function(command,phase){phase=Math.max(0,Math.min(1,phase));return command===14?1-phase:(command===15?phase:1);};
if(typeof module!=='undefined')module.exports=Compass;
