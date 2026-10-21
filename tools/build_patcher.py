#!/usr/bin/env python3
"""Build Barcode for Simpler, Max 8 audio effect."""

from __future__ import annotations

import argparse
import json
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
APPVERSION = {"major": 8, "minor": 5, "revision": 5, "architecture": "x64", "modernui": 1}
BG = [0.11, 0.12, 0.14, 1.0]
INK = [0.91, 0.93, 0.94, 1.0]
MUTED = [0.58, 0.64, 0.69, 1.0]
ACCENT = [0.27, 0.83, 0.67, 1.0]
BUTTON = [0.22, 0.25, 0.29, 1.0]


class Patch:
    def __init__(self, width=1100, height=169, presentation=False):
        self.data = {
            "fileversion": 1,
            "appversion": APPVERSION,
            "classnamespace": "box",
            "rect": [0.0, 0.0, float(width), float(height)],
            "openinpresentation": int(presentation),
            "default_fontsize": 11.0,
            "default_fontface": 0,
            "default_fontname": "Arial",
            "gridonopen": 0,
            "gridsize": [10.0, 10.0],
            "bglocked": 1,
            "bgcolor": BG,
            "boxes": [],
            "lines": [],
        }
        self.params = {}

    def box(self, ident, cls="newobj", text=None, rect=None, **attrs):
        box = {"id": ident, "maxclass": cls, "patching_rect": rect or [0.0, 200.0, 100.0, 22.0]}
        if text is not None:
            box["text"] = text
        box.update(attrs)
        self.data["boxes"].append({"box": box})
        return ident

    def connect(self, src, out, dest, inlet=0, **attrs):
        self.data["lines"].append({"patchline": {"source": [src, out], "destination": [dest, inlet], **attrs}})

    def label(self, ident, text, rect, **attrs):
        return self.box(ident, "comment", text, rect, numinlets=1, numoutlets=0,
                        presentation=1, presentation_rect=rect, textcolor=INK,
                        fontname="Arial", **dict({"fontsize":11.0}, **attrs))

    def control(self, ident, cls, label, rect, minimum=0, maximum=1, initial=0, enum=None, **attrs):
        valueof = {
            "parameter_longname": label,
            "parameter_shortname": label,
            "parameter_type": 2 if enum else (1 if ident in ("a", "b") else 0),
            "parameter_mmin": minimum,
            "parameter_mmax": maximum,
            "parameter_initial": [initial],
            "parameter_initial_enable": 1,
            "parameter_unitstyle": attrs.pop("unitstyle", 1),
        }
        if enum:
            valueof["parameter_enum"] = enum
        self.box(ident, cls, rect=rect, varname=ident, numinlets=1,
                 numoutlets=2 if cls in ("live.text", "live.numbox", "live.slider", "live.dial") else 1,
                 outlettype=["", ""] if cls in ("live.text", "live.numbox", "live.slider", "live.dial") else [""],
                 parameter_enable=1, presentation=1, presentation_rect=rect,
                 saved_attribute_attributes={"valueof": valueof}, **attrs)
        self.params[ident] = [label, label, 0]
        return ident


