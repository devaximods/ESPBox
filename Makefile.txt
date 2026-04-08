TARGET := iphone:clang:latest:7.0

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = ESPBox1
ESPBox1_FILES = Tweak.x
ESPBox1_FILES = Tweak.x
ESPBox1_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
ESPBox1_FRAMEWORKS = UIKit Foundation CoreGraphics
