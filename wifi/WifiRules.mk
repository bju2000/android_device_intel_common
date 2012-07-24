####################################
# Paths declaration
####################################

COMMON_WIFI_DIR = vendor/intel/common/wifi
COMMON = vendor/intel/common
LOCAL_COMMON_WIFI_DIR = $(PWD)/$(COMMON_WIFI_DIR)

####################################
# Configuration filenames
####################################

STA_CONF_FILE_NAME      = wpa_supplicant.conf
P2P_CONF_FILE_NAME      = p2p_supplicant.conf
HOSTAPD_CONF_FILE_NAME  = hostapd.conf
ifeq ($(strip $(INTEL_WIDI)),true)
WIDI_CONF_FILE_NAME     = widi_supplicant.conf
endif

####################################
# Files path on target
####################################

CONF_PATH_ON_TARGET = system/etc/wifi
STA_CONF_PATH_ON_TARGET       = $(CONF_PATH_ON_TARGET)/$(STA_CONF_FILE_NAME)
P2P_CONF_PATH_ON_TARGET       = $(CONF_PATH_ON_TARGET)/$(P2P_CONF_FILE_NAME)
HOSTAPD_CONF_PATH_ON_TARGET   = $(CONF_PATH_ON_TARGET)/$(HOSTAPD_CONF_FILE_NAME)
ifeq ($(strip $(INTEL_WIDI)),true)
WIDI_CONF_PATH_ON_TARGET = $(CONF_PATH_ON_TARGET)/$(WIDI_CONF_FILE_NAME)
endif

####################################
# Manufacturer
####################################

include $(COMMON)/ComboChipVendor.mk

ifeq (ti,$(COMBO_CHIP_VENDOR))
    include $(TOP)/hardware/ti/wlan/wl12xx-compat/AndroidWl12xxCompat.mk
endif

ifeq (bcm,$(COMBO_CHIP_VENDOR))
ifeq (bcm4334,$(COMBO_CHIP))
    include $(TOP)/hardware/broadcom/wlan_driver/bcm4334/AndroidBcmdhd.mk
endif
ifeq (bcm4335,$(COMBO_CHIP))
    include $(TOP)/hardware/broadcom/wlan_driver/bcm4335/AndroidBcmdhd.mk
endif
endif

####################################
# Configuration files
####################################

# common configuration files
STA_CONF_FILES      += $(LOCAL_COMMON_WIFI_DIR)/$(STA_CONF_FILE_NAME)
P2P_CONF_FILES      += $(LOCAL_COMMON_WIFI_DIR)/$(P2P_CONF_FILE_NAME)
HOSTAPD_CONF_FILES  += $(LOCAL_COMMON_WIFI_DIR)/$(HOSTAPD_CONF_FILE_NAME)
ifeq ($(strip $(INTEL_WIDI)),true)
WIDI_CONF_FILES     += $(LOCAL_COMMON_WIFI_DIR)/$(WIDI_CONF_FILE_NAME)
endif

# manufacturer specific files
STA_CONF_FILES      += $(LOCAL_COMMON_WIFI_DIR)/$(COMBO_CHIP_VENDOR)_specific/$(STA_CONF_FILE_NAME)
P2P_CONF_FILES      += $(LOCAL_COMMON_WIFI_DIR)/$(COMBO_CHIP_VENDOR)_specific/$(P2P_CONF_FILE_NAME)
HOSTAPD_CONF_FILES  += $(LOCAL_COMMON_WIFI_DIR)/$(COMBO_CHIP_VENDOR)_specific/$(HOSTAPD_CONF_FILE_NAME)
ifeq ($(strip $(INTEL_WIDI)),true)
WIDI_CONF_FILES     += $(LOCAL_COMMON_WIFI_DIR)/$(COMBO_CHIP_VENDOR)_specific/$(WIDI_CONF_FILE_NAME)
endif

####################################
# Locale variables
####################################

REGDOM=$(word 2,$(subst _, ,$(word 1,$(PRODUCT_LOCALES))))
MV=mv
CAT=cat
SED=sed
MKDIR=mkdir
GREP=grep

####################################
# Functions
####################################

define set_def_regdom
	$(SED) 's/country=XY/country=$(REGDOM)/g' $1 > $1.tmp
	$(MV) $1.tmp $1
endef

define clean_conf_file
	$(CAT) $1 | $(GREP) -v "(todel)" > $1.tmp
	$(MV) $1.tmp $1
endef

####################################
# Rules and targets
####################################

# targets names
WIFI_CONF_TARGET = wifi_conf
WIFI_RC_TARGET   = wifi_rc
ifeq ($(strip $(INTEL_WIDI)),true)
WIDI_CONF_TARGET = widi_conf
WIDI_RC_TARGET   = widi_rc
endif

# common targets and rules
$(PRODUCT_OUT)/$(STA_CONF_PATH_ON_TARGET):
	$(MKDIR) -p $(PRODUCT_OUT)/$(CONF_PATH_ON_TARGET)
	$(CAT) $(STA_CONF_FILES) > $(PRODUCT_OUT)/$(STA_CONF_PATH_ON_TARGET)
	$(call set_def_regdom,$(PRODUCT_OUT)/$(STA_CONF_PATH_ON_TARGET))
	$(call clean_conf_file,$(PRODUCT_OUT)/$(STA_CONF_PATH_ON_TARGET))

$(PRODUCT_OUT)/$(P2P_CONF_PATH_ON_TARGET):
	$(MKDIR) -p $(PRODUCT_OUT)/$(CONF_PATH_ON_TARGET)
	$(CAT) $(P2P_CONF_FILES) > $(PRODUCT_OUT)/$(P2P_CONF_PATH_ON_TARGET)
	$(call set_def_regdom,$(PRODUCT_OUT)/$(P2P_CONF_PATH_ON_TARGET))
	$(call clean_conf_file,$(PRODUCT_OUT)/$(P2P_CONF_PATH_ON_TARGET))

$(PRODUCT_OUT)/$(HOSTAPD_CONF_PATH_ON_TARGET):
	$(MKDIR) -p $(PRODUCT_OUT)/$(CONF_PATH_ON_TARGET)
	$(CAT) $(HOSTAPD_CONF_FILES) > $(PRODUCT_OUT)/$(HOSTAPD_CONF_PATH_ON_TARGET)

$(PRODUCT_OUT)/$(WIDI_CONF_PATH_ON_TARGET):
	$(MKDIR) -p $(PRODUCT_OUT)/$(CONF_PATH_ON_TARGET)
	$(CAT) $(WIDI_CONF_FILES) > $(PRODUCT_OUT)/$(WIDI_CONF_PATH_ON_TARGET)
	$(call set_def_regdom,$(PRODUCT_OUT)/$(WIDI_CONF_PATH_ON_TARGET))
	$(call clean_conf_file,$(PRODUCT_OUT)/$(WIDI_CONF_PATH_ON_TARGET))

$(WIFI_CONF_TARGET): $(PRODUCT_OUT)/$(STA_CONF_PATH_ON_TARGET)  \
           $(PRODUCT_OUT)/$(P2P_CONF_PATH_ON_TARGET)  \
           $(PRODUCT_OUT)/$(HOSTAPD_CONF_PATH_ON_TARGET)

$(WIDI_CONF_TARGET): $(PRODUCT_OUT)/$(WIDI_CONF_PATH_ON_TARGET)

systemimg_gz: $(WIFI_CONF_TARGET)
ifeq ($(strip $(INTEL_WIDI)),true)
systemimg_gz: $(WIDI_CONF_TARGET)
endif

