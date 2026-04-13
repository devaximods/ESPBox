# Makefile - NexusMod par XSNPOWWWWWW (iOS 13+ ready)

export TARGET = iphone:latest:13.0   # ← C'EST ÇA QUI RÉSOUT TOUT

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = NexusMod
NexusMod_FILES = Tweak.xm
NexusMod_CFLAGS = -fobjc-arc
NexusMod_FRAMEWORKS = UIKit StoreKit

include $(THEOS_MAKE_PATH)/tweak.mk