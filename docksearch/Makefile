ARCHS = arm64 arm64e
TARGET = iphone:clang:14.4:14

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = docksearch

docksearch_LIBRARIES = gscommon
docksearch_FILES = $(shell find Sources/docksearch -name '*.swift') $(shell find Sources/docksearchC -name '*.m' -o -name '*.c' -o -name '*.mm' -o -name '*.cpp')
docksearch_INSTALL_PATH = /Library/PreferenceBundles
docksearch_SWIFTFLAGS = -ISources/docksearchC/include
docksearch_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/bundle.mk
