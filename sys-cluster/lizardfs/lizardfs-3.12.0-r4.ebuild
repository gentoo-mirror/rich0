# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

MY_P="lizardfs-${PV}"
S="${WORKDIR}/${MY_P}"

DESCRIPTION="LizardFS is an Open Source Distributed File System licenced under GPLv3."
HOMEPAGE="https://lizardfs.org"
SRC_URI="https://github.com/lizardfs/lizardfs/archive/v${PV}.tar.gz -> ${P}.tar.gz"

#EGIT_REPO_URI="https://github.com/lizardfs/lizardfs.git"
#EGIT_COMMIT="If316525daf78165494416508cb81b5448f3b760d"
#EGIT_COMMIT="v3.12.0"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="cgi +fuse static-libs"

RDEPEND="
	acct-group/mfs
	acct-user/mfs
	cgi? ( dev-lang/python:= )
	!sys-cluster/moosefs
	app-text/asciidoc
	dev-libs/judy
	sys-apps/util-linux
	fuse? ( >=sys-fs/fuse-2.6:0= )"
DEPEND="${RDEPEND}
		dev-libs/boost"

PATCHES=( "${FILESDIR}"/iostat-${PV}.patch )

pkg_setup() {
	mycmakeargs=(-DCMAKE_BUILD_TYPE=Release -DENABLE_TESTS=NO -DCMAKE_INSTALL_PREFIX=/ -DENABLE_DEBIAN_PATHS=YES -DBUILD_SHARED_LIBS=OFF)
}

src_install() {
	cmake_src_install

	diropts -m0750 -o mfs -g mfs
	dodir "/var/lib/mfs"

}
