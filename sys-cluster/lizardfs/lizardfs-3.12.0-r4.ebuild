# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit eutils autotools cmake

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
	fuse? ( >=sys-fs/fuse-2.6:0= )"
DEPEND="${RDEPEND}
		dev-libs/boost"

PATCHES=( "${FILESDIR}"/iostat-${PV}.patch )

pkg_setup() {
	mycmakeargs=(-DCMAKE_BUILD_TYPE=Release -DENABLE_TESTS=NO -DCMAKE_INSTALL_PREFIX=/ -DENABLE_DEBIAN_PATHS=YES -DCMAKE_BUILD_WITH_INSTALL_RPATH=true)
}

src_install() {
	cmake_src_install

	dolib.so "../${MY_P}_build/src/mount/fuse/libmount_fuse.so"
	dolib.so "../${MY_P}_build/src/common/libmfscommon.so"
	dolib.so "../${MY_P}_build/src/admin/liblizardfs-admin-lib.so"
	dolib.so "../${MY_P}_build/src/mount/libmount.so"
	dolib.so "../${MY_P}_build/src/chunkserver/libchunkserver.so"
	dolib.so "../${MY_P}_build/src/master/libmaster.so"
	dolib.so "../${MY_P}_build/src/metalogger/libmetalogger.so"
	dolib.so "../${MY_P}_build/src/metarestore/libmetarestore.so"
	dolib.so "../${MY_P}_build/src/protocol/liblzfsprotocol.so"
	dolib.so "../${MY_P}_build/external/libcrcutil.so"

	diropts -m0750 -o mfs -g mfs
	dodir "/var/lib/mfs"

}
