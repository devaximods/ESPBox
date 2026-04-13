export TARGET = iphone:latest:15.0
export ARCHS = arm64

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = test
test_FILES = Tweak.x
test_FRAMEWORKS = UIKit

include $(THEOS)/makefiles/tweak.mk