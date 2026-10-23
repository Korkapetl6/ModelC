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
