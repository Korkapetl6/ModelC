/* No Repeat: exclude the previous step's estimated source span, including loop wraps. */
(function(){
 var resetOriginal=Compass.prototype.reset,advanceOriginal=Compass.prototype.advance;
 function span(lo,hi,p,travel,reverse){
  var length=hi-lo;p=Math.max(lo,Math.min(hi-.01,p));
  if(travel>=length)return [[lo,hi]];
  if(reverse){var left=p-travel;return left>=lo?[[left,p]]:[[lo,p],[hi-(lo-left),hi]];}
  var right=p+travel;return right<=hi?[[p,right]]:[[p,hi],[lo,lo+(right-hi)]];
 }
 function overlap(a,b){var sum=0;for(var i=0;i<a.length;i++)for(var j=0;j<b.length;j++)sum+=Math.max(0,Math.min(a[i][1],b[j][1])-Math.max(a[i][0],b[j][0]));return sum;}
 Compass.prototype.reset=function(){this.previousZone=-1;this.previousSpan=[];this.repeatLimited=false;return resetOriginal.call(this);};
 Compass.prototype.advance=function(cursor,tempo,actualRate){
  var h=advanceOriginal.call(this),a=this.start*this.duration,b=this.end*this.duration,width=(b-a)/16;
  tempo=Number(tempo);if(!isFinite(tempo)||tempo<=0)tempo=120;
  actualRate=Math.abs(Number(actualRate));if(!isFinite(actualRate))actualRate=Math.abs(this.rate);
  // Conservative rate during slope, plus a small snapshot/crossfade guard.
  var travel=(60000/tempo/this.division+30)*Math.max(Math.abs(this.rate),actualRate),self=this;
  function candidate(p){
   p=Math.max(a,Math.min(b-.01,p));var lo=self.lo,hi=self.hi;
   if(p<lo||p>=hi-.01){var length=Math.min(b-a,hi-lo);lo=Math.max(a,Math.min(b-length,p-length/2));hi=lo+length;}
   return {pos:p,lo:lo,hi:hi,zone:Math.max(0,Math.min(15,Math.floor((p-a)/width))),span:span(lo,hi,p,travel,self.rate<0)};
  }
  var p=h&&h.seek?h.pos:Number(cursor);if(!isFinite(p))p=this.lo;
  var chosen=candidate(p),score=overlap(chosen.span,this.previousSpan),changed=false;
  if(chosen.zone===this.previousZone||score>0){
   var best=null,bestScore=Infinity,offset=Math.floor(this.random()*64);
   for(var i=0;i<64;i++){
    var q=candidate(a+(((i+offset)%64)+.5)*(b-a)/64);
    if(q.zone===this.previousZone)continue;
    var s=overlap(q.span,this.previousSpan);
    if(s<bestScore){best=q;bestScore=s;if(s===0)break;}
   }
   if(best){chosen=best;score=bestScore;changed=true;}
  }
  if(changed){this.lo=chosen.lo;this.hi=chosen.hi;h=this.head(chosen.pos);h.seek=true;}
  this.repeatLimited=score>0;this.previousZone=chosen.zone;this.previousSpan=chosen.span;
  return h;
 };
})();
