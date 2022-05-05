ARCHS = arm64
TARGET := iphone:clang:latest:13.0
INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = UmaPyogin

UmaPyogin_FILES = src/Tweak.x src/Plugin.cpp
UmaPyogin_CCFLAGS = -std=c++2a
UmaPyogin_CFLAGS = -fobjc-arc

include build/conanbuildinfo.mak

UmaPyogin_CCFLAGS += $(CONAN_CXXFLAGS)
UmaPyogin_CCFLAGS += $(addprefix -I, $(CONAN_INCLUDE_DIRS))
UmaPyogin_CCFLAGS += $(addprefix -D, $(CONAN_DEFINES))
UmaPyogin_LDFLAGS += $(addprefix -L, $(CONAN_LIB_DIRS))
UmaPyogin_LDFLAGS += $(addprefix -l, $(CONAN_LIBS))

include $(THEOS_MAKE_PATH)/tweak.mk
