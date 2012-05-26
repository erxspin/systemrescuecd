EAPI="2"
ETYPE="sources"
inherit kernel-2 eutils

S=${WORKDIR}/linux-${KV}

DESCRIPTION="Full sources for the Linux kernel, including gentoo and sysresccd patches."
SRC_URI="http://www.kernel.org/pub/linux/kernel/v3.x/linux-3.2.tar.bz2"
PROVIDE="virtual/linux-sources"
HOMEPAGE="http://kernel.sysresccd.org"
LICENSE="GPL-2"
SLOT="${KV}"
KEYWORDS="-* arm amd64 x86"
IUSE=""

src_unpack()
{
	unpack linux-3.2.tar.bz2
	ln -s linux-${KV} linux
	mv linux-3.2 linux-${KV}
	cd linux-${KV}
	epatch ${FILESDIR}/std-sources-3.2-01-stable-3.2.18.patch.bz2 || die "std-sources stable patch failed."
	epatch ${FILESDIR}/std-sources-3.2-02-fc15.patch.bz2 || die "std-sources fedora patch failed."
	epatch ${FILESDIR}/std-sources-3.2-03-aufs.patch.bz2 || die "std-sources aufs patch failed."
	epatch ${FILESDIR}/std-sources-3.2-04-loopaes.patch.bz2 || die "std-sources loopaes patch failed."
	epatch ${FILESDIR}/std-sources-3.2-05-yaffs2.patch.bz2 || die "std-sources yaffs2 patch failed."
	sedlockdep='s!.*#define MAX_LOCKDEP_SUBCLASSES.*8UL!#define MAX_LOCKDEP_SUBCLASSES 16UL!'
	sed -i -e "${sedlockdep}" include/linux/lockdep.h
	sednoagp='s!int nouveau_noagp;!int nouveau_noagp=1;!g'
	sed -i -e "${sednoagp}" drivers/gpu/drm/nouveau/nouveau_drv.c
	oldextra=$(cat Makefile | grep "^EXTRAVERSION")
	sed -i -e "s/${oldextra}/EXTRAVERSION = -std271/" Makefile
	sed -i -e 's/2.6.$$((40 + $(PATCHLEVEL)))$(EXTRAVERSION)/$(KERNELVERSION)/' Makefile
}

