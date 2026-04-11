export TARGET = iphone:latest:15.0
export ARCHS = arm64e

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = TestMenu
TestMenu_FILES = Tweak.x
TestMenu_FRAMEWORKS = UIKit Foundation CoreGraphics QuartzCore

include $(THEOS)/makefiles/tweak.mk