def voice_patch():
    p=Patch(750,500)
    for n in range(9):p.box(f'in{n}','inlet',rect=[30+n*130,20,30,30],index=n+1)
    p.box('speed',text='line~ 0.',numinlets=2,numoutlets=2)
    p.box('groove',text='groove~ #1 2 @loop 1 @loopinterp 1',numinlets=3,numoutlets=3,outlettype=['signal','signal','signal'])
    p.box('bounds',text='unpack f f',numinlets=1,numoutlets=2)
    p.connect('in0',0,'speed');p.connect('speed',0,'groove')
    p.connect('in1',0,'bounds');p.connect('bounds',0,'groove',1);p.connect('bounds',1,'groove',2)
    p.box('trim',text='line~ 1.',numinlets=2,numoutlets=2);p.connect('in8',0,'trim')
    p.box('effective-level',text='*~',numinlets=2,numoutlets=1)
    p.box('level',text='line~ 0.',numinlets=2,numoutlets=2);p.connect('in2',0,'level')
    p.connect('level',0,'effective-level');p.connect('trim',0,'effective-level',1)
    p.box('pan',text='unpack f f f',numinlets=1,numoutlets=3);p.connect('in3',0,'pan')
    for ch in range(2):
        p.box(f'pack{ch}',text='pack 0. 1000.',numinlets=2,numoutlets=1)
        p.box(f'panline{ch}',text='line~ 0.707',numinlets=2,numoutlets=2)
        p.box(f'amp{ch}',text='*~',numinlets=2,numoutlets=1)
        p.box(f'panned{ch}',text='*~',numinlets=2,numoutlets=1)
        p.box(f'out{ch}','outlet',rect=[100+ch*150,440,30,30],index=ch+1)
        p.connect('pan',ch,f'pack{ch}');p.connect('pan',2,f'pack{ch}',1)
        p.connect(f'pack{ch}',0,f'panline{ch}')
        p.connect('groove',ch,f'amp{ch}');p.connect('effective-level',0,f'amp{ch}',1)
        p.connect(f'amp{ch}',0,f'panned{ch}');p.connect(f'panline{ch}',0,f'panned{ch}',1)
        p.connect(f'panned{ch}',0,f'out{ch}')
    p.connect('in4',0,'groove')
    p.box('set-buffer',text='prepend set',numinlets=1,numoutlets=1)
    p.connect('in6',0,'set-buffer');p.connect('set-buffer',0,'groove')
    p.connect('in7',0,'groove')
    p.box('right-select',text='selector~ 2 1',numinlets=3,numoutlets=1)
    p.connect('in5',0,'right-select');p.connect('groove',0,'right-select',1);p.connect('groove',1,'right-select',2)
    p.data['lines']=[line for line in p.data['lines'] if not (line['patchline']['source']==['groove',1] and line['patchline']['destination']==['amp1',0])]
    p.connect('right-select',0,'amp1')
    return p.data

