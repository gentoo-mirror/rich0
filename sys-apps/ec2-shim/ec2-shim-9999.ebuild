# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils git-r3

DESCRIPTION="Files necessary to run a gentoo ec2 instance."
HOMEPAGE="https://github.com/rich0/gentoo-ec2-shim"
#SRC_URI="ftp://foo.example.org/${P}.tar.gz"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"

IUSE=""

DEPEND=""

RDEPEND="${DEPEND}"

EGIT_REPO_URI="https://github.com/rich0/gentoo-ec2-shim.git"

# Source directory; the dir where the sources can be found (automatically
# unpacked) inside ${WORKDIR}.  The default value for S is ${WORKDIR}/${P}
# If you don't need to change it, leave the S= line out of the ebuild
# to keep it tidy.
#S=${WORKDIR}/${P}


src_install() {
  cd "${S}/image/"
  cp -R "." "${D}/" || die "Install failed!"
}

