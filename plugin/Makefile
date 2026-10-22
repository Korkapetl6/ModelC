NAME = StepCompass
FILES_DSP = Plugin.cpp
FILES_UI = UI.cpp
ifeq ($(shell uname -s),Darwin)
FILES_UI += Drop.mm
endif
include ../third_party/DPF/Makefile.plugins.mk
BUILD_CXX_FLAGS += -I../src -std=c++17 -fno-fast-math -fno-strict-aliasing
all: vst3
