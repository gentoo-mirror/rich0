# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils cmake-utils wxwidgets

DESCRIPTION="ARRL Logbook of the World"
HOMEPAGE="http://www.arrl.org/tqsl-download"
SRC_URI="mirror://sourceforge/trustedqsl/${P}.tar.gz"

LICENSE="LOTW"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-libs/expat:=
		 dev-libs/openssl:=
		 net-misc/curl:=
		 sys-libs/db:=
		 sys-libs/zlib:=
		 x11-libs/wxGTK:3.0="
DEPEND="${RDEPEND}"

DOCS=( AUTHORS.txt INSTALL README )
HTML_DOCS=( html )

WX_GTK_VER=3.0

pkg_setup() {
	setup-wxwidgets
}

src_prepare() {
# Fix syntax file in makefile
	eapply_user
	epatch "${FILESDIR}/${PV}-suffix.patch"
}
