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
