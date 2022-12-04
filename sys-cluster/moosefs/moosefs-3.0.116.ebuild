# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_8 python3_9 python3_10 python3_11 )

inherit python-r1

MY_P="moosefs-${PV}"
S="${WORKDIR}/${MY_P}"

DESCRIPTION="MooseFS is an Open Source Distributed File System licenced under GPLv2."
HOMEPAGE="https://moosefs.com"
SRC_URI="https://github.com/moosefs/moosefs/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="cgi chunkserver cli +client master metalogger netdump static-libs supervisor"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	acct-group/mfs
	acct-user/mfs
	!sys-cluster/lizardfs
	app-text/asciidoc
	dev-libs/judy
	sys-apps/util-linux
	client? ( >=sys-fs/fuse-2.6:0= )
	cgi? ( ${PYTHON_DEPS} )"

DEPEND="${RDEPEND}
		dev-libs/boost"

src_configure() {
	econf --with-default-user=mfs --with-default-group=mfs \
	$(use_enable client mfsmount) \
	$(use_enable master mfsmaster ) \
	$(use_enable metalogger mfsmetalogger) \
	$(use_enable supervisor mfssupervisor) \
	$(use_enable chunkserver mfschunkserver) \
	$(use_enable cgi mfscgi) \
	$(use_enable cgi mfscgiserv) \
	$(use_enable cli mfscli) \
	$(use_enable netdump mfsnetdump)
}
