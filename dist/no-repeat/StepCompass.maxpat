{
  "patcher": {
    "fileversion": 1,
    "appversion": {
      "major": 8,
      "minor": 5,
      "revision": 5,
      "architecture": "x64",
      "modernui": 1
    },
    "classnamespace": "box",
    "rect": [
      0.0,
      0.0,
      1430.0,
      169.0
    ],
    "openinpresentation": 1,
    "default_fontsize": 11.0,
    "default_fontface": 0,
    "default_fontname": "Arial",
    "gridonopen": 0,
    "gridsize": [
      10.0,
      10.0
    ],
    "bglocked": 1,
    "bgcolor": [
      0.11,
      0.12,
      0.14,
      1.0
    ],
    "boxes": [
      {
        "box": {
          "id": "title",
          "maxclass": "comment",
          "patching_rect": [
            10.0,
            4.0,
            240.0,
            20.0
          ],
          "text": "COMPASS / SAFE NO REPEAT",
          "numinlets": 1,
          "numoutlets": 0,
          "presentation": 1,
          "presentation_rect": [
            10.0,
            4.0,
            240.0,
            20.0
          ],
          "textcolor": [
            0.91,
            0.93,
            0.94,
            1.0
          ],
          "fontname": "Arial",
          "fontsize": 11.0,
          "fontface": 1
        }
      },
      {
        "box": {
          "id": "display",
          "maxclass": "jsui",
          "patching_rect": [
            10.0,
            30.0,
            240.0,
            96.0
          ],
          "filename": "display.js",
          "presentation": 1,
          "presentation_rect": [
            10.0,
            30.0,
            240.0,
            96.0
          ],
          "numinlets": 1,
          "numoutlets": 0
        }
      },
      {
        "box": {
          "id": "status",
          "maxclass": "comment",
          "patching_rect": [
            260.0,
            5.0,
            730.0,
            20.0
          ],
          "text": "Place directly after Simpler. Drop a sample into Simpler.",
          "numinlets": 1,
          "numoutlets": 0,
          "presentation": 1,
          "presentation_rect": [
            260.0,
            5.0,
            730.0,
            20.0
          ],
          "textcolor": [
            0.91,
            0.93,
            0.94,
            1.0
          ],
          "fontname": "Arial",
          "fontsize": 11.0,
          "varname": "status"
        }
      },
      {
        "box": {
          "id": "playing",
          "maxclass": "comment",
          "patching_rect": [
            1000.0,
            5.0,
            420.0,
            20.0
          ],
          "text": "Step 0 | STOP",
          "numinlets": 1,
          "numoutlets": 0,
          "presentation": 1,
          "presentation_rect": [
            1000.0,
            5.0,
            420.0,
            20.0
          ],
          "textcolor": [
            0.91,
            0.93,
            0.94,
            1.0
          ],
          "fontname": "Arial",
          "fontsize": 11.0,
          "varname": "playing"
        }
      },
      {
        "box": {
          "id": "engine",
          "maxclass": "newobj",
          "patching_rect": [
            0.0,
            200.0,
            100.0,
            22.0
          ],
          "text": "js compass.js #0-compass",
          "varname": "engine",
          "numinlets": 1,
          "numoutlets": 2
        }
      },
      {
        "box": {
          "id": "defer",
          "maxclass": "newobj",
          "patching_rect": [
            0.0,
            200.0,
            100.0,
            22.0
          ],
          "text": "deferlow",
          "numinlets": 1,
          "numoutlets": 1
        }
      },
      {
        "box": {
          "id": "enable",
          "maxclass": "live.text",
          "patching_rect": [
            260.0,
            30.0,
            90.0,
            22.0
          ],
          "text": "OFF",
          "varname": "enable",
          "numinlets": 1,
          "numoutlets": 2,
          "outlettype": [
            "",
            ""
          ],
          "parameter_enable": 1,
          "presentation": 1,
          "presentation_rect": [
            260.0,
            30.0,
            90.0,
            22.0
          ],
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "ON",
              "parameter_shortname": "ON",
              "parameter_type": 2,
              "parameter_mmin": 0,
              "parameter_mmax": 1,
              "parameter_initial": [
                1
              ],
              "parameter_initial_enable": 1,
              "parameter_unitstyle": 1,
              "parameter_enum": [
                "OFF",
                "ON"
              ]
            }
          },
          "texton": "ON",
          "mode": 1,
          "textcolor": [
            0.91,
            0.93,
            0.94,
            1.0
          ],
          "textoncolor": [
            0.11,
            0.12,
            0.14,
            1.0
          ],
          "bgcolor": [
            0.22,
            0.25,
            0.29,
            1.0
          ],
          "bgoncolor": [
            0.27,
            0.83,
            0.67,
            1.0
          ],
          "activebgcolor": [
            0.22,
            0.25,
            0.29,
            1.0
          ],
          "activebgoncolor": [
            0.27,
            0.83,
            0.67,
            1.0
          ],
          "activetextcolor": [
            0.91,
            0.93,
            0.94,
            1.0
          ],
          "activetextoncolor": [
            0.11,
            0.12,
            0.14,
            1.0
          ]
        }
      },
      {
        "box": {
          "id": "enablecmd",
          "maxclass": "newobj",
          "patching_rect": [
            0.0,
            200.0,
            100.0,
            22.0
          ],
          "text": "prepend enable",
          "numinlets": 1,
          "numoutlets": 1
        }
      },
      {
        "box": {
          "id": "freeplay",
          "maxclass": "live.text",
          "patching_rect": [
            356.0,
            30.0,
            90.0,
            22.0
          ],
          "text": "LIVE PLAY",
          "varname": "freeplay",
          "numinlets": 1,
          "numoutlets": 2,
          "outlettype": [
            "",
            ""
          ],
          "parameter_enable": 1,
          "presentation": 1,
          "presentation_rect": [
            356.0,
            30.0,
            90.0,
            22.0
          ],
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "FREE PLAY",
              "parameter_shortname": "FREE PLAY",
              "parameter_type": 2,
              "parameter_mmin": 0,
              "parameter_mmax": 1,
              "parameter_initial": [
                1
              ],
              "parameter_initial_enable": 1,
              "parameter_unitstyle": 1,
              "parameter_enum": [
                "OFF",
                "FREE PLAY"
              ]
            }
          },
          "texton": "FREE PLAY",
          "mode": 1,
          "textcolor": [
            0.91,
            0.93,
            0.94,
            1.0
          ],
          "textoncolor": [
            0.11,
            0.12,
            0.14,
            1.0
          ],
          "bgcolor": [
            0.22,
            0.25,
            0.29,
            1.0
          ],
          "bgoncolor": [
            0.27,
            0.83,
            0.67,
            1.0
          ],
          "activebgcolor": [
            0.22,
            0.25,
            0.29,
            1.0
          ],
          "activebgoncolor": [
            0.27,
            0.83,
            0.67,
            1.0
          ],
          "activetextcolor": [
            0.91,
            0.93,
            0.94,
            1.0
          ],
          "activetextoncolor": [
            0.11,
            0.12,
            0.14,
            1.0
          ]
        }
      },
      {
        "box": {
          "id": "freeplaycmd",
          "maxclass": "newobj",
          "patching_rect": [
            0.0,
            200.0,
            100.0,
            22.0
          ],
          "text": "prepend freeplay",
          "numinlets": 1,
          "numoutlets": 1
        }
      },
      {
        "box": {
          "id": "reload",
          "maxclass": "textbutton",
          "patching_rect": [
            455.0,
            30.0,
            106.0,
            22.0
          ],
          "text": "RELOAD",
          "presentation": 1,
          "presentation_rect": [
            455.0,
            30.0,
            106.0,
            22.0
          ],
          "numinlets": 1,
          "numoutlets": 3
        }
      },
      {
        "box": {
          "id": "reloadcmd",
          "maxclass": "message",
          "patching_rect": [
            0.0,
            200.0,
            100.0,
            22.0
          ],
          "text": "reload",
          "numinlets": 2,
          "numoutlets": 1
        }
      },
      {
        "box": {
          "id": "reset",
          "maxclass": "textbutton",
          "patching_rect": [
            567.0,
            30.0,
            106.0,
            22.0
          ],
          "text": "RESET",
          "presentation": 1,
          "presentation_rect": [
            567.0,
            30.0,
            106.0,
            22.0
          ],
          "numinlets": 1,
          "numoutlets": 3
        }
      },
      {
        "box": {
          "id": "resetcmd",
          "maxclass": "message",
          "patching_rect": [
            0.0,
            200.0,
            100.0,
            22.0
          ],
          "text": "reset",
          "numinlets": 2,
          "numoutlets": 1
        }
      },
      {
        "box": {
          "id": "randomize",
          "maxclass": "textbutton",
          "patching_rect": [
            679.0,
            30.0,
            106.0,
            22.0
          ],
          "text": "RANDOMIZE",
          "presentation": 1,
          "presentation_rect": [
            679.0,
            30.0,
            106.0,
            22.0
          ],
          "numinlets": 1,
          "numoutlets": 3
        }
      },
      {
        "box": {
          "id": "randomizecmd",
          "maxclass": "message",
          "patching_rect": [
            0.0,
            200.0,
            100.0,
            22.0
          ],
          "text": "randomize",
          "numinlets": 2,
          "numoutlets": 1
        }
      },
      {
        "box": {
          "id": "preset-menu",
          "maxclass": "umenu",
          "patching_rect": [
            10.0,
            134.0,
            155.0,
            22.0
          ],
          "presentation": 1,
          "presentation_rect": [
            10.0,
            134.0,
            155.0,
            22.0
          ],
          "numinlets": 1,
          "numoutlets": 3,
          "items": [
            "01 Soft drift",
            ",",
            "02 Small detours",
            ",",
            "03 Position drift",
            ",",
            "04 Loop wander",
            ",",
            "05 Broken motion",
            ",",
            "06 Tape turns",
            ",",
            "07 Loop shuffle",
            ",",
            "08 Clock fracture",
            ",",
            "09 Jump cuts",
            ",",
            "10 Full scatter"
          ]
        }
      },
      {
        "box": {
          "id": "preset-menucmd",
          "maxclass": "newobj",
          "patching_rect": [
            0.0,
            200.0,
            100.0,
            22.0
          ],
          "text": "prepend presetselect",
          "numinlets": 1,
          "numoutlets": 1
        }
      },
      {
        "box": {
          "id": "preset-load",
          "maxclass": "textbutton",
          "patching_rect": [
            172.0,
            134.0,
            78.0,
            22.0
          ],
          "text": "LOAD PRESET",
          "presentation": 1,
          "presentation_rect": [
            172.0,
            134.0,
            78.0,
            22.0
          ],
          "numinlets": 1,
          "numoutlets": 3
        }
      },
      {
        "box": {
          "id": "preset-load-cmd",
          "maxclass": "message",
          "patching_rect": [
            0.0,
            200.0,
            100.0,
            22.0
          ],
          "text": "loadpreset",
          "numinlets": 2,
          "numoutlets": 1
        }
      },
      {
        "box": {
          "id": "rateslope-label",
          "maxclass": "comment",
          "patching_rect": [
            800.0,
            31.0,
            100.0,
            20.0
          ],
          "text": "Rate slope ms",
          "numinlets": 1,
          "numoutlets": 0,
          "presentation": 1,
          "presentation_rect": [
            800.0,
            31.0,
            100.0,
            20.0
          ],
          "textcolor": [
            0.91,
            0.93,
            0.94,
            1.0
          ],
          "fontname": "Arial",
          "fontsize": 11.0
        }
      },
      {
        "box": {
          "id": "rateslope",
          "maxclass": "number",
          "patching_rect": [
            898.0,
            30.0,
            72.0,
            22.0
          ],
          "varname": "rateslope",
          "minimum": 0,
          "maximum": 10000,
          "numinlets": 1,
          "numoutlets": 2,
          "presentation": 1,
          "presentation_rect": [
            898.0,
            30.0,
            72.0,
            22.0
          ]
        }
      },
      {
        "box": {
          "id": "rateslopecmd",
          "maxclass": "newobj",
          "patching_rect": [
            0.0,
            200.0,
            100.0,
            22.0
          ],
          "text": "prepend rateslope",
          "numinlets": 1,
          "numoutlets": 1
        }
      },
      {
        "box": {
          "id": "slope-minus",
          "maxclass": "textbutton",
          "patching_rect": [
            976.0,
            30.0,
            50.0,
            22.0
          ],
          "text": "-10",
          "presentation": 1,
          "presentation_rect": [
            976.0,
            30.0,
            50.0,
            22.0
          ],
          "numinlets": 1,
          "numoutlets": 3
        }
      },
      {
        "box": {
          "id": "slope-minuscmd",
          "maxclass": "message",
          "patching_rect": [
            0.0,
            200.0,
            100.0,
            22.0
          ],
          "text": "slopeadjust -10",
          "numinlets": 2,
          "numoutlets": 1
        }
      },
      {
        "box": {
          "id": "slope-plus",
          "maxclass": "textbutton",
          "patching_rect": [
            1032.0,
            30.0,
            50.0,
            22.0
          ],
          "text": "+10",
          "presentation": 1,
          "presentation_rect": [
            1032.0,
            30.0,
            50.0,
            22.0
          ],
          "numinlets": 1,
          "numoutlets": 3
        }
      },
      {
        "box": {
          "id": "slope-pluscmd",
          "maxclass": "message",
          "patching_rect": [
            0.0,
            200.0,
            100.0,
            22.0
          ],
          "text": "slopeadjust 10",
          "numinlets": 2,
          "numoutlets": 1
        }
      },
      {
        "box": {
          "id": "label0",
          "maxclass": "comment",
          "patching_rect": [
            260.0,
            60.0,
            18.0,
            20.0
          ],
          "text": "1",
          "numinlets": 1,
          "numoutlets": 0,
          "presentation": 1,
          "presentation_rect": [
            260.0,
            60.0,
            18.0,
            20.0
          ],
          "textcolor": [
            0.91,
            0.93,
            0.94,
            1.0
          ],
          "fontname": "Arial",
          "fontsize": 11.0
        }
      },
      {
        "box": {
          "id": "step0",
          "maxclass": "live.menu",
          "patching_rect": [
            278.0,
            60.0,
            82.0,
            22.0
          ],
          "varname": "step0",
          "numinlets": 1,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "parameter_enable": 1,
          "presentation": 1,
          "presentation_rect": [
            278.0,
            60.0,
            82.0,
            22.0
          ],
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "Step 1",
              "parameter_shortname": "Step 1",
              "parameter_type": 2,
              "parameter_mmin": 0,
              "parameter_mmax": 13,
              "parameter_initial": [
                1
              ],
              "parameter_initial_enable": 1,
              "parameter_unitstyle": 1,
              "parameter_enum": [
                "Hold",
                "Forward",
                "Reverse",
                "Rate +",
                "Rate -",
                "Rate random",
                "Loop start",
                "Position",
                "Loop random",
                "Clock +",
                "Clock -",
                "Clock fastest",
                "Clock slowest",
                "Step random"
              ]
            }
          }
        }
      },
      {
        "box": {
          "id": "step0cmd",
          "maxclass": "newobj",
          "patching_rect": [
            0.0,
            200.0,
            100.0,
            22.0
          ],
          "text": "prepend step 0",
          "numinlets": 1,
          "numoutlets": 1
        }
      },
      {
        "box": {
          "id": "label1",
          "maxclass": "comment",
          "patching_rect": [
            364.0,
            60.0,
            18.0,
            20.0
          ],
          "text": "2",
          "numinlets": 1,
          "numoutlets": 0,
          "presentation": 1,
          "presentation_rect": [
            364.0,
            60.0,
            18.0,
            20.0
          ],
          "textcolor": [
            0.91,
            0.93,
            0.94,
            1.0
          ],
          "fontname": "Arial",
          "fontsize": 11.0
        }
      },
      {
        "box": {
          "id": "step1",
          "maxclass": "live.menu",
          "patching_rect": [
            382.0,
            60.0,
            82.0,
            22.0
          ],
          "varname": "step1",
          "numinlets": 1,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "parameter_enable": 1,
          "presentation": 1,
          "presentation_rect": [
            382.0,
            60.0,
            82.0,
            22.0
          ],
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "Step 2",
              "parameter_shortname": "Step 2",
              "parameter_type": 2,
              "parameter_mmin": 0,
              "parameter_mmax": 13,
              "parameter_initial": [
                0
              ],
              "parameter_initial_enable": 1,
              "parameter_unitstyle": 1,
              "parameter_enum": [
                "Hold",
                "Forward",
                "Reverse",
                "Rate +",
                "Rate -",
                "Rate random",
                "Loop start",
                "Position",
                "Loop random",
                "Clock +",
                "Clock -",
                "Clock fastest",
                "Clock slowest",
                "Step random"
              ]
            }
          }
        }
      },
      {
        "box": {
          "id": "step1cmd",
          "maxclass": "newobj",
          "patching_rect": [
            0.0,
            200.0,
            100.0,
            22.0
          ],
          "text": "prepend step 1",
          "numinlets": 1,
          "numoutlets": 1
        }
      },
      {
        "box": {
          "id": "label2",
          "maxclass": "comment",
          "patching_rect": [
            468.0,
            60.0,
            18.0,
            20.0
          ],
          "text": "3",
          "numinlets": 1,
          "numoutlets": 0,
          "presentation": 1,
          "presentation_rect": [
            468.0,
            60.0,
            18.0,
            20.0
          ],
          "textcolor": [
            0.91,
            0.93,
            0.94,
            1.0
          ],
          "fontname": "Arial",
          "fontsize": 11.0
        }
      },
      {
        "box": {
          "id": "step2",
          "maxclass": "live.menu",
          "patching_rect": [
            486.0,
            60.0,
            82.0,
            22.0
          ],
          "varname": "step2",
          "numinlets": 1,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "parameter_enable": 1,
          "presentation": 1,
          "presentation_rect": [
            486.0,
            60.0,
            82.0,
            22.0
          ],
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "Step 3",
              "parameter_shortname": "Step 3",
              "parameter_type": 2,
              "parameter_mmin": 0,
              "parameter_mmax": 13,
              "parameter_initial": [
                9
              ],
              "parameter_initial_enable": 1,
              "parameter_unitstyle": 1,
              "parameter_enum": [
                "Hold",
                "Forward",
                "Reverse",
                "Rate +",
                "Rate -",
                "Rate random",
                "Loop start",
                "Position",
                "Loop random",
                "Clock +",
                "Clock -",
                "Clock fastest",
                "Clock slowest",
                "Step random"
              ]
            }
          }
        }
      },
      {
        "box": {
          "id": "step2cmd",
          "maxclass": "newobj",
          "patching_rect": [
            0.0,
            200.0,
            100.0,
            22.0
          ],
          "text": "prepend step 2",
          "numinlets": 1,
          "numoutlets": 1
        }
      },
      {
        "box": {
          "id": "label3",
          "maxclass": "comment",
          "patching_rect": [
            572.0,
            60.0,
            18.0,
            20.0
          ],
          "text": "4",
          "numinlets": 1,
          "numoutlets": 0,
          "presentation": 1,
          "presentation_rect": [
            572.0,
            60.0,
            18.0,
            20.0
          ],
          "textcolor": [
            0.91,
            0.93,
            0.94,
            1.0
          ],
          "fontname": "Arial",
          "fontsize": 11.0
        }
      },
      {
        "box": {
          "id": "step3",
          "maxclass": "live.menu",
          "patching_rect": [
            590.0,
            60.0,
            82.0,
            22.0
          ],
          "varname": "step3",
          "numinlets": 1,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "parameter_enable": 1,
          "presentation": 1,
          "presentation_rect": [
            590.0,
            60.0,
            82.0,
            22.0
          ],
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "Step 4",
              "parameter_shortname": "Step 4",
              "parameter_type": 2,
              "parameter_mmin": 0,
              "parameter_mmax": 13,
              "parameter_initial": [
                2
              ],
              "parameter_initial_enable": 1,
              "parameter_unitstyle": 1,
              "parameter_enum": [
                "Hold",
                "Forward",
                "Reverse",
                "Rate +",
                "Rate -",
                "Rate random",
                "Loop start",
                "Position",
                "Loop random",
                "Clock +",
                "Clock -",
                "Clock fastest",
                "Clock slowest",
                "Step random"
              ]
            }
          }
        }
      },
      {
        "box": {
          "id": "step3cmd",
          "maxclass": "newobj",
          "patching_rect": [
            0.0,
            200.0,
            100.0,
            22.0
          ],
          "text": "prepend step 3",
          "numinlets": 1,
          "numoutlets": 1
        }
      },
      {
        "box": {
          "id": "label4",
          "maxclass": "comment",
          "patching_rect": [
            676.0,
            60.0,
            18.0,
            20.0
          ],
          "text": "5",
          "numinlets": 1,
          "numoutlets": 0,
          "presentation": 1,
          "presentation_rect": [
            676.0,
            60.0,
            18.0,
            20.0
          ],
          "textcolor": [
            0.91,
            0.93,
            0.94,
            1.0
          ],
          "fontname": "Arial",
          "fontsize": 11.0
        }
      },
      {
        "box": {
          "id": "step4",
          "maxclass": "live.menu",
          "patching_rect": [
            694.0,
            60.0,
            82.0,
            22.0
          ],
          "varname": "step4",
          "numinlets": 1,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "parameter_enable": 1,
          "presentation": 1,
          "presentation_rect": [
            694.0,
            60.0,
            82.0,
            22.0
          ],
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "Step 5",
              "parameter_shortname": "Step 5",
              "parameter_type": 2,
              "parameter_mmin": 0,
              "parameter_mmax": 13,
              "parameter_initial": [
                13
              ],
              "parameter_initial_enable": 1,
              "parameter_unitstyle": 1,
              "parameter_enum": [
                "Hold",
                "Forward",
                "Reverse",
                "Rate +",
                "Rate -",
                "Rate random",
                "Loop start",
                "Position",
                "Loop random",
                "Clock +",
                "Clock -",
                "Clock fastest",
                "Clock slowest",
                "Step random"
              ]
            }
          }
        }
      },
      {
        "box": {
          "id": "step4cmd",
          "maxclass": "newobj",
          "patching_rect": [
            0.0,
            200.0,
            100.0,
            22.0
          ],
          "text": "prepend step 4",
          "numinlets": 1,
          "numoutlets": 1
        }
      },
      {
        "box": {
          "id": "label5",
          "maxclass": "comment",
          "patching_rect": [
            780.0,
            60.0,
            18.0,
            20.0
          ],
          "text": "6",
          "numinlets": 1,
          "numoutlets": 0,
          "presentation": 1,
          "presentation_rect": [
            780.0,
            60.0,
            18.0,
            20.0
          ],
          "textcolor": [
            0.91,
            0.93,
            0.94,
            1.0
          ],
          "fontname": "Arial",
          "fontsize": 11.0
        }
      },
      {
        "box": {
          "id": "step5",
          "maxclass": "live.menu",
          "patching_rect": [
            798.0,
            60.0,
            82.0,
            22.0
          ],
          "varname": "step5",
          "numinlets": 1,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "parameter_enable": 1,
          "presentation": 1,
          "presentation_rect": [
            798.0,
            60.0,
            82.0,
            22.0
          ],
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "Step 6",
              "parameter_shortname": "Step 6",
              "parameter_type": 2,
              "parameter_mmin": 0,
              "parameter_mmax": 13,
              "parameter_initial": [
                0
              ],
              "parameter_initial_enable": 1,
              "parameter_unitstyle": 1,
              "parameter_enum": [
                "Hold",
                "Forward",
                "Reverse",
                "Rate +",
                "Rate -",
                "Rate random",
                "Loop start",
                "Position",
                "Loop random",
                "Clock +",
                "Clock -",
                "Clock fastest",
                "Clock slowest",
                "Step random"
              ]
            }
          }
        }
      },
      {
        "box": {
          "id": "step5cmd",
          "maxclass": "newobj",
          "patching_rect": [
            0.0,
            200.0,
            100.0,
            22.0
          ],
          "text": "prepend step 5",
          "numinlets": 1,
          "numoutlets": 1
        }
      },
      {
        "box": {
          "id": "label6",
          "maxclass": "comment",
          "patching_rect": [
            884.0,
            60.0,
            18.0,
            20.0
          ],
          "text": "7",
          "numinlets": 1,
          "numoutlets": 0,
          "presentation": 1,
          "presentation_rect": [
            884.0,
            60.0,
            18.0,
            20.0
          ],
          "textcolor": [
            0.91,
            0.93,
            0.94,
            1.0
          ],
          "fontname": "Arial",
          "fontsize": 11.0
        }
      },
      {
        "box": {
          "id": "step6",
          "maxclass": "live.menu",
          "patching_rect": [
            902.0,
            60.0,
            82.0,
            22.0
          ],
          "varname": "step6",
          "numinlets": 1,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "parameter_enable": 1,
          "presentation": 1,
          "presentation_rect": [
            902.0,
            60.0,
            82.0,
            22.0
          ],
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "Step 7",
              "parameter_shortname": "Step 7",
              "parameter_type": 2,
              "parameter_mmin": 0,
              "parameter_mmax": 13,
              "parameter_initial": [
                0
              ],
              "parameter_initial_enable": 1,
              "parameter_unitstyle": 1,
              "parameter_enum": [
                "Hold",
                "Forward",
                "Reverse",
                "Rate +",
                "Rate -",
                "Rate random",
                "Loop start",
                "Position",
                "Loop random",
                "Clock +",
                "Clock -",
                "Clock fastest",
                "Clock slowest",
                "Step random"
              ]
            }
          }
        }
      },
      {
        "box": {
          "id": "step6cmd",
          "maxclass": "newobj",
          "patching_rect": [
            0.0,
            200.0,
            100.0,
            22.0
          ],
          "text": "prepend step 6",
          "numinlets": 1,
          "numoutlets": 1
        }
      },
      {
        "box": {
          "id": "label7",
          "maxclass": "comment",
          "patching_rect": [
            988.0,
            60.0,
            18.0,
            20.0
          ],
          "text": "8",
          "numinlets": 1,
          "numoutlets": 0,
          "presentation": 1,
          "presentation_rect": [
            988.0,
            60.0,
            18.0,
            20.0
          ],
          "textcolor": [
            0.91,
            0.93,
            0.94,
            1.0
          ],
          "fontname": "Arial",
          "fontsize": 11.0
        }
      },
      {
        "box": {
          "id": "step7",
          "maxclass": "live.menu",
          "patching_rect": [
            1006.0,
            60.0,
            82.0,
            22.0
          ],
          "varname": "step7",
          "numinlets": 1,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "parameter_enable": 1,
          "presentation": 1,
          "presentation_rect": [
            1006.0,
            60.0,
            82.0,
            22.0
          ],
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "Step 8",
              "parameter_shortname": "Step 8",
              "parameter_type": 2,
              "parameter_mmin": 0,
              "parameter_mmax": 13,
              "parameter_initial": [
                10
              ],
              "parameter_initial_enable": 1,
              "parameter_unitstyle": 1,
              "parameter_enum": [
                "Hold",
                "Forward",
                "Reverse",
                "Rate +",
                "Rate -",
                "Rate random",
                "Loop start",
                "Position",
                "Loop random",
                "Clock +",
                "Clock -",
                "Clock fastest",
                "Clock slowest",
                "Step random"
              ]
            }
          }
        }
      },
      {
        "box": {
          "id": "step7cmd",
          "maxclass": "newobj",
          "patching_rect": [
            0.0,
            200.0,
            100.0,
            22.0
          ],
          "text": "prepend step 7",
          "numinlets": 1,
          "numoutlets": 1
        }
      },
      {
        "box": {
          "id": "label8",
          "maxclass": "comment",
          "patching_rect": [
            260.0,
            95.0,
            18.0,
            20.0
          ],
          "text": "9",
          "numinlets": 1,
          "numoutlets": 0,
          "presentation": 1,
          "presentation_rect": [
            260.0,
            95.0,
            18.0,
            20.0
          ],
          "textcolor": [
            0.91,
            0.93,
            0.94,
            1.0
          ],
          "fontname": "Arial",
          "fontsize": 11.0
        }
      },
      {
        "box": {
          "id": "step8",
          "maxclass": "live.menu",
          "patching_rect": [
            278.0,
            95.0,
            82.0,
            22.0
          ],
          "varname": "step8",
          "numinlets": 1,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "parameter_enable": 1,
          "presentation": 1,
          "presentation_rect": [
            278.0,
            95.0,
            82.0,
            22.0
          ],
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "Step 9",
              "parameter_shortname": "Step 9",
              "parameter_type": 2,
              "parameter_mmin": 0,
              "parameter_mmax": 13,
              "parameter_initial": [
                9
              ],
              "parameter_initial_enable": 1,
              "parameter_unitstyle": 1,
              "parameter_enum": [
                "Hold",
                "Forward",
                "Reverse",
                "Rate +",
                "Rate -",
                "Rate random",
                "Loop start",
                "Position",
                "Loop random",
                "Clock +",
                "Clock -",
                "Clock fastest",
                "Clock slowest",
                "Step random"
              ]
            }
          }
        }
      },
      {
        "box": {
          "id": "step8cmd",
          "maxclass": "newobj",
          "patching_rect": [
            0.0,
            200.0,
            100.0,
            22.0
          ],
          "text": "prepend step 8",
          "numinlets": 1,
          "numoutlets": 1
        }
      },
      {
        "box": {
          "id": "label9",
          "maxclass": "comment",
          "patching_rect": [
            364.0,
            95.0,
            18.0,
            20.0
          ],
          "text": "10",
          "numinlets": 1,
          "numoutlets": 0,
          "presentation": 1,
          "presentation_rect": [
            364.0,
            95.0,
            18.0,
            20.0
          ],
          "textcolor": [
            0.91,
            0.93,
            0.94,
            1.0
          ],
          "fontname": "Arial",
          "fontsize": 11.0
        }
      },
      {
        "box": {
          "id": "step9",
          "maxclass": "live.menu",
          "patching_rect": [
            382.0,
            95.0,
            82.0,
            22.0
          ],
          "varname": "step9",
          "numinlets": 1,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "parameter_enable": 1,
          "presentation": 1,
          "presentation_rect": [
            382.0,
            95.0,
            82.0,
            22.0
          ],
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "Step 10",
              "parameter_shortname": "Step 10",
              "parameter_type": 2,
              "parameter_mmin": 0,
              "parameter_mmax": 13,
              "parameter_initial": [
                0
              ],
              "parameter_initial_enable": 1,
              "parameter_unitstyle": 1,
              "parameter_enum": [
                "Hold",
                "Forward",
                "Reverse",
                "Rate +",
                "Rate -",
                "Rate random",
                "Loop start",
                "Position",
                "Loop random",
                "Clock +",
                "Clock -",
                "Clock fastest",
                "Clock slowest",
                "Step random"
              ]
            }
          }
        }
      },
      {
        "box": {
          "id": "step9cmd",
          "maxclass": "newobj",
          "patching_rect": [
            0.0,
            200.0,
            100.0,
            22.0
          ],
          "text": "prepend step 9",
          "numinlets": 1,
          "numoutlets": 1
        }
      },
      {
        "box": {
          "id": "label10",
          "maxclass": "comment",
          "patching_rect": [
            468.0,
            95.0,
            18.0,
            20.0
          ],
          "text": "11",
          "numinlets": 1,
          "numoutlets": 0,
          "presentation": 1,
          "presentation_rect": [
            468.0,
            95.0,
            18.0,
            20.0
          ],
          "textcolor": [
            0.91,
            0.93,
            0.94,
            1.0
          ],
          "fontname": "Arial",
          "fontsize": 11.0
        }
      },
      {
        "box": {
          "id": "step10",
          "maxclass": "live.menu",
          "patching_rect": [
            486.0,
            95.0,
            82.0,
            22.0
          ],
          "varname": "step10",
          "numinlets": 1,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "parameter_enable": 1,
          "presentation": 1,
          "presentation_rect": [
            486.0,
            95.0,
            82.0,
            22.0
          ],
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "Step 11",
              "parameter_shortname": "Step 11",
              "parameter_type": 2,
              "parameter_mmin": 0,
              "parameter_mmax": 13,
              "parameter_initial": [
                10
              ],
              "parameter_initial_enable": 1,
              "parameter_unitstyle": 1,
              "parameter_enum": [
                "Hold",
                "Forward",
                "Reverse",
                "Rate +",
                "Rate -",
                "Rate random",
                "Loop start",
                "Position",
                "Loop random",
                "Clock +",
                "Clock -",
                "Clock fastest",
                "Clock slowest",
                "Step random"
              ]
            }
          }
        }
      },
      {
        "box": {
          "id": "step10cmd",
          "maxclass": "newobj",
          "patching_rect": [
            0.0,
            200.0,
            100.0,
            22.0
          ],
          "text": "prepend step 10",
          "numinlets": 1,
          "numoutlets": 1
        }
      },
      {
        "box": {
          "id": "label11",
          "maxclass": "comment",
          "patching_rect": [
            572.0,
            95.0,
            18.0,
            20.0
          ],
          "text": "12",
          "numinlets": 1,
          "numoutlets": 0,
          "presentation": 1,
          "presentation_rect": [
            572.0,
            95.0,
            18.0,
            20.0
          ],
          "textcolor": [
            0.91,
            0.93,
            0.94,
            1.0
          ],
          "fontname": "Arial",
          "fontsize": 11.0
        }
      },
      {
        "box": {
          "id": "step11",
          "maxclass": "live.menu",
          "patching_rect": [
            590.0,
            95.0,
            82.0,
            22.0
          ],
          "varname": "step11",
          "numinlets": 1,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "parameter_enable": 1,
          "presentation": 1,
          "presentation_rect": [
            590.0,
            95.0,
            82.0,
            22.0
          ],
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "Step 12",
              "parameter_shortname": "Step 12",
              "parameter_type": 2,
              "parameter_mmin": 0,
              "parameter_mmax": 13,
              "parameter_initial": [
                0
              ],
              "parameter_initial_enable": 1,
              "parameter_unitstyle": 1,
              "parameter_enum": [
                "Hold",
                "Forward",
                "Reverse",
                "Rate +",
                "Rate -",
                "Rate random",
                "Loop start",
                "Position",
                "Loop random",
                "Clock +",
                "Clock -",
                "Clock fastest",
                "Clock slowest",
                "Step random"
              ]
            }
          }
        }
      },
      {
        "box": {
          "id": "step11cmd",
          "maxclass": "newobj",
          "patching_rect": [
            0.0,
            200.0,
            100.0,
            22.0
          ],
          "text": "prepend step 11",
          "numinlets": 1,
          "numoutlets": 1
        }
      },
      {
        "box": {
          "id": "label12",
          "maxclass": "comment",
          "patching_rect": [
            676.0,
            95.0,
            18.0,
            20.0
          ],
          "text": "13",
          "numinlets": 1,
          "numoutlets": 0,
          "presentation": 1,
          "presentation_rect": [
            676.0,
            95.0,
            18.0,
            20.0
          ],
          "textcolor": [
            0.91,
            0.93,
            0.94,
            1.0
          ],
          "fontname": "Arial",
          "fontsize": 11.0
        }
      },
      {
        "box": {
          "id": "step12",
          "maxclass": "live.menu",
          "patching_rect": [
            694.0,
            95.0,
            82.0,
            22.0
          ],
          "varname": "step12",
          "numinlets": 1,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "parameter_enable": 1,
          "presentation": 1,
          "presentation_rect": [
            694.0,
            95.0,
            82.0,
            22.0
          ],
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "Step 13",
              "parameter_shortname": "Step 13",
              "parameter_type": 2,
              "parameter_mmin": 0,
              "parameter_mmax": 13,
              "parameter_initial": [
                10
              ],
              "parameter_initial_enable": 1,
              "parameter_unitstyle": 1,
              "parameter_enum": [
                "Hold",
                "Forward",
                "Reverse",
                "Rate +",
                "Rate -",
                "Rate random",
                "Loop start",
                "Position",
                "Loop random",
                "Clock +",
                "Clock -",
                "Clock fastest",
                "Clock slowest",
                "Step random"
              ]
            }
          }
        }
      },
      {
        "box": {
          "id": "step12cmd",
          "maxclass": "newobj",
          "patching_rect": [
            0.0,
            200.0,
            100.0,
            22.0
          ],
          "text": "prepend step 12",
          "numinlets": 1,
          "numoutlets": 1
        }
      },
      {
        "box": {
          "id": "label13",
          "maxclass": "comment",
          "patching_rect": [
            780.0,
            95.0,
            18.0,
            20.0
          ],
          "text": "14",
          "numinlets": 1,
          "numoutlets": 0,
          "presentation": 1,
          "presentation_rect": [
            780.0,
            95.0,
            18.0,
            20.0
          ],
          "textcolor": [
            0.91,
            0.93,
            0.94,
            1.0
          ],
          "fontname": "Arial",
          "fontsize": 11.0
        }
      },
      {
        "box": {
          "id": "step13",
          "maxclass": "live.menu",
          "patching_rect": [
            798.0,
            95.0,
            82.0,
            22.0
          ],
          "varname": "step13",
          "numinlets": 1,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "parameter_enable": 1,
          "presentation": 1,
          "presentation_rect": [
            798.0,
            95.0,
            82.0,
            22.0
          ],
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "Step 14",
              "parameter_shortname": "Step 14",
              "parameter_type": 2,
              "parameter_mmin": 0,
              "parameter_mmax": 13,
              "parameter_initial": [
                0
              ],
              "parameter_initial_enable": 1,
              "parameter_unitstyle": 1,
              "parameter_enum": [
                "Hold",
                "Forward",
                "Reverse",
                "Rate +",
                "Rate -",
                "Rate random",
                "Loop start",
                "Position",
                "Loop random",
                "Clock +",
                "Clock -",
                "Clock fastest",
                "Clock slowest",
                "Step random"
              ]
            }
          }
        }
      },
      {
        "box": {
          "id": "step13cmd",
          "maxclass": "newobj",
          "patching_rect": [
            0.0,
            200.0,
            100.0,
            22.0
          ],
          "text": "prepend step 13",
          "numinlets": 1,
          "numoutlets": 1
        }
      },
      {
        "box": {
          "id": "label14",
          "maxclass": "comment",
          "patching_rect": [
            884.0,
            95.0,
            18.0,
            20.0
          ],
          "text": "15",
          "numinlets": 1,
          "numoutlets": 0,
          "presentation": 1,
          "presentation_rect": [
            884.0,
            95.0,
            18.0,
            20.0
          ],
          "textcolor": [
            0.91,
            0.93,
            0.94,
            1.0
          ],
          "fontname": "Arial",
          "fontsize": 11.0
        }
      },
      {
        "box": {
          "id": "step14",
          "maxclass": "live.menu",
          "patching_rect": [
            902.0,
            95.0,
            82.0,
            22.0
          ],
          "varname": "step14",
          "numinlets": 1,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "parameter_enable": 1,
          "presentation": 1,
          "presentation_rect": [
            902.0,
            95.0,
            82.0,
            22.0
          ],
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "Step 15",
              "parameter_shortname": "Step 15",
              "parameter_type": 2,
              "parameter_mmin": 0,
              "parameter_mmax": 13,
              "parameter_initial": [
                1
              ],
              "parameter_initial_enable": 1,
              "parameter_unitstyle": 1,
              "parameter_enum": [
                "Hold",
                "Forward",
                "Reverse",
                "Rate +",
                "Rate -",
                "Rate random",
                "Loop start",
                "Position",
                "Loop random",
                "Clock +",
                "Clock -",
                "Clock fastest",
                "Clock slowest",
                "Step random"
              ]
            }
          }
        }
      },
      {
        "box": {
          "id": "step14cmd",
          "maxclass": "newobj",
          "patching_rect": [
            0.0,
            200.0,
            100.0,
            22.0
          ],
          "text": "prepend step 14",
          "numinlets": 1,
          "numoutlets": 1
        }
      },
      {
        "box": {
          "id": "label15",
          "maxclass": "comment",
          "patching_rect": [
            988.0,
            95.0,
            18.0,
            20.0
          ],
          "text": "16",
          "numinlets": 1,
          "numoutlets": 0,
          "presentation": 1,
          "presentation_rect": [
            988.0,
            95.0,
            18.0,
            20.0
          ],
          "textcolor": [
            0.91,
            0.93,
            0.94,
            1.0
          ],
          "fontname": "Arial",
          "fontsize": 11.0
        }
      },
      {
        "box": {
          "id": "step15",
          "maxclass": "live.menu",
          "patching_rect": [
            1006.0,
            95.0,
            82.0,
            22.0
          ],
          "varname": "step15",
          "numinlets": 1,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "parameter_enable": 1,
          "presentation": 1,
          "presentation_rect": [
            1006.0,
            95.0,
            82.0,
            22.0
          ],
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "Step 16",
              "parameter_shortname": "Step 16",
              "parameter_type": 2,
              "parameter_mmin": 0,
              "parameter_mmax": 13,
              "parameter_initial": [
                10
              ],
              "parameter_initial_enable": 1,
              "parameter_unitstyle": 1,
              "parameter_enum": [
                "Hold",
                "Forward",
                "Reverse",
                "Rate +",
                "Rate -",
                "Rate random",
                "Loop start",
                "Position",
                "Loop random",
                "Clock +",
                "Clock -",
                "Clock fastest",
                "Clock slowest",
                "Step random"
              ]
            }
          }
        }
      },
      {
        "box": {
          "id": "step15cmd",
          "maxclass": "newobj",
          "patching_rect": [
            0.0,
            200.0,
            100.0,
            22.0
          ],
          "text": "prepend step 15",
          "numinlets": 1,
          "numoutlets": 1
        }
      },
      {
        "box": {
          "id": "regionstartlabel",
          "maxclass": "comment",
          "patching_rect": [
            260.0,
            130.0,
            70.0,
            17.0
          ],
          "text": "Start %",
          "numinlets": 1,
          "numoutlets": 0,
          "presentation": 1,
          "presentation_rect": [
            260.0,
            130.0,
            70.0,
            17.0
          ],
          "textcolor": [
            0.91,
            0.93,
            0.94,
            1.0
          ],
          "fontname": "Arial",
          "fontsize": 11.0
        }
      },
      {
        "box": {
          "id": "regionstart",
          "maxclass": "live.numbox",
          "patching_rect": [
            324.0,
            130.0,
            50.0,
            22.0
          ],
          "varname": "regionstart",
          "numinlets": 1,
          "numoutlets": 2,
          "outlettype": [
            "",
            ""
          ],
          "parameter_enable": 1,
          "presentation": 1,
          "presentation_rect": [
            324.0,
            130.0,
            50.0,
            22.0
          ],
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "Start %",
              "parameter_shortname": "Start %",
              "parameter_type": 0,
              "parameter_mmin": 0,
              "parameter_mmax": 99.9,
              "parameter_initial": [
                0
              ],
              "parameter_initial_enable": 1,
              "parameter_unitstyle": 1
            }
          }
        }
      },
      {
        "box": {
          "id": "regionstartcmd",
          "maxclass": "newobj",
          "patching_rect": [
            0.0,
            200.0,
            100.0,
            22.0
          ],
          "text": "prepend regionstart",
          "numinlets": 1,
          "numoutlets": 1
        }
      },
      {
        "box": {
          "id": "regionendlabel",
          "maxclass": "comment",
          "patching_rect": [
            378.0,
            130.0,
            70.0,
            17.0
          ],
          "text": "End %",
          "numinlets": 1,
          "numoutlets": 0,
          "presentation": 1,
          "presentation_rect": [
            378.0,
            130.0,
            70.0,
            17.0
          ],
          "textcolor": [
            0.91,
            0.93,
            0.94,
            1.0
          ],
          "fontname": "Arial",
          "fontsize": 11.0
        }
      },
      {
        "box": {
          "id": "regionend",
          "maxclass": "live.numbox",
          "patching_rect": [
            442.0,
            130.0,
            50.0,
            22.0
          ],
          "varname": "regionend",
          "numinlets": 1,
          "numoutlets": 2,
          "outlettype": [
            "",
            ""
          ],
          "parameter_enable": 1,
          "presentation": 1,
          "presentation_rect": [
            442.0,
            130.0,
            50.0,
            22.0
          ],
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "End %",
              "parameter_shortname": "End %",
              "parameter_type": 0,
              "parameter_mmin": 0.1,
              "parameter_mmax": 100,
              "parameter_initial": [
                100
              ],
              "parameter_initial_enable": 1,
              "parameter_unitstyle": 1
            }
          }
        }
      },
      {
        "box": {
          "id": "regionendcmd",
          "maxclass": "newobj",
          "patching_rect": [
            0.0,
            200.0,
            100.0,
            22.0
          ],
          "text": "prepend regionend",
          "numinlets": 1,
          "numoutlets": 1
        }
      },
      {
        "box": {
          "id": "smoothinglabel",
          "maxclass": "comment",
          "patching_rect": [
            496.0,
            130.0,
            70.0,
            17.0
          ],
          "text": "Fade ms",
          "numinlets": 1,
          "numoutlets": 0,
          "presentation": 1,
          "presentation_rect": [
            496.0,
            130.0,
            70.0,
            17.0
          ],
          "textcolor": [
            0.91,
            0.93,
            0.94,
            1.0
          ],
          "fontname": "Arial",
          "fontsize": 11.0
        }
      },
      {
        "box": {
          "id": "smoothing",
          "maxclass": "live.numbox",
          "patching_rect": [
            560.0,
            130.0,
            50.0,
            22.0
          ],
          "varname": "smoothing",
          "numinlets": 1,
          "numoutlets": 2,
          "outlettype": [
            "",
            ""
          ],
          "parameter_enable": 1,
          "presentation": 1,
          "presentation_rect": [
            560.0,
            130.0,
            50.0,
            22.0
          ],
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "Fade ms",
              "parameter_shortname": "Fade ms",
              "parameter_type": 0,
              "parameter_mmin": 1,
              "parameter_mmax": 100,
              "parameter_initial": [
                20
              ],
              "parameter_initial_enable": 1,
              "parameter_unitstyle": 1
            }
          }
        }
      },
      {
        "box": {
          "id": "smoothingcmd",
          "maxclass": "newobj",
          "patching_rect": [
            0.0,
            200.0,
            100.0,
            22.0
          ],
          "text": "prepend smoothing",
          "numinlets": 1,
          "numoutlets": 1
        }
      },
      {
        "box": {
          "id": "volumelabel",
          "maxclass": "comment",
          "patching_rect": [
            614.0,
            130.0,
            70.0,
            17.0
          ],
          "text": "Out dB",
          "numinlets": 1,
          "numoutlets": 0,
          "presentation": 1,
          "presentation_rect": [
            614.0,
            130.0,
            70.0,
            17.0
          ],
          "textcolor": [
            0.91,
            0.93,
            0.94,
            1.0
          ],
          "fontname": "Arial",
          "fontsize": 11.0
        }
      },
      {
        "box": {
          "id": "volume",
          "maxclass": "live.numbox",
          "patching_rect": [
            678.0,
            130.0,
            50.0,
            22.0
          ],
          "varname": "volume",
          "numinlets": 1,
          "numoutlets": 2,
          "outlettype": [
            "",
            ""
          ],
          "parameter_enable": 1,
          "presentation": 1,
          "presentation_rect": [
            678.0,
            130.0,
            50.0,
            22.0
          ],
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "Out dB",
              "parameter_shortname": "Out dB",
              "parameter_type": 0,
              "parameter_mmin": -60,
              "parameter_mmax": 6,
              "parameter_initial": [
                -6
              ],
              "parameter_initial_enable": 1,
              "parameter_unitstyle": 4
            }
          }
        }
      },
      {
        "box": {
          "id": "volumecmd",
          "maxclass": "newobj",
          "patching_rect": [
            0.0,
            200.0,
            100.0,
            22.0
          ],
          "text": "prepend volume",
          "numinlets": 1,
          "numoutlets": 1
        }
      },
      {
        "box": {
          "id": "stepslabel",
          "maxclass": "comment",
          "patching_rect": [
            732.0,
            130.0,
            70.0,
            17.0
          ],
          "text": "Steps",
          "numinlets": 1,
          "numoutlets": 0,
          "presentation": 1,
          "presentation_rect": [
            732.0,
            130.0,
            70.0,
            17.0
          ],
          "textcolor": [
            0.91,
            0.93,
            0.94,
            1.0
          ],
          "fontname": "Arial",
          "fontsize": 11.0
        }
      },
      {
        "box": {
          "id": "steps",
          "maxclass": "live.numbox",
          "patching_rect": [
            796.0,
            130.0,
            50.0,
            22.0
          ],
          "varname": "steps",
          "numinlets": 1,
          "numoutlets": 2,
          "outlettype": [
            "",
            ""
          ],
          "parameter_enable": 1,
          "presentation": 1,
          "presentation_rect": [
            796.0,
            130.0,
            50.0,
            22.0
          ],
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "Steps",
              "parameter_shortname": "Steps",
              "parameter_type": 0,
              "parameter_mmin": 1,
              "parameter_mmax": 16,
              "parameter_initial": [
                16
              ],
              "parameter_initial_enable": 1,
              "parameter_unitstyle": 1
            }
          }
        }
      },
      {
        "box": {
          "id": "stepscmd",
          "maxclass": "newobj",
          "patching_rect": [
            0.0,
            200.0,
            100.0,
            22.0
          ],
          "text": "prepend steps",
          "numinlets": 1,
          "numoutlets": 1
        }
      },
      {
        "box": {
          "id": "divisionlabel",
          "maxclass": "comment",
          "patching_rect": [
            850.0,
            130.0,
            70.0,
            17.0
          ],
          "text": "Clock 0-4",
          "numinlets": 1,
          "numoutlets": 0,
          "presentation": 1,
          "presentation_rect": [
            850.0,
            130.0,
            70.0,
            17.0
          ],
          "textcolor": [
            0.91,
            0.93,
            0.94,
            1.0
          ],
          "fontname": "Arial",
          "fontsize": 11.0
        }
      },
      {
        "box": {
          "id": "division",
          "maxclass": "live.numbox",
          "patching_rect": [
            914.0,
            130.0,
            50.0,
            22.0
          ],
          "varname": "division",
          "numinlets": 1,
          "numoutlets": 2,
          "outlettype": [
            "",
            ""
          ],
          "parameter_enable": 1,
          "presentation": 1,
          "presentation_rect": [
            914.0,
            130.0,
            50.0,
            22.0
          ],
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "Clock 0-4",
              "parameter_shortname": "Clock 0-4",
              "parameter_type": 0,
              "parameter_mmin": 0,
              "parameter_mmax": 4,
              "parameter_initial": [
                0
              ],
              "parameter_initial_enable": 1,
              "parameter_unitstyle": 1
            }
          }
        }
      },
      {
        "box": {
          "id": "divisioncmd",
          "maxclass": "newobj",
          "patching_rect": [
            0.0,
            200.0,
            100.0,
            22.0
          ],
          "text": "prepend division",
          "numinlets": 1,
          "numoutlets": 1
        }
      },
      {
        "box": {
          "id": "seedlabel",
          "maxclass": "comment",
          "patching_rect": [
            968.0,
            130.0,
            70.0,
            17.0
          ],
          "text": "Seed",
          "numinlets": 1,
          "numoutlets": 0,
          "presentation": 1,
          "presentation_rect": [
            968.0,
            130.0,
            70.0,
            17.0
          ],
          "textcolor": [
            0.91,
            0.93,
            0.94,
            1.0
          ],
          "fontname": "Arial",
          "fontsize": 11.0
        }
      },
      {
        "box": {
          "id": "seed",
          "maxclass": "live.numbox",
          "patching_rect": [
            1032.0,
            130.0,
            50.0,
            22.0
          ],
          "varname": "seed",
          "numinlets": 1,
          "numoutlets": 2,
          "outlettype": [
            "",
            ""
          ],
          "parameter_enable": 1,
          "presentation": 1,
          "presentation_rect": [
            1032.0,
            130.0,
            50.0,
            22.0
          ],
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "Seed",
              "parameter_shortname": "Seed",
              "parameter_type": 0,
              "parameter_mmin": 1,
              "parameter_mmax": 65535,
              "parameter_initial": [
                1234
              ],
              "parameter_initial_enable": 1,
              "parameter_unitstyle": 1
            }
          }
        }
      },
      {
        "box": {
          "id": "seedcmd",
          "maxclass": "newobj",
          "patching_rect": [
            0.0,
            200.0,
            100.0,
            22.0
          ],
          "text": "prepend seed",
          "numinlets": 1,
          "numoutlets": 1
        }
      },
      {
        "box": {
          "id": "hold-label",
          "maxclass": "comment",
          "patching_rect": [
            1110.0,
            31.0,
            48.0,
            20.0
          ],
          "text": "HOLD %",
          "numinlets": 1,
          "numoutlets": 0,
          "presentation": 1,
          "presentation_rect": [
            1110.0,
            31.0,
            48.0,
            20.0
          ],
          "textcolor": [
            0.91,
            0.93,
            0.94,
            1.0
          ],
          "fontname": "Arial",
          "fontsize": 11.0,
          "fontface": 1
        }
      },
      {
        "box": {
          "id": "holdpercent",
          "maxclass": "live.numbox",
          "patching_rect": [
            1159.0,
            30.0,
            48.0,
            22.0
          ],
          "varname": "holdpercent",
          "numinlets": 1,
          "numoutlets": 2,
          "outlettype": [
            "",
            ""
          ],
          "parameter_enable": 1,
          "presentation": 1,
          "presentation_rect": [
            1159.0,
            30.0,
            48.0,
            22.0
          ],
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "Hold percent",
              "parameter_shortname": "Hold percent",
              "parameter_type": 0,
              "parameter_mmin": 0,
              "parameter_mmax": 100,
              "parameter_initial": [
                25
              ],
              "parameter_initial_enable": 1,
              "parameter_unitstyle": 5
            }
          }
        }
      },
      {
        "box": {
          "id": "holdpercentcmd",
          "maxclass": "newobj",
          "patching_rect": [
            0.0,
            200.0,
            100.0,
            22.0
          ],
          "text": "prepend holdpercent",
          "numinlets": 1,
          "numoutlets": 1
        }
      },
      {
        "box": {
          "id": "hold-count",
          "maxclass": "comment",
          "patching_rect": [
            1110.0,
            55.0,
            74.0,
            18.0
          ],
          "text": "NEXT 4/16",
          "numinlets": 1,
          "numoutlets": 0,
          "presentation": 1,
          "presentation_rect": [
            1110.0,
            55.0,
            74.0,
            18.0
          ],
          "textcolor": [
            0.91,
            0.93,
            0.94,
            1.0
          ],
          "fontname": "Arial",
          "fontsize": 9.0,
          "varname": "hold-count"
        }
      },
      {
        "box": {
          "id": "pool-label",
          "maxclass": "comment",
          "patching_rect": [
            1220.0,
            30.0,
            200.0,
            20.0
          ],
          "text": "COMMAND WEIGHTS",
          "numinlets": 1,
          "numoutlets": 0,
          "presentation": 1,
          "presentation_rect": [
            1220.0,
            30.0,
            200.0,
            20.0
          ],
          "textcolor": [
            0.91,
            0.93,
            0.94,
            1.0
          ],
          "fontname": "Arial",
          "fontsize": 11.0,
          "fontface": 1
        }
      },
      {
        "box": {
          "id": "poolname1",
          "maxclass": "comment",
          "patching_rect": [
            1187.0,
            55.0,
            37.0,
            18.0
          ],
          "text": "FWD",
          "numinlets": 1,
          "numoutlets": 0,
          "presentation": 1,
          "presentation_rect": [
            1187.0,
            55.0,
            37.0,
            18.0
          ],
          "textcolor": [
            0.91,
            0.93,
            0.94,
            1.0
          ],
          "fontname": "Arial",
          "fontsize": 8.5
        }
      },
      {
        "box": {
          "id": "pool1",
          "maxclass": "live.numbox",
          "patching_rect": [
            1224.0,
            53.0,
            36.0,
            21.0
          ],
          "varname": "pool1",
          "numinlets": 1,
          "numoutlets": 2,
          "outlettype": [
            "",
            ""
          ],
          "parameter_enable": 1,
          "presentation": 1,
          "presentation_rect": [
            1224.0,
            53.0,
            36.0,
            21.0
          ],
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "Weight Forward",
              "parameter_shortname": "Weight Forward",
              "parameter_type": 0,
              "parameter_mmin": 0,
              "parameter_mmax": 100,
              "parameter_initial": [
                100
              ],
              "parameter_initial_enable": 1,
              "parameter_unitstyle": 1
            }
          },
          "fontsize": 10.0
        }
      },
      {
        "box": {
          "id": "pool1cmd",
          "maxclass": "newobj",
          "patching_rect": [
            0.0,
            200.0,
            100.0,
            22.0
          ],
          "text": "prepend pool 1",
          "numinlets": 1,
          "numoutlets": 1
        }
      },
      {
        "box": {
          "id": "poolname2",
          "maxclass": "comment",
          "patching_rect": [
            1264.0,
            55.0,
            37.0,
            18.0
          ],
          "text": "REV",
          "numinlets": 1,
          "numoutlets": 0,
          "presentation": 1,
          "presentation_rect": [
            1264.0,
            55.0,
            37.0,
            18.0
          ],
          "textcolor": [
            0.91,
            0.93,
            0.94,
            1.0
          ],
          "fontname": "Arial",
          "fontsize": 8.5
        }
      },
      {
        "box": {
          "id": "pool2",
          "maxclass": "live.numbox",
          "patching_rect": [
            1301.0,
            53.0,
            36.0,
            21.0
          ],
          "varname": "pool2",
          "numinlets": 1,
          "numoutlets": 2,
          "outlettype": [
            "",
            ""
          ],
          "parameter_enable": 1,
          "presentation": 1,
          "presentation_rect": [
            1301.0,
            53.0,
            36.0,
            21.0
          ],
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "Weight Reverse",
              "parameter_shortname": "Weight Reverse",
              "parameter_type": 0,
              "parameter_mmin": 0,
              "parameter_mmax": 100,
              "parameter_initial": [
                100
              ],
              "parameter_initial_enable": 1,
              "parameter_unitstyle": 1
            }
          },
          "fontsize": 10.0
        }
      },
      {
        "box": {
          "id": "pool2cmd",
          "maxclass": "newobj",
          "patching_rect": [
            0.0,
            200.0,
            100.0,
            22.0
          ],
          "text": "prepend pool 2",
          "numinlets": 1,
          "numoutlets": 1
        }
      },
      {
        "box": {
          "id": "poolname3",
          "maxclass": "comment",
          "patching_rect": [
            1341.0,
            55.0,
            37.0,
            18.0
          ],
          "text": "R+",
          "numinlets": 1,
          "numoutlets": 0,
          "presentation": 1,
          "presentation_rect": [
            1341.0,
            55.0,
            37.0,
            18.0
          ],
          "textcolor": [
            0.91,
            0.93,
            0.94,
            1.0
          ],
          "fontname": "Arial",
          "fontsize": 8.5
        }
      },
      {
        "box": {
          "id": "pool3",
          "maxclass": "live.numbox",
          "patching_rect": [
            1378.0,
            53.0,
            36.0,
            21.0
          ],
          "varname": "pool3",
          "numinlets": 1,
          "numoutlets": 2,
          "outlettype": [
            "",
            ""
          ],
          "parameter_enable": 1,
          "presentation": 1,
          "presentation_rect": [
            1378.0,
            53.0,
            36.0,
            21.0
          ],
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "Weight Rate +",
              "parameter_shortname": "Weight Rate +",
              "parameter_type": 0,
              "parameter_mmin": 0,
              "parameter_mmax": 100,
              "parameter_initial": [
                0
              ],
              "parameter_initial_enable": 1,
              "parameter_unitstyle": 1
            }
          },
          "fontsize": 10.0
        }
      },
      {
        "box": {
          "id": "pool3cmd",
          "maxclass": "newobj",
          "patching_rect": [
            0.0,
            200.0,
            100.0,
            22.0
          ],
          "text": "prepend pool 3",
          "numinlets": 1,
          "numoutlets": 1
        }
      },
      {
        "box": {
          "id": "poolname4",
          "maxclass": "comment",
          "patching_rect": [
            1110.0,
            80.0,
            37.0,
            18.0
          ],
          "text": "R-",
          "numinlets": 1,
          "numoutlets": 0,
          "presentation": 1,
          "presentation_rect": [
            1110.0,
            80.0,
            37.0,
            18.0
          ],
          "textcolor": [
            0.91,
            0.93,
            0.94,
            1.0
          ],
          "fontname": "Arial",
          "fontsize": 8.5
        }
      },
      {
        "box": {
          "id": "pool4",
          "maxclass": "live.numbox",
          "patching_rect": [
            1147.0,
            78.0,
            36.0,
            21.0
          ],
          "varname": "pool4",
          "numinlets": 1,
          "numoutlets": 2,
          "outlettype": [
            "",
            ""
          ],
          "parameter_enable": 1,
          "presentation": 1,
          "presentation_rect": [
            1147.0,
            78.0,
            36.0,
            21.0
          ],
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "Weight Rate -",
              "parameter_shortname": "Weight Rate -",
              "parameter_type": 0,
              "parameter_mmin": 0,
              "parameter_mmax": 100,
              "parameter_initial": [
                0
              ],
              "parameter_initial_enable": 1,
              "parameter_unitstyle": 1
            }
          },
          "fontsize": 10.0
        }
      },
      {
        "box": {
          "id": "pool4cmd",
          "maxclass": "newobj",
          "patching_rect": [
            0.0,
            200.0,
            100.0,
            22.0
          ],
          "text": "prepend pool 4",
          "numinlets": 1,
          "numoutlets": 1
        }
      },
      {
        "box": {
          "id": "poolname5",
          "maxclass": "comment",
          "patching_rect": [
            1187.0,
            80.0,
            37.0,
            18.0
          ],
          "text": "R?",
          "numinlets": 1,
          "numoutlets": 0,
          "presentation": 1,
          "presentation_rect": [
            1187.0,
            80.0,
            37.0,
            18.0
          ],
          "textcolor": [
            0.91,
            0.93,
            0.94,
            1.0
          ],
          "fontname": "Arial",
          "fontsize": 8.5
        }
      },
      {
        "box": {
          "id": "pool5",
          "maxclass": "live.numbox",
          "patching_rect": [
            1224.0,
            78.0,
            36.0,
            21.0
          ],
          "varname": "pool5",
          "numinlets": 1,
          "numoutlets": 2,
          "outlettype": [
            "",
            ""
          ],
          "parameter_enable": 1,
          "presentation": 1,
          "presentation_rect": [
            1224.0,
            78.0,
            36.0,
            21.0
          ],
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "Weight Rate random",
              "parameter_shortname": "Weight Rate random",
              "parameter_type": 0,
              "parameter_mmin": 0,
              "parameter_mmax": 100,
              "parameter_initial": [
                100
              ],
              "parameter_initial_enable": 1,
              "parameter_unitstyle": 1
            }
          },
          "fontsize": 10.0
        }
      },
      {
        "box": {
          "id": "pool5cmd",
          "maxclass": "newobj",
          "patching_rect": [
            0.0,
            200.0,
            100.0,
            22.0
          ],
          "text": "prepend pool 5",
          "numinlets": 1,
          "numoutlets": 1
        }
      },
      {
        "box": {
          "id": "poolname6",
          "maxclass": "comment",
          "patching_rect": [
            1264.0,
            80.0,
            37.0,
            18.0
          ],
          "text": "HOME",
          "numinlets": 1,
          "numoutlets": 0,
          "presentation": 1,
          "presentation_rect": [
            1264.0,
            80.0,
            37.0,
            18.0
          ],
          "textcolor": [
            0.91,
            0.93,
            0.94,
            1.0
          ],
          "fontname": "Arial",
          "fontsize": 8.5
        }
      },
      {
        "box": {
          "id": "pool6",
          "maxclass": "live.numbox",
          "patching_rect": [
            1301.0,
            78.0,
            36.0,
            21.0
          ],
          "varname": "pool6",
          "numinlets": 1,
          "numoutlets": 2,
          "outlettype": [
            "",
            ""
          ],
          "parameter_enable": 1,
          "presentation": 1,
          "presentation_rect": [
            1301.0,
            78.0,
            36.0,
            21.0
          ],
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "Weight Loop start",
              "parameter_shortname": "Weight Loop start",
              "parameter_type": 0,
              "parameter_mmin": 0,
              "parameter_mmax": 100,
              "parameter_initial": [
                100
              ],
              "parameter_initial_enable": 1,
              "parameter_unitstyle": 1
            }
          },
          "fontsize": 10.0
        }
      },
      {
        "box": {
          "id": "pool6cmd",
          "maxclass": "newobj",
          "patching_rect": [
            0.0,
            200.0,
            100.0,
            22.0
          ],
          "text": "prepend pool 6",
          "numinlets": 1,
          "numoutlets": 1
        }
      },
      {
        "box": {
          "id": "poolname7",
          "maxclass": "comment",
          "patching_rect": [
            1341.0,
            80.0,
            37.0,
            18.0
          ],
          "text": "POS?",
          "numinlets": 1,
          "numoutlets": 0,
          "presentation": 1,
          "presentation_rect": [
            1341.0,
            80.0,
            37.0,
            18.0
          ],
          "textcolor": [
            0.91,
            0.93,
            0.94,
            1.0
          ],
          "fontname": "Arial",
          "fontsize": 8.5
        }
      },
      {
        "box": {
          "id": "pool7",
          "maxclass": "live.numbox",
          "patching_rect": [
            1378.0,
            78.0,
            36.0,
            21.0
          ],
          "varname": "pool7",
          "numinlets": 1,
          "numoutlets": 2,
          "outlettype": [
            "",
            ""
          ],
          "parameter_enable": 1,
          "presentation": 1,
          "presentation_rect": [
            1378.0,
            78.0,
            36.0,
            21.0
          ],
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "Weight Position",
              "parameter_shortname": "Weight Position",
              "parameter_type": 0,
              "parameter_mmin": 0,
              "parameter_mmax": 100,
              "parameter_initial": [
                100
              ],
              "parameter_initial_enable": 1,
              "parameter_unitstyle": 1
            }
          },
          "fontsize": 10.0
        }
      },
      {
        "box": {
          "id": "pool7cmd",
          "maxclass": "newobj",
          "patching_rect": [
            0.0,
            200.0,
            100.0,
            22.0
          ],
          "text": "prepend pool 7",
          "numinlets": 1,
          "numoutlets": 1
        }
      },
      {
        "box": {
          "id": "poolname8",
          "maxclass": "comment",
          "patching_rect": [
            1110.0,
            105.0,
            37.0,
            18.0
          ],
          "text": "LOOP?",
          "numinlets": 1,
          "numoutlets": 0,
          "presentation": 1,
          "presentation_rect": [
            1110.0,
            105.0,
            37.0,
            18.0
          ],
          "textcolor": [
            0.91,
            0.93,
            0.94,
            1.0
          ],
          "fontname": "Arial",
          "fontsize": 8.5
        }
      },
      {
        "box": {
          "id": "pool8",
          "maxclass": "live.numbox",
          "patching_rect": [
            1147.0,
            103.0,
            36.0,
            21.0
          ],
          "varname": "pool8",
          "numinlets": 1,
          "numoutlets": 2,
          "outlettype": [
            "",
            ""
          ],
          "parameter_enable": 1,
          "presentation": 1,
          "presentation_rect": [
            1147.0,
            103.0,
            36.0,
            21.0
          ],
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "Weight Loop random",
              "parameter_shortname": "Weight Loop random",
              "parameter_type": 0,
              "parameter_mmin": 0,
              "parameter_mmax": 100,
              "parameter_initial": [
                100
              ],
              "parameter_initial_enable": 1,
              "parameter_unitstyle": 1
            }
          },
          "fontsize": 10.0
        }
      },
      {
        "box": {
          "id": "pool8cmd",
          "maxclass": "newobj",
          "patching_rect": [
            0.0,
            200.0,
            100.0,
            22.0
          ],
          "text": "prepend pool 8",
          "numinlets": 1,
          "numoutlets": 1
        }
      },
      {
        "box": {
          "id": "poolname9",
          "maxclass": "comment",
          "patching_rect": [
            1187.0,
            105.0,
            37.0,
            18.0
          ],
          "text": "C+",
          "numinlets": 1,
          "numoutlets": 0,
          "presentation": 1,
          "presentation_rect": [
            1187.0,
            105.0,
            37.0,
            18.0
          ],
          "textcolor": [
            0.91,
            0.93,
            0.94,
            1.0
          ],
          "fontname": "Arial",
          "fontsize": 8.5
        }
      },
      {
        "box": {
          "id": "pool9",
          "maxclass": "live.numbox",
          "patching_rect": [
            1224.0,
            103.0,
            36.0,
            21.0
          ],
          "varname": "pool9",
          "numinlets": 1,
          "numoutlets": 2,
          "outlettype": [
            "",
            ""
          ],
          "parameter_enable": 1,
          "presentation": 1,
          "presentation_rect": [
            1224.0,
            103.0,
            36.0,
            21.0
          ],
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "Weight Clock +",
              "parameter_shortname": "Weight Clock +",
              "parameter_type": 0,
              "parameter_mmin": 0,
              "parameter_mmax": 100,
              "parameter_initial": [
                100
              ],
              "parameter_initial_enable": 1,
              "parameter_unitstyle": 1
            }
          },
          "fontsize": 10.0
        }
      },
      {
        "box": {
          "id": "pool9cmd",
          "maxclass": "newobj",
          "patching_rect": [
            0.0,
            200.0,
            100.0,
            22.0
          ],
          "text": "prepend pool 9",
          "numinlets": 1,
          "numoutlets": 1
        }
      },
      {
        "box": {
          "id": "poolname10",
          "maxclass": "comment",
          "patching_rect": [
            1264.0,
            105.0,
            37.0,
            18.0
          ],
          "text": "C-",
          "numinlets": 1,
          "numoutlets": 0,
          "presentation": 1,
          "presentation_rect": [
            1264.0,
            105.0,
            37.0,
            18.0
          ],
          "textcolor": [
            0.91,
            0.93,
            0.94,
            1.0
          ],
          "fontname": "Arial",
          "fontsize": 8.5
        }
      },
      {
        "box": {
          "id": "pool10",
          "maxclass": "live.numbox",
          "patching_rect": [
            1301.0,
            103.0,
            36.0,
            21.0
          ],
          "varname": "pool10",
          "numinlets": 1,
          "numoutlets": 2,
          "outlettype": [
            "",
            ""
          ],
          "parameter_enable": 1,
          "presentation": 1,
          "presentation_rect": [
            1301.0,
            103.0,
            36.0,
            21.0
          ],
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "Weight Clock -",
              "parameter_shortname": "Weight Clock -",
              "parameter_type": 0,
              "parameter_mmin": 0,
              "parameter_mmax": 100,
              "parameter_initial": [
                100
              ],
              "parameter_initial_enable": 1,
              "parameter_unitstyle": 1
            }
          },
          "fontsize": 10.0
        }
      },
      {
        "box": {
          "id": "pool10cmd",
          "maxclass": "newobj",
          "patching_rect": [
            0.0,
            200.0,
            100.0,
            22.0
          ],
          "text": "prepend pool 10",
          "numinlets": 1,
          "numoutlets": 1
        }
      },
      {
        "box": {
          "id": "poolname11",
          "maxclass": "comment",
          "patching_rect": [
            1341.0,
            105.0,
            37.0,
            18.0
          ],
          "text": "C16",
          "numinlets": 1,
          "numoutlets": 0,
          "presentation": 1,
          "presentation_rect": [
            1341.0,
            105.0,
            37.0,
            18.0
          ],
          "textcolor": [
            0.91,
            0.93,
            0.94,
            1.0
          ],
          "fontname": "Arial",
          "fontsize": 8.5
        }
      },
      {
        "box": {
          "id": "pool11",
          "maxclass": "live.numbox",
          "patching_rect": [
            1378.0,
            103.0,
            36.0,
            21.0
          ],
          "varname": "pool11",
          "numinlets": 1,
          "numoutlets": 2,
          "outlettype": [
            "",
            ""
          ],
          "parameter_enable": 1,
          "presentation": 1,
          "presentation_rect": [
            1378.0,
            103.0,
            36.0,
            21.0
          ],
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "Weight Clock fastest",
              "parameter_shortname": "Weight Clock fastest",
              "parameter_type": 0,
              "parameter_mmin": 0,
              "parameter_mmax": 100,
              "parameter_initial": [
                0
              ],
              "parameter_initial_enable": 1,
              "parameter_unitstyle": 1
            }
          },
          "fontsize": 10.0
        }
      },
      {
        "box": {
          "id": "pool11cmd",
          "maxclass": "newobj",
          "patching_rect": [
            0.0,
            200.0,
            100.0,
            22.0
          ],
          "text": "prepend pool 11",
          "numinlets": 1,
          "numoutlets": 1
        }
      },
      {
        "box": {
          "id": "poolname12",
          "maxclass": "comment",
          "patching_rect": [
            1110.0,
            130.0,
            37.0,
            18.0
          ],
          "text": "C1",
          "numinlets": 1,
          "numoutlets": 0,
          "presentation": 1,
          "presentation_rect": [
            1110.0,
            130.0,
            37.0,
            18.0
          ],
          "textcolor": [
            0.91,
            0.93,
            0.94,
            1.0
          ],
          "fontname": "Arial",
          "fontsize": 8.5
        }
      },
      {
        "box": {
          "id": "pool12",
          "maxclass": "live.numbox",
          "patching_rect": [
            1147.0,
            128.0,
            36.0,
            21.0
          ],
          "varname": "pool12",
          "numinlets": 1,
          "numoutlets": 2,
          "outlettype": [
            "",
            ""
          ],
          "parameter_enable": 1,
          "presentation": 1,
          "presentation_rect": [
            1147.0,
            128.0,
            36.0,
            21.0
          ],
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "Weight Clock slowest",
              "parameter_shortname": "Weight Clock slowest",
              "parameter_type": 0,
              "parameter_mmin": 0,
              "parameter_mmax": 100,
              "parameter_initial": [
                0
              ],
              "parameter_initial_enable": 1,
              "parameter_unitstyle": 1
            }
          },
          "fontsize": 10.0
        }
      },
      {
        "box": {
          "id": "pool12cmd",
          "maxclass": "newobj",
          "patching_rect": [
            0.0,
            200.0,
            100.0,
            22.0
          ],
          "text": "prepend pool 12",
          "numinlets": 1,
          "numoutlets": 1
        }
      },
      {
        "box": {
          "id": "poolname13",
          "maxclass": "comment",
          "patching_rect": [
            1187.0,
            130.0,
            37.0,
            18.0
          ],
          "text": "STEP?",
          "numinlets": 1,
          "numoutlets": 0,
          "presentation": 1,
          "presentation_rect": [
            1187.0,
            130.0,
            37.0,
            18.0
          ],
          "textcolor": [
            0.91,
            0.93,
            0.94,
            1.0
          ],
          "fontname": "Arial",
          "fontsize": 8.5
        }
      },
      {
        "box": {
          "id": "pool13",
          "maxclass": "live.numbox",
          "patching_rect": [
            1224.0,
            128.0,
            36.0,
            21.0
          ],
          "varname": "pool13",
          "numinlets": 1,
          "numoutlets": 2,
          "outlettype": [
            "",
            ""
          ],
          "parameter_enable": 1,
          "presentation": 1,
          "presentation_rect": [
            1224.0,
            128.0,
            36.0,
            21.0
          ],
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "Weight Step random",
              "parameter_shortname": "Weight Step random",
              "parameter_type": 0,
              "parameter_mmin": 0,
              "parameter_mmax": 100,
              "parameter_initial": [
                100
              ],
              "parameter_initial_enable": 1,
              "parameter_unitstyle": 1
            }
          },
          "fontsize": 10.0
        }
      },
      {
        "box": {
          "id": "pool13cmd",
          "maxclass": "newobj",
          "patching_rect": [
            0.0,
            200.0,
            100.0,
            22.0
          ],
          "text": "prepend pool 13",
          "numinlets": 1,
          "numoutlets": 1
        }
      },
      {
        "box": {
          "id": "ready",
          "maxclass": "newobj",
          "patching_rect": [
            0.0,
            200.0,
            100.0,
            22.0
          ],
          "text": "live.thisdevice",
          "numinlets": 1,
          "numoutlets": 3
        }
      },
      {
        "box": {
          "id": "init",
          "maxclass": "message",
          "patching_rect": [
            0.0,
            200.0,
            100.0,
            22.0
          ],
          "text": "initialize",
          "numinlets": 2,
          "numoutlets": 1
        }
      },
      {
        "box": {
          "id": "active",
          "maxclass": "newobj",
          "patching_rect": [
            0.0,
            200.0,
            100.0,
            22.0
          ],
          "text": "prepend deviceactive",
          "numinlets": 1,
          "numoutlets": 1
        }
      },
      {
        "box": {
          "id": "data",
          "maxclass": "newobj",
          "patching_rect": [
            0.0,
            200.0,
            100.0,
            22.0
          ],
          "text": "pattr CompassData @bindto engine @parameter_enable 1",
          "varname": "CompassData",
          "numinlets": 1,
          "numoutlets": 3,
          "saved_object_attributes": {
            "parameter_enable": 1,
            "parameter_mappable": 0
          },
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_type": 3,
              "parameter_invisible": 1,
              "parameter_longname": "CompassData",
              "parameter_shortname": "CompassData"
            }
          }
        }
      },
      {
        "box": {
          "id": "route",
          "maxclass": "newobj",
          "patching_rect": [
            0.0,
            200.0,
            100.0,
            22.0
          ],
          "text": "route choose load bind channels bounds edge rate seek fade loadgate master stepenv start clear direction",
          "numinlets": 1,
          "numoutlets": 16
        }
      },
      {
        "box": {
          "id": "replace",
          "maxclass": "newobj",
          "patching_rect": [
            0.0,
            200.0,
            100.0,
            22.0
          ],
          "text": "prepend replace",
          "numinlets": 1,
          "numoutlets": 1
        }
      },
      {
        "box": {
          "id": "buffer",
          "maxclass": "newobj",
          "patching_rect": [
            0.0,
            200.0,
            100.0,
            22.0
          ],
          "text": "buffer~ #0-compass",
          "numinlets": 1,
          "numoutlets": 2
        }
      },
      {
        "box": {
          "id": "clearbuffer",
          "maxclass": "message",
          "patching_rect": [
            0.0,
            200.0,
            100.0,
            22.0
          ],
          "text": "clear",
          "numinlets": 2,
          "numoutlets": 1
        }
      },
      {
        "box": {
          "id": "loaded",
          "maxclass": "message",
          "patching_rect": [
            0.0,
            200.0,
            100.0,
            22.0
          ],
          "text": "loaded",
          "numinlets": 2,
          "numoutlets": 1
        }
      },
      {
        "box": {
          "id": "boundsroute",
          "maxclass": "newobj",
          "patching_rect": [
            0.0,
            200.0,
            100.0,
            22.0
          ],
          "text": "route 0 1",
          "numinlets": 1,
          "numoutlets": 3
        }
      },
      {
        "box": {
          "id": "edgeroute",
          "maxclass": "newobj",
          "patching_rect": [
            0.0,
            200.0,
            100.0,
            22.0
          ],
          "text": "route 0 1",
          "numinlets": 1,
          "numoutlets": 3
        }
      },
      {
        "box": {
          "id": "seekroute",
          "maxclass": "newobj",
          "patching_rect": [
            0.0,
            200.0,
            100.0,
            22.0
          ],
          "text": "route 0 1",
          "numinlets": 1,
          "numoutlets": 3
        }
      },
      {
        "box": {
          "id": "faderoute",
          "maxclass": "newobj",
          "patching_rect": [
            0.0,
            200.0,
            100.0,
            22.0
          ],
          "text": "route 0 1",
          "numinlets": 1,
          "numoutlets": 3
        }
      },
      {
        "box": {
          "id": "startroute",
          "maxclass": "newobj",
          "patching_rect": [
            0.0,
            200.0,
            100.0,
            22.0
          ],
          "text": "route 0 1",
          "numinlets": 1,
          "numoutlets": 3
        }
      },
      {
        "box": {
          "id": "directionroute",
          "maxclass": "newobj",
          "patching_rect": [
            0.0,
            200.0,
            100.0,
            22.0
          ],
          "text": "route 0 1",
          "numinlets": 1,
          "numoutlets": 3
        }
      },
      {
        "box": {
          "id": "rate-glide",
          "maxclass": "newobj",
          "patching_rect": [
            0.0,
            200.0,
            100.0,
            22.0
          ],
          "text": "line~ 1.",
          "numinlets": 2,
          "numoutlets": 2
        }
      },
      {
        "box": {
          "id": "rate-meter",
          "maxclass": "newobj",
          "patching_rect": [
            0.0,
            200.0,
            100.0,
            22.0
          ],
          "text": "snapshot~ 20",
          "numinlets": 2,
          "numoutlets": 1
        }
      },
      {
        "box": {
          "id": "rate-meter-cmd",
          "maxclass": "newobj",
          "patching_rect": [
            0.0,
            200.0,
            100.0,
            22.0
          ],
          "text": "prepend ratevalue",
          "numinlets": 1,
          "numoutlets": 1
        }
      },
      {
        "box": {
          "id": "head0",
          "maxclass": "newobj",
          "patching_rect": [
            0.0,
            200.0,
            100.0,
            22.0
          ],
          "text": "p head_0",
          "numinlets": 12,
          "numoutlets": 4,
          "patcher": {
            "fileversion": 1,
            "appversion": {
              "major": 8,
              "minor": 5,
              "revision": 5,
              "architecture": "x64",
              "modernui": 1
            },
            "classnamespace": "box",
            "rect": [
              0.0,
              0.0,
              750.0,
              500.0
            ],
            "openinpresentation": 0,
            "default_fontsize": 11.0,
            "default_fontface": 0,
            "default_fontname": "Arial",
            "gridonopen": 0,
            "gridsize": [
              10.0,
              10.0
            ],
            "bglocked": 1,
            "bgcolor": [
              0.11,
              0.12,
              0.14,
              1.0
            ],
            "boxes": [
              {
                "box": {
                  "id": "in0",
                  "maxclass": "inlet",
                  "patching_rect": [
                    30,
                    20,
                    30,
                    30
                  ],
                  "index": 1
                }
              },
              {
                "box": {
                  "id": "in1",
                  "maxclass": "inlet",
                  "patching_rect": [
                    160,
                    20,
                    30,
                    30
                  ],
                  "index": 2
                }
              },
              {
                "box": {
                  "id": "in2",
                  "maxclass": "inlet",
                  "patching_rect": [
                    290,
                    20,
                    30,
                    30
                  ],
                  "index": 3
                }
              },
              {
                "box": {
                  "id": "in3",
                  "maxclass": "inlet",
                  "patching_rect": [
                    420,
                    20,
                    30,
                    30
                  ],
                  "index": 4
                }
              },
              {
                "box": {
                  "id": "in4",
                  "maxclass": "inlet",
                  "patching_rect": [
                    550,
                    20,
                    30,
                    30
                  ],
                  "index": 5
                }
              },
              {
                "box": {
                  "id": "in5",
                  "maxclass": "inlet",
                  "patching_rect": [
                    680,
                    20,
                    30,
                    30
                  ],
                  "index": 6
                }
              },
              {
                "box": {
                  "id": "in6",
                  "maxclass": "inlet",
                  "patching_rect": [
                    810,
                    20,
                    30,
                    30
                  ],
                  "index": 7
                }
              },
              {
                "box": {
                  "id": "in7",
                  "maxclass": "inlet",
                  "patching_rect": [
                    940,
                    20,
                    30,
                    30
                  ],
                  "index": 8
                }
              },
              {
                "box": {
                  "id": "in8",
                  "maxclass": "inlet",
                  "patching_rect": [
                    1070,
                    20,
                    30,
                    30
                  ],
                  "index": 9
                }
              },
              {
                "box": {
                  "id": "in9",
                  "maxclass": "inlet",
                  "patching_rect": [
                    1200,
                    20,
                    30,
                    30
                  ],
                  "index": 10
                }
              },
              {
                "box": {
                  "id": "in10",
                  "maxclass": "inlet",
                  "patching_rect": [
                    1330,
                    20,
                    30,
                    30
                  ],
                  "index": 11
                }
              },
              {
                "box": {
                  "id": "groove",
                  "maxclass": "newobj",
                  "patching_rect": [
                    0.0,
                    200.0,
                    100.0,
                    22.0
                  ],
                  "text": "groove~ #0-compass 2 @loop 1 @loopinterp 1",
                  "numinlets": 3,
                  "numoutlets": 3,
                  "outlettype": [
                    "signal",
                    "signal",
                    "signal"
                  ]
                }
              },
              {
                "box": {
                  "id": "bounds",
                  "maxclass": "newobj",
                  "patching_rect": [
                    0.0,
                    200.0,
                    100.0,
                    22.0
                  ],
                  "text": "unpack f f",
                  "numinlets": 1,
                  "numoutlets": 2
                }
              },
              {
                "box": {
                  "id": "trim",
                  "maxclass": "newobj",
                  "patching_rect": [
                    0.0,
                    200.0,
                    100.0,
                    22.0
                  ],
                  "text": "line~ 1.",
                  "numinlets": 2,
                  "numoutlets": 2
                }
              },
              {
                "box": {
                  "id": "effective-level",
                  "maxclass": "newobj",
                  "patching_rect": [
                    0.0,
                    200.0,
                    100.0,
                    22.0
                  ],
                  "text": "*~",
                  "numinlets": 2,
                  "numoutlets": 1
                }
              },
              {
                "box": {
                  "id": "level",
                  "maxclass": "newobj",
                  "patching_rect": [
                    0.0,
                    200.0,
                    100.0,
                    22.0
                  ],
                  "text": "line~ 1.",
                  "numinlets": 2,
                  "numoutlets": 2
                }
              },
              {
                "box": {
                  "id": "boundary-fade",
                  "maxclass": "newobj",
                  "patching_rect": [
                    0.0,
                    200.0,
                    100.0,
                    22.0
                  ],
                  "text": "line~ 1.",
                  "numinlets": 2,
                  "numoutlets": 2
                }
              },
              {
                "box": {
                  "id": "fade-done",
                  "maxclass": "outlet",
                  "patching_rect": [
                    500,
                    440,
                    30,
                    30
                  ],
                  "index": 3
                }
              },
              {
                "box": {
                  "id": "edge-scale",
                  "maxclass": "newobj",
                  "patching_rect": [
                    0.0,
                    200.0,
                    100.0,
                    22.0
                  ],
                  "text": "line~ 4.",
                  "numinlets": 2,
                  "numoutlets": 2
                }
              },
              {
                "box": {
                  "id": "phase-neg",
                  "maxclass": "newobj",
                  "patching_rect": [
                    0.0,
                    200.0,
                    100.0,
                    22.0
                  ],
                  "text": "*~ -1.",
                  "numinlets": 2,
                  "numoutlets": 1
                }
              },
              {
                "box": {
                  "id": "phase-back",
                  "maxclass": "newobj",
                  "patching_rect": [
                    0.0,
                    200.0,
                    100.0,
                    22.0
                  ],
                  "text": "+~ 1.",
                  "numinlets": 2,
                  "numoutlets": 1
                }
              },
              {
                "box": {
                  "id": "risescale",
                  "maxclass": "newobj",
                  "patching_rect": [
                    0.0,
                    200.0,
                    100.0,
                    22.0
                  ],
                  "text": "*~",
                  "numinlets": 2,
                  "numoutlets": 1
                }
              },
              {
                "box": {
                  "id": "rise",
                  "maxclass": "newobj",
                  "patching_rect": [
                    0.0,
                    200.0,
                    100.0,
                    22.0
                  ],
                  "text": "clip~ 0. 1.",
                  "numinlets": 3,
                  "numoutlets": 1
                }
              },
              {
                "box": {
                  "id": "fallscale",
                  "maxclass": "newobj",
                  "patching_rect": [
                    0.0,
                    200.0,
                    100.0,
                    22.0
                  ],
                  "text": "*~",
                  "numinlets": 2,
                  "numoutlets": 1
                }
              },
              {
                "box": {
                  "id": "fall",
                  "maxclass": "newobj",
                  "patching_rect": [
                    0.0,
                    200.0,
                    100.0,
                    22.0
                  ],
                  "text": "clip~ 0. 1.",
                  "numinlets": 3,
                  "numoutlets": 1
                }
              },
              {
                "box": {
                  "id": "edge-envelope",
                  "maxclass": "newobj",
                  "patching_rect": [
                    0.0,
                    200.0,
                    100.0,
                    22.0
                  ],
                  "text": "*~",
                  "numinlets": 2,
                  "numoutlets": 1
                }
              },
              {
                "box": {
                  "id": "safe-level",
                  "maxclass": "newobj",
                  "patching_rect": [
                    0.0,
                    200.0,
                    100.0,
                    22.0
                  ],
                  "text": "*~",
                  "numinlets": 2,
                  "numoutlets": 1
                }
              },
              {
                "box": {
                  "id": "safe-transition",
                  "maxclass": "newobj",
                  "patching_rect": [
                    0.0,
                    200.0,
                    100.0,
                    22.0
                  ],
                  "text": "*~",
                  "numinlets": 2,
                  "numoutlets": 1
                }
              },
              {
                "box": {
                  "id": "pan",
                  "maxclass": "newobj",
                  "patching_rect": [
                    0.0,
                    200.0,
                    100.0,
                    22.0
                  ],
                  "text": "unpack f f f",
                  "numinlets": 1,
                  "numoutlets": 3
                }
              },
              {
                "box": {
                  "id": "pack0",
                  "maxclass": "newobj",
                  "patching_rect": [
                    0.0,
                    200.0,
                    100.0,
                    22.0
                  ],
                  "text": "pack 0. 1000.",
                  "numinlets": 2,
                  "numoutlets": 1
                }
              },
              {
                "box": {
                  "id": "panline0",
                  "maxclass": "newobj",
                  "patching_rect": [
                    0.0,
                    200.0,
                    100.0,
                    22.0
                  ],
                  "text": "line~ 1.",
                  "numinlets": 2,
                  "numoutlets": 2
                }
              },
              {
                "box": {
                  "id": "amp0",
                  "maxclass": "newobj",
                  "patching_rect": [
                    0.0,
                    200.0,
                    100.0,
                    22.0
                  ],
                  "text": "*~",
                  "numinlets": 2,
                  "numoutlets": 1
                }
              },
              {
                "box": {
                  "id": "panned0",
                  "maxclass": "newobj",
                  "patching_rect": [
                    0.0,
                    200.0,
                    100.0,
                    22.0
                  ],
                  "text": "*~",
                  "numinlets": 2,
                  "numoutlets": 1
                }
              },
              {
                "box": {
                  "id": "out0",
                  "maxclass": "outlet",
                  "patching_rect": [
                    100,
                    440,
                    30,
                    30
                  ],
                  "index": 1
                }
              },
              {
                "box": {
                  "id": "pack1",
                  "maxclass": "newobj",
                  "patching_rect": [
                    0.0,
                    200.0,
                    100.0,
                    22.0
                  ],
                  "text": "pack 0. 1000.",
                  "numinlets": 2,
                  "numoutlets": 1
                }
              },
              {
                "box": {
                  "id": "panline1",
                  "maxclass": "newobj",
                  "patching_rect": [
                    0.0,
                    200.0,
                    100.0,
                    22.0
                  ],
                  "text": "line~ 1.",
                  "numinlets": 2,
                  "numoutlets": 2
                }
              },
              {
                "box": {
                  "id": "amp1",
                  "maxclass": "newobj",
                  "patching_rect": [
                    0.0,
                    200.0,
                    100.0,
                    22.0
                  ],
                  "text": "*~",
                  "numinlets": 2,
                  "numoutlets": 1
                }
              },
              {
                "box": {
                  "id": "panned1",
                  "maxclass": "newobj",
                  "patching_rect": [
                    0.0,
                    200.0,
                    100.0,
                    22.0
                  ],
                  "text": "*~",
                  "numinlets": 2,
                  "numoutlets": 1
                }
              },
              {
                "box": {
                  "id": "out1",
                  "maxclass": "outlet",
                  "patching_rect": [
                    250,
                    440,
                    30,
                    30
                  ],
                  "index": 2
                }
              },
              {
                "box": {
                  "id": "set-buffer",
                  "maxclass": "newobj",
                  "patching_rect": [
                    0.0,
                    200.0,
                    100.0,
                    22.0
                  ],
                  "text": "prepend set",
                  "numinlets": 1,
                  "numoutlets": 1
                }
              },
              {
                "box": {
                  "id": "right-select",
                  "maxclass": "newobj",
                  "patching_rect": [
                    0.0,
                    200.0,
                    100.0,
                    22.0
                  ],
                  "text": "selector~ 2 1",
                  "numinlets": 3,
                  "numoutlets": 1
                }
              },
              {
                "box": {
                  "id": "phase-out",
                  "maxclass": "outlet",
                  "patching_rect": [
                    650,
                    440,
                    30,
                    30
                  ],
                  "index": 4
                }
              },
              {
                "box": {
                  "id": "direction-in",
                  "maxclass": "inlet",
                  "patching_rect": [
                    1460,
                    20,
                    30,
                    30
                  ],
                  "index": 12
                }
              },
              {
                "box": {
                  "id": "signed-rate",
                  "maxclass": "newobj",
                  "patching_rect": [
                    0.0,
                    200.0,
                    100.0,
                    22.0
                  ],
                  "text": "*~ 1.",
                  "numinlets": 2,
                  "numoutlets": 1
                }
              }
            ],
            "lines": [
              {
                "patchline": {
                  "source": [
                    "in1",
                    0
                  ],
                  "destination": [
                    "bounds",
                    0
                  ]
                }
              },
              {
                "patchline": {
                  "source": [
                    "bounds",
                    0
                  ],
                  "destination": [
                    "groove",
                    1
                  ]
                }
              },
              {
                "patchline": {
                  "source": [
                    "bounds",
                    1
                  ],
                  "destination": [
                    "groove",
                    2
                  ]
                }
              },
              {
                "patchline": {
                  "source": [
                    "in8",
                    0
                  ],
                  "destination": [
                    "trim",
                    0
                  ]
                }
              },
              {
                "patchline": {
                  "source": [
                    "in2",
                    0
                  ],
                  "destination": [
                    "level",
                    0
                  ]
                }
              },
              {
                "patchline": {
                  "source": [
                    "level",
                    0
                  ],
                  "destination": [
                    "effective-level",
                    0
                  ]
                }
              },
              {
                "patchline": {
                  "source": [
                    "trim",
                    0
                  ],
                  "destination": [
                    "effective-level",
                    1
                  ]
                }
              },
              {
                "patchline": {
                  "source": [
                    "in9",
                    0
                  ],
                  "destination": [
                    "boundary-fade",
                    0
                  ]
                }
              },
              {
                "patchline": {
                  "source": [
                    "boundary-fade",
                    1
                  ],
                  "destination": [
                    "fade-done",
                    0
                  ]
                }
              },
              {
                "patchline": {
                  "source": [
                    "in10",
                    0
                  ],
                  "destination": [
                    "edge-scale",
                    0
                  ]
                }
              },
              {
                "patchline": {
                  "source": [
                    "groove",
                    2
                  ],
                  "destination": [
                    "phase-neg",
                    0
                  ]
                }
              },
              {
                "patchline": {
                  "source": [
                    "phase-neg",
                    0
                  ],
                  "destination": [
                    "phase-back",
                    0
                  ]
                }
              },
              {
                "patchline": {
                  "source": [
                    "groove",
                    2
                  ],
                  "destination": [
                    "risescale",
                    0
                  ]
                }
              },
              {
                "patchline": {
                  "source": [
                    "edge-scale",
                    0
                  ],
                  "destination": [
                    "risescale",
                    1
                  ]
                }
              },
              {
                "patchline": {
                  "source": [
                    "risescale",
                    0
                  ],
                  "destination": [
                    "rise",
                    0
                  ]
                }
              },
              {
                "patchline": {
                  "source": [
                    "phase-back",
                    0
                  ],
                  "destination": [
                    "fallscale",
                    0
                  ]
                }
              },
              {
                "patchline": {
                  "source": [
                    "edge-scale",
                    0
                  ],
                  "destination": [
                    "fallscale",
                    1
                  ]
                }
              },
              {
                "patchline": {
                  "source": [
                    "fallscale",
                    0
                  ],
                  "destination": [
                    "fall",
                    0
                  ]
                }
              },
              {
                "patchline": {
                  "source": [
                    "rise",
                    0
                  ],
                  "destination": [
                    "edge-envelope",
                    0
                  ]
                }
              },
              {
                "patchline": {
                  "source": [
                    "fall",
                    0
                  ],
                  "destination": [
                    "edge-envelope",
                    1
                  ]
                }
              },
              {
                "patchline": {
                  "source": [
                    "effective-level",
                    0
                  ],
                  "destination": [
                    "safe-level",
                    0
                  ]
                }
              },
              {
                "patchline": {
                  "source": [
                    "edge-envelope",
                    0
                  ],
                  "destination": [
                    "safe-level",
                    1
                  ]
                }
              },
              {
                "patchline": {
                  "source": [
                    "safe-level",
                    0
                  ],
                  "destination": [
                    "safe-transition",
                    0
                  ]
                }
              },
              {
                "patchline": {
                  "source": [
                    "boundary-fade",
                    0
                  ],
                  "destination": [
                    "safe-transition",
                    1
                  ]
                }
              },
              {
                "patchline": {
                  "source": [
                    "in3",
                    0
                  ],
                  "destination": [
                    "pan",
                    0
                  ]
                }
              },
              {
                "patchline": {
                  "source": [
                    "pan",
                    0
                  ],
                  "destination": [
                    "pack0",
                    0
                  ]
                }
              },
              {
                "patchline": {
                  "source": [
                    "pan",
                    2
                  ],
                  "destination": [
                    "pack0",
                    1
                  ]
                }
              },
              {
                "patchline": {
                  "source": [
                    "pack0",
                    0
                  ],
                  "destination": [
                    "panline0",
                    0
                  ]
                }
              },
              {
                "patchline": {
                  "source": [
                    "groove",
                    0
                  ],
                  "destination": [
                    "amp0",
                    0
                  ]
                }
              },
              {
                "patchline": {
                  "source": [
                    "safe-transition",
                    0
                  ],
                  "destination": [
                    "amp0",
                    1
                  ]
                }
              },
              {
                "patchline": {
                  "source": [
                    "amp0",
                    0
                  ],
                  "destination": [
                    "panned0",
                    0
                  ]
                }
              },
              {
                "patchline": {
                  "source": [
                    "panline0",
                    0
                  ],
                  "destination": [
                    "panned0",
                    1
                  ]
                }
              },
              {
                "patchline": {
                  "source": [
                    "panned0",
                    0
                  ],
                  "destination": [
                    "out0",
                    0
                  ]
                }
              },
              {
                "patchline": {
                  "source": [
                    "pan",
                    1
                  ],
                  "destination": [
                    "pack1",
                    0
                  ]
                }
              },
              {
                "patchline": {
                  "source": [
                    "pan",
                    2
                  ],
                  "destination": [
                    "pack1",
                    1
                  ]
                }
              },
              {
                "patchline": {
                  "source": [
                    "pack1",
                    0
                  ],
                  "destination": [
                    "panline1",
                    0
                  ]
                }
              },
              {
                "patchline": {
                  "source": [
                    "safe-transition",
                    0
                  ],
                  "destination": [
                    "amp1",
                    1
                  ]
                }
              },
              {
                "patchline": {
                  "source": [
                    "amp1",
                    0
                  ],
                  "destination": [
                    "panned1",
                    0
                  ]
                }
              },
              {
                "patchline": {
                  "source": [
                    "panline1",
                    0
                  ],
                  "destination": [
                    "panned1",
                    1
                  ]
                }
              },
              {
                "patchline": {
                  "source": [
                    "panned1",
                    0
                  ],
                  "destination": [
                    "out1",
                    0
                  ]
                }
              },
              {
                "patchline": {
                  "source": [
                    "in4",
                    0
                  ],
                  "destination": [
                    "groove",
                    0
                  ]
                }
              },
              {
                "patchline": {
                  "source": [
                    "in6",
                    0
                  ],
                  "destination": [
                    "set-buffer",
                    0
                  ]
                }
              },
              {
                "patchline": {
                  "source": [
                    "set-buffer",
                    0
                  ],
                  "destination": [
                    "groove",
                    0
                  ]
                }
              },
              {
                "patchline": {
                  "source": [
                    "in7",
                    0
                  ],
                  "destination": [
                    "groove",
                    0
                  ]
                }
              },
              {
                "patchline": {
                  "source": [
                    "in5",
                    0
                  ],
                  "destination": [
                    "right-select",
                    0
                  ]
                }
              },
              {
                "patchline": {
                  "source": [
                    "groove",
                    0
                  ],
                  "destination": [
                    "right-select",
                    1
                  ]
                }
              },
              {
                "patchline": {
                  "source": [
                    "groove",
                    1
                  ],
                  "destination": [
                    "right-select",
                    2
                  ]
                }
              },
              {
                "patchline": {
                  "source": [
                    "right-select",
                    0
                  ],
                  "destination": [
                    "amp1",
                    0
                  ]
                }
              },
              {
                "patchline": {
                  "source": [
                    "groove",
                    2
                  ],
                  "destination": [
                    "phase-out",
                    0
                  ]
                }
              },
              {
                "patchline": {
                  "source": [
                    "in0",
                    0
                  ],
                  "destination": [
                    "signed-rate",
                    0
                  ]
                }
              },
              {
                "patchline": {
                  "source": [
                    "direction-in",
                    0
                  ],
                  "destination": [
                    "signed-rate",
                    1
                  ]
                }
              },
              {
                "patchline": {
                  "source": [
                    "signed-rate",
                    0
                  ],
                  "destination": [
                    "groove",
                    0
                  ]
                }
              }
            ]
          },
          "outlettype": [
            "signal",
            "signal",
            "bang",
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "ended0",
          "maxclass": "message",
          "patching_rect": [
            0.0,
            200.0,
            100.0,
            22.0
          ],
          "text": "ended 0",
          "numinlets": 2,
          "numoutlets": 1
        }
      },
      {
        "box": {
          "id": "snapshot0",
          "maxclass": "newobj",
          "patching_rect": [
            0.0,
            200.0,
            100.0,
            22.0
          ],
          "text": "snapshot~ 10",
          "numinlets": 2,
          "numoutlets": 1
        }
      },
      {
        "box": {
          "id": "position0",
          "maxclass": "newobj",
          "patching_rect": [
            0.0,
            200.0,
            100.0,
            22.0
          ],
          "text": "prepend position 0",
          "numinlets": 1,
          "numoutlets": 1
        }
      },
      {
        "box": {
          "id": "head1",
          "maxclass": "newobj",
          "patching_rect": [
            0.0,
            200.0,
            100.0,
            22.0
          ],
          "text": "p head_1",
          "numinlets": 12,
          "numoutlets": 4,
          "patcher": {
            "fileversion": 1,
            "appversion": {
              "major": 8,
              "minor": 5,
              "revision": 5,
              "architecture": "x64",
              "modernui": 1
            },
            "classnamespace": "box",
            "rect": [
              0.0,
              0.0,
              750.0,
              500.0
            ],
            "openinpresentation": 0,
            "default_fontsize": 11.0,
            "default_fontface": 0,
            "default_fontname": "Arial",
            "gridonopen": 0,
            "gridsize": [
              10.0,
              10.0
            ],
            "bglocked": 1,
            "bgcolor": [
              0.11,
              0.12,
              0.14,
              1.0
            ],
            "boxes": [
              {
                "box": {
                  "id": "in0",
                  "maxclass": "inlet",
                  "patching_rect": [
                    30,
                    20,
                    30,
                    30
                  ],
                  "index": 1
                }
              },
              {
                "box": {
                  "id": "in1",
                  "maxclass": "inlet",
                  "patching_rect": [
                    160,
                    20,
                    30,
                    30
                  ],
                  "index": 2
                }
              },
              {
                "box": {
                  "id": "in2",
                  "maxclass": "inlet",
                  "patching_rect": [
                    290,
                    20,
                    30,
                    30
                  ],
                  "index": 3
                }
              },
              {
                "box": {
                  "id": "in3",
                  "maxclass": "inlet",
                  "patching_rect": [
                    420,
                    20,
                    30,
                    30
                  ],
                  "index": 4
                }
              },
              {
                "box": {
                  "id": "in4",
                  "maxclass": "inlet",
                  "patching_rect": [
                    550,
                    20,
                    30,
                    30
                  ],
                  "index": 5
                }
              },
              {
                "box": {
                  "id": "in5",
                  "maxclass": "inlet",
                  "patching_rect": [
                    680,
                    20,
                    30,
                    30
                  ],
                  "index": 6
                }
              },
              {
                "box": {
                  "id": "in6",
                  "maxclass": "inlet",
                  "patching_rect": [
                    810,
                    20,
                    30,
                    30
                  ],
                  "index": 7
                }
              },
              {
                "box": {
                  "id": "in7",
                  "maxclass": "inlet",
                  "patching_rect": [
                    940,
                    20,
                    30,
                    30
                  ],
                  "index": 8
                }
              },
              {
                "box": {
                  "id": "in8",
                  "maxclass": "inlet",
                  "patching_rect": [
                    1070,
                    20,
                    30,
                    30
                  ],
                  "index": 9
                }
              },
              {
                "box": {
                  "id": "in9",
                  "maxclass": "inlet",
                  "patching_rect": [
                    1200,
                    20,
                    30,
                    30
                  ],
                  "index": 10
                }
              },
              {
                "box": {
                  "id": "in10",
                  "maxclass": "inlet",
                  "patching_rect": [
                    1330,
                    20,
                    30,
                    30
                  ],
                  "index": 11
                }
              },
              {
                "box": {
                  "id": "groove",
                  "maxclass": "newobj",
                  "patching_rect": [
                    0.0,
                    200.0,
                    100.0,
                    22.0
                  ],
                  "text": "groove~ #0-compass 2 @loop 1 @loopinterp 1",
                  "numinlets": 3,
                  "numoutlets": 3,
                  "outlettype": [
                    "signal",
                    "signal",
                    "signal"
                  ]
                }
              },
              {
                "box": {
                  "id": "bounds",
                  "maxclass": "newobj",
                  "patching_rect": [
                    0.0,
                    200.0,
                    100.0,
                    22.0
                  ],
                  "text": "unpack f f",
                  "numinlets": 1,
                  "numoutlets": 2
                }
              },
              {
                "box": {
                  "id": "trim",
                  "maxclass": "newobj",
                  "patching_rect": [
                    0.0,
                    200.0,
                    100.0,
                    22.0
                  ],
                  "text": "line~ 1.",
                  "numinlets": 2,
                  "numoutlets": 2
                }
              },
              {
                "box": {
                  "id": "effective-level",
                  "maxclass": "newobj",
                  "patching_rect": [
                    0.0,
                    200.0,
                    100.0,
                    22.0
                  ],
                  "text": "*~",
                  "numinlets": 2,
                  "numoutlets": 1
                }
              },
              {
                "box": {
                  "id": "level",
                  "maxclass": "newobj",
                  "patching_rect": [
                    0.0,
                    200.0,
                    100.0,
                    22.0
                  ],
                  "text": "line~ 1.",
                  "numinlets": 2,
                  "numoutlets": 2
                }
              },
              {
                "box": {
                  "id": "boundary-fade",
                  "maxclass": "newobj",
                  "patching_rect": [
                    0.0,
                    200.0,
                    100.0,
                    22.0
                  ],
                  "text": "line~ 0.",
                  "numinlets": 2,
                  "numoutlets": 2
                }
              },
              {
                "box": {
                  "id": "fade-done",
                  "maxclass": "outlet",
                  "patching_rect": [
                    500,
                    440,
                    30,
                    30
                  ],
                  "index": 3
                }
              },
              {
                "box": {
                  "id": "edge-scale",
                  "maxclass": "newobj",
                  "patching_rect": [
                    0.0,
                    200.0,
                    100.0,
                    22.0
                  ],
                  "text": "line~ 4.",
                  "numinlets": 2,
                  "numoutlets": 2
                }
              },
              {
                "box": {
                  "id": "phase-neg",
                  "maxclass": "newobj",
                  "patching_rect": [
                    0.0,
                    200.0,
                    100.0,
                    22.0
                  ],
                  "text": "*~ -1.",
                  "numinlets": 2,
                  "numoutlets": 1
                }
              },
              {
                "box": {
                  "id": "phase-back",
                  "maxclass": "newobj",
                  "patching_rect": [
                    0.0,
                    200.0,
                    100.0,
                    22.0
                  ],
                  "text": "+~ 1.",
                  "numinlets": 2,
                  "numoutlets": 1
                }
              },
              {
                "box": {
                  "id": "risescale",
                  "maxclass": "newobj",
                  "patching_rect": [
                    0.0,
                    200.0,
                    100.0,
                    22.0
                  ],
                  "text": "*~",
                  "numinlets": 2,
                  "numoutlets": 1
                }
              },
              {
                "box": {
                  "id": "rise",
                  "maxclass": "newobj",
                  "patching_rect": [
                    0.0,
                    200.0,
                    100.0,
                    22.0
                  ],
                  "text": "clip~ 0. 1.",
                  "numinlets": 3,
                  "numoutlets": 1
                }
              },
              {
                "box": {
                  "id": "fallscale",
                  "maxclass": "newobj",
                  "patching_rect": [
                    0.0,
                    200.0,
                    100.0,
                    22.0
                  ],
                  "text": "*~",
                  "numinlets": 2,
                  "numoutlets": 1
                }
              },
              {
                "box": {
                  "id": "fall",
                  "maxclass": "newobj",
                  "patching_rect": [
                    0.0,
                    200.0,
                    100.0,
                    22.0
                  ],
                  "text": "clip~ 0. 1.",
                  "numinlets": 3,
                  "numoutlets": 1
                }
              },
              {
                "box": {
                  "id": "edge-envelope",
                  "maxclass": "newobj",
                  "patching_rect": [
                    0.0,
                    200.0,
                    100.0,
                    22.0
                  ],
                  "text": "*~",
                  "numinlets": 2,
                  "numoutlets": 1
                }
              },
              {
                "box": {
                  "id": "safe-level",
                  "maxclass": "newobj",
                  "patching_rect": [
                    0.0,
                    200.0,
                    100.0,
                    22.0
                  ],
                  "text": "*~",
                  "numinlets": 2,
                  "numoutlets": 1
                }
              },
              {
                "box": {
                  "id": "safe-transition",
                  "maxclass": "newobj",
                  "patching_rect": [
                    0.0,
                    200.0,
                    100.0,
                    22.0
                  ],
                  "text": "*~",
                  "numinlets": 2,
                  "numoutlets": 1
                }
              },
              {
                "box": {
                  "id": "pan",
                  "maxclass": "newobj",
                  "patching_rect": [
                    0.0,
                    200.0,
                    100.0,
                    22.0
                  ],
                  "text": "unpack f f f",
                  "numinlets": 1,
                  "numoutlets": 3
                }
              },
              {
                "box": {
                  "id": "pack0",
                  "maxclass": "newobj",
                  "patching_rect": [
                    0.0,
                    200.0,
                    100.0,
                    22.0
                  ],
                  "text": "pack 0. 1000.",
                  "numinlets": 2,
                  "numoutlets": 1
                }
              },
              {
                "box": {
                  "id": "panline0",
                  "maxclass": "newobj",
                  "patching_rect": [
                    0.0,
                    200.0,
                    100.0,
                    22.0
                  ],
                  "text": "line~ 1.",
                  "numinlets": 2,
                  "numoutlets": 2
                }
              },
              {
                "box": {
                  "id": "amp0",
                  "maxclass": "newobj",
                  "patching_rect": [
                    0.0,
                    200.0,
                    100.0,
                    22.0
                  ],
                  "text": "*~",
                  "numinlets": 2,
                  "numoutlets": 1
                }
              },
              {
                "box": {
                  "id": "panned0",
                  "maxclass": "newobj",
                  "patching_rect": [
                    0.0,
                    200.0,
                    100.0,
                    22.0
                  ],
                  "text": "*~",
                  "numinlets": 2,
                  "numoutlets": 1
                }
              },
              {
                "box": {
                  "id": "out0",
                  "maxclass": "outlet",
                  "patching_rect": [
                    100,
                    440,
                    30,
                    30
                  ],
                  "index": 1
                }
              },
              {
                "box": {
                  "id": "pack1",
                  "maxclass": "newobj",
                  "patching_rect": [
                    0.0,
                    200.0,
                    100.0,
                    22.0
                  ],
                  "text": "pack 0. 1000.",
                  "numinlets": 2,
                  "numoutlets": 1
                }
              },
              {
                "box": {
                  "id": "panline1",
                  "maxclass": "newobj",
                  "patching_rect": [
                    0.0,
                    200.0,
                    100.0,
                    22.0
                  ],
                  "text": "line~ 1.",
                  "numinlets": 2,
                  "numoutlets": 2
                }
              },
              {
                "box": {
                  "id": "amp1",
                  "maxclass": "newobj",
                  "patching_rect": [
                    0.0,
                    200.0,
                    100.0,
                    22.0
                  ],
                  "text": "*~",
                  "numinlets": 2,
                  "numoutlets": 1
                }
              },
              {
                "box": {
                  "id": "panned1",
                  "maxclass": "newobj",
                  "patching_rect": [
                    0.0,
                    200.0,
                    100.0,
                    22.0
                  ],
                  "text": "*~",
                  "numinlets": 2,
                  "numoutlets": 1
                }
              },
              {
                "box": {
                  "id": "out1",
                  "maxclass": "outlet",
                  "patching_rect": [
                    250,
                    440,
                    30,
                    30
                  ],
                  "index": 2
                }
              },
              {
                "box": {
                  "id": "set-buffer",
                  "maxclass": "newobj",
                  "patching_rect": [
                    0.0,
                    200.0,
                    100.0,
                    22.0
                  ],
                  "text": "prepend set",
                  "numinlets": 1,
                  "numoutlets": 1
                }
              },
              {
                "box": {
                  "id": "right-select",
                  "maxclass": "newobj",
                  "patching_rect": [
                    0.0,
                    200.0,
                    100.0,
                    22.0
                  ],
                  "text": "selector~ 2 1",
                  "numinlets": 3,
                  "numoutlets": 1
                }
              },
              {
                "box": {
                  "id": "phase-out",
                  "maxclass": "outlet",
                  "patching_rect": [
                    650,
                    440,
                    30,
                    30
                  ],
                  "index": 4
                }
              },
              {
                "box": {
                  "id": "direction-in",
                  "maxclass": "inlet",
                  "patching_rect": [
                    1460,
                    20,
                    30,
                    30
                  ],
                  "index": 12
                }
              },
              {
                "box": {
                  "id": "signed-rate",
                  "maxclass": "newobj",
                  "patching_rect": [
                    0.0,
                    200.0,
                    100.0,
                    22.0
                  ],
                  "text": "*~ 1.",
                  "numinlets": 2,
                  "numoutlets": 1
                }
              }
            ],
            "lines": [
              {
                "patchline": {
                  "source": [
                    "in1",
                    0
                  ],
                  "destination": [
                    "bounds",
                    0
                  ]
                }
              },
              {
                "patchline": {
                  "source": [
                    "bounds",
                    0
                  ],
                  "destination": [
                    "groove",
                    1
                  ]
                }
              },
              {
                "patchline": {
                  "source": [
                    "bounds",
                    1
                  ],
                  "destination": [
                    "groove",
                    2
                  ]
                }
              },
              {
                "patchline": {
                  "source": [
                    "in8",
                    0
                  ],
                  "destination": [
                    "trim",
                    0
                  ]
                }
              },
              {
                "patchline": {
                  "source": [
                    "in2",
                    0
                  ],
                  "destination": [
                    "level",
                    0
                  ]
                }
              },
              {
                "patchline": {
                  "source": [
                    "level",
                    0
                  ],
                  "destination": [
                    "effective-level",
                    0
                  ]
                }
              },
              {
                "patchline": {
                  "source": [
                    "trim",
                    0
                  ],
                  "destination": [
                    "effective-level",
                    1
                  ]
                }
              },
              {
                "patchline": {
                  "source": [
                    "in9",
                    0
                  ],
                  "destination": [
                    "boundary-fade",
                    0
                  ]
                }
              },
              {
                "patchline": {
                  "source": [
                    "boundary-fade",
                    1
                  ],
                  "destination": [
                    "fade-done",
                    0
                  ]
                }
              },
              {
                "patchline": {
                  "source": [
                    "in10",
                    0
                  ],
                  "destination": [
                    "edge-scale",
                    0
                  ]
                }
              },
              {
                "patchline": {
                  "source": [
                    "groove",
                    2
                  ],
                  "destination": [
                    "phase-neg",
                    0
                  ]
                }
              },
              {
                "patchline": {
                  "source": [
                    "phase-neg",
                    0
                  ],
                  "destination": [
                    "phase-back",
                    0
                  ]
                }
              },
              {
                "patchline": {
                  "source": [
                    "groove",
                    2
                  ],
                  "destination": [
                    "risescale",
                    0
                  ]
                }
              },
              {
                "patchline": {
                  "source": [
                    "edge-scale",
                    0
                  ],
                  "destination": [
                    "risescale",
                    1
                  ]
                }
              },
              {
                "patchline": {
                  "source": [
                    "risescale",
                    0
                  ],
                  "destination": [
                    "rise",
                    0
                  ]
                }
              },
              {
                "patchline": {
                  "source": [
                    "phase-back",
                    0
                  ],
                  "destination": [
                    "fallscale",
                    0
                  ]
                }
              },
              {
                "patchline": {
                  "source": [
                    "edge-scale",
                    0
                  ],
                  "destination": [
                    "fallscale",
                    1
                  ]
                }
              },
              {
                "patchline": {
                  "source": [
                    "fallscale",
                    0
                  ],
                  "destination": [
                    "fall",
                    0
                  ]
                }
              },
              {
                "patchline": {
                  "source": [
                    "rise",
                    0
                  ],
                  "destination": [
                    "edge-envelope",
                    0
                  ]
                }
              },
              {
                "patchline": {
                  "source": [
                    "fall",
                    0
                  ],
                  "destination": [
                    "edge-envelope",
                    1
                  ]
                }
              },
              {
                "patchline": {
                  "source": [
                    "effective-level",
                    0
                  ],
                  "destination": [
                    "safe-level",
                    0
                  ]
                }
              },
              {
                "patchline": {
                  "source": [
                    "edge-envelope",
                    0
                  ],
                  "destination": [
                    "safe-level",
                    1
                  ]
                }
              },
              {
                "patchline": {
                  "source": [
                    "safe-level",
                    0
                  ],
                  "destination": [
                    "safe-transition",
                    0
                  ]
                }
              },
              {
                "patchline": {
                  "source": [
                    "boundary-fade",
                    0
                  ],
                  "destination": [
                    "safe-transition",
                    1
                  ]
                }
              },
              {
                "patchline": {
                  "source": [
                    "in3",
                    0
                  ],
                  "destination": [
                    "pan",
                    0
                  ]
                }
              },
              {
                "patchline": {
                  "source": [
                    "pan",
                    0
                  ],
                  "destination": [
                    "pack0",
                    0
                  ]
                }
              },
              {
                "patchline": {
                  "source": [
                    "pan",
                    2
                  ],
                  "destination": [
                    "pack0",
                    1
                  ]
                }
              },
              {
                "patchline": {
                  "source": [
                    "pack0",
                    0
                  ],
                  "destination": [
                    "panline0",
                    0
                  ]
                }
              },
              {
                "patchline": {
                  "source": [
                    "groove",
                    0
                  ],
                  "destination": [
                    "amp0",
                    0
                  ]
                }
              },
              {
                "patchline": {
                  "source": [
                    "safe-transition",
                    0
                  ],
                  "destination": [
                    "amp0",
                    1
                  ]
                }
              },
              {
                "patchline": {
                  "source": [
                    "amp0",
                    0
                  ],
                  "destination": [
                    "panned0",
                    0
                  ]
                }
              },
              {
                "patchline": {
                  "source": [
                    "panline0",
                    0
                  ],
                  "destination": [
                    "panned0",
                    1
                  ]
                }
              },
              {
                "patchline": {
                  "source": [
                    "panned0",
                    0
                  ],
                  "destination": [
                    "out0",
                    0
                  ]
                }
              },
              {
                "patchline": {
                  "source": [
                    "pan",
                    1
                  ],
                  "destination": [
                    "pack1",
                    0
                  ]
                }
              },
              {
                "patchline": {
                  "source": [
                    "pan",
                    2
                  ],
                  "destination": [
                    "pack1",
                    1
                  ]
                }
              },
              {
                "patchline": {
                  "source": [
                    "pack1",
                    0
                  ],
                  "destination": [
                    "panline1",
                    0
                  ]
                }
              },
              {
                "patchline": {
                  "source": [
                    "safe-transition",
                    0
                  ],
                  "destination": [
                    "amp1",
                    1
                  ]
                }
              },
              {
                "patchline": {
                  "source": [
                    "amp1",
                    0
                  ],
                  "destination": [
                    "panned1",
                    0
                  ]
                }
              },
              {
                "patchline": {
                  "source": [
                    "panline1",
                    0
                  ],
                  "destination": [
                    "panned1",
                    1
                  ]
                }
              },
              {
                "patchline": {
                  "source": [
                    "panned1",
                    0
                  ],
                  "destination": [
                    "out1",
                    0
                  ]
                }
              },
              {
                "patchline": {
                  "source": [
                    "in4",
                    0
                  ],
                  "destination": [
                    "groove",
                    0
                  ]
                }
              },
              {
                "patchline": {
                  "source": [
                    "in6",
                    0
                  ],
                  "destination": [
                    "set-buffer",
                    0
                  ]
                }
              },
              {
                "patchline": {
                  "source": [
                    "set-buffer",
                    0
                  ],
                  "destination": [
                    "groove",
                    0
                  ]
                }
              },
              {
                "patchline": {
                  "source": [
                    "in7",
                    0
                  ],
                  "destination": [
                    "groove",
                    0
                  ]
                }
              },
              {
                "patchline": {
                  "source": [
                    "in5",
                    0
                  ],
                  "destination": [
                    "right-select",
                    0
                  ]
                }
              },
              {
                "patchline": {
                  "source": [
                    "groove",
                    0
                  ],
                  "destination": [
                    "right-select",
                    1
                  ]
                }
              },
              {
                "patchline": {
                  "source": [
                    "groove",
                    1
                  ],
                  "destination": [
                    "right-select",
                    2
                  ]
                }
              },
              {
                "patchline": {
                  "source": [
                    "right-select",
                    0
                  ],
                  "destination": [
                    "amp1",
                    0
                  ]
                }
              },
              {
                "patchline": {
                  "source": [
                    "groove",
                    2
                  ],
                  "destination": [
                    "phase-out",
                    0
                  ]
                }
              },
              {
                "patchline": {
                  "source": [
                    "in0",
                    0
                  ],
                  "destination": [
                    "signed-rate",
                    0
                  ]
                }
              },
              {
                "patchline": {
                  "source": [
                    "direction-in",
                    0
                  ],
                  "destination": [
                    "signed-rate",
                    1
                  ]
                }
              },
              {
                "patchline": {
                  "source": [
                    "signed-rate",
                    0
                  ],
                  "destination": [
                    "groove",
                    0
                  ]
                }
              }
            ]
          },
          "outlettype": [
            "signal",
            "signal",
            "bang",
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "ended1",
          "maxclass": "message",
          "patching_rect": [
            0.0,
            200.0,
            100.0,
            22.0
          ],
          "text": "ended 1",
          "numinlets": 2,
          "numoutlets": 1
        }
      },
      {
        "box": {
          "id": "snapshot1",
          "maxclass": "newobj",
          "patching_rect": [
            0.0,
            200.0,
            100.0,
            22.0
          ],
          "text": "snapshot~ 10",
          "numinlets": 2,
          "numoutlets": 1
        }
      },
      {
        "box": {
          "id": "position1",
          "maxclass": "newobj",
          "patching_rect": [
            0.0,
            200.0,
            100.0,
            22.0
          ],
          "text": "prepend position 1",
          "numinlets": 1,
          "numoutlets": 1
        }
      },
      {
        "box": {
          "id": "loadgate",
          "maxclass": "newobj",
          "patching_rect": [
            0.0,
            200.0,
            100.0,
            22.0
          ],
          "text": "line~ 0.",
          "numinlets": 2,
          "numoutlets": 2
        }
      },
      {
        "box": {
          "id": "gatedone",
          "maxclass": "message",
          "patching_rect": [
            0.0,
            200.0,
            100.0,
            22.0
          ],
          "text": "gateended",
          "numinlets": 2,
          "numoutlets": 1
        }
      },
      {
        "box": {
          "id": "gatevalue",
          "maxclass": "newobj",
          "patching_rect": [
            0.0,
            200.0,
            100.0,
            22.0
          ],
          "text": "snapshot~",
          "numinlets": 2,
          "numoutlets": 1
        }
      },
      {
        "box": {
          "id": "gatezero",
          "maxclass": "newobj",
          "patching_rect": [
            0.0,
            200.0,
            100.0,
            22.0
          ],
          "text": "if $f1 <= 0.000001 then bang",
          "numinlets": 1,
          "numoutlets": 1
        }
      },
      {
        "box": {
          "id": "master",
          "maxclass": "newobj",
          "patching_rect": [
            0.0,
            200.0,
            100.0,
            22.0
          ],
          "text": "line~ 0.",
          "numinlets": 2,
          "numoutlets": 2
        }
      },
      {
        "box": {
          "id": "envmessage",
          "maxclass": "message",
          "patching_rect": [
            0.0,
            200.0,
            100.0,
            22.0
          ],
          "text": "$1, $2 $3",
          "numinlets": 2,
          "numoutlets": 1
        }
      },
      {
        "box": {
          "id": "envline",
          "maxclass": "newobj",
          "patching_rect": [
            0.0,
            200.0,
            100.0,
            22.0
          ],
          "text": "line~ 1.",
          "numinlets": 2,
          "numoutlets": 2
        }
      },
      {
        "box": {
          "id": "stepenv",
          "maxclass": "newobj",
          "patching_rect": [
            0.0,
            200.0,
            100.0,
            22.0
          ],
          "text": "rampsmooth~ 64 64",
          "numinlets": 3,
          "numoutlets": 1
        }
      },
      {
        "box": {
          "id": "output",
          "maxclass": "newobj",
          "patching_rect": [
            0.0,
            200.0,
            100.0,
            22.0
          ],
          "text": "plugout~",
          "numinlets": 2,
          "numoutlets": 0
        }
      },
      {
        "box": {
          "id": "sum0",
          "maxclass": "newobj",
          "patching_rect": [
            0.0,
            200.0,
            100.0,
            22.0
          ],
          "text": "+~",
          "numinlets": 2,
          "numoutlets": 1
        }
      },
      {
        "box": {
          "id": "amp0master",
          "maxclass": "newobj",
          "patching_rect": [
            0.0,
            200.0,
            100.0,
            22.0
          ],
          "text": "*~",
          "numinlets": 2,
          "numoutlets": 1
        }
      },
      {
        "box": {
          "id": "amp0loadgate",
          "maxclass": "newobj",
          "patching_rect": [
            0.0,
            200.0,
            100.0,
            22.0
          ],
          "text": "*~",
          "numinlets": 2,
          "numoutlets": 1
        }
      },
      {
        "box": {
          "id": "amp0stepenv",
          "maxclass": "newobj",
          "patching_rect": [
            0.0,
            200.0,
            100.0,
            22.0
          ],
          "text": "*~",
          "numinlets": 2,
          "numoutlets": 1
        }
      },
      {
        "box": {
          "id": "sum1",
          "maxclass": "newobj",
          "patching_rect": [
            0.0,
            200.0,
            100.0,
            22.0
          ],
          "text": "+~",
          "numinlets": 2,
          "numoutlets": 1
        }
      },
      {
        "box": {
          "id": "amp1master",
          "maxclass": "newobj",
          "patching_rect": [
            0.0,
            200.0,
            100.0,
            22.0
          ],
          "text": "*~",
          "numinlets": 2,
          "numoutlets": 1
        }
      },
      {
        "box": {
          "id": "amp1loadgate",
          "maxclass": "newobj",
          "patching_rect": [
            0.0,
            200.0,
            100.0,
            22.0
          ],
          "text": "*~",
          "numinlets": 2,
          "numoutlets": 1
        }
      },
      {
        "box": {
          "id": "amp1stepenv",
          "maxclass": "newobj",
          "patching_rect": [
            0.0,
            200.0,
            100.0,
            22.0
          ],
          "text": "*~",
          "numinlets": 2,
          "numoutlets": 1
        }
      }
    ],
    "lines": [
      {
        "patchline": {
          "source": [
            "defer",
            0
          ],
          "destination": [
            "engine",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "engine",
            1
          ],
          "destination": [
            "display",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "enable",
            0
          ],
          "destination": [
            "enablecmd",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "enablecmd",
            0
          ],
          "destination": [
            "defer",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "freeplay",
            0
          ],
          "destination": [
            "freeplaycmd",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "freeplaycmd",
            0
          ],
          "destination": [
            "defer",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "reload",
            0
          ],
          "destination": [
            "reloadcmd",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "reloadcmd",
            0
          ],
          "destination": [
            "defer",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "reset",
            0
          ],
          "destination": [
            "resetcmd",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "resetcmd",
            0
          ],
          "destination": [
            "defer",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "randomize",
            0
          ],
          "destination": [
            "randomizecmd",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "randomizecmd",
            0
          ],
          "destination": [
            "defer",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "preset-menu",
            0
          ],
          "destination": [
            "preset-menucmd",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "preset-menucmd",
            0
          ],
          "destination": [
            "defer",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "preset-load",
            0
          ],
          "destination": [
            "preset-load-cmd",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "preset-load-cmd",
            0
          ],
          "destination": [
            "defer",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "rateslope",
            0
          ],
          "destination": [
            "rateslopecmd",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "rateslopecmd",
            0
          ],
          "destination": [
            "defer",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "slope-minus",
            0
          ],
          "destination": [
            "slope-minuscmd",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "slope-minuscmd",
            0
          ],
          "destination": [
            "defer",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "slope-plus",
            0
          ],
          "destination": [
            "slope-pluscmd",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "slope-pluscmd",
            0
          ],
          "destination": [
            "defer",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "step0",
            0
          ],
          "destination": [
            "step0cmd",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "step0cmd",
            0
          ],
          "destination": [
            "defer",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "step1",
            0
          ],
          "destination": [
            "step1cmd",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "step1cmd",
            0
          ],
          "destination": [
            "defer",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "step2",
            0
          ],
          "destination": [
            "step2cmd",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "step2cmd",
            0
          ],
          "destination": [
            "defer",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "step3",
            0
          ],
          "destination": [
            "step3cmd",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "step3cmd",
            0
          ],
          "destination": [
            "defer",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "step4",
            0
          ],
          "destination": [
            "step4cmd",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "step4cmd",
            0
          ],
          "destination": [
            "defer",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "step5",
            0
          ],
          "destination": [
            "step5cmd",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "step5cmd",
            0
          ],
          "destination": [
            "defer",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "step6",
            0
          ],
          "destination": [
            "step6cmd",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "step6cmd",
            0
          ],
          "destination": [
            "defer",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "step7",
            0
          ],
          "destination": [
            "step7cmd",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "step7cmd",
            0
          ],
          "destination": [
            "defer",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "step8",
            0
          ],
          "destination": [
            "step8cmd",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "step8cmd",
            0
          ],
          "destination": [
            "defer",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "step9",
            0
          ],
          "destination": [
            "step9cmd",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "step9cmd",
            0
          ],
          "destination": [
            "defer",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "step10",
            0
          ],
          "destination": [
            "step10cmd",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "step10cmd",
            0
          ],
          "destination": [
            "defer",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "step11",
            0
          ],
          "destination": [
            "step11cmd",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "step11cmd",
            0
          ],
          "destination": [
            "defer",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "step12",
            0
          ],
          "destination": [
            "step12cmd",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "step12cmd",
            0
          ],
          "destination": [
            "defer",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "step13",
            0
          ],
          "destination": [
            "step13cmd",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "step13cmd",
            0
          ],
          "destination": [
            "defer",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "step14",
            0
          ],
          "destination": [
            "step14cmd",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "step14cmd",
            0
          ],
          "destination": [
            "defer",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "step15",
            0
          ],
          "destination": [
            "step15cmd",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "step15cmd",
            0
          ],
          "destination": [
            "defer",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "regionstart",
            0
          ],
          "destination": [
            "regionstartcmd",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "regionstartcmd",
            0
          ],
          "destination": [
            "defer",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "regionend",
            0
          ],
          "destination": [
            "regionendcmd",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "regionendcmd",
            0
          ],
          "destination": [
            "defer",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "smoothing",
            0
          ],
          "destination": [
            "smoothingcmd",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "smoothingcmd",
            0
          ],
          "destination": [
            "defer",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "volume",
            0
          ],
          "destination": [
            "volumecmd",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "volumecmd",
            0
          ],
          "destination": [
            "defer",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "steps",
            0
          ],
          "destination": [
            "stepscmd",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "stepscmd",
            0
          ],
          "destination": [
            "defer",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "division",
            0
          ],
          "destination": [
            "divisioncmd",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "divisioncmd",
            0
          ],
          "destination": [
            "defer",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "seed",
            0
          ],
          "destination": [
            "seedcmd",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "seedcmd",
            0
          ],
          "destination": [
            "defer",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "holdpercent",
            0
          ],
          "destination": [
            "holdpercentcmd",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "holdpercentcmd",
            0
          ],
          "destination": [
            "defer",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "pool1",
            0
          ],
          "destination": [
            "pool1cmd",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "pool1cmd",
            0
          ],
          "destination": [
            "defer",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "pool2",
            0
          ],
          "destination": [
            "pool2cmd",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "pool2cmd",
            0
          ],
          "destination": [
            "defer",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "pool3",
            0
          ],
          "destination": [
            "pool3cmd",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "pool3cmd",
            0
          ],
          "destination": [
            "defer",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "pool4",
            0
          ],
          "destination": [
            "pool4cmd",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "pool4cmd",
            0
          ],
          "destination": [
            "defer",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "pool5",
            0
          ],
          "destination": [
            "pool5cmd",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "pool5cmd",
            0
          ],
          "destination": [
            "defer",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "pool6",
            0
          ],
          "destination": [
            "pool6cmd",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "pool6cmd",
            0
          ],
          "destination": [
            "defer",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "pool7",
            0
          ],
          "destination": [
            "pool7cmd",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "pool7cmd",
            0
          ],
          "destination": [
            "defer",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "pool8",
            0
          ],
          "destination": [
            "pool8cmd",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "pool8cmd",
            0
          ],
          "destination": [
            "defer",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "pool9",
            0
          ],
          "destination": [
            "pool9cmd",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "pool9cmd",
            0
          ],
          "destination": [
            "defer",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "pool10",
            0
          ],
          "destination": [
            "pool10cmd",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "pool10cmd",
            0
          ],
          "destination": [
            "defer",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "pool11",
            0
          ],
          "destination": [
            "pool11cmd",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "pool11cmd",
            0
          ],
          "destination": [
            "defer",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "pool12",
            0
          ],
          "destination": [
            "pool12cmd",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "pool12cmd",
            0
          ],
          "destination": [
            "defer",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "pool13",
            0
          ],
          "destination": [
            "pool13cmd",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "pool13cmd",
            0
          ],
          "destination": [
            "defer",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "ready",
            0
          ],
          "destination": [
            "init",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "init",
            0
          ],
          "destination": [
            "defer",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "ready",
            1
          ],
          "destination": [
            "active",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "active",
            0
          ],
          "destination": [
            "defer",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "engine",
            0
          ],
          "destination": [
            "route",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "route",
            1
          ],
          "destination": [
            "replace",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "replace",
            0
          ],
          "destination": [
            "buffer",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "route",
            13
          ],
          "destination": [
            "clearbuffer",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "clearbuffer",
            0
          ],
          "destination": [
            "buffer",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "buffer",
            1
          ],
          "destination": [
            "loaded",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "loaded",
            0
          ],
          "destination": [
            "defer",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "route",
            4
          ],
          "destination": [
            "boundsroute",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "route",
            5
          ],
          "destination": [
            "edgeroute",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "route",
            7
          ],
          "destination": [
            "seekroute",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "route",
            8
          ],
          "destination": [
            "faderoute",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "route",
            12
          ],
          "destination": [
            "startroute",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "route",
            14
          ],
          "destination": [
            "directionroute",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "route",
            6
          ],
          "destination": [
            "rate-glide",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "rate-glide",
            0
          ],
          "destination": [
            "rate-meter",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "rate-meter",
            0
          ],
          "destination": [
            "rate-meter-cmd",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "rate-meter-cmd",
            0
          ],
          "destination": [
            "defer",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "boundsroute",
            0
          ],
          "destination": [
            "head0",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "seekroute",
            0
          ],
          "destination": [
            "head0",
            4
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "faderoute",
            0
          ],
          "destination": [
            "head0",
            9
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "edgeroute",
            0
          ],
          "destination": [
            "head0",
            10
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "startroute",
            0
          ],
          "destination": [
            "head0",
            7
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "directionroute",
            0
          ],
          "destination": [
            "head0",
            11
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "rate-glide",
            0
          ],
          "destination": [
            "head0",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "route",
            2
          ],
          "destination": [
            "head0",
            6
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "route",
            3
          ],
          "destination": [
            "head0",
            5
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "head0",
            2
          ],
          "destination": [
            "ended0",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "ended0",
            0
          ],
          "destination": [
            "defer",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "head0",
            3
          ],
          "destination": [
            "snapshot0",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "snapshot0",
            0
          ],
          "destination": [
            "position0",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "position0",
            0
          ],
          "destination": [
            "defer",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "boundsroute",
            1
          ],
          "destination": [
            "head1",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "seekroute",
            1
          ],
          "destination": [
            "head1",
            4
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "faderoute",
            1
          ],
          "destination": [
            "head1",
            9
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "edgeroute",
            1
          ],
          "destination": [
            "head1",
            10
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "startroute",
            1
          ],
          "destination": [
            "head1",
            7
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "directionroute",
            1
          ],
          "destination": [
            "head1",
            11
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "rate-glide",
            0
          ],
          "destination": [
            "head1",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "route",
            2
          ],
          "destination": [
            "head1",
            6
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "route",
            3
          ],
          "destination": [
            "head1",
            5
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "head1",
            2
          ],
          "destination": [
            "ended1",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "ended1",
            0
          ],
          "destination": [
            "defer",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "head1",
            3
          ],
          "destination": [
            "snapshot1",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "snapshot1",
            0
          ],
          "destination": [
            "position1",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "position1",
            0
          ],
          "destination": [
            "defer",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "route",
            9
          ],
          "destination": [
            "loadgate",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "loadgate",
            0
          ],
          "destination": [
            "gatevalue",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "loadgate",
            1
          ],
          "destination": [
            "gatevalue",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "gatevalue",
            0
          ],
          "destination": [
            "gatezero",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "gatezero",
            0
          ],
          "destination": [
            "gatedone",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "gatedone",
            0
          ],
          "destination": [
            "defer",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "route",
            10
          ],
          "destination": [
            "master",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "route",
            11
          ],
          "destination": [
            "envmessage",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "envmessage",
            0
          ],
          "destination": [
            "envline",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "envline",
            0
          ],
          "destination": [
            "stepenv",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "head0",
            0
          ],
          "destination": [
            "sum0",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "head1",
            0
          ],
          "destination": [
            "sum0",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "sum0",
            0
          ],
          "destination": [
            "amp0master",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "master",
            0
          ],
          "destination": [
            "amp0master",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "amp0master",
            0
          ],
          "destination": [
            "amp0loadgate",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "loadgate",
            0
          ],
          "destination": [
            "amp0loadgate",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "amp0loadgate",
            0
          ],
          "destination": [
            "amp0stepenv",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "stepenv",
            0
          ],
          "destination": [
            "amp0stepenv",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "amp0stepenv",
            0
          ],
          "destination": [
            "output",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "head0",
            1
          ],
          "destination": [
            "sum1",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "head1",
            1
          ],
          "destination": [
            "sum1",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "sum1",
            0
          ],
          "destination": [
            "amp1master",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "master",
            0
          ],
          "destination": [
            "amp1master",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "amp1master",
            0
          ],
          "destination": [
            "amp1loadgate",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "loadgate",
            0
          ],
          "destination": [
            "amp1loadgate",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "amp1loadgate",
            0
          ],
          "destination": [
            "amp1stepenv",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "stepenv",
            0
          ],
          "destination": [
            "amp1stepenv",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "amp1stepenv",
            0
          ],
          "destination": [
            "output",
            1
          ]
        }
      }
    ],
    "devicewidth": 1430.0,
    "openrect": [
      0.0,
      0.0,
      1430.0,
      169.0
    ],
    "project": {
      "version": 1,
      "amxdtype": 1633771873,
      "hideprojectwindow": 1,
      "contents": {
        "patchers": {}
      },
      "searchpath": {},
      "autolocalize": 0
    },
    "description": "StepCompass sample command sequencer. Independent sample-only device.",
    "digest": "StepCompass M4L v0.1.11",
    "autosave": 0,
    "parameters": {
      "enable": [
        "ON",
        "ON",
        0
      ],
      "freeplay": [
        "FREE PLAY",
        "FREE PLAY",
        0
      ],
      "step0": [
        "Step 1",
        "Step 1",
        0
      ],
      "step1": [
        "Step 2",
        "Step 2",
        0
      ],
      "step2": [
        "Step 3",
        "Step 3",
        0
      ],
      "step3": [
        "Step 4",
        "Step 4",
        0
      ],
      "step4": [
        "Step 5",
        "Step 5",
        0
      ],
      "step5": [
        "Step 6",
        "Step 6",
        0
      ],
      "step6": [
        "Step 7",
        "Step 7",
        0
      ],
      "step7": [
        "Step 8",
        "Step 8",
        0
      ],
      "step8": [
        "Step 9",
        "Step 9",
        0
      ],
      "step9": [
        "Step 10",
        "Step 10",
        0
      ],
      "step10": [
        "Step 11",
        "Step 11",
        0
      ],
      "step11": [
        "Step 12",
        "Step 12",
        0
      ],
      "step12": [
        "Step 13",
        "Step 13",
        0
      ],
      "step13": [
        "Step 14",
        "Step 14",
        0
      ],
      "step14": [
        "Step 15",
        "Step 15",
        0
      ],
      "step15": [
        "Step 16",
        "Step 16",
        0
      ],
      "regionstart": [
        "Start %",
        "Start %",
        0
      ],
      "regionend": [
        "End %",
        "End %",
        0
      ],
      "smoothing": [
        "Fade ms",
        "Fade ms",
        0
      ],
      "volume": [
        "Out dB",
        "Out dB",
        0
      ],
      "steps": [
        "Steps",
        "Steps",
        0
      ],
      "division": [
        "Clock 0-4",
        "Clock 0-4",
        0
      ],
      "seed": [
        "Seed",
        "Seed",
        0
      ],
      "holdpercent": [
        "Hold percent",
        "Hold percent",
        0
      ],
      "pool1": [
        "Weight Forward",
        "Weight Forward",
        0
      ],
      "pool2": [
        "Weight Reverse",
        "Weight Reverse",
        0
      ],
      "pool3": [
        "Weight Rate +",
        "Weight Rate +",
        0
      ],
      "pool4": [
        "Weight Rate -",
        "Weight Rate -",
        0
      ],
      "pool5": [
        "Weight Rate random",
        "Weight Rate random",
        0
      ],
      "pool6": [
        "Weight Loop start",
        "Weight Loop start",
        0
      ],
      "pool7": [
        "Weight Position",
        "Weight Position",
        0
      ],
      "pool8": [
        "Weight Loop random",
        "Weight Loop random",
        0
      ],
      "pool9": [
        "Weight Clock +",
        "Weight Clock +",
        0
      ],
      "pool10": [
        "Weight Clock -",
        "Weight Clock -",
        0
      ],
      "pool11": [
        "Weight Clock fastest",
        "Weight Clock fastest",
        0
      ],
      "pool12": [
        "Weight Clock slowest",
        "Weight Clock slowest",
        0
      ],
      "pool13": [
        "Weight Step random",
        "Weight Step random",
        0
      ],
      "data": [
        "CompassData",
        "CompassData",
        0
      ],
      "inherited_shortname": 1
    },
    "dependency_cache": [
      {
        "name": "compass.js",
        "type": "TEXT",
        "implicit": 1
      },
      {
        "name": "core.js",
        "type": "TEXT",
        "implicit": 1
      },
      {
        "name": "display.js",
        "type": "TEXT",
        "implicit": 1
      }
    ]
  }
}
