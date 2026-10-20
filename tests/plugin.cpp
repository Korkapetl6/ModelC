#include "../plugin/Plugin.cpp"
#include <cassert>
#include <cmath>
#include <iostream>
namespace DISTRHO {extern double d_nextSampleRate;extern uint32_t d_nextBufferSize;}
int main(){
 DISTRHO::d_nextSampleRate=48000;DISTRHO::d_nextBufferSize=128;
 DISTRHO::BeadsTablePlugin p;
 float l[128]{},r[128]{};float* out[]={l,r};
 DISTRHO::MidiEvent e{};e.frame=64;e.size=3;e.data[0]=0x90;e.data[1]=69;e.data[2]=127;
 p.run(nullptr,out,128,&e,1);
 for(int i=0;i<64;++i)assert(l[i]==0);
 double sum=0;for(int i=64;i<128;++i)sum+=std::abs(l[i]);assert(sum>0);
 p.setParameterValue(beadstable::Position,80);assert(p.getParameterValue(beadstable::Position)==80);
 for(int i=0;i<100;++i)p.run(nullptr,out,128,nullptr,0);
 e.frame=33;e.data[0]=0xb0;e.data[1]=120;e.data[2]=0;p.run(nullptr,out,128,&e,1);
 for(int i=33;i<128;++i)assert(l[i]==0);
 p.activate();p.run(nullptr,out,128,nullptr,0);for(float x:l)assert(x==0);
 std::cout<<"PASS: DPF adapter, MIDI sample offsets, parameter recall and activation reset\n";
}
