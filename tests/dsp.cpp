#include "Synth.hpp"
#include <cassert>
#include <iostream>
#include <limits>
using namespace beadstable;
int main(){
 float l[257],r[257];
 for(double rate:{44100.,48000.,96000.}){
  Synth s;s.reset(rate);s.render(l,r,257);for(float x:l)assert(x==0);
  s.parameter(Release,10);
  for(int bank=1;bank<=12;++bank)for(int pos:{0,50,100}){
   s.parameter(Bank,bank);s.parameter(Position,pos);
   uint8_t on[]={0x90,69,100},off[]={0x80,69,0};s.midi(on,3);
   double energy=0;
   for(int j=0;j<50;++j){s.render(l,r,257);for(unsigned k=0;k<257;++k){assert(std::isfinite(l[k]));assert(std::abs(l[k])<=1);assert(l[k]==r[k]);energy+=l[k]*l[k];}}
   assert(energy>1e-8);s.midi(off,3);for(int j=0;j<10;++j)s.render(l,r,257);assert(s.activeVoices()==0);
  }
  for(int n=0;n<40;++n){uint8_t on[]={0x90,uint8_t(n+40),127};s.midi(on,3);s.render(l,r,257);}assert(s.activeVoices()==8);
  uint8_t kill[]={0xb0,120,0};s.midi(kill,3);assert(s.activeVoices()==0);
  uint8_t on[]={0x90,60,127},off[]={0x80,60,0},pedal[]={0xb0,64,127};
  s.midi(on,3);s.render(l,r,257);s.midi(pedal,3);s.midi(off,3);for(int j=0;j<20;++j)s.render(l,r,257);assert(s.activeVoices()==1);
  pedal[2]=0;s.midi(pedal,3);for(int j=0;j<20;++j)s.render(l,r,257);assert(s.activeVoices()==0);
  s.midi(nullptr,0);s.midi(on,1);s.midi(on,2);assert(s.activeVoices()==0);
  s.parameter(Bank,std::numeric_limits<float>::quiet_NaN());assert(s.parameter(Bank)==1);
 }
 // A4 tuning measured from waveform periodicity after oscillator smoothing.
 Synth tuned;tuned.parameter(Sustain,100);tuned.parameter(Attack,1);
 uint8_t a4[]={0x90,69,127};tuned.midi(a4,3);
 for(int i=0;i<100;++i)tuned.render(l,r,257);
 float signal[4096],right[4096];tuned.render(signal,right,4096);
 int bestLag=0;double bestError=1e30;
 for(int lag=90;lag<130;++lag){double error=0;for(int i=0;i<3900;++i){double delta=signal[i]-signal[i+lag];error+=delta*delta;}if(error<bestError){bestError=error;bestLag=lag;}}
 assert(std::abs(48000./bestLag-440.)<3.);
 std::array<float,Count> p{};p[Attack]=10;p[Decay]=20;p[Sustain]=50;p[Release]=10;
 Envelope e;e.start();for(int i=0;i<480;++i)e.next(p,48000);assert(std::abs(e.level-1)<.003);
 for(int i=0;i<965;++i)e.next(p,48000);assert(std::abs(e.level-.5)<.003);
 e.stop(10,48000);for(int i=0;i<485;++i)e.next(p,48000);assert(e.stage==Envelope::Idle);
 std::cout<<"PASS: 12 banks, positions, 3 rates, ADSR, sustain, stealing, silence, bounds and malformed MIDI\n";
}
