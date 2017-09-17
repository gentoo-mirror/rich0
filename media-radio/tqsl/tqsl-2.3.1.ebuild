# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils cmake-utils

DESCRIPTION="ARRL Logbook of the World"
HOMEPAGE="http://www.arrl.org/tqsl-download"
SRC_URI="http://www.arrl.org/files/file/LoTW%20Instructions/${P}.tar.gz"

LICENSE="LOTW"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}"

DOCS=( AUTHORS.txt INSTALL README )
HTML_DOCS=( html )
