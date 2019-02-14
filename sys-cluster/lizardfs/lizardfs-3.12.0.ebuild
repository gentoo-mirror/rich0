# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils autotools cmake-utils user

MY_P="lizardfs-${PV}"
S="${WORKDIR}/${MY_P}"

DESCRIPTION="LizardFS is an Open Source Distributed File System licenced under GPLv3."
HOMEPAGE="http://lizardfs.org"
SRC_URI="https://github.com/lizardfs/lizardfs/archive/v${PV}.tar.gz -> ${P}.tar.gz https://github.com/gabime/spdlog/archive/v0.14.0.zip -> ${P}-spdlog.zip"

#EGIT_REPO_URI="https://github.com/lizardfs/lizardfs.git"
#EGIT_COMMIT="If316525daf78165494416508cb81b5448f3b760d"
#EGIT_COMMIT="v3.12.0"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="cgi +fuse static-libs"

RDEPEND="
	cgi? ( dev-lang/python:= )
	!sys-cluster/moosefs
	app-text/asciidoc
	dev-libs/judy
	dev-libs/spdlog
	fuse? ( >=sys-fs/fuse-2.6:= )"
DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}"/iostat-${PV}.patch "${FILESDIR}"/download-${PV}.patch )

pkg_setup() {
	enewgroup mfs
	enewuser mfs -1 -1 -1 mfs
	mycmakeargs=(-DCMAKE_BUILD_TYPE=Release -DENABLE_TESTS=NO -DCMAKE_INSTALL_PREFIX=/ -DENABLE_DEBIAN_PATHS=YES)
}

src_install() {
	cmake-utils_src_install

	diropts -m0750 -o mfs -g mfs
	dodir "/var/lib/mfs"
	#chown -R mfs:mfs "${D}var/lib/mfs" || die
	#chmod 750 "${D}var/lib/mfs" || die
}
