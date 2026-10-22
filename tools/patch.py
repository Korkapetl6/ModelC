#!/usr/bin/env python3
"""Shared Max 8 patcher helpers and native stereo playback head."""

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
    for n in range(11):p.box(f'in{n}','inlet',rect=[30+n*130,20,30,30],index=n+1)
    p.box('speed',text='line~ 0.',numinlets=2,numoutlets=2)
    p.box('groove',text='groove~ #1 2 @loop 1 @loopinterp 1',numinlets=3,numoutlets=3,outlettype=['signal','signal','signal'])
    p.box('bounds',text='unpack f f',numinlets=1,numoutlets=2)
    p.connect('in0',0,'speed');p.connect('speed',0,'groove')
    p.connect('in1',0,'bounds');p.connect('bounds',0,'groove',1);p.connect('bounds',1,'groove',2)
    p.box('trim',text='line~ 1.',numinlets=2,numoutlets=2);p.connect('in8',0,'trim')
    p.box('effective-level',text='*~',numinlets=2,numoutlets=1)
    p.box('level',text='line~ 0.',numinlets=2,numoutlets=2);p.connect('in2',0,'level')
    p.connect('level',0,'effective-level');p.connect('trim',0,'effective-level',1)
    p.box('boundary-fade',text='line~ 1.',numinlets=2,numoutlets=2)
    p.connect('in9',0,'boundary-fade')
    p.box('fade-done','outlet',rect=[500,440,30,30],index=3)
    p.connect('boundary-fade',1,'fade-done')
    p.box('edge-scale',text='line~ 4.',numinlets=2,numoutlets=2);p.connect('in10',0,'edge-scale')
    p.box('phase-neg',text='*~ -1.',numinlets=2,numoutlets=1);p.connect('groove',2,'phase-neg')
    p.box('phase-back',text='+~ 1.',numinlets=2,numoutlets=1);p.connect('phase-neg',0,'phase-back')
    for name,source,outlet in [('rise','groove',2),('fall','phase-back',0)]:
        p.box(name+'scale',text='*~',numinlets=2,numoutlets=1)
        p.box(name,text='clip~ 0. 1.',numinlets=3,numoutlets=1)
        p.connect(source,outlet,name+'scale');p.connect('edge-scale',0,name+'scale',1);p.connect(name+'scale',0,name)
    p.box('edge-envelope',text='*~',numinlets=2,numoutlets=1)
    p.connect('rise',0,'edge-envelope');p.connect('fall',0,'edge-envelope',1)
    p.box('safe-level',text='*~',numinlets=2,numoutlets=1)
    p.connect('effective-level',0,'safe-level');p.connect('edge-envelope',0,'safe-level',1)
    p.box('safe-transition',text='*~',numinlets=2,numoutlets=1)
    p.connect('safe-level',0,'safe-transition');p.connect('boundary-fade',0,'safe-transition',1)
    p.box('pan',text='unpack f f f',numinlets=1,numoutlets=3);p.connect('in3',0,'pan')
    for ch in range(2):
        p.box(f'pack{ch}',text='pack 0. 1000.',numinlets=2,numoutlets=1)
        p.box(f'panline{ch}',text='line~ 0.707',numinlets=2,numoutlets=2)
        p.box(f'amp{ch}',text='*~',numinlets=2,numoutlets=1)
        p.box(f'panned{ch}',text='*~',numinlets=2,numoutlets=1)
        p.box(f'out{ch}','outlet',rect=[100+ch*150,440,30,30],index=ch+1)
        p.connect('pan',ch,f'pack{ch}');p.connect('pan',2,f'pack{ch}',1)
        p.connect(f'pack{ch}',0,f'panline{ch}')
        p.connect('groove',ch,f'amp{ch}');p.connect('safe-transition',0,f'amp{ch}',1)
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
