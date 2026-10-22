#!/usr/bin/env python3
import json,sys,hashlib
from pathlib import Path
from patch import Patch,voice_patch,BG,INK,ACCENT,BUTTON
from amxd_container import Entry,frozen_amxd,unpack_frozen
ROOT=Path(__file__).resolve().parents[1]
NAMES=['Hold','Forward','Reverse','Rate +','Rate -','Rate random','Loop start','Position','Loop random','Clock +','Clock -','Clock fastest','Clock slowest','Step random','Fade out','Fade in']
SHORT=['--','FWD','REV','R+','R-','R?','HOME','POS?','LOOP?','C+','C-','C16','C1','STEP?','FADE OUT','FADE IN']
DEFAULT=[1, 14, 9, 2, 13, 14, 0, 10, 9, 14, 10, 15, 10, 14, 1, 10]
WEIGHTS=[100, 100, 100, 0, 0, 100, 100, 100, 100, 100, 100, 0, 0, 100, 100, 100]
p=Patch(1430,169,True)
p.data.update(devicewidth=1430.,openrect=[0.,0.,1430.,169.],project={'version':1,'amxdtype':1633771873,'hideprojectwindow':1,'contents':{'patchers':{}},'searchpath':{},'autolocalize':0},description='StepCompass sample command sequencer. Independent sample-only device.',digest='StepCompass M4L v0.1.6',autosave=0)
p.label('title','STEP COMPASS / SIMPLER',[10.,4.,240.,20.],fontface=1)
p.box('display','jsui',filename='display.js',rect=[10.,30.,240.,128.],presentation=1,presentation_rect=[10.,30.,240.,128.],numinlets=1,numoutlets=0)
p.label('status','Place directly after Simpler. Drop a sample into Simpler.',[260.,5.,730.,20.],varname='status')
p.label('playing','Step 0 | STOP',[1000.,5.,420.,20.],varname='playing')
p.box('engine',text='js compass.js #0-compass',varname='engine',numinlets=1,numoutlets=2)
p.box('defer',text='deferlow',numinlets=1,numoutlets=1);p.connect('defer',0,'engine');p.connect('engine',1,'display')
def cmd(ident,command):
 p.box(ident+'cmd',text='prepend '+command,numinlets=1,numoutlets=1);p.connect(ident,0,ident+'cmd');p.connect(ident+'cmd',0,'defer')
styles={'textcolor':INK,'textoncolor':BG,'bgcolor':BUTTON,'bgoncolor':ACCENT,'activebgcolor':BUTTON,'activebgoncolor':ACCENT,'activetextcolor':INK,'activetextoncolor':BG}
for i,(id,label,initial) in enumerate([('enable','ON',1),('freeplay','FREE PLAY',1)]):
 p.control(id,'live.text',label,[260.+i*96,30.,90.,22.],initial=initial,enum=['OFF',label],text='OFF' if id=='enable' else 'LIVE PLAY',texton=label,mode=1,**styles);cmd(id,id)
for i,(id,label) in enumerate([('reload','RELOAD'),('reset','RESET'),('randomize','RANDOMIZE')]):
 p.box(id,'textbutton',rect=[455.+i*112,30.,106.,22.],presentation=1,presentation_rect=[455.+i*112,30.,106.,22.],text=label,numinlets=1,numoutlets=3)
 p.box(id+'cmd','message',id,numinlets=2,numoutlets=1);p.connect(id,0,id+'cmd');p.connect(id+'cmd',0,'defer')
p.label('rateslope-label','Rate slope ms',[800.,31.,100.,20.])
# Native integer entry avoids normalized 0..10000 Live dragging; state lives in CompassData.
p.box('rateslope','number',rect=[898.,30.,72.,22.],varname='rateslope',minimum=0,maximum=10000,numinlets=1,numoutlets=2,presentation=1,presentation_rect=[898.,30.,72.,22.]);cmd('rateslope','rateslope')
for ident,label,delta,x in [('slope-minus','-10',-10,976.),('slope-plus','+10',10,1032.)]:
 p.box(ident,'textbutton',rect=[x,30.,50.,22.],presentation=1,presentation_rect=[x,30.,50.,22.],text=label,numinlets=1,numoutlets=3)
 p.box(ident+'cmd','message','slopeadjust '+str(delta),numinlets=2,numoutlets=1);p.connect(ident,0,ident+'cmd');p.connect(ident+'cmd',0,'defer')
