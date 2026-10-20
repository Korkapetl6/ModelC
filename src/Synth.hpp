#pragma once
#include <algorithm>
#include <array>
#include <cmath>
#include <cstdint>
#include "Parameters.hpp"
#include "stmlib/dsp/units.h"
#include "beads/resources.h"
#include "beads/dsp/frame.h"
#include "beads/dsp/granular_player.h"
#include "beads/dsp/wavetable_grain.h"
#include "beads/dsp/wavetable_voice.h"

namespace beadstable {
class Envelope {
public:
 enum Stage { Idle, AttackStage, DecayStage, SustainStage, ReleaseStage };
 Stage stage=Idle; float level=0,releaseStep=0;
 void start() {level=0;stage=AttackStage;}
 void stop(float ms,double rate) {if(stage!=Idle){stage=ReleaseStage;releaseStep=level/std::max(1.,ms*rate*.001);}}
 float next(const std::array<float,Count>& p,double rate) {
  switch(stage){
   case Idle:return 0;
   case AttackStage:level+=float(1./std::max(1.,p[Attack]*rate*.001));if(level>=1){level=1;stage=DecayStage;}break;
   case DecayStage:level-=float((1-p[Sustain]*.01)/std::max(1.,p[Decay]*rate*.001));
    if(level<=p[Sustain]*.01+1e-7f){level=p[Sustain]*.01f;stage=SustainStage;}break;
   case SustainStage:level=p[Sustain]*.01f;break;
   case ReleaseStage:level-=releaseStep;if(level<=1e-7f){level=0;stage=Idle;}break;
  }
  return level;
 }
};
class Synth {
 struct Voice {
  beads::WavetableVoice oscillator;
  Envelope envelope;
  int note=-1,channel=0; bool held=false;
  uint64_t age=0;float velocity=0,last=0,tail=0;unsigned tailLeft=0;
 };
 std::array<Voice,8> voices_{};
 std::array<float,16> bend_{};
 std::array<bool,16> pedal_{};
 std::array<float,Count> parameters_{};
 double rate_=48000;uint64_t age_=0;float gain_=0;
public:
 Synth(){for(unsigned i=0;i<Count;++i)parameters_[i]=specs[i].initial;reset(48000);}
 void reset(double rate){
  rate_=std::isfinite(rate)&&rate>=8000&&rate<=384000?rate:48000;
  for(auto& v:voices_){v.oscillator.Init(float(rate_));v.envelope=Envelope{};v.note=-1;v.held=false;v.tailLeft=0;v.last=0;}
  bend_.fill(0);pedal_.fill(false);gain_=std::pow(10.f,parameters_[Volume]/20.f);age_=0;
 }
 void parameter(unsigned id,float value){if(id<Count)parameters_[id]=sanitize(id,value);}
 float parameter(unsigned id)const{return id<Count?parameters_[id]:0;}
 unsigned activeVoices()const {unsigned n=0;for(const auto& v:voices_)if(v.envelope.stage!=Envelope::Idle)++n;return n;}
 void midi(const uint8_t* data,unsigned size) {
  if(!data||!size)return;
  const unsigned type=data[0]&0xf0,channel=data[0]&15;
  if(type==0x90&&size>=3&&data[2]){noteOn(channel,data[1]&127,data[2]&127);return;}
  if((type==0x80||type==0x90)&&size>=3){noteOff(channel,data[1]&127);return;}
  if(type==0xe0&&size>=3){bend_[channel]=(int((data[1]&127)|((data[2]&127)<<7))-8192)/8192.f*2;return;}
  if(type==0xb0&&size>=3){
   const unsigned cc=data[1]&127,value=data[2]&127;
   if(cc==64){pedal_[channel]=value>=64;if(!pedal_[channel])releaseUnheld(channel);}
   if(cc==123){for(auto& v:voices_)if(v.channel==int(channel))v.held=false; if(!pedal_[channel])releaseUnheld(channel);}
   if(cc==120){for(auto& v:voices_)if(v.channel==int(channel)){v.envelope=Envelope{};v.held=false;v.tailLeft=0;v.last=0;}}
   if(cc==121){pedal_[channel]=false;bend_[channel]=0;releaseUnheld(channel);}
  }
 }
 void render(float* left,float* right,unsigned frames) {
  const float targetGain=std::pow(10.f,parameters_[Volume]/20.f);
  const float gainSlew=float(1-std::exp(-1/(.005*rate_)));
  unsigned offset=0;
  while(offset<frames){
   const unsigned n=std::min(32u,frames-offset);
   float mix[32]{};bool freeze[32]{};
   for(auto& v:voices_){
    if(v.envelope.stage==Envelope::Idle && !v.tailLeft)continue;
    beads::FloatFrame buffer[32]{};beads::Parameters p{};
    // Use the original Beads continuous wavetable voice. CV path with zero
    // attenuverter explicitly avoids its internal random generator/shared RNG.
    p.pitch.base=float(v.note-48)+bend_[v.channel]+float(12*std::log2(130.8127826502993/130.81));
    p.time.base=parameters_[Position]*.01f;p.time.has_cv=true;
    v.oscillator.Render(int(parameters_[Bank])-1,16,freeze,p,buffer,n);
    for(unsigned j=0;j<n;++j){
     float sample=buffer[j].l*v.envelope.next(parameters_,rate_)*v.velocity;
     if(v.tailLeft){sample+=v.tail*float(v.tailLeft)/64.f;--v.tailLeft;}
     v.last=sample;mix[j]+=sample;
    }
   }
   for(unsigned j=0;j<n;++j){
    gain_+=(targetGain-gain_)*gainSlew;
    // Headroom for eight voices, with a bounded soft output stage at high gain.
    const float x=mix[j]*gain_*.25f;
    left[offset+j]=right[offset+j]=std::tanh(x);
   }
   offset+=n;
  }
 }
private:
 void releaseUnheld(unsigned channel){for(auto& v:voices_)if(v.channel==int(channel)&&!v.held&&v.envelope.stage!=Envelope::ReleaseStage)v.envelope.stop(parameters_[Release],rate_);}
 void noteOff(unsigned channel,unsigned note){
  Voice* oldest=nullptr;
  for(auto& v:voices_)if(v.held&&v.channel==int(channel)&&v.note==int(note)&&(!oldest||v.age<oldest->age))oldest=&v;
  if(oldest){oldest->held=false;if(!pedal_[channel])oldest->envelope.stop(parameters_[Release],rate_);}
 }
 void noteOn(unsigned channel,unsigned note,unsigned velocity){
  Voice* chosen=nullptr;
  for(auto& v:voices_)if(v.envelope.stage==Envelope::Idle){chosen=&v;break;}
  if(!chosen){
   for(auto& v:voices_)if(!v.held&&(!chosen||v.envelope.level<chosen->envelope.level))chosen=&v;
   if(!chosen)for(auto& v:voices_)if(!chosen||v.age<chosen->age)chosen=&v;
  }
  chosen->tail=chosen->last;chosen->tailLeft=chosen->envelope.stage==Envelope::Idle?0:64;
  // Keep oscillator state/bank continuous on voice reuse, matching Beads'
  // continuous source and avoiding a fresh bank-0 attack on every MIDI note.
  chosen->note=int(note);chosen->channel=int(channel);chosen->held=true;
  chosen->velocity=velocity/127.f;chosen->age=++age_;chosen->envelope.start();
 }
};
}
