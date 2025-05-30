BEEPY_SYMBOL_OVERLAY_VERSION = 1.1
BEEPY_SYMBOL_OVERLAY_BASE = $(BR2_EXTERNAL_BEEPY_DRIVERS_PATH)/package/beepy-symbol-overlay
BEEPY_SYMBOL_OVERLAY_SITE = $(BEEPY_SYMBOL_OVERLAY_BASE)/module
BEEPY_SYMBOL_OVERLAY_SITE_METHOD = local

BEEPY_SYMBOL_OVERLAY_INSTALL_IMAGES = YES
BEEPY_SYMBOL_OVERLAY_MODULE_SUBDIRS = .

define BEEPY_SYMBOL_OVERLAY_BUILD_CMDS
	$(MAKE) CXX="$(TARGET_CXX)" OBJCOPY="$(TARGET_OBJCOPY)" LD="$(TARGET_LD)" -C $(@D) \
		CXXFLAGS=-DDEFAULT_KEYMAP_PATH=\\\"/usr/share/keymaps/beepy-kbd.map\\\"
endef

define BEEPY_SYMBOL_OVERLAY_INSTALL_TARGET_CMDS
    $(INSTALL) -D -m 0755 $(@D)/symbol-overlay $(TARGET_DIR)/sbin
endef

$(eval $(generic-package))
