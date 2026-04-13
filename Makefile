# Makefile - Version corrigée pour ton NexusMod

THEOS_DEVICE_IP = 127.0.0.1  # Change si besoin

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = NexusMod
NexusMod_FILES = Tweak.xm
NexusMod_CFLAGS = -fobjc-arc
NexusMod_FRAMEWORKS = UIKit StoreKit   # ← AJOUTÉ StoreKit ici pour SKPaymentQueue
NexusMod_EXTRA_FRAMEWORKS =   # Ajoute d'autres si besoin plus tard

include $(THEOS_MAKE_PATH)/tweak.mk