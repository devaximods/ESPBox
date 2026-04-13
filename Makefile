# Makefile - NexusMod par XSNPOWWWWWW

THEOS_DEVICE_IP = 127.0.0.1

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = NexusMod
NexusMod_FILES = Tweak.xm
NexusMod_CFLAGS = -fobjc-arc
NexusMod_FRAMEWORKS = UIKit StoreKit
NexusMod_EXTRA_FRAMEWORKS =

include $(THEOS_MAKE_PATH)/tweak.mk