LOCAL_PATH := $(ANDROID_BUILD_TOP)
WIFI_COMMON := vendor/intel/common/wifi
COMMON := vendor/intel/common

include $(COMMON)/ComboChipVendor.mk

##################################################
include $(CLEAR_VARS)
LOCAL_MODULE := wifi_common
LOCAL_MODULE_TAGS := optional
LOCAL_REQUIRED_MODULES :=  \
    libwpa_client          \
    iw                     \
    init.wifi.rc           \
    init.wifi.vendor.rc    \
    android.conf

ifeq ($(strip $(INTEL_WIDI)),true)
LOCAL_REQUIRED_MODULES +=  \
    init.widi.rc           \
    init.widi.vendor.rc
endif

include $(BUILD_PHONY_PACKAGE)

##################################################

include $(CLEAR_VARS)
LOCAL_MODULE := init.wifi.rc
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_MODULE_PATH := $(TARGET_ROOT_OUT)
LOCAL_SRC_FILES := $(WIFI_COMMON)/$(LOCAL_MODULE)
include $(BUILD_PREBUILT)

##################################################

include $(CLEAR_VARS)
LOCAL_MODULE := init.wifi.vendor.rc
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_MODULE_PATH := $(TARGET_ROOT_OUT)
LOCAL_SRC_FILES := $(WIFI_COMMON)/init.wifi.$(COMBO_CHIP_VENDOR).rc
include $(BUILD_PREBUILT)

##################################################

include $(CLEAR_VARS)
LOCAL_MODULE := init.widi.rc
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_MODULE_PATH := $(TARGET_ROOT_OUT)
LOCAL_SRC_FILES := $(WIFI_COMMON)/$(LOCAL_MODULE)
include $(BUILD_PREBUILT)

##################################################

include $(CLEAR_VARS)
LOCAL_MODULE := init.widi.vendor.rc
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_MODULE_PATH := $(TARGET_ROOT_OUT)
LOCAL_SRC_FILES := $(WIFI_COMMON)/init.widi.$(COMBO_CHIP_VENDOR).rc
include $(BUILD_PREBUILT)

##################################################

include $(CLEAR_VARS)
LOCAL_MODULE := android.conf
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_MODULE_PATH := $(TARGET_OUT_ETC)/dhcpcd
LOCAL_SRC_FILES := $(WIFI_COMMON)/android.$(COMBO_CHIP_VENDOR).conf
include $(BUILD_PREBUILT)