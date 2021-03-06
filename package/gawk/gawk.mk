################################################################################
#
# gawk
#
################################################################################

GAWK_VERSION = 4.1.3
GAWK_SOURCE = gawk-$(GAWK_VERSION).tar.xz
GAWK_SITE = $(BR2_GNU_MIRROR)/gawk
GAWK_DEPENDENCIES = host-gawk $(if $(BR2_PACKAGE_MPFR),mpfr)
GAWK_LICENSE = GPLv3+
GAWK_LICENSE_FILES = COPYING

# Prefer full-blown gawk over busybox awk
ifeq ($(BR2_PACKAGE_BUSYBOX),y)
GAWK_DEPENDENCIES += busybox
endif

# We don't have a host-busybox, and we don't want to use readline or mpfr
HOST_GAWK_DEPENDENCIES =

HOST_GAWK_CONF_OPTS = --without-readline --without-mpfr

define GAWK_CREATE_SYMLINK
	ln -sf /usr/bin/gawk $(TARGET_DIR)/usr/bin/awk
endef

GAWK_POST_INSTALL_TARGET_HOOKS += GAWK_CREATE_SYMLINK

# Assume we support shared libs
# The check isn't cross-compile friendly and it's mandatory anyway
define GAWK_DISABLE_SHARED_CHECK
	$(SED) 's/ check-for-shared-lib-support//' $(@D)/extension/Makefile.in
endef

GAWK_POST_PATCH_HOOKS += GAWK_DISABLE_SHARED_CHECK

$(eval $(autotools-package))
$(eval $(host-autotools-package))
