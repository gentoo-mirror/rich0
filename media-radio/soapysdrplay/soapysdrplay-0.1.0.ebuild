# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="SoapySDR SDRPlay Support Module"
HOMEPAGE="https://github.com/pothosware/SoapySDRPlay"

if [ "${PV}" = "9999" ]; then
	EGIT_REPO_URI="https://github.com/pothosware/SoapySDRPlay.git"
	inherit git-r3
	KEYWORDS=""
else
	KEYWORDS="~amd64 ~x86"
	SRC_URI="https://github.com/pothosware/SoapySDRPlay/archive/soapy-sdrplay-${PV}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}"/SoapySDRPlay-soapy-sdrplay-"${PV}"
fi

LICENSE="MIT"
SLOT="0"

RDEPEND="net-wireless/soapysdr"
DEPEND="${RDEPEND}"
