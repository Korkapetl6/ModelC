#include "DistrhoPlugin.hpp"
#include "Synth.hpp"
START_NAMESPACE_DISTRHO
class BeadsTablePlugin : public Plugin {
 beadstable::Synth synth;
public:
 BeadsTablePlugin():Plugin(beadstable::Count,0,0){synth.reset(getSampleRate());}
 const char* getLabel()const override{return "BeadsTable";}
 const char* getDescription()const override{return "Beads continuous wavetable oscillator with eight MIDI voices and ADSR.";}
 const char* getMaker()const override{return "BeadsTable contributors";}
 const char* getHomePage()const override{return "https://github.com/pichenettes/eurorack";}
 const char* getLicense()const override{return "MIT / ISC";}
 uint32_t getVersion()const override{return d_version(0,1,0);}
 void initAudioPort(bool input,uint32_t index,AudioPort& port)override{port.groupId=kPortGroupStereo;Plugin::initAudioPort(input,index,port);}
 void initParameter(uint32_t id,Parameter& p)override{
  const auto& s=beadstable::specs[id];p.name=s.name;p.symbol=s.symbol;p.unit=s.unit;
  p.hints=kParameterIsAutomatable|(s.integer?kParameterIsInteger:0)|(s.logarithmic?kParameterIsLogarithmic:0);
  p.ranges.min=s.min;p.ranges.max=s.max;p.ranges.def=s.initial;
 }
 float getParameterValue(uint32_t id)const override{return synth.parameter(id);}
 void setParameterValue(uint32_t id,float value)override{synth.parameter(id,value);}
 void sampleRateChanged(double rate)override{synth.reset(rate);}
 void activate()override{synth.reset(getSampleRate());}
 void run(const float**,float** out,uint32_t frames,const MidiEvent* events,uint32_t count)override{
  uint32_t cursor=0;
  for(uint32_t i=0;i<count;++i){
   const auto& e=events[i];const uint32_t next=std::max(cursor,std::min(e.frame,frames));
   synth.render(out[0]+cursor,out[1]+cursor,next-cursor);cursor=next;
   if(e.size<=4)synth.midi(e.data,e.size);
  }
  synth.render(out[0]+cursor,out[1]+cursor,frames-cursor);
 }
};
Plugin* createPlugin(){return new BeadsTablePlugin;}
END_NAMESPACE_DISTRHO
