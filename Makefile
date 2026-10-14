TARGET := iphone:clang:latest:14.0
ARCHS := arm64

include $(THEOS)/makefiles/common.mk

LIBRARY_NAME = MyFloatingMenu

MyFloatingMenu_FILES = Menu.mm
MyFloatingMenu_CFLAGS = -fobjc-arc
MyFloatingMenu_FRAMEWORKS = UIKit Foundation QuartzCore

include $(THEOS_MAKE_PATH)/library.mk
