
TWEAK_NAME = OmniCorrect
OmniCorrect_FILES = Tweak.xm

ARCHS = arm64
TARGET_IPHONEOS_DEPLOYMENT_VERSION = 8.1

include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
