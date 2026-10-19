#!/usr/bin/env python3
"""Build the dependency-free native Max 8 UI and Live parameter bridge.

The generated patch is an Audio Effect with a transparent stereo signal path.
JavaScript implements scene logic; live.remote~ owns parameter modulation, and
persistent live.observer objects retain parameter identities with a Live Set.
"""

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
                        fontname="Arial", fontsize=11.0, **attrs)

    def control(self, ident, cls, label, rect, minimum=0, maximum=1, initial=0, enum=None, **attrs):
        valueof = {
            "parameter_longname": label,
            "parameter_shortname": label,
            "parameter_type": 2 if enum else (1 if ident in ("a", "b") else 0),
            "parameter_mmin": minimum,
            "parameter_mmax": maximum,
            "parameter_initial": [initial],
            "parameter_initial_enable": 1,
            "parameter_unitstyle": 0,
        }
        if enum:
            valueof["parameter_enum"] = enum
        self.box(ident, cls, rect=rect, varname=ident, numinlets=1,
                 numoutlets=2 if cls in ("live.text", "live.numbox", "live.slider") else 1,
                 outlettype=["", ""] if cls in ("live.text", "live.numbox", "live.slider") else [""],
                 parameter_enable=1, presentation=1, presentation_rect=rect,
                 saved_attribute_attributes={"valueof": valueof}, **attrs)
        self.params[ident] = [label, label, 0]
        return ident


def remote_slot(index):
    p = Patch(600, 360)
    p.box("target-in", "inlet", rect=[20.0, 20.0, 30.0, 30.0], index=1, comment="target: parameter ID, actual value")
    p.box("release-in", "inlet", rect=[210.0, 20.0, 30.0, 30.0], index=2, comment="release parameter ownership")
    p.box("map-in", "inlet", rect=[380.0, 20.0, 30.0, 30.0], index=3, comment="persistent mapping ID")
    p.box("target-unpack", text="unpack i f", rect=[20.0, 75.0, 90.0, 22.0], numinlets=1, numoutlets=2, outlettype=["int", "float"])
    p.box("target-id", text="prepend id", rect=[20.0, 120.0, 80.0, 22.0], numinlets=1, numoutlets=1)
    p.box("release-id", "message", "id 0", [210.0, 120.0, 50.0, 22.0], numinlets=2, numoutlets=1)
    p.box("remote", text="live.remote~", rect=[120.0, 185.0, 90.0, 22.0], numinlets=2, numoutlets=0,
          varname=f"remote_{index}")
    p.box("map-id", text="prepend id", rect=[380.0, 75.0, 80.0, 22.0], numinlets=1, numoutlets=1)
    p.box("identity", text="live.observer id", rect=[380.0, 120.0, 110.0, 22.0], numinlets=2, numoutlets=2,
          outlettype=["", ""], varname=f"identity_{index}", saved_object_attributes={"_persistence": 1})
    p.box("strip-id", text="route id", rect=[380.0, 165.0, 70.0, 22.0], numinlets=1, numoutlets=2)
    p.box("binding", text=f"prepend binding {index}", rect=[380.0, 210.0, 140.0, 22.0], numinlets=1, numoutlets=1)
    p.box("binding-out", "outlet", rect=[380.0, 270.0, 30.0, 30.0], index=1, comment="persistent mapping: binding SLOT ID")
    p.connect("target-in", 0, "target-unpack")
    # unpack outputs right-to-left: preload value before attaching the target.
    p.connect("target-unpack", 1, "remote", 0)
    p.connect("target-unpack", 0, "target-id")
    p.connect("target-id", 0, "remote", 1)
    p.connect("release-in", 0, "release-id")
    p.connect("release-id", 0, "remote", 1)
    p.connect("map-in", 0, "map-id")
    p.connect("map-id", 0, "identity", 1)
    p.connect("identity", 0, "strip-id")
    p.connect("strip-id", 0, "binding")
    p.connect("binding", 0, "binding-out")
    return p.data