def build():
    p=Patch(1480,169,True)
    p.data.update({'devicewidth':1480.,'openrect':[0.,0.,1480.,169.],
      'project':{'version':1,'amxdtype':1633771873,'hideprojectwindow':1,'contents':{'patchers':{}},'searchpath':{},'autolocalize':0},
      'description':'Barcode six-voice sample playback following the preceding Simpler. No recording.',
      'digest':'Barcode for Simpler v0.1.3','autosave':0})
    p.label('title','BARCODE / SIMPLER',[12.,6.,250.,20.],fontface=1)
    p.label('status','Place directly after Simpler. Drop a sample in Simpler.',[280.,6.,805.,22.],varname='status')
    p.box('display','jsui',rect=[10.,30.,256.,128.],filename='barcode-display.js',numinlets=1,numoutlets=0,
          presentation=1,presentation_rect=[10.,30.,256.,128.],jsarguments=[],parameter_enable=0)
    p.box('engine',text='js barcode.js #0-barcode',rect=[20.,240.,230.,22.],varname='engine',numinlets=1,numoutlets=2)
    p.box('defer',text='deferlow',numinlets=1,numoutlets=1);p.connect('defer',0,'engine')
    p.connect('engine',1,'display')
    styles={'textcolor':INK,'textoncolor':BG,'bgcolor':BUTTON,'bgoncolor':ACCENT,'activebgcolor':BUTTON,'activebgoncolor':ACCENT,'activetextcolor':INK,'activetextoncolor':BG}
    for i,(ident,label,off,on,initial) in enumerate([
      ('enable','Barcode On','OFF','ON',1),('lfofreeze','Freeze LFO','LFO RUN','FROZEN',0),
      ('allowreverse','Reverse Allowed','FORWARD','REVERSE',1),('bpmsync','LFO Tempo Sync','LFO SEC','LFO BEATS',0),
      ('transport','Follow Transport','FREE PLAY','LIVE PLAY',1)]):
        p.control(ident,'live.text',label,[280.+i*120,36.,110.,23.],initial=initial,enum=[off,on],text=off,texton=on,mode=1,**styles)
        p.box(ident+'cmd',text='prepend '+ident,numinlets=1,numoutlets=1);p.connect(ident,0,ident+'cmd');p.connect(ident+'cmd',0,'defer')
    for i,(ident,label) in enumerate([('reload','Reload'),('resetvoices','Reset voices')]):
        p.box(ident,'textbutton',rect=[890.+i*98,36.,90.,23.],varname=ident,presentation=1,presentation_rect=[890.+i*98,36.,90.,23.],text=label,mode=0,numinlets=1,numoutlets=3)
        p.box(ident+'cmd','message',ident,numinlets=2,numoutlets=1);p.connect(ident,0,ident+'cmd');p.connect(ident+'cmd',0,'defer')
    p.label('voice-label','VOICE',[280.,68.,55.,18.])
    p.box('voice','number',rect=[335.,68.,45.,22.],varname='voice',minimum=1,maximum=6,numinlets=1,numoutlets=2,presentation=1,presentation_rect=[335.,68.,45.,22.])
    p.box('parameter','umenu',rect=[395.,68.,135.,22.],varname='parameter',items=['Level',',','Pan',',','Rate',',','Direction',',','Loop start',',','Loop end'],numinlets=1,numoutlets=3,presentation=1,presentation_rect=[395.,68.,135.,22.])
    p.label('edit-label','Voice 1 / Level',[550.,69.,150.,20.],varname='edit-label')
    p.label('bias-label','Bias',[710.,70.,35.,18.]);p.label('period-label','LFO period (0 = off)',[835.,70.,135.,18.])
    for ident,rect,lo,hi in [('bias',[752.,68.,70.,22.],-2.,2.),('period',[977.,68.,90.,22.],0.,50.)]:
        p.box(ident,'flonum',rect=rect,varname=ident,minimum=lo,maximum=hi,numinlets=1,numoutlets=2,presentation=1,presentation_rect=rect)
    for ident in ['voice','parameter','bias','period']:
        p.box(ident+'cmd',text='prepend '+ident,numinlets=1,numoutlets=1);p.connect(ident,0,ident+'cmd');p.connect(ident+'cmd',0,'defer')
    for i,(ident,label,lo,hi,val) in enumerate([
      ('volume','Output dB',-60,12,0),('filterfreq','Filter Hz',20,20000,18000),('filterres','Resonance',0,.85,.2),
      ('rateslew','Rate slew s',.01,30,1),('panslew','Pan slew s',.01,30,1),('levelslew','Level slew s',.01,30,1)]):
        x=280.+i*132
        p.label(ident+'label',label,[x,103.,125.,18.])
        p.control(ident,'live.numbox',label,[x,124.,115.,24.],minimum=lo,maximum=hi,initial=val,unitstyle=4 if ident=='volume' else 1)
        p.box(ident+'cmd',text='prepend '+ident,numinlets=1,numoutlets=1);p.connect(ident,0,ident+'cmd');p.connect(ident+'cmd',0,'defer')
    p.label('mixer-title','VOICE LEVELS',[1110.,12.,350.,20.],fontface=1)
    p.label('mixer-hint','0% = mute  /  100% = original  /  200% = +6 dB',[1110.,135.,360.,20.],fontsize=10)
    for i in range(6):
        ident='gain'+str(i)
        p.control(ident,'live.dial','Voice '+str(i+1),[1110.+i*60,48.,54.,70.],minimum=0,maximum=200,initial=100,unitstyle=5)
        p.box(ident+'cmd',text='prepend voicegain '+str(i),numinlets=1,numoutlets=1)
        p.connect(ident,0,ident+'cmd');p.connect(ident+'cmd',0,'defer')
    p.label('diagnostic','DSP: waiting for initialization',[280.,151.,800.,16.],varname='diagnostic',fontsize=10)
    p.box('ready',text='live.thisdevice',numinlets=1,numoutlets=3)
    p.box('init','message','initialize',numinlets=2,numoutlets=1);p.connect('ready',0,'init');p.connect('init',0,'defer')
    p.box('active',text='prepend deviceactive',numinlets=1,numoutlets=1);p.connect('ready',1,'active');p.connect('active',0,'defer')
    p.box('data',text='pattr BarcodeData @bindto engine @parameter_enable 1',varname='BarcodeData',numinlets=1,numoutlets=3,
      saved_object_attributes={'parameter_enable':1,'parameter_mappable':0},
      saved_attribute_attributes={'valueof':{'parameter_type':3,'parameter_invisible':1,'parameter_longname':'BarcodeData','parameter_shortname':'BarcodeData'}})
    p.params['data']=['BarcodeData','BarcodeData',0]
    p.box('protocol',text='route load bounds rate level pan seek master dry filter channels bind start trim',numinlets=1,numoutlets=14);p.connect('engine',0,'protocol')
    p.box('replace',text='prepend replace',numinlets=1,numoutlets=1)
    p.box('buffer',text='buffer~ #0-barcode',numinlets=1,numoutlets=2,outlettype=['float','bang'])
    p.connect('protocol',0,'replace');p.connect('replace',0,'buffer')
    p.box('loaded','message','loaded',numinlets=2,numoutlets=1);p.connect('buffer',1,'loaded');p.connect('loaded',0,'defer')
    for out,name in enumerate(['bounds','rate','level','pan','seek'],1):
        p.box(name+'route',text='route 0 1 2 3 4 5',numinlets=1,numoutlets=7);p.connect('protocol',out,name+'route')
    p.box('trim-route',text='route 0 1 2 3 4 5',numinlets=1,numoutlets=7);p.connect('protocol',12,'trim-route')
    p.box('start-route',text='route 0 1 2 3 4 5',numinlets=1,numoutlets=7);p.connect('protocol',11,'start-route')
    for i in range(6):
        # Embedded subpatchers share the parent #0 symbol directly; no abstraction argument lookup.
        sub=voice_patch()
        for entry in sub['boxes']:
            if entry['box']['id']=='groove':entry['box']['text']='groove~ #0-barcode 2 @loop 1 @loopinterp 1'
        p.box('voice'+str(i),text='p voice_'+str(i+1),numinlets=9,numoutlets=2,outlettype=['signal','signal'],patcher=sub)
        p.connect('trim-route',i,'voice'+str(i),8)
        p.connect('protocol',10,'voice'+str(i),6)
        p.connect('start-route',i,'voice'+str(i),7)
        p.connect('protocol',9,'voice'+str(i),5)
        for inlet,name in enumerate(['rate','bounds','level','pan','seek']):p.connect(name+'route',i,'voice'+str(i),inlet)
    p.box('wet',text='line~ 0.',numinlets=2,numoutlets=2);p.connect('protocol',6,'wet')
    p.box('dry',text='line~ 0.',numinlets=2,numoutlets=2);p.connect('protocol',7,'dry')
    p.box('dspstate',text='dspstate~',numinlets=1,numoutlets=3)
    p.box('samplerate',text='prepend samplerate',numinlets=1,numoutlets=1)
    p.connect('dspstate',1,'samplerate');p.connect('samplerate',0,'defer')
    p.connect('ready',0,'dspstate')
    p.box('dspstatecmd',text='prepend dspstate',numinlets=1,numoutlets=1)
    p.connect('dspstate',0,'dspstatecmd');p.connect('dspstatecmd',0,'defer')
    for name in ['rawmeter','filtermeter','outmeter']:
        p.box(name,text='peakamp~ 200',numinlets=2,numoutlets=1)
        p.box(name+'cmd',text='prepend '+name,numinlets=1,numoutlets=1)
        p.connect(name,0,name+'cmd');p.connect(name+'cmd',0,'defer')
    p.box('input',text='plugin~',numinlets=1,numoutlets=2,outlettype=['signal','signal'])
    p.box('output',text='plugout~',numinlets=2,numoutlets=0)
    for ch in range(2):
        p.box('sum'+str(ch),text='+~',numinlets=2,numoutlets=1)
        for i in range(6):p.connect('voice'+str(i),ch,'sum'+str(ch),0)
        p.box('filter'+str(ch),text='biquad~',numinlets=6,numoutlets=1)
        p.connect('sum'+str(ch),0,'filter'+str(ch));p.connect('protocol',8,'filter'+str(ch))
        p.box('amp'+str(ch),text='*~',numinlets=2,numoutlets=1);p.connect('filter'+str(ch),0,'amp'+str(ch));p.connect('wet',0,'amp'+str(ch),1)
        p.box('limit'+str(ch),text='clip~ -0.98 0.98',numinlets=3,numoutlets=1);p.connect('amp'+str(ch),0,'limit'+str(ch))
        p.box('dryamp'+str(ch),text='*~',numinlets=2,numoutlets=1);p.connect('input',ch,'dryamp'+str(ch));p.connect('dry',0,'dryamp'+str(ch),1)
        p.connect('limit'+str(ch),0,'output',ch);p.connect('dryamp'+str(ch),0,'output',ch)
    p.connect('sum0',0,'rawmeter');p.connect('filter0',0,'filtermeter');p.connect('limit0',0,'outmeter')
    p.data['parameters']={**p.params,'parameterbanks':{'0':{'index':0,'name':'Barcode','parameters':['Barcode On','Output dB','Freeze LFO','Reverse Allowed','LFO Tempo Sync','Follow Transport','Filter Hz','Resonance']}},'inherited_shortname':1}
    p.data['dependency_cache']=[{'name':name,'type':'TEXT','implicit':1} for name in ['barcode.js','barcode-core.js','barcode-display.js']]
    return {'patcher':p.data}
