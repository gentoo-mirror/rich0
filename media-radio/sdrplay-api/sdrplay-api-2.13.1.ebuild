# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit udev

DESCRIPTION="SDRPlay Proprietary APIs"

HOMEPAGE="https://www.sdrplay.com/"

SRC_URI="SDRplay_RSP_API-Linux-${PV}.run"

LICENSE="sdrplay"

SLOT="0"

KEYWORDS="~amd64"
IUSE=""
RESTRICT="fetch"

QA_PREBUILT="/usr/lib*/libmirsdrapi-rsp.so.2.13"

DEPEND=""
RDEPEND="${DEPEND}"

pkg_nofetch() {
	einfo "Please download"
	einfo "  - ${SRC_URI} "
	einfo "from ${HOMEPAGE} and place them in your DISTDIR directory."
}

src_unpack() {
	mkdir "${S}"
	cp "${DISTDIR}/${A}" "${S}"
	cd "${S}"
	chmod a+x ${A}
	./${A} --noexec --target unpack
}

src_install() {
	cd unpack
	doheader mirsdrapi-rsp.h
	udev_dorules 66-mirics.rules
	cd $(uname -m)
	dolib.so libmirsdrapi-rsp.so.2.13
	ln -s libmirsdrapi-rsp.so.2.13 libmirsdrapi-rsp.so.2
	ln -s libmirsdrapi-rsp.so.2.13 libmirsdrapi-rsp.so
	dolib.so libmirsdrapi-rsp.so.2
	dolib.so libmirsdrapi-rsp.so
}