def build():
    p = Patch(presentation=True)
    p.data.update({"devicewidth": 1100.0, "openrect": [0.0, 0.0, 1100.0, 169.0],
                   "project": {"version": 1, "amxdtype": 1633771873, "hideprojectwindow": 1,
                               "contents": {"patchers": {}}, "searchpath": {}, "autolocalize": 0}, "description": "Sixteen scene locks, direct recall and A/B morph for Live 11.",
                   "digest": "OctaScenes v0.1.1", "tags": "Max for Live, scenes, crossfader", "autosave": 0})
    p.label("title", "OCTA SCENES", [12.0, 7.0, 135.0, 22.0], fontface=1)
    p.label("version", "v0.1.1 · Live 11 / Max 8", [911.0, 7.0, 175.0, 20.0])

    toggle_style = {"textcolor": INK, "textoncolor": BG, "bgcolor": BUTTON, "bgoncolor": ACCENT,
                    "activebgcolor": BUTTON, "activebgoncolor": ACCENT,
                    "activetextcolor": INK, "activetextoncolor": BG}
    p.control("enable", "live.text", "Scenes On", [150.0, 7.0, 57.0, 22.0],
              enum=["Off", "On"], text="OFF", texton="ON", mode=1, **toggle_style)
    p.control("mode", "live.text", "Direct / Morph", [215.0, 7.0, 82.0, 22.0],
              enum=["Direct", "Morph"], text="DIRECT", texton="MORPH", mode=1, **toggle_style)
    p.control("edit", "live.text", "Edit Scene", [305.0, 7.0, 76.0, 22.0],
              enum=["Perform", "Edit"], text="EDIT", texton="EDITING", mode=1, **toggle_style)
    p.label("a-label", "A", [397.0, 9.0, 17.0, 18.0])
    p.control("a", "live.numbox", "Scene A", [416.0, 8.0, 39.0, 21.0], minimum=1, maximum=16, initial=1)
    p.label("b-label", "B", [467.0, 9.0, 17.0, 18.0])
    p.control("b", "live.numbox", "Scene B", [486.0, 8.0, 39.0, 21.0], minimum=1, maximum=16, initial=2)
    p.label("fade-a-label", "A", [540.0, 9.0, 17.0, 18.0])
    p.control("xfade", "live.slider", "Crossfader", [562.0, 9.0, 290.0, 20.0], maximum=127, orientation=1)
    p.label("fade-b-label", "B", [859.0, 9.0, 17.0, 18.0])

    for i in range(16):
        rect = [12.0 + (i % 8) * 47.0, 43.0 + (i // 8) * 35.0, 40.0, 28.0]
        p.control(f"scene_{i}", "live.text", f"Scene {i + 1:02d}", rect,
                  enum=["Released", "Trigger"], mode=0, text=str(i + 1), texton=str(i + 1), **toggle_style)
    p.label("scene-help", "DIRECT: recall  ·  EDIT: choose scene to change", [12.0, 112.0, 375.0, 19.0])

    p.label("slot-label", "PARAMETER", [404.0, 43.0, 90.0, 19.0])
    menu_items = []
    for i in range(32):
        if i:
            menu_items.append(",")
        menu_items.append(f"{i+1:02d} — Empty")
    p.box("slot", "umenu", rect=[495.0, 43.0, 284.0, 22.0], varname="slot", numinlets=1, numoutlets=3,
          outlettype=["int", "", ""], presentation=1, presentation_rect=[495.0, 43.0, 284.0, 22.0],
          items=menu_items, parameter_enable=0)

    # Utility actions are deliberately not automation parameters.
    actions = [
        ("map", "MAP", [792.0, 43.0, 63.0, 22.0]),
        ("unmap", "UNMAP", [864.0, 43.0, 68.0, 22.0]),
        ("focus", "SHOW", [941.0, 43.0, 63.0, 22.0]),
        ("clearlock", "CLEAR LOCK", [404.0, 79.0, 102.0, 24.0]),
        ("clearscene", "CLEAR SCENE", [516.0, 79.0, 109.0, 24.0]),
        ("copy", "COPY SCENE", [635.0, 79.0, 105.0, 24.0]),
        ("paste", "PASTE SCENE", [750.0, 79.0, 108.0, 24.0]),
    ]
    for ident, label, rect in actions:
        p.box(ident, "textbutton", rect=rect, varname=ident, text=label, texton=label,
              mode=0, numinlets=1, numoutlets=3, outlettype=["", "", "int"],
              presentation=1, presentation_rect=rect, bgcolor=BUTTON, textcolor=INK)
    p.label("detail", "Select a parameter slot; MAP then click a parameter in Live.", [404.0, 112.0, 681.0, 19.0], varname="detail")
    p.label("status", "Scenes off. Your sound is the shared base.", [12.0, 143.0, 1073.0, 19.0], varname="status")

    # Audio passes through untouched. All Live API work is deferred.
    p.box("audio-in", text="plugin~", rect=[20.0, 215.0, 80.0, 22.0], numinlets=1, numoutlets=2, outlettype=["signal", "signal"])
    p.box("audio-out", text="plugout~", rect=[20.0, 260.0, 80.0, 22.0], numinlets=2, numoutlets=0)
    p.connect("audio-in", 0, "audio-out", 0)
    p.connect("audio-in", 1, "audio-out", 1)
    p.box("defer", text="deferlow", rect=[420.0, 400.0, 70.0, 22.0], numinlets=1, numoutlets=1)
    p.box("engine", text="js octascenes.js", rect=[420.0, 450.0, 140.0, 22.0], varname="engine", numinlets=1, numoutlets=3,
          outlettype=["", "", ""], saved_object_attributes={"filename": "octascenes.js", "parameter_enable": 0})
    p.connect("defer", 0, "engine")
    p.box("status-set", text="prepend set", rect=[600.0, 450.0, 90.0, 22.0], numinlets=1, numoutlets=1)
    p.connect("engine", 1, "status-set")
    p.connect("status-set", 0, "status")

    for index, ident in enumerate(["enable", "mode", "edit", "xfade", "slot", "a", "b"]):
        command = f"command-{ident}"
        p.box(command, text=f"prepend {ident}", rect=[200.0 + index * 110.0, 320.0, 105.0, 22.0], numinlets=1, numoutlets=1)
        source = ident
        if ident in ("a", "b"):
            source = f"zero-{ident}"
            p.box(source, text="- 1", rect=[200.0 + index * 110.0, 280.0, 50.0, 22.0], numinlets=2, numoutlets=1)
            p.connect(ident, 0, source)
        p.connect(source, 0, command)
        p.connect(command, 0, "defer")
    for i in range(16):
        sel, msg = f"scene-press-{i}", f"scene-command-{i}"
        click = f"scene-click-{i}"
        # Button-mode live.text clicks emit bang; MIDI can emit 1/0.
        # Handle click and note-on separately, ignoring note-off.
        p.box(click, text="route bang", rect=[20.0 + i * 70.0, 505.0, 65.0, 22.0], numinlets=1, numoutlets=2)
        p.box(sel, text="sel 1", rect=[20.0 + i * 70.0, 540.0, 50.0, 22.0], numinlets=2, numoutlets=2)
        p.box(msg, "message", f"scene {i}", [20.0 + i * 70.0, 580.0, 65.0, 22.0], numinlets=2, numoutlets=1)
        p.connect(f"scene_{i}", 0, click)
        p.connect(click, 0, msg)
        p.connect(click, 1, sel)
        p.connect(sel, 0, msg)
        p.connect(msg, 0, "defer")
    for i, (ident, _, _) in enumerate(actions):
        # textbutton outlet 0 bangs once per click in button mode.
        msg = f"command-{ident}"
        p.box(msg, "message", ident, [20.0 + i * 125.0, 650.0, 105.0, 22.0], numinlets=2, numoutlets=1)
        p.connect(ident, 0, msg)
        p.connect(msg, 0, "defer")

    p.box("device-ready", text="live.thisdevice", rect=[20.0, 720.0, 105.0, 22.0], numinlets=1, numoutlets=3,
          outlettype=["bang", "int", "int"])
    p.box("initialize-defer", text="deferlow", rect=[20.0, 760.0, 70.0, 22.0], numinlets=1, numoutlets=1)
    p.box("initialize", "message", "initialize", [20.0, 800.0, 75.0, 22.0], numinlets=2, numoutlets=1)
    p.box("device-active", text="prepend deviceactive", rect=[140.0, 760.0, 135.0, 22.0], numinlets=1, numoutlets=1)
    p.connect("device-ready", 1, "device-active")
    p.connect("device-active", 0, "defer")
    p.connect("device-ready", 0, "initialize-defer")
    p.connect("initialize-defer", 0, "initialize")
    p.connect("initialize", 0, "defer")

    p.box("scene-data", text="pattr SceneData @bindto engine @parameter_enable 1", rect=[180.0, 720.0, 350.0, 22.0],
          varname="SceneData", numinlets=1, numoutlets=3, outlettype=["", "", ""],
          saved_object_attributes={"parameter_enable": 1, "parameter_mappable": 0},
          saved_attribute_attributes={"valueof": {"parameter_type": 3, "parameter_invisible": 1,
                                                "parameter_longname": "SceneData", "parameter_shortname": "SceneData"}})
    p.params["scene-data"] = ["SceneData", "SceneData", 0]

    p.box("engine-protocol", text="route target release mapid", rect=[420.0, 850.0, 190.0, 22.0], numinlets=1, numoutlets=4)
    p.connect("engine", 0, "engine-protocol")
    for channel, prefix in enumerate(["target", "release", "mapid"]):
        ident = f"{prefix}-route"
        p.box(ident, text="route " + " ".join(str(i) for i in range(32)), rect=[20.0, 910.0 + channel * 40.0, 900.0, 22.0],
              numinlets=1, numoutlets=33)
        p.connect("engine-protocol", channel, ident)
    for i in range(32):
        ident = f"remote-slot-{i}"
        p.box(ident, text=f"p parameter_{i+1:02d}", rect=[20.0 + (i % 8) * 140.0, 1060.0 + (i // 8) * 55.0, 125.0, 22.0],
              varname=f"parameter_{i+1:02d}", numinlets=3, numoutlets=1, outlettype=[""], patcher=remote_slot(i))
        p.connect("target-route", i, ident, 0)
        p.connect("release-route", i, ident, 1)
        p.connect("mapid-route", i, ident, 2)
        p.connect(ident, 0, "defer")

    banks = {
        "0": {"index": 0, "name": "Performance", "parameters": ["Crossfader", "Scene A", "Scene B", "Direct / Morph", "Scenes On", "Edit Scene", "-", "-"]},
        "1": {"index": 1, "name": "Scenes 01–08", "parameters": [f"Scene {i+1:02d}" for i in range(8)]},
        "2": {"index": 2, "name": "Scenes 09–16", "parameters": [f"Scene {i+1:02d}" for i in range(8, 16)]},
    }
    p.data["parameters"] = {**p.params, "parameterbanks": banks, "inherited_shortname": 1}
    p.data["dependency_cache"] = [
        {"name": "octascenes.js", "type": "TEXT", "implicit": 1},
        {"name": "scene-core.js", "type": "TEXT", "implicit": 1},
    ]
    return {"patcher": p.data}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--output", type=Path, default=ROOT / "dist" / "OctaScenes.maxpat")
    args = parser.parse_args()
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(json.dumps(build(), indent=2, ensure_ascii=False) + "\n", encoding="utf-8")
    print(args.output)


if __name__ == "__main__":
    main()
