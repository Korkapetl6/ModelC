/* Independent sample command sequencer. MIT. ES5 for Max 8. */
function Compass(){this.steps=[1, 0, 9, 2, 13, 0, 0, 10, 9, 0, 10, 0, 10, 0, 1, 10];this.holdPercent=25;this.pool=[0,100,100,0,0,100,100,100,100,100,100,0,0,100,0,0];this.count=16;this.baseDivision=1;this.seed=1234;this.start=0;this.end=1;this.duration=1000;this.reset();}
Compass.prototype.random=function(){var s=this.rng|0;s^=s<<13;s^=s>>>17;s^=s<<5;this.rng=s>>>0;return this.rng/4294967296;};
Compass.prototype.reset=function(){this.rng=this.seed||1;this.index=-1;this.division=this.baseDivision;this.lo=this.start*this.duration;this.hi=Math.max(this.lo+1,this.end*this.duration);this.rate=1;return this.head(this.lo);};
Compass.prototype.head=function(p){return {lo:this.lo,hi:this.hi,rate:this.rate,pos:Math.max(this.lo,Math.min(this.hi-.01,p))};};
Compass.prototype.advance=function(){this.index=(this.index+1)%this.count;return this.command(this.steps[this.index]);};
Compass.prototype.command=function(c){var rates=[.5,1,2],p=null,sign=this.rate<0?-1:1,i=rates.indexOf(Math.abs(this.rate));
 switch(c){case 1:this.rate=Math.abs(this.rate);break;case 2:this.rate=-Math.abs(this.rate);break;case 3:this.rate=sign*rates[Math.min(2,i+1)];break;case 4:this.rate=sign*rates[Math.max(0,i-1)];break;case 5:this.rate=sign*rates[Math.floor(this.random()*3)];break;
 case 6:p=this.rate>0?this.lo:this.hi-.01;break;case 7:p=this.lo+this.random()*(this.hi-this.lo);break;
 case 8:var a=this.start*this.duration,b=this.end*this.duration,n=Math.min(b-a,40);this.lo=a+this.random()*Math.max(0,b-a-n);this.hi=this.lo+n+this.random()*Math.max(0,b-this.lo-n);p=this.rate>0?this.lo:this.hi-.01;break;
 case 9:this.division=Math.min(16,this.division*2);return null;case 10:this.division=Math.max(1,this.division/2);return null;case 11:this.division=16;return null;case 12:this.division=1;return null;case 13:this.index=Math.floor(this.random()*this.count);return null;
 case 14:case 15:return null;default:return null;}
 var h=this.head(p===null?this.lo:p);h.seek=p!==null;return h;};
Compass.prototype.holdCount=function(){return Math.round(this.count*Math.max(0,Math.min(100,Number(this.holdPercent)||0))/100);};
Compass.prototype.randomize=function(){
 var weights=[0],total=0,i,j,n=this.count,holds=this.holdCount(),slots=[],next=this.steps.slice();
 for(i=1;i<14;i++){var w=Number(this.pool[i]);w=isFinite(w)?Math.max(0,Math.min(100,w)):0;weights.push(w);total+=w;}
 if(holds<n&&total<=0)return false;
 this.seed=1+(this.seed%65535);this.rng=this.seed;
 // Advance beyond correlated first outputs of nearby 16-bit seeds.
 for(i=0;i<16;i++)this.random();
 for(i=0;i<n;i++)slots.push(i);
 // Uniformly shuffle active positions, then reserve exactly the requested number for Hold.
 for(i=n-1;i>0;i--){j=Math.floor(this.random()*(i+1));var tmp=slots[i];slots[i]=slots[j];slots[j]=tmp;}
 for(i=0;i<n;i++){
  if(i<holds){next[slots[i]]=0;continue;}
  var draw=this.random()*total;
  for(j=1;j<14;j++){if(weights[j]<=0)continue;if(draw<weights[j]){next[slots[i]]=j;break;}draw-=weights[j];}
 }
 this.steps=next;return true;
};
Compass.prototype.fadeValue=function(){return 1;};
if(typeof module!=='undefined')module.exports=Compass;

