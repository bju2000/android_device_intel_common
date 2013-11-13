LOCAL_PATH := $(ANDROID_BUILD_TOP)

##################################################

include $(CLEAR_VARS)
LOCAL_MODULE := bt_rtl
LOCAL_MODULE_TAGS := optional
LOCAL_REQUIRED_MODULES :=  \
    bt_common
# Note: additional modules for the Bluetooth firmware are
# appended in each product-specific makefile (victoriabay.mk etc)
#
# Still, bt_bcm is kept instead of pointing directly to bt_common in
# victoriabay.mk, etc for the following reasons:
#  1) Placeholder for additional modules required by all BRCM-based platforms
#  2) Symetrical code with TI
#  3) [most important] bt_bcm is used in ComboChipVendor.mk to know if this is a BRCM chip

include $(BUILD_PHONY_PACKAGE)

##################################################
