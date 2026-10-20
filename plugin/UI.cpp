#include "DistrhoUI.hpp"
#include "Parameters.hpp"
#include <cstdio>
START_NAMESPACE_DISTRHO
class BeadsTableUI:public UI {
 float values[beadstable::Count];int drag=-1;float originY=0,originValue=0;
public:
 BeadsTableUI():UI(760,290){loadSharedResources();for(unsigned i=0;i<beadstable::Count;++i)values[i]=beadstable::specs[i].initial;}
 void parameterChanged(uint32_t id,float value)override{if(id<beadstable::Count){values[id]=value;repaint();}}
 void onNanoDisplay()override{
  fontFace(NANOVG_DEJAVU_SANS_TTF);
  beginPath();rect(0,0,760,290);fillColor(23,27,32);fill();
  fillColor(235,240,240);fontSize(26);text(24,40,"BEADS TABLE",nullptr);
  fontSize(13);fillColor(150,165,175);text(24,64,"Continuous wavetable / 8 voices / MIDI",nullptr);
  for(unsigned i=0;i<beadstable::Count;++i){
   float x=24+i*104;const float t=beadstable::normalized(i,values[i]);
   fillColor(210,220,225);fontSize(14);text(x,101,beadstable::specs[i].name,nullptr);
   beginPath();roundedRect(x,116,84,100,5);fillColor(40,47,54);fill();
   beginPath();roundedRect(x+8,204-80*t,68,4,2);fillColor(87,215,182);fill();
   char label[40];std::snprintf(label,sizeof(label),"%.0f %s",values[i],beadstable::specs[i].unit);
   fillColor(235,240,240);fontSize(14);text(x,239,label,nullptr);
  }
  fillColor(145,158,170);fontSize(12);text(24,272,"Drag vertically to change a value. Parameters can be automated in Live.",nullptr);
 }
 bool onMouse(const MouseEvent& ev)override{
  if(ev.button!=1)return false;
  if(!ev.press){if(drag>=0){editParameter(drag,false);drag=-1;return true;}return false;}
  int id=int((ev.pos.getX()-24)/104);
  if(ev.pos.getX()<24||id<0||id>=beadstable::Count||ev.pos.getY()<90||ev.pos.getY()>245)return false;
  drag=id;originY=ev.pos.getY();originValue=beadstable::normalized(id,values[id]);editParameter(id,true);return true;
 }
 bool onMotion(const MotionEvent& ev)override{
  if(drag<0)return false;
  values[drag]=beadstable::denormalized(drag,std::max(0.f,std::min(1.f,originValue+(originY-float(ev.pos.getY()))/160.f)));
  setParameterValue(drag,values[drag]);repaint();return true;
 }
};
UI* createUI(){return new BeadsTableUI;}
END_NAMESPACE_DISTRHO
