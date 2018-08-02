MEDIALIBRARY_HASH := c7b32d94c80cacbd0329ffefdb8d9a495e13beb0
MEDIALIBRARY_VERSION := git-$(MEDIALIBRARY_HASH)
MEDIALIBRARY_GITURL := https://code.videolan.org/videolan/medialibrary.git

PKGS += medialibrary
ifeq ($(call need_pkg,"medialibrary"),)
PKGS_FOUND += medialibrary
endif

DEPS_medialibrary = sqlite $(DEPS_sqlite)

$(TARBALLS)/medialibrary-$(MEDIALIBRARY_VERSION).tar.xz:
	$(call download_git,$(MEDIALIBRARY_GITURL),,$(MEDIALIBRARY_HASH))

.sum-medialibrary: medialibrary-$(MEDIALIBRARY_VERSION).tar.xz
	$(call check_githash,$(MEDIALIBRARY_HASH))
	touch $@

medialibrary: medialibrary-$(MEDIALIBRARY_VERSION).tar.xz .sum-medialibrary
	rm -rf $@-$(MEDIALIBRARY_VERSION) $@
	mkdir -p $@-$(MEDIALIBRARY_VERSION)
	tar xvf "$<" --strip-components=1 -C $@-$(MEDIALIBRARY_VERSION)
	$(call pkg_static, "medialibrary.pc.in")
	$(UPDATE_AUTOCONFIG)
	$(MOVE)

.medialibrary: medialibrary
	$(RECONF)
	cd $< && $(HOSTVARS_PIC) ./configure CXXFLAGS="-g -O0" --disable-tests --without-libvlc $(HOSTCONF)
	cd $< && $(MAKE)
	cd $< && $(MAKE) install
	touch $@

