export TARGET = iphone:latest:15.0
export ARCHS = arm64

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = NexusMod
NexusMod_FILES = Tweak.x
NexusMod_FRAMEWORKS = UIKit

include $(THEOS)/makefiles/tweak.mk