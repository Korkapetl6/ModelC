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
      1480.0,
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
            12.0,
            6.0,
            250.0,
            20.0
          ],
          "text": "BARCODE / SIMPLER",
          "numinlets": 1,
          "numoutlets": 0,
          "presentation": 1,
          "presentation_rect": [
            12.0,
            6.0,
            250.0,
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
          "id": "status",
          "maxclass": "comment",
          "patching_rect": [
            280.0,
            6.0,
            805.0,
            22.0
          ],
          "text": "Place directly after Simpler. Drop a sample in Simpler.",
          "numinlets": 1,
          "numoutlets": 0,
          "presentation": 1,
          "presentation_rect": [
            280.0,
            6.0,
            805.0,
            22.0
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
          "id": "display",
          "maxclass": "jsui",
          "patching_rect": [
            10.0,
            30.0,
            256.0,
            128.0
          ],
          "filename": "barcode-display.js",
          "numinlets": 1,
          "numoutlets": 0,
          "presentation": 1,
          "presentation_rect": [
            10.0,
            30.0,
            256.0,
            128.0
          ],
          "jsarguments": [],
          "parameter_enable": 0
        }
      },
      {
        "box": {
          "id": "engine",
          "maxclass": "newobj",
          "patching_rect": [
            20.0,
            240.0,
            230.0,
            22.0
          ],
          "text": "js barcode.js #0-barcode",
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
            280.0,
            36.0,
            110.0,
            23.0
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
            280.0,
            36.0,
            110.0,
            23.0
          ],
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "Barcode On",
              "parameter_shortname": "Barcode On",
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
          "id": "lfofreeze",
          "maxclass": "live.text",
          "patching_rect": [
            400.0,
            36.0,
            110.0,
            23.0
          ],
          "text": "LFO RUN",
          "varname": "lfofreeze",
          "numinlets": 1,
          "numoutlets": 2,
          "outlettype": [
            "",
            ""
          ],
          "parameter_enable": 1,
          "presentation": 1,
          "presentation_rect": [
            400.0,
            36.0,
            110.0,
            23.0
          ],
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "Freeze LFO",
              "parameter_shortname": "Freeze LFO",
              "parameter_type": 2,
              "parameter_mmin": 0,
              "parameter_mmax": 1,
              "parameter_initial": [
                0
              ],
              "parameter_initial_enable": 1,
              "parameter_unitstyle": 1,
              "parameter_enum": [
                "LFO RUN",
                "FROZEN"
              ]
            }
          },
          "texton": "FROZEN",
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
          "id": "lfofreezecmd",
          "maxclass": "newobj",
          "patching_rect": [
            0.0,
            200.0,
            100.0,
            22.0
          ],
          "text": "prepend lfofreeze",
          "numinlets": 1,
          "numoutlets": 1
        }
      },
      {
        "box": {
          "id": "allowreverse",
          "maxclass": "live.text",
          "patching_rect": [
            520.0,
            36.0,
            110.0,
            23.0
          ],
          "text": "FORWARD",
          "varname": "allowreverse",
          "numinlets": 1,
          "numoutlets": 2,
          "outlettype": [
            "",
            ""
          ],
          "parameter_enable": 1,
          "presentation": 1,
          "presentation_rect": [
            520.0,
            36.0,
            110.0,
            23.0
          ],
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "Reverse Allowed",
              "parameter_shortname": "Reverse Allowed",
              "parameter_type": 2,
              "parameter_mmin": 0,
              "parameter_mmax": 1,
              "parameter_initial": [
                1
              ],
              "parameter_initial_enable": 1,
              "parameter_unitstyle": 1,
              "parameter_enum": [
                "FORWARD",
                "REVERSE"
              ]
            }
          },
          "texton": "REVERSE",
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
          "id": "allowreversecmd",
          "maxclass": "newobj",
          "patching_rect": [
            0.0,
            200.0,
            100.0,
            22.0
          ],
          "text": "prepend allowreverse",
          "numinlets": 1,
          "numoutlets": 1
        }
      },
      {
        "box": {
          "id": "bpmsync",
          "maxclass": "live.text",
          "patching_rect": [
            640.0,
            36.0,
            110.0,
            23.0
          ],
          "text": "LFO SEC",
          "varname": "bpmsync",
          "numinlets": 1,
          "numoutlets": 2,
          "outlettype": [
            "",
            ""
          ],
          "parameter_enable": 1,
          "presentation": 1,
          "presentation_rect": [
            640.0,
            36.0,
            110.0,
            23.0
          ],
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "LFO Tempo Sync",
              "parameter_shortname": "LFO Tempo Sync",
              "parameter_type": 2,
              "parameter_mmin": 0,
              "parameter_mmax": 1,
              "parameter_initial": [
                0
              ],
              "parameter_initial_enable": 1,
              "parameter_unitstyle": 1,
              "parameter_enum": [
                "LFO SEC",
                "LFO BEATS"
              ]
            }
          },
          "texton": "LFO BEATS",
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
          "id": "bpmsynccmd",
          "maxclass": "newobj",
          "patching_rect": [
            0.0,
            200.0,
            100.0,
            22.0
          ],
          "text": "prepend bpmsync",
          "numinlets": 1,
          "numoutlets": 1
        }
      },
      {
        "box": {
          "id": "transport",
          "maxclass": "live.text",
          "patching_rect": [
            760.0,
            36.0,
            110.0,
            23.0
          ],
          "text": "FREE PLAY",
          "varname": "transport",
          "numinlets": 1,
          "numoutlets": 2,
          "outlettype": [
            "",
            ""
          ],
          "parameter_enable": 1,
          "presentation": 1,
          "presentation_rect": [
            760.0,
            36.0,
            110.0,
            23.0
          ],
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "Follow Transport",
              "parameter_shortname": "Follow Transport",
              "parameter_type": 2,
              "parameter_mmin": 0,
              "parameter_mmax": 1,
              "parameter_initial": [
                1
              ],
              "parameter_initial_enable": 1,
              "parameter_unitstyle": 1,
              "parameter_enum": [
                "FREE PLAY",
                "LIVE PLAY"
              ]
            }
          },
          "texton": "LIVE PLAY",
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
          "id": "transportcmd",
          "maxclass": "newobj",
          "patching_rect": [
            0.0,
            200.0,
            100.0,
            22.0
          ],
          "text": "prepend transport",
          "numinlets": 1,
          "numoutlets": 1
        }
      },
      {
        "box": {
          "id": "reload",
          "maxclass": "textbutton",
          "patching_rect": [
            890.0,
            36.0,
            90.0,
            23.0
          ],
          "text": "Reload",
          "varname": "reload",
          "presentation": 1,
          "presentation_rect": [
            890.0,
            36.0,
            90.0,
            23.0
          ],
          "mode": 0,
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
          "id": "resetvoices",
          "maxclass": "textbutton",
          "patching_rect": [
            988.0,
            36.0,
            90.0,
            23.0
          ],
          "text": "Reset voices",
          "varname": "resetvoices",
          "presentation": 1,
          "presentation_rect": [
            988.0,
            36.0,
            90.0,
            23.0
          ],
          "mode": 0,
          "numinlets": 1,
          "numoutlets": 3
        }
      },
      {
        "box": {
          "id": "resetvoicescmd",
          "maxclass": "message",
          "patching_rect": [
            0.0,
            200.0,
            100.0,
            22.0
          ],
          "text": "resetvoices",
          "numinlets": 2,
          "numoutlets": 1
        }
      },
      {
        "box": {
          "id": "voice-label",
          "maxclass": "comment",
          "patching_rect": [
            280.0,
            68.0,
            55.0,
            18.0
          ],
          "text": "VOICE",
          "numinlets": 1,
          "numoutlets": 0,
          "presentation": 1,
          "presentation_rect": [
            280.0,
            68.0,
            55.0,
            18.0
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
          "id": "voice",
          "maxclass": "number",
          "patching_rect": [
            335.0,
            68.0,
            45.0,
            22.0
          ],
          "varname": "voice",
          "minimum": 1,
          "maximum": 6,
          "numinlets": 1,
          "numoutlets": 2,
          "presentation": 1,
          "presentation_rect": [
            335.0,
            68.0,
            45.0,
            22.0
          ]
        }
      },
      {
        "box": {
          "id": "parameter",
          "maxclass": "umenu",
          "patching_rect": [
            395.0,
            68.0,
            135.0,
            22.0
          ],
          "varname": "parameter",
          "items": [
            "Level",
            ",",
            "Pan",
            ",",
            "Rate",
            ",",
            "Direction",
            ",",
            "Loop start",
            ",",
            "Loop end"
          ],
          "numinlets": 1,
          "numoutlets": 3,
          "presentation": 1,
          "presentation_rect": [
            395.0,
            68.0,
            135.0,
            22.0
          ]
        }
      },
      {
        "box": {
          "id": "edit-label",
          "maxclass": "comment",
          "patching_rect": [
            550.0,
            69.0,
            150.0,
            20.0
          ],
          "text": "Voice 1 / Level",
          "numinlets": 1,
          "numoutlets": 0,
          "presentation": 1,
          "presentation_rect": [
            550.0,
            69.0,
            150.0,
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
          "varname": "edit-label"
        }
      },
      {
        "box": {
          "id": "bias-label",
          "maxclass": "comment",
          "patching_rect": [
            710.0,
            70.0,
            35.0,
            18.0
          ],
          "text": "Bias",
          "numinlets": 1,
          "numoutlets": 0,
          "presentation": 1,
          "presentation_rect": [
            710.0,
            70.0,
            35.0,
            18.0
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
          "id": "period-label",
          "maxclass": "comment",
          "patching_rect": [
            835.0,
            70.0,
            135.0,
            18.0
          ],
          "text": "LFO period (0 = off)",
          "numinlets": 1,
          "numoutlets": 0,
          "presentation": 1,
          "presentation_rect": [
            835.0,
            70.0,
            135.0,
            18.0
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
          "id": "bias",
          "maxclass": "flonum",
          "patching_rect": [
            752.0,
            68.0,
            70.0,
            22.0
          ],
          "varname": "bias",
          "minimum": -2.0,
          "maximum": 2.0,
          "numinlets": 1,
          "numoutlets": 2,
          "presentation": 1,
          "presentation_rect": [
            752.0,
            68.0,
            70.0,
            22.0
          ]
        }
      },
      {
        "box": {
          "id": "period",
          "maxclass": "flonum",
          "patching_rect": [
            977.0,
            68.0,
            90.0,
            22.0
          ],
          "varname": "period",
          "minimum": 0.0,
          "maximum": 50.0,
          "numinlets": 1,
          "numoutlets": 2,
          "presentation": 1,
          "presentation_rect": [
            977.0,
            68.0,
            90.0,
            22.0
          ]
        }
      },
      {
        "box": {
          "id": "voicecmd",
          "maxclass": "newobj",
          "patching_rect": [
            0.0,
            200.0,
            100.0,
            22.0
          ],
          "text": "prepend voice",
          "numinlets": 1,
          "numoutlets": 1
        }
      },
      {
        "box": {
          "id": "parametercmd",
          "maxclass": "newobj",
          "patching_rect": [
            0.0,
            200.0,
            100.0,
            22.0
          ],
          "text": "prepend parameter",
          "numinlets": 1,
          "numoutlets": 1
        }
      },
      {
        "box": {
          "id": "biascmd",
          "maxclass": "newobj",
          "patching_rect": [
            0.0,
            200.0,
            100.0,
            22.0
          ],
          "text": "prepend bias",
          "numinlets": 1,
          "numoutlets": 1
        }
      },
      {
        "box": {
          "id": "periodcmd",
          "maxclass": "newobj",
          "patching_rect": [
            0.0,
            200.0,
            100.0,
            22.0
          ],
          "text": "prepend period",
          "numinlets": 1,
          "numoutlets": 1
        }
      },
      {
        "box": {
          "id": "volumelabel",
          "maxclass": "comment",
          "patching_rect": [
            280.0,
            103.0,
            125.0,
            18.0
          ],
          "text": "Output dB",
          "numinlets": 1,
          "numoutlets": 0,
          "presentation": 1,
          "presentation_rect": [
            280.0,
            103.0,
            125.0,
            18.0
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
            280.0,
            124.0,
            115.0,
            24.0
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
            280.0,
            124.0,
            115.0,
            24.0
          ],
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "Output dB",
              "parameter_shortname": "Output dB",
              "parameter_type": 0,
              "parameter_mmin": -60,
              "parameter_mmax": 12,
              "parameter_initial": [
                0
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
          "id": "filterfreqlabel",
          "maxclass": "comment",
          "patching_rect": [
            412.0,
            103.0,
            125.0,
            18.0
          ],
          "text": "Filter Hz",
          "numinlets": 1,
          "numoutlets": 0,
          "presentation": 1,
          "presentation_rect": [
            412.0,
            103.0,
            125.0,
            18.0
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
          "id": "filterfreq",
          "maxclass": "live.numbox",
          "patching_rect": [
            412.0,
            124.0,
            115.0,
            24.0
          ],
          "varname": "filterfreq",
          "numinlets": 1,
          "numoutlets": 2,
          "outlettype": [
            "",
            ""
          ],
          "parameter_enable": 1,
          "presentation": 1,
          "presentation_rect": [
            412.0,
            124.0,
            115.0,
            24.0
          ],
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "Filter Hz",
              "parameter_shortname": "Filter Hz",
              "parameter_type": 0,
              "parameter_mmin": 20,
              "parameter_mmax": 20000,
              "parameter_initial": [
                18000
              ],
              "parameter_initial_enable": 1,
              "parameter_unitstyle": 1
            }
          }
        }
      },
      {
        "box": {
          "id": "filterfreqcmd",
          "maxclass": "newobj",
          "patching_rect": [
            0.0,
            200.0,
            100.0,
            22.0
          ],
          "text": "prepend filterfreq",
          "numinlets": 1,
          "numoutlets": 1
        }
      },
      {
        "box": {
          "id": "filterreslabel",
          "maxclass": "comment",
          "patching_rect": [
            544.0,
            103.0,
            125.0,
            18.0
          ],
          "text": "Resonance",
          "numinlets": 1,
          "numoutlets": 0,
          "presentation": 1,
          "presentation_rect": [
            544.0,
            103.0,
            125.0,
            18.0
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
          "id": "filterres",
          "maxclass": "live.numbox",
          "patching_rect": [
            544.0,
            124.0,
            115.0,
            24.0
          ],
          "varname": "filterres",
          "numinlets": 1,
          "numoutlets": 2,
          "outlettype": [
            "",
            ""
          ],
          "parameter_enable": 1,
          "presentation": 1,
          "presentation_rect": [
            544.0,
            124.0,
            115.0,
            24.0
          ],
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "Resonance",
              "parameter_shortname": "Resonance",
              "parameter_type": 0,
              "parameter_mmin": 0,
              "parameter_mmax": 0.85,
              "parameter_initial": [
                0.2
              ],
              "parameter_initial_enable": 1,
              "parameter_unitstyle": 1
            }
          }
        }
      },
      {
        "box": {
          "id": "filterrescmd",
          "maxclass": "newobj",
          "patching_rect": [
            0.0,
            200.0,
            100.0,
            22.0
          ],
          "text": "prepend filterres",
          "numinlets": 1,
          "numoutlets": 1
        }
      },
      {
        "box": {
          "id": "rateslewlabel",
          "maxclass": "comment",
          "patching_rect": [
            676.0,
            103.0,
            125.0,
            18.0
          ],
          "text": "Rate slew s",
          "numinlets": 1,
          "numoutlets": 0,
          "presentation": 1,
          "presentation_rect": [
            676.0,
            103.0,
            125.0,
            18.0
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
          "id": "rateslew",
          "maxclass": "live.numbox",
          "patching_rect": [
            676.0,
            124.0,
            115.0,
            24.0
          ],
          "varname": "rateslew",
          "numinlets": 1,
          "numoutlets": 2,
          "outlettype": [
            "",
            ""
          ],
          "parameter_enable": 1,
          "presentation": 1,
          "presentation_rect": [
            676.0,
            124.0,
            115.0,
            24.0
          ],
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "Rate slew s",
              "parameter_shortname": "Rate slew s",
              "parameter_type": 0,
              "parameter_mmin": 0.01,
              "parameter_mmax": 30,
              "parameter_initial": [
                1
              ],
              "parameter_initial_enable": 1,
              "parameter_unitstyle": 1
            }
          }
        }
      },
      {
        "box": {
          "id": "rateslewcmd",
          "maxclass": "newobj",
          "patching_rect": [
            0.0,
            200.0,
            100.0,
            22.0
          ],
          "text": "prepend rateslew",
          "numinlets": 1,
          "numoutlets": 1
        }
      },
      {
        "box": {
          "id": "panslewlabel",
          "maxclass": "comment",
          "patching_rect": [
            808.0,
            103.0,
            125.0,
            18.0
          ],
          "text": "Pan slew s",
          "numinlets": 1,
          "numoutlets": 0,
          "presentation": 1,
          "presentation_rect": [
            808.0,
            103.0,
            125.0,
            18.0
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
          "id": "panslew",
          "maxclass": "live.numbox",
          "patching_rect": [
            808.0,
            124.0,
            115.0,
            24.0
          ],
          "varname": "panslew",
          "numinlets": 1,
          "numoutlets": 2,
          "outlettype": [
            "",
            ""
          ],
          "parameter_enable": 1,
          "presentation": 1,
          "presentation_rect": [
            808.0,
            124.0,
            115.0,
            24.0
          ],
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "Pan slew s",
              "parameter_shortname": "Pan slew s",
              "parameter_type": 0,
              "parameter_mmin": 0.01,
              "parameter_mmax": 30,
              "parameter_initial": [
                1
              ],
              "parameter_initial_enable": 1,
              "parameter_unitstyle": 1
            }
          }
        }
      },
      {
        "box": {
          "id": "panslewcmd",
          "maxclass": "newobj",
          "patching_rect": [
            0.0,
            200.0,
            100.0,
            22.0
          ],
          "text": "prepend panslew",
          "numinlets": 1,
          "numoutlets": 1
        }
      },
      {
        "box": {
          "id": "levelslewlabel",
          "maxclass": "comment",
          "patching_rect": [
            940.0,
            103.0,
            125.0,
            18.0
          ],
          "text": "Level slew s",
          "numinlets": 1,
          "numoutlets": 0,
          "presentation": 1,
          "presentation_rect": [
            940.0,
            103.0,
            125.0,
            18.0
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
          "id": "levelslew",
          "maxclass": "live.numbox",
          "patching_rect": [
            940.0,
            124.0,
            115.0,
            24.0
          ],
          "varname": "levelslew",
          "numinlets": 1,
          "numoutlets": 2,
          "outlettype": [
            "",
            ""
          ],
          "parameter_enable": 1,
          "presentation": 1,
          "presentation_rect": [
            940.0,
            124.0,
            115.0,
            24.0
          ],
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "Level slew s",
              "parameter_shortname": "Level slew s",
              "parameter_type": 0,
              "parameter_mmin": 0.01,
              "parameter_mmax": 30,
              "parameter_initial": [
                1
              ],
              "parameter_initial_enable": 1,
              "parameter_unitstyle": 1
            }
          }
        }
      },
      {
        "box": {
          "id": "levelslewcmd",
          "maxclass": "newobj",
          "patching_rect": [
            0.0,
            200.0,
            100.0,
            22.0
          ],
          "text": "prepend levelslew",
          "numinlets": 1,
          "numoutlets": 1
        }
      },
      {
        "box": {
          "id": "mixer-title",
          "maxclass": "comment",
          "patching_rect": [
            1110.0,
            12.0,
            350.0,
            20.0
          ],
          "text": "VOICE LEVELS",
          "numinlets": 1,
          "numoutlets": 0,
          "presentation": 1,
          "presentation_rect": [
            1110.0,
            12.0,
            350.0,
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
          "id": "mixer-hint",
          "maxclass": "comment",
          "patching_rect": [
            1110.0,
            135.0,
            360.0,
            20.0
          ],
          "text": "0% = mute  /  100% = original  /  200% = +6 dB",
          "numinlets": 1,
          "numoutlets": 0,
          "presentation": 1,
          "presentation_rect": [
            1110.0,
            135.0,
            360.0,
            20.0
          ],
          "textcolor": [
            0.91,
            0.93,
            0.94,
            1.0
          ],
          "fontname": "Arial",
          "fontsize": 10
        }
      },
      {
        "box": {
          "id": "gain0",
          "maxclass": "live.dial",
          "patching_rect": [
            1110.0,
            48.0,
            54.0,
            70.0
          ],
          "varname": "gain0",
          "numinlets": 1,
          "numoutlets": 2,
          "outlettype": [
            "",
            ""
          ],
          "parameter_enable": 1,
          "presentation": 1,
          "presentation_rect": [
            1110.0,
            48.0,
            54.0,
            70.0
          ],
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "Voice 1",
              "parameter_shortname": "Voice 1",
              "parameter_type": 0,
              "parameter_mmin": 0,
              "parameter_mmax": 200,
              "parameter_initial": [
                100
              ],
              "parameter_initial_enable": 1,
              "parameter_unitstyle": 5
            }
          }
        }
      },
      {
        "box": {
          "id": "gain0cmd",
          "maxclass": "newobj",
          "patching_rect": [
            0.0,
            200.0,
            100.0,
            22.0
          ],
          "text": "prepend voicegain 0",
          "numinlets": 1,
          "numoutlets": 1
        }
      },
      {
        "box": {
          "id": "gain1",
          "maxclass": "live.dial",
          "patching_rect": [
            1170.0,
            48.0,
            54.0,
            70.0
          ],
          "varname": "gain1",
          "numinlets": 1,
          "numoutlets": 2,
          "outlettype": [
            "",
            ""
          ],
          "parameter_enable": 1,
          "presentation": 1,
          "presentation_rect": [
            1170.0,
            48.0,
            54.0,
            70.0
          ],
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "Voice 2",
              "parameter_shortname": "Voice 2",
              "parameter_type": 0,
              "parameter_mmin": 0,
              "parameter_mmax": 200,
              "parameter_initial": [
                100
              ],
              "parameter_initial_enable": 1,
              "parameter_unitstyle": 5
            }
          }
        }
      },
      {
        "box": {
          "id": "gain1cmd",
          "maxclass": "newobj",
          "patching_rect": [
            0.0,
            200.0,
            100.0,
            22.0
          ],
          "text": "prepend voicegain 1",
          "numinlets": 1,
          "numoutlets": 1
        }
      },
      {
        "box": {
          "id": "gain2",
          "maxclass": "live.dial",
          "patching_rect": [
            1230.0,
            48.0,
            54.0,
            70.0
          ],
          "varname": "gain2",
          "numinlets": 1,
          "numoutlets": 2,
          "outlettype": [
            "",
            ""
          ],
          "parameter_enable": 1,
          "presentation": 1,
          "presentation_rect": [
            1230.0,
            48.0,
            54.0,
            70.0
          ],
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "Voice 3",
              "parameter_shortname": "Voice 3",
              "parameter_type": 0,
              "parameter_mmin": 0,
              "parameter_mmax": 200,
              "parameter_initial": [
                100
              ],
              "parameter_initial_enable": 1,
              "parameter_unitstyle": 5
            }
          }
        }
      },
      {
        "box": {
          "id": "gain2cmd",
          "maxclass": "newobj",
          "patching_rect": [
            0.0,
            200.0,
            100.0,
            22.0
          ],
          "text": "prepend voicegain 2",
          "numinlets": 1,
          "numoutlets": 1
        }
      },
      {
        "box": {
          "id": "gain3",
          "maxclass": "live.dial",
          "patching_rect": [
            1290.0,
            48.0,
            54.0,
            70.0
          ],
          "varname": "gain3",
          "numinlets": 1,
          "numoutlets": 2,
          "outlettype": [
            "",
            ""
          ],
          "parameter_enable": 1,
          "presentation": 1,
          "presentation_rect": [
            1290.0,
            48.0,
            54.0,
            70.0
          ],
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "Voice 4",
              "parameter_shortname": "Voice 4",
              "parameter_type": 0,
              "parameter_mmin": 0,
              "parameter_mmax": 200,
              "parameter_initial": [
                100
              ],
              "parameter_initial_enable": 1,
              "parameter_unitstyle": 5
            }
          }
        }
      },
      {
        "box": {
          "id": "gain3cmd",
          "maxclass": "newobj",
          "patching_rect": [
            0.0,
            200.0,
            100.0,
            22.0
          ],
          "text": "prepend voicegain 3",
          "numinlets": 1,
          "numoutlets": 1
        }
      },
      {
        "box": {
          "id": "gain4",
          "maxclass": "live.dial",
          "patching_rect": [
            1350.0,
            48.0,
            54.0,
            70.0
          ],
          "varname": "gain4",
          "numinlets": 1,
          "numoutlets": 2,
          "outlettype": [
            "",
            ""
          ],
          "parameter_enable": 1,
          "presentation": 1,
          "presentation_rect": [
            1350.0,
            48.0,
            54.0,
            70.0
          ],
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "Voice 5",
              "parameter_shortname": "Voice 5",
              "parameter_type": 0,
              "parameter_mmin": 0,
              "parameter_mmax": 200,
              "parameter_initial": [
                100
              ],
              "parameter_initial_enable": 1,
              "parameter_unitstyle": 5
            }
          }
        }
      },
      {
        "box": {
          "id": "gain4cmd",
          "maxclass": "newobj",
          "patching_rect": [
            0.0,
            200.0,
            100.0,
            22.0
          ],
          "text": "prepend voicegain 4",
          "numinlets": 1,
          "numoutlets": 1
        }
      },
      {
        "box": {
          "id": "gain5",
          "maxclass": "live.dial",
          "patching_rect": [
            1410.0,
            48.0,
            54.0,
            70.0
          ],
          "varname": "gain5",
          "numinlets": 1,
          "numoutlets": 2,
          "outlettype": [
            "",
            ""
          ],
          "parameter_enable": 1,
          "presentation": 1,
          "presentation_rect": [
            1410.0,
            48.0,
            54.0,
            70.0
          ],
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "Voice 6",
              "parameter_shortname": "Voice 6",
              "parameter_type": 0,
              "parameter_mmin": 0,
              "parameter_mmax": 200,
              "parameter_initial": [
                100
              ],
              "parameter_initial_enable": 1,
              "parameter_unitstyle": 5
            }
          }
        }
      },
      {
        "box": {
          "id": "gain5cmd",
          "maxclass": "newobj",
          "patching_rect": [
            0.0,
            200.0,
            100.0,
            22.0
          ],
          "text": "prepend voicegain 5",
          "numinlets": 1,
          "numoutlets": 1
        }
      },
      {
        "box": {
          "id": "diagnostic",
          "maxclass": "comment",
          "patching_rect": [
            280.0,
            151.0,
            800.0,
            16.0
          ],
          "text": "DSP: waiting for initialization",
          "numinlets": 1,
          "numoutlets": 0,
          "presentation": 1,
          "presentation_rect": [
            280.0,
            151.0,
            800.0,
            16.0
          ],
          "textcolor": [
            0.91,
            0.93,
            0.94,
            1.0
          ],
          "fontname": "Arial",
          "fontsize": 10,
          "varname": "diagnostic"
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
          "text": "pattr BarcodeData @bindto engine @parameter_enable 1",
          "varname": "BarcodeData",
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
              "parameter_longname": "BarcodeData",
              "parameter_shortname": "BarcodeData"
            }
          }
        }
      },
      {
        "box": {
          "id": "protocol",
          "maxclass": "newobj",
          "patching_rect": [
            0.0,
            200.0,
            100.0,
            22.0
          ],
          "text": "route load bounds rate level pan seek master dry filter channels bind start trim",
          "numinlets": 1,
          "numoutlets": 14
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
          "text": "buffer~ #0-barcode",
          "numinlets": 1,
          "numoutlets": 2,
          "outlettype": [
            "float",
            "bang"
          ]
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
          "text": "route 0 1 2 3 4 5",
          "numinlets": 1,
          "numoutlets": 7
        }
      },
      {
        "box": {
          "id": "rateroute",
          "maxclass": "newobj",
          "patching_rect": [
            0.0,
            200.0,
            100.0,
            22.0
          ],
          "text": "route 0 1 2 3 4 5",
          "numinlets": 1,
          "numoutlets": 7
        }
      },
      {
        "box": {
          "id": "levelroute",
          "maxclass": "newobj",
          "patching_rect": [
            0.0,
            200.0,
            100.0,
            22.0
          ],
          "text": "route 0 1 2 3 4 5",
          "numinlets": 1,
          "numoutlets": 7
        }
      },
      {
        "box": {
          "id": "panroute",
          "maxclass": "newobj",
          "patching_rect": [
            0.0,
            200.0,
            100.0,
            22.0
          ],
          "text": "route 0 1 2 3 4 5",
          "numinlets": 1,
          "numoutlets": 7
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
          "text": "route 0 1 2 3 4 5",
          "numinlets": 1,
          "numoutlets": 7
        }
      },
      {
        "box": {
          "id": "trim-route",
          "maxclass": "newobj",
          "patching_rect": [
            0.0,
            200.0,
            100.0,
            22.0
          ],
          "text": "route 0 1 2 3 4 5",
          "numinlets": 1,
          "numoutlets": 7
        }
      },
      {
        "box": {
          "id": "start-route",
          "maxclass": "newobj",
          "patching_rect": [
            0.0,
            200.0,
            100.0,
            22.0
          ],
          "text": "route 0 1 2 3 4 5",
          "numinlets": 1,
          "numoutlets": 7
        }
      },
      {
        "box": {
          "id": "voice0",
          "maxclass": "newobj",
          "patching_rect": [
            0.0,
            200.0,
            100.0,
            22.0
          ],
          "text": "p voice_1",
          "numinlets": 9,
          "numoutlets": 2,
          "outlettype": [
            "signal",
            "signal"
          ],
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
                  "id": "speed",
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
                  "id": "groove",
                  "maxclass": "newobj",
                  "patching_rect": [
                    0.0,
                    200.0,
                    100.0,
                    22.0
                  ],
                  "text": "groove~ #0-barcode 2 @loop 1 @loopinterp 1",
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
                  "text": "line~ 0.",
                  "numinlets": 2,
                  "numoutlets": 2
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
                  "text": "line~ 0.707",
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
                  "text": "line~ 0.707",
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
              }
            ],
            "lines": [
              {
                "patchline": {
                  "source": [
                    "in0",
                    0
                  ],
                  "destination": [
                    "speed",
                    0
                  ]
                }
              },
              {
                "patchline": {
                  "source": [
                    "speed",
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
                    "effective-level",
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
                    "effective-level",
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
              }
            ]
          }
        }
      },
      {
        "box": {
          "id": "voice1",
          "maxclass": "newobj",
          "patching_rect": [
            0.0,
            200.0,
            100.0,
            22.0
          ],
          "text": "p voice_2",
          "numinlets": 9,
          "numoutlets": 2,
          "outlettype": [
            "signal",
            "signal"
          ],
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
                  "id": "speed",
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
                  "id": "groove",
                  "maxclass": "newobj",
                  "patching_rect": [
                    0.0,
                    200.0,
                    100.0,
                    22.0
                  ],
                  "text": "groove~ #0-barcode 2 @loop 1 @loopinterp 1",
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
                  "text": "line~ 0.",
                  "numinlets": 2,
                  "numoutlets": 2
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
                  "text": "line~ 0.707",
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
                  "text": "line~ 0.707",
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
              }
            ],
            "lines": [
              {
                "patchline": {
                  "source": [
                    "in0",
                    0
                  ],
                  "destination": [
                    "speed",
                    0
                  ]
                }
              },
              {
                "patchline": {
                  "source": [
                    "speed",
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
                    "effective-level",
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
                    "effective-level",
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
              }
            ]
          }
        }
      },
      {
        "box": {
          "id": "voice2",
          "maxclass": "newobj",
          "patching_rect": [
            0.0,
            200.0,
            100.0,
            22.0
          ],
          "text": "p voice_3",
          "numinlets": 9,
          "numoutlets": 2,
          "outlettype": [
            "signal",
            "signal"
          ],
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
                  "id": "speed",
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
                  "id": "groove",
                  "maxclass": "newobj",
                  "patching_rect": [
                    0.0,
                    200.0,
                    100.0,
                    22.0
                  ],
                  "text": "groove~ #0-barcode 2 @loop 1 @loopinterp 1",
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
                  "text": "line~ 0.",
                  "numinlets": 2,
                  "numoutlets": 2
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
                  "text": "line~ 0.707",
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
                  "text": "line~ 0.707",
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
              }
            ],
            "lines": [
              {
                "patchline": {
                  "source": [
                    "in0",
                    0
                  ],
                  "destination": [
                    "speed",
                    0
                  ]
                }
              },
              {
                "patchline": {
                  "source": [
                    "speed",
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
                    "effective-level",
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
                    "effective-level",
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
              }
            ]
          }
        }
      },
      {
        "box": {
          "id": "voice3",
          "maxclass": "newobj",
          "patching_rect": [
            0.0,
            200.0,
            100.0,
            22.0
          ],
          "text": "p voice_4",
          "numinlets": 9,
          "numoutlets": 2,
          "outlettype": [
            "signal",
            "signal"
          ],
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
                  "id": "speed",
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
                  "id": "groove",
                  "maxclass": "newobj",
                  "patching_rect": [
                    0.0,
                    200.0,
                    100.0,
                    22.0
                  ],
                  "text": "groove~ #0-barcode 2 @loop 1 @loopinterp 1",
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
                  "text": "line~ 0.",
                  "numinlets": 2,
                  "numoutlets": 2
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
                  "text": "line~ 0.707",
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
                  "text": "line~ 0.707",
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
              }
            ],
            "lines": [
              {
                "patchline": {
                  "source": [
                    "in0",
                    0
                  ],
                  "destination": [
                    "speed",
                    0
                  ]
                }
              },
              {
                "patchline": {
                  "source": [
                    "speed",
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
                    "effective-level",
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
                    "effective-level",
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
              }
            ]
          }
        }
      },
      {
        "box": {
          "id": "voice4",
          "maxclass": "newobj",
          "patching_rect": [
            0.0,
            200.0,
            100.0,
            22.0
          ],
          "text": "p voice_5",
          "numinlets": 9,
          "numoutlets": 2,
          "outlettype": [
            "signal",
            "signal"
          ],
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
                  "id": "speed",
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
                  "id": "groove",
                  "maxclass": "newobj",
                  "patching_rect": [
                    0.0,
                    200.0,
                    100.0,
                    22.0
                  ],
                  "text": "groove~ #0-barcode 2 @loop 1 @loopinterp 1",
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
                  "text": "line~ 0.",
                  "numinlets": 2,
                  "numoutlets": 2
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
                  "text": "line~ 0.707",
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
                  "text": "line~ 0.707",
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
              }
            ],
            "lines": [
              {
                "patchline": {
                  "source": [
                    "in0",
                    0
                  ],
                  "destination": [
                    "speed",
                    0
                  ]
                }
              },
              {
                "patchline": {
                  "source": [
                    "speed",
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
                    "effective-level",
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
                    "effective-level",
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
              }
            ]
          }
        }
      },
      {
        "box": {
          "id": "voice5",
          "maxclass": "newobj",
          "patching_rect": [
            0.0,
            200.0,
            100.0,
            22.0
          ],
          "text": "p voice_6",
          "numinlets": 9,
          "numoutlets": 2,
          "outlettype": [
            "signal",
            "signal"
          ],
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
                  "id": "speed",
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
                  "id": "groove",
                  "maxclass": "newobj",
                  "patching_rect": [
                    0.0,
                    200.0,
                    100.0,
                    22.0
                  ],
                  "text": "groove~ #0-barcode 2 @loop 1 @loopinterp 1",
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
                  "text": "line~ 0.",
                  "numinlets": 2,
                  "numoutlets": 2
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
                  "text": "line~ 0.707",
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
                  "text": "line~ 0.707",
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
              }
            ],
            "lines": [
              {
                "patchline": {
                  "source": [
                    "in0",
                    0
                  ],
                  "destination": [
                    "speed",
                    0
                  ]
                }
              },
              {
                "patchline": {
                  "source": [
                    "speed",
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
                    "effective-level",
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
                    "effective-level",
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
              }
            ]
          }
        }
      },
      {
        "box": {
          "id": "wet",
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
          "id": "dry",
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
          "id": "dspstate",
          "maxclass": "newobj",
          "patching_rect": [
            0.0,
            200.0,
            100.0,
            22.0
          ],
          "text": "dspstate~",
          "numinlets": 1,
          "numoutlets": 3
        }
      },
      {
        "box": {
          "id": "samplerate",
          "maxclass": "newobj",
          "patching_rect": [
            0.0,
            200.0,
            100.0,
            22.0
          ],
          "text": "prepend samplerate",
          "numinlets": 1,
          "numoutlets": 1
        }
      },
      {
        "box": {
          "id": "dspstatecmd",
          "maxclass": "newobj",
          "patching_rect": [
            0.0,
            200.0,
            100.0,
            22.0
          ],
          "text": "prepend dspstate",
          "numinlets": 1,
          "numoutlets": 1
        }
      },
      {
        "box": {
          "id": "rawmeter",
          "maxclass": "newobj",
          "patching_rect": [
            0.0,
            200.0,
            100.0,
            22.0
          ],
          "text": "peakamp~ 200",
          "numinlets": 2,
          "numoutlets": 1
        }
      },
      {
        "box": {
          "id": "rawmetercmd",
          "maxclass": "newobj",
          "patching_rect": [
            0.0,
            200.0,
            100.0,
            22.0
          ],
          "text": "prepend rawmeter",
          "numinlets": 1,
          "numoutlets": 1
        }
      },
      {
        "box": {
          "id": "filtermeter",
          "maxclass": "newobj",
          "patching_rect": [
            0.0,
            200.0,
            100.0,
            22.0
          ],
          "text": "peakamp~ 200",
          "numinlets": 2,
          "numoutlets": 1
        }
      },
      {
        "box": {
          "id": "filtermetercmd",
          "maxclass": "newobj",
          "patching_rect": [
            0.0,
            200.0,
            100.0,
            22.0
          ],
          "text": "prepend filtermeter",
          "numinlets": 1,
          "numoutlets": 1
        }
      },
      {
        "box": {
          "id": "outmeter",
          "maxclass": "newobj",
          "patching_rect": [
            0.0,
            200.0,
            100.0,
            22.0
          ],
          "text": "peakamp~ 200",
          "numinlets": 2,
          "numoutlets": 1
        }
      },
      {
        "box": {
          "id": "outmetercmd",
          "maxclass": "newobj",
          "patching_rect": [
            0.0,
            200.0,
            100.0,
            22.0
          ],
          "text": "prepend outmeter",
          "numinlets": 1,
          "numoutlets": 1
        }
      },
      {
        "box": {
          "id": "input",
          "maxclass": "newobj",
          "patching_rect": [
            0.0,
            200.0,
            100.0,
            22.0
          ],
          "text": "plugin~",
          "numinlets": 1,
          "numoutlets": 2,
          "outlettype": [
            "signal",
            "signal"
          ]
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
          "id": "filter0",
          "maxclass": "newobj",
          "patching_rect": [
            0.0,
            200.0,
            100.0,
            22.0
          ],
          "text": "biquad~",
          "numinlets": 6,
          "numoutlets": 1
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
          "id": "limit0",
          "maxclass": "newobj",
          "patching_rect": [
            0.0,
            200.0,
            100.0,
            22.0
          ],
          "text": "clip~ -0.98 0.98",
          "numinlets": 3,
          "numoutlets": 1
        }
      },
      {
        "box": {
          "id": "dryamp0",
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
          "id": "filter1",
          "maxclass": "newobj",
          "patching_rect": [
            0.0,
            200.0,
            100.0,
            22.0
          ],
          "text": "biquad~",
          "numinlets": 6,
          "numoutlets": 1
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
          "id": "limit1",
          "maxclass": "newobj",
          "patching_rect": [
            0.0,
            200.0,
            100.0,
            22.0
          ],
          "text": "clip~ -0.98 0.98",
          "numinlets": 3,
          "numoutlets": 1
        }
      },
      {
        "box": {
          "id": "dryamp1",
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
            "lfofreeze",
            0
          ],
          "destination": [
            "lfofreezecmd",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "lfofreezecmd",
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
            "allowreverse",
            0
          ],
          "destination": [
            "allowreversecmd",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "allowreversecmd",
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
            "bpmsync",
            0
          ],
          "destination": [
            "bpmsynccmd",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "bpmsynccmd",
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
            "transport",
            0
          ],
          "destination": [
            "transportcmd",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "transportcmd",
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
            "resetvoices",
            0
          ],
          "destination": [
            "resetvoicescmd",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "resetvoicescmd",
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
            "voice",
            0
          ],
          "destination": [
            "voicecmd",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "voicecmd",
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
            "parameter",
            0
          ],
          "destination": [
            "parametercmd",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "parametercmd",
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
            "bias",
            0
          ],
          "destination": [
            "biascmd",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "biascmd",
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
            "period",
            0
          ],
          "destination": [
            "periodcmd",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "periodcmd",
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
            "filterfreq",
            0
          ],
          "destination": [
            "filterfreqcmd",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "filterfreqcmd",
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
            "filterres",
            0
          ],
          "destination": [
            "filterrescmd",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "filterrescmd",
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
            "rateslew",
            0
          ],
          "destination": [
            "rateslewcmd",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "rateslewcmd",
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
            "panslew",
            0
          ],
          "destination": [
            "panslewcmd",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "panslewcmd",
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
            "levelslew",
            0
          ],
          "destination": [
            "levelslewcmd",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "levelslewcmd",
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
            "gain0",
            0
          ],
          "destination": [
            "gain0cmd",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "gain0cmd",
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
            "gain1",
            0
          ],
          "destination": [
            "gain1cmd",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "gain1cmd",
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
            "gain2",
            0
          ],
          "destination": [
            "gain2cmd",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "gain2cmd",
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
            "gain3",
            0
          ],
          "destination": [
            "gain3cmd",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "gain3cmd",
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
            "gain4",
            0
          ],
          "destination": [
            "gain4cmd",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "gain4cmd",
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
            "gain5",
            0
          ],
          "destination": [
            "gain5cmd",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "gain5cmd",
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
            "protocol",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "protocol",
            0
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
            "protocol",
            1
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
            "protocol",
            2
          ],
          "destination": [
            "rateroute",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "protocol",
            3
          ],
          "destination": [
            "levelroute",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "protocol",
            4
          ],
          "destination": [
            "panroute",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "protocol",
            5
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
            "protocol",
            12
          ],
          "destination": [
            "trim-route",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "protocol",
            11
          ],
          "destination": [
            "start-route",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "trim-route",
            0
          ],
          "destination": [
            "voice0",
            8
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "protocol",
            10
          ],
          "destination": [
            "voice0",
            6
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "start-route",
            0
          ],
          "destination": [
            "voice0",
            7
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "protocol",
            9
          ],
          "destination": [
            "voice0",
            5
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "rateroute",
            0
          ],
          "destination": [
            "voice0",
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
            "voice0",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "levelroute",
            0
          ],
          "destination": [
            "voice0",
            2
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "panroute",
            0
          ],
          "destination": [
            "voice0",
            3
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
            "voice0",
            4
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "trim-route",
            1
          ],
          "destination": [
            "voice1",
            8
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "protocol",
            10
          ],
          "destination": [
            "voice1",
            6
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "start-route",
            1
          ],
          "destination": [
            "voice1",
            7
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "protocol",
            9
          ],
          "destination": [
            "voice1",
            5
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "rateroute",
            1
          ],
          "destination": [
            "voice1",
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
            "voice1",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "levelroute",
            1
          ],
          "destination": [
            "voice1",
            2
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "panroute",
            1
          ],
          "destination": [
            "voice1",
            3
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
            "voice1",
            4
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "trim-route",
            2
          ],
          "destination": [
            "voice2",
            8
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "protocol",
            10
          ],
          "destination": [
            "voice2",
            6
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "start-route",
            2
          ],
          "destination": [
            "voice2",
            7
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "protocol",
            9
          ],
          "destination": [
            "voice2",
            5
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "rateroute",
            2
          ],
          "destination": [
            "voice2",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "boundsroute",
            2
          ],
          "destination": [
            "voice2",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "levelroute",
            2
          ],
          "destination": [
            "voice2",
            2
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "panroute",
            2
          ],
          "destination": [
            "voice2",
            3
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "seekroute",
            2
          ],
          "destination": [
            "voice2",
            4
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "trim-route",
            3
          ],
          "destination": [
            "voice3",
            8
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "protocol",
            10
          ],
          "destination": [
            "voice3",
            6
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "start-route",
            3
          ],
          "destination": [
            "voice3",
            7
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "protocol",
            9
          ],
          "destination": [
            "voice3",
            5
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "rateroute",
            3
          ],
          "destination": [
            "voice3",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "boundsroute",
            3
          ],
          "destination": [
            "voice3",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "levelroute",
            3
          ],
          "destination": [
            "voice3",
            2
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "panroute",
            3
          ],
          "destination": [
            "voice3",
            3
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "seekroute",
            3
          ],
          "destination": [
            "voice3",
            4
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "trim-route",
            4
          ],
          "destination": [
            "voice4",
            8
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "protocol",
            10
          ],
          "destination": [
            "voice4",
            6
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "start-route",
            4
          ],
          "destination": [
            "voice4",
            7
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "protocol",
            9
          ],
          "destination": [
            "voice4",
            5
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "rateroute",
            4
          ],
          "destination": [
            "voice4",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "boundsroute",
            4
          ],
          "destination": [
            "voice4",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "levelroute",
            4
          ],
          "destination": [
            "voice4",
            2
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "panroute",
            4
          ],
          "destination": [
            "voice4",
            3
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "seekroute",
            4
          ],
          "destination": [
            "voice4",
            4
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "trim-route",
            5
          ],
          "destination": [
            "voice5",
            8
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "protocol",
            10
          ],
          "destination": [
            "voice5",
            6
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "start-route",
            5
          ],
          "destination": [
            "voice5",
            7
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "protocol",
            9
          ],
          "destination": [
            "voice5",
            5
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "rateroute",
            5
          ],
          "destination": [
            "voice5",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "boundsroute",
            5
          ],
          "destination": [
            "voice5",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "levelroute",
            5
          ],
          "destination": [
            "voice5",
            2
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "panroute",
            5
          ],
          "destination": [
            "voice5",
            3
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "seekroute",
            5
          ],
          "destination": [
            "voice5",
            4
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "protocol",
            6
          ],
          "destination": [
            "wet",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "protocol",
            7
          ],
          "destination": [
            "dry",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "dspstate",
            1
          ],
          "destination": [
            "samplerate",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "samplerate",
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
            "dspstate",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "dspstate",
            0
          ],
          "destination": [
            "dspstatecmd",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "dspstatecmd",
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
            "rawmeter",
            0
          ],
          "destination": [
            "rawmetercmd",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "rawmetercmd",
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
            "filtermeter",
            0
          ],
          "destination": [
            "filtermetercmd",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "filtermetercmd",
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
            "outmeter",
            0
          ],
          "destination": [
            "outmetercmd",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "outmetercmd",
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
            "voice0",
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
            "voice1",
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
            "voice2",
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
            "voice3",
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
            "voice4",
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
            "voice5",
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
            "sum0",
            0
          ],
          "destination": [
            "filter0",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "protocol",
            8
          ],
          "destination": [
            "filter0",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "filter0",
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
            "wet",
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
            "limit0",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "input",
            0
          ],
          "destination": [
            "dryamp0",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "dry",
            0
          ],
          "destination": [
            "dryamp0",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "limit0",
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
            "dryamp0",
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
            "voice0",
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
            "voice1",
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
            "voice2",
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
            "voice3",
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
            "voice4",
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
            "voice5",
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
            "sum1",
            0
          ],
          "destination": [
            "filter1",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "protocol",
            8
          ],
          "destination": [
            "filter1",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "filter1",
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
            "wet",
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
            "limit1",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "input",
            1
          ],
          "destination": [
            "dryamp1",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "dry",
            0
          ],
          "destination": [
            "dryamp1",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "limit1",
            0
          ],
          "destination": [
            "output",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "dryamp1",
            0
          ],
          "destination": [
            "output",
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
            "rawmeter",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "filter0",
            0
          ],
          "destination": [
            "filtermeter",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "limit0",
            0
          ],
          "destination": [
            "outmeter",
            0
          ]
        }
      }
    ],
    "devicewidth": 1480.0,
    "openrect": [
      0.0,
      0.0,
      1480.0,
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
    "description": "Barcode six-voice sample playback following the preceding Simpler. No recording.",
    "digest": "Barcode for Simpler v0.1.3",
    "autosave": 0,
    "parameters": {
      "enable": [
        "Barcode On",
        "Barcode On",
        0
      ],
      "lfofreeze": [
        "Freeze LFO",
        "Freeze LFO",
        0
      ],
      "allowreverse": [
        "Reverse Allowed",
        "Reverse Allowed",
        0
      ],
      "bpmsync": [
        "LFO Tempo Sync",
        "LFO Tempo Sync",
        0
      ],
      "transport": [
        "Follow Transport",
        "Follow Transport",
        0
      ],
      "volume": [
        "Output dB",
        "Output dB",
        0
      ],
      "filterfreq": [
        "Filter Hz",
        "Filter Hz",
        0
      ],
      "filterres": [
        "Resonance",
        "Resonance",
        0
      ],
      "rateslew": [
        "Rate slew s",
        "Rate slew s",
        0
      ],
      "panslew": [
        "Pan slew s",
        "Pan slew s",
        0
      ],
      "levelslew": [
        "Level slew s",
        "Level slew s",
        0
      ],
      "gain0": [
        "Voice 1",
        "Voice 1",
        0
      ],
      "gain1": [
        "Voice 2",
        "Voice 2",
        0
      ],
      "gain2": [
        "Voice 3",
        "Voice 3",
        0
      ],
      "gain3": [
        "Voice 4",
        "Voice 4",
        0
      ],
      "gain4": [
        "Voice 5",
        "Voice 5",
        0
      ],
      "gain5": [
        "Voice 6",
        "Voice 6",
        0
      ],
      "data": [
        "BarcodeData",
        "BarcodeData",
        0
      ],
      "parameterbanks": {
        "0": {
          "index": 0,
          "name": "Barcode",
          "parameters": [
            "Barcode On",
            "Output dB",
            "Freeze LFO",
            "Reverse Allowed",
            "LFO Tempo Sync",
            "Follow Transport",
            "Filter Hz",
            "Resonance"
          ]
        }
      },
      "inherited_shortname": 1
    },
    "dependency_cache": [
      {
        "name": "barcode.js",
        "type": "TEXT",
        "implicit": 1
      },
      {
        "name": "barcode-core.js",
        "type": "TEXT",
        "implicit": 1
      },
      {
        "name": "barcode-display.js",
        "type": "TEXT",
        "implicit": 1
      }
    ]
  }
}
