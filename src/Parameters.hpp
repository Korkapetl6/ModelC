#pragma once
#include <algorithm>
#include <cmath>
namespace beadstable {
enum ParameterId { Bank, Position, Attack, Decay, Sustain, Release, Volume, Count };
struct ParameterSpec { const char* name; const char* symbol; const char* unit; float min,max,initial; bool logarithmic,integer; };
static const ParameterSpec specs[Count] = {
 {"Bank","bank","",1,12,1,false,true},
 {"Position","position","%",0,100,0,false,false},
 {"Attack","attack","ms",1,5000,5,true,false},
 {"Decay","decay","ms",1,5000,200,true,false},
 {"Sustain","sustain","%",0,100,65,false,false},
 {"Release","release","ms",1,10000,350,true,false},
 {"Volume","volume","dB",-60,0,-12,false,false}
};
inline float sanitize(unsigned id,float value) {
 const auto& s=specs[id];
 if(!std::isfinite(value))return s.initial;
 value=std::max(s.min,std::min(s.max,value));
 return s.integer?std::round(value):value;
}
inline float normalized(unsigned id,float value) {
 const auto& s=specs[id];value=sanitize(id,value);
 return s.logarithmic?std::log(value/s.min)/std::log(s.max/s.min):(value-s.min)/(s.max-s.min);
}
inline float denormalized(unsigned id,float x) {
 const auto& s=specs[id];x=std::max(0.f,std::min(1.f,x));
 return sanitize(id,s.logarithmic?s.min*std::pow(s.max/s.min,x):s.min+x*(s.max-s.min));
}
}
