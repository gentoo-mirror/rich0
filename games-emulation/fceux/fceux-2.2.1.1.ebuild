# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
inherit eutils scons-utils games

DESCRIPTION="A portable Famicom/NES emulator, an evolution of the original FCE Ultra"
HOMEPAGE="http://fceux.com/"
SRC_URI="mirror://sourceforge/fceultra/${P}.src.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="+lua +opengl"

RDEPEND="lua? ( dev-lang/lua )
	media-libs/libsdl[opengl?,video]
	opengl? ( virtual/opengl )
	x11-libs/gtk+:2
	sys-libs/zlib[minizip]
	gnome-extra/zenity"
DEPEND="${RDEPEND}"

# Note: zenity is "almost" optional. It is possible to compile and run fceux
# without zenity, but file dialogs will not work.

src_prepare() {
	epatch "${FILESDIR}"/${P}-unzip.patch
	# mentioned in bug #335836
	if ! use lua ; then
		sed -i -e '/_S9XLUA_H/d' SConstruct || die
	fi
}

src_compile() {
	escons \
		SYSTEM_MINIZIP=1 \
		$(use_scons opengl OPENGL) \
		$(use_scons lua LUA)
}

src_install() {
	dogamesbin bin/fceux

	doman documentation/fceux.6
	docompress -x /usr/share/doc/${PF}/documentation
	docompress -x /usr/share/doc/${PF}/fceux.chm
	dodoc -r Authors changelog.txt bin/fceux.chm documentation
	rm -f "${D}/usr/share/doc/${PF}/documentation/fceux.6"

	prepgamesdirs
}
