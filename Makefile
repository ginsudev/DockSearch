ARCHS = arm64 arm64e
THEOS_DEVICE_IP = root@localhost -p 2222
INSTALL_TARGET_PROCESSES = SpringBoard
TARGET = iphone:clang:14.4:14
PACKAGE_VERSION = 2.1.3

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = DockSearch

DockSearch_LIBRARIES = gsutils
DockSearch_PRIVATE_FRAMEWORKS = SpringBoardHome SpringBoard SearchUI MaterialKit
DockSearch_FILES = $(shell find Sources/DockSearch -name '*.swift') $(shell find Sources/DockSearchC -name '*.m' -o -name '*.c' -o -name '*.mm' -o -name '*.cpp')
DockSearch_SWIFTFLAGS = -ISources/DockSearchC/include
DockSearch_CFLAGS = -fobjc-arc -ISources/DockSearchC/include

include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += docksearch
include $(THEOS_MAKE_PATH)/aggregate.mk