for i in range(16):
 x=260.+(i%8)*104;y=60.+(i//8)*35
 p.label('label'+str(i),str(i+1),[x,y,18.,20.])
 p.control('step'+str(i),'live.menu','Step '+str(i+1),[x+18,y,82.,22.],maximum=15,initial=DEFAULT[i],enum=NAMES);cmd('step'+str(i),'step '+str(i))
for i,(id,label,lo,hi,val) in enumerate([('regionstart','Start %',0,99.9,0),('regionend','End %',.1,100,100),('smoothing','Fade ms',1,100,20),('volume','Out dB',-60,6,-6),('steps','Steps',1,16,16),('division','Clock 0-4',0,4,2),('seed','Seed',1,65535,1234)]):
 x=260.+i*118;p.label(id+'label',label,[x,130.,70.,17.]);p.control(id,'live.numbox',label,[x+64,130.,50.,22.],minimum=lo,maximum=hi,initial=val,unitstyle=4 if id=='volume' else 1);cmd(id,id)
p.label('hold-label','HOLD %',[1110.,31.,48.,20.],fontface=1)
p.control('holdpercent','live.numbox','Hold percent',[1159.,30.,48.,22.],minimum=0,maximum=100,initial=25,unitstyle=5);cmd('holdpercent','holdpercent')
p.label('hold-count','NEXT 4/16',[1110.,55.,74.,18.],varname='hold-count',fontsize=9.)
p.label('pool-label','COMMAND WEIGHTS',[1220.,30.,200.,20.],fontface=1)
for i in range(1,16):
 x=1110.+(i%4)*77;y=53.+(i//4)*25
 p.label('poolname'+str(i),SHORT[i],[x,y+2,37.,18.],fontsize=8.5)
 p.control('pool'+str(i),'live.numbox','Weight '+NAMES[i],[x+37,y,36.,21.],minimum=0,maximum=100,initial=WEIGHTS[i],unitstyle=1,fontsize=10.);cmd('pool'+str(i),'pool '+str(i))
p.box('ready',text='live.thisdevice',numinlets=1,numoutlets=3)
p.box('init','message','initialize',numinlets=2,numoutlets=1);p.connect('ready',0,'init');p.connect('init',0,'defer')
p.box('active',text='prepend deviceactive',numinlets=1,numoutlets=1);p.connect('ready',1,'active');p.connect('active',0,'defer')
p.box('data',text='pattr CompassData @bindto engine @parameter_enable 1',varname='CompassData',numinlets=1,numoutlets=3,saved_object_attributes={'parameter_enable':1,'parameter_mappable':0},saved_attribute_attributes={'valueof':{'parameter_type':3,'parameter_invisible':1,'parameter_longname':'CompassData','parameter_shortname':'CompassData'}});p.params['data']=['CompassData','CompassData',0]
protocol=['choose','load','bind','channels','bounds','edge','rate','seek','fade','loadgate','master','stepenv','start','clear','direction']
p.box('route',text='route '+' '.join(protocol),numinlets=1,numoutlets=len(protocol)+1);p.connect('engine',0,'route')
def route(name,dest,inlet=0):p.connect('route',protocol.index(name),dest,inlet)
p.box('replace',text='prepend replace',numinlets=1,numoutlets=1);route('load','replace')
p.box('buffer',text='buffer~ #0-compass',numinlets=1,numoutlets=2);p.connect('replace',0,'buffer');p.box('clearbuffer','message','clear',numinlets=2,numoutlets=1);route('clear','clearbuffer');p.connect('clearbuffer',0,'buffer')
p.box('loaded','message','loaded',numinlets=2,numoutlets=1);p.connect('buffer',1,'loaded');p.connect('loaded',0,'defer')
for name in ['bounds','edge','seek','fade','start','direction']:
 p.box(name+'route',text='route 0 1',numinlets=1,numoutlets=3);route(name,name+'route')
p.box('rate-glide',text='line~ 1.',numinlets=2,numoutlets=2);route('rate','rate-glide')
p.box('rate-meter',text='snapshot~ 20',numinlets=2,numoutlets=1);p.connect('rate-glide',0,'rate-meter')
p.box('rate-meter-cmd',text='prepend ratevalue',numinlets=1,numoutlets=1);p.connect('rate-meter',0,'rate-meter-cmd');p.connect('rate-meter-cmd',0,'defer')
for i in range(2):
 sub=voice_patch()
 sub['boxes']=[e for e in sub['boxes'] if e['box']['id']!='speed']
 sub['lines']=[e for e in sub['lines'] if 'speed' not in [e['patchline']['source'][0],e['patchline']['destination'][0]]]
 for e in sub['boxes']:
  b=e['box']
  if b['id']=='groove':b['text']='groove~ #0-compass 2 @loop 1 @loopinterp 1'
  if b['id']=='boundary-fade':b['text']='line~ '+('1.' if i==0 else '0.')
  if b['id']=='level':b['text']='line~ 1.'
  if b['id'].startswith('panline'):b['text']='line~ 1.'
 # Add phase snapshots for continuing at the current position on rate changes.
 q=Patch();q.data=sub;q.box('phase-out','outlet',rect=[650,440,30,30],index=4);q.connect('groove',2,'phase-out')
 q.box('direction-in','inlet',rect=[720,20,30,30],index=12);q.box('signed-rate',text='*~ 1.',numinlets=2,numoutlets=1);q.connect('in0',0,'signed-rate');q.connect('direction-in',0,'signed-rate',1);q.connect('signed-rate',0,'groove')
 p.box('head'+str(i),text='p head_'+str(i),numinlets=12,numoutlets=4,patcher=sub,outlettype=['signal','signal','bang','signal'])
 for name,inlet in [('bounds',1),('seek',4),('fade',9),('edge',10),('start',7),('direction',11)]:p.connect(name+'route',i,'head'+str(i),inlet)
 p.connect('rate-glide',0,'head'+str(i),0)
 route('bind','head'+str(i),6);route('channels','head'+str(i),5)
 p.box('ended'+str(i),'message','ended '+str(i),numinlets=2,numoutlets=1);p.connect('head'+str(i),2,'ended'+str(i));p.connect('ended'+str(i),0,'defer')
 p.box('snapshot'+str(i),text='snapshot~ 10',numinlets=2,numoutlets=1);p.connect('head'+str(i),3,'snapshot'+str(i))
 p.box('position'+str(i),text='prepend position '+str(i),numinlets=1,numoutlets=1);p.connect('snapshot'+str(i),0,'position'+str(i));p.connect('position'+str(i),0,'defer')
p.box('loadgate',text='line~ 0.',numinlets=2,numoutlets=2);route('loadgate','loadgate')
p.box('gatedone','message','gateended',numinlets=2,numoutlets=1);p.box('gatevalue',text='snapshot~',numinlets=2,numoutlets=1);p.connect('loadgate',0,'gatevalue');p.connect('loadgate',1,'gatevalue');p.box('gatezero',text='if $f1 <= 0.000001 then bang',numinlets=1,numoutlets=1);p.connect('gatevalue',0,'gatezero');p.connect('gatezero',0,'gatedone');p.connect('gatedone',0,'defer')
p.box('master',text='line~ 0.',numinlets=2,numoutlets=2);route('master','master')
# Each step resets the envelope; a new line message cancels the preceding ramp.
p.box('envmessage','message','$1, $2 $3',numinlets=2,numoutlets=1);route('stepenv','envmessage')
p.box('envline',text='line~ 1.',numinlets=2,numoutlets=2);p.connect('envmessage',0,'envline')
# Short smoothing only on discontinuities (e.g. Fade Out -> Hold), not a second musical fade.
p.box('stepenv',text='rampsmooth~ 64 64',numinlets=3,numoutlets=1);p.connect('envline',0,'stepenv')
p.box('output',text='plugout~',numinlets=2,numoutlets=0)
for ch in range(2):
 p.box('sum'+str(ch),text='+~',numinlets=2,numoutlets=1)
 for i in range(2):p.connect('head'+str(i),ch,'sum'+str(ch),i)
 prev='sum'+str(ch)
 for kind in ['master','loadgate','stepenv']:
  ident='amp'+str(ch)+kind;p.box(ident,text='*~',numinlets=2,numoutlets=1);p.connect(prev,0,ident);p.connect(kind,0,ident,1);prev=ident
 p.connect(prev,0,'output',ch)
p.data['parameters']={**p.params,'inherited_shortname':1}
p.data['dependency_cache']=[{'name':n,'type':'TEXT','implicit':1} for n in ['compass.js','core.js','display.js']]
dist=ROOT/'dist';dist.mkdir(exist_ok=True);blob=(json.dumps({'patcher':p.data},indent=2)+'\n').encode();(dist/'StepCompass.maxpat').write_bytes(blob)
entries=[Entry('StepCompass.amxd',blob+b'\0',b'JSON',17)]
for n in ['compass.js','core.js','display.js']:
 data=(ROOT/'src'/n).read_bytes();entries.append(Entry(n,data));(dist/n).write_bytes(data)
amxd=frozen_amxd(entries);assert unpack_frozen(amxd)==(b'aaaa',entries);(dist/'StepCompass-M4L-v0.1.6.amxd').write_bytes(amxd)
print('Built frozen AMXD:',len(amxd),'bytes')
