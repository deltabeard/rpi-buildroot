OMXPLAYER_VERSION = f5440845cdd91e7816de1937c30057f58c10c268
OMXPLAYER_SITE = git://github.com/popcornmix/omxplayer.git
OMXPLAYER_SITE_METHOD = git
OMXPLAYER_DEPENDENCIES = ffmpeg boost pcre rpi-userland freetype dbus

OMXPLAYER_CONFIG_ENV = \
	BUILDROOT=$(TOPDIR) \
	SDKSTAGE=$(STAGING_DIR) \
	TARGETFS=$(TARGET_DIR) \
	TOOLCHAIN=$(HOST_DIR)/usr/ \
	HOST=$(HOSTCC) \
	SYSROOT=$(STAGING_DIR) \
	LD="$(TARGET_LD)" \
	CC="$(TARGET_CC)" \
	CXX="$(TARGET_CXX)" \
	OBJDUMP=$(TARGET_CROSS)objdump \
	RANLIB=$(TARGET_CROSS)ranlib \
	STRIP=$(TARGET_CROSS)strip \
	AR=$(TARGET_CROSS)ar \
	CXXCP="$(CXX) -E" \
	PATH=$(HOST_DIR)/usr/bin:$(PATH) \
	CFLAGS="$(TARGET_CFLAGS) -Wno-psabi -mno-apcs-stack-check -O3 -mstructure-size-boundary=32 -mno-sched-prolog" \
	LDFLAGS="$(TARGET_LDFLAGS)" \
	INCLUDES="-isystem$(STAGING_DIR)/usr/include -isystem$(STAGING_DIR)/usr/include/interface/vcos/pthreads -isystem$(STAGING_DIR)/usr/include/interface/vmcs_host/linux -isystem$(STAGING_DIR)/usr/include/freetype2 -isystem$(STAGING_DIR)/usr/lib/dbus-1.0/include/ -isystem$(STAGING_DIR)/usr/include/dbus-1.0/"

define OMXPLAYER_CONFIGURE_CMDS
	$(OMXPLAYER_CONFIG_ENV) $(MAKE) -C $(@D) clean
endef

define OMXPLAYER_BUILD_CMDS
	$(OMXPLAYER_CONFIG_ENV) $(MAKE) -C $(@D)
endef

define OMXPLAYER_INSTALL_TARGET_CMDS
	$(INSTALL) -m 755 $(@D)/omxplayer.bin $(TARGET_DIR)/usr/bin/omxplayer.bin
	$(INSTALL) -m 755 $(@D)/omxplayer $(TARGET_DIR)/usr/bin/omxplayer
	mkdir -p $(TARGET_DIR)/usr/share/fonts/truetype/freefont/
	$(INSTALL) -m 644 $(@D)/fonts/FreeSans.ttf $(TARGET_DIR)/usr/share/fonts/truetype/freefont/
	$(INSTALL) -m 644 $(@D)/fonts/FreeSansOblique.ttf $(TARGET_DIR)/usr/share/fonts/truetype/freefont/
endef

define OMXPLAYER_UNINSTALL_TARGET_CMDS
	-rm $(TARGET_DIR)/usr/bin/omxplayer.bin
	-rm $(TARGET_DIR)/usr/bin/omxplayer
	-rm $(TARGET_DIR)/usr/share/fonts/truetype/freefont/FreeSans.ttf
	-rm $(TARGET_DIR)/usr/share/fonts/truetype/freefont/FreeSansOblique.ttf
endef

$(eval $(generic-package))