// Factory patterns are fixed commands, not weighted random draws.
Compass.presets=[{"name": "01 Soft drift", "steps": [2, 1, 0, 3, 0, 10, 2, 1, 0, 9, 4, 10, 2, 1, 0, 0], "slope": 50, "clock":0}, {"name": "02 Small detours", "steps": [2, 1, 9, 3, 13, 10, 2, 1, 0, 9, 4, 13, 2, 1, 10, 0], "slope": 50, "clock": 0}, {"name": "03 Position drift", "steps": [1, 2, 7, 9, 3, 0, 10, 13, 2, 0, 9, 0, 4, 10, 2, 7], "slope": 50, "clock": 0}, {"name": "04 Loop wander", "steps": [1, 2, 7, 9, 3, 8, 10, 13, 2, 0, 9, 0, 4, 10, 2, 6], "slope": 50, "clock": 0}, {"name": "05 Broken motion", "steps": [1, 2, 13, 9, 3, 8, 10, 7, 2, 13, 9, 0, 4, 10, 2, 6], "slope": 50, "clock": 0}, {"name": "06 Tape turns", "steps": [1, 3, 2, 9, 13, 8, 10, 4, 1, 7, 2, 9, 5, 13, 10, 6], "slope": 50, "clock": 0}, {"name": "07 Loop shuffle", "steps": [1, 8, 3, 9, 13, 2, 7, 10, 5, 8, 1, 9, 4, 13, 10, 6], "slope": 50, "clock": 0}, {"name": "08 Clock fracture", "steps": [1, 9, 3, 13, 8, 2, 0, 7, 5, 10, 13, 4, 8, 12, 1, 6], "slope": 50, "clock": 0}, {"name": "09 Jump cuts", "steps": [1, 13, 8, 0, 3, 7, 2, 10, 5, 13, 8, 12, 4, 7, 9, 13], "slope": 50, "clock": 0}, {"name": "10 Full scatter", "steps": [13, 8, 0, 5, 2, 7, 13, 12, 3, 8, 1, 0, 13, 4, 7, 5], "slope": 50, "clock": 0}];
Compass.prototype.applyPreset=function(index){
 if(index!==Math.floor(index)||index<0||index>=Compass.presets.length)return null;
 var p=Compass.presets[index];this.steps=p.steps.slice();this.count=16;this.baseDivision=1<<p.clock;this.seed=index===0?12340:1234+index*997;return p;
};

/* Safe edition: musical-time excursion window, independent of sequence jumps. */
(function(){
 var resetOriginal=Compass.prototype.reset;
 Compass.prototype.reset=function(){this.safeElapsed=0;this.safeRest=0;return resetOriginal.call(this);};
 Compass.prototype.advance=function(){
  var returning=this.safeElapsed>=4-1e-8;
  if(returning){this.safeElapsed=0;this.safeRest=2;this.division=1;this.rate=this.rate<0?-1:1;}
  var resting=this.safeRest>1e-8;
  this.index=(this.index+1)%this.count;
  var c=this.steps[this.index];
  // During recovery, both pitch and clock commands become Hold, without modifying the pattern.
  var h=this.command(resting&&((c>=3&&c<=5)||(c>=9&&c<=12))?0:c);
  if(returning){
   if(!h||h.lo===undefined){h=this.head(this.lo);h.seek=false;}
   h.rate=this.rate;
  }
  var beats=1/this.division;
  if(resting)this.safeRest=Math.max(0,this.safeRest-beats);
  else if(this.division!==1||Math.abs(this.rate)!==1||this.safeElapsed>0){
   // If a slower next step would cross the deadline, recover at this boundary instead.
   if(this.safeElapsed+beats>4+1e-8){
    this.safeElapsed=0;this.safeRest=1;this.division=1;this.rate=this.rate<0?-1:1;
    if(!h||h.lo===undefined){h=this.head(this.lo);h.seek=false;}h.rate=this.rate;
   }else this.safeElapsed+=beats;
  }
  return h;
 };
})();

/* No Repeat: compare consecutive step starts in 16 zones of the selected region. */
(function(){
 var resetOriginal=Compass.prototype.reset,advanceOriginal=Compass.prototype.advance;
 Compass.prototype.reset=function(){this.previousZone=-1;return resetOriginal.call(this);};
 Compass.prototype.advance=function(cursor){
  var h=advanceOriginal.call(this),a=this.start*this.duration,b=this.end*this.duration,width=(b-a)/16;
  var p=h&&h.seek?h.pos:Number(cursor);
  if(!isFinite(p))p=this.lo;
  p=Math.max(a,Math.min(b-.01,p));
  var zone=Math.max(0,Math.min(15,Math.floor((p-a)/width)));
  if(zone===this.previousZone){
   // Uniformly choose one of the other 15 zones, with no retry loop.
   var next=Math.floor(this.random()*15);if(next>=zone)next++;
   p=a+(next+.5)*width;
   // Preserve loop length, relocating it only if the new start lies outside it.
   if(p<this.lo||p>=this.hi-.01){
    var length=Math.min(b-a,this.hi-this.lo);
    this.lo=Math.max(a,Math.min(b-length,p-length/2));this.hi=this.lo+length;
   }
   h=this.head(p);h.seek=true;zone=next;
  }
  this.previousZone=zone;return h;
 };
})();
