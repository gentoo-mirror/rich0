# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit eutils systemd flag-o-matic

DESCRIPTION="decode and send infra-red signals of many commonly used remote controls"
HOMEPAGE="http://www.lirc.org/"

MY_P=${PN}-${PV/_/}

if [[ "${PV/_pre/}" = "${PV}" ]]; then
	SRC_URI="mirror://sourceforge/lirc/${MY_P}.tar.bz2"
else
	SRC_URI="http://www.lirc.org/software/snapshots/${MY_P}.tar.bz2"
fi

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86"
IUSE="doc static-libs X audio irman ftdi inputlirc iguanair"

S="${WORKDIR}/${MY_P}"

REQUIRED_USE="
	iguanair? ( irman )
"
DEPEND="
	doc? ( app-doc/doxygen )
"

RDEPEND="
	X? (
		x11-libs/libX11
		x11-libs/libSM
		x11-libs/libICE
	)
	audio? (
		>media-libs/portaudio-18
		media-libs/alsa-lib
	)
	irman? ( media-libs/libirman )

	iguanair? ( app-misc/iguanaIR )

	ftdi? ( dev-embedded/libftdi:0 )

	inputlirc? ( app-misc/inputlircd )
"

pkg_setup() {

	# set default configure options															Any ideas what is this used for now?
	LIRC_DRIVER_DEVICE="/dev/lirc0"

	filter-flags -Wl,-O1
}

src_prepare() {
	# Rip out dos CRLF
	edos2unix contrib/lirc.rules
}

src_configure() {
	econf \
		$(use_enable static-libs static) \
		$(use_with X x)
}

	#	ARCH="$(tc-arch-kernel)"
	#	ABI="${KERNEL_ABI}" \													i have no idea how to make it work. Inherit kernel-2 cause errors and linux-info does not have such feature

	#	--localstatedir=/var \													To avoid QA Notice leave it in here. No need to use it during install / after the first run lircd creates this dir
#src_compile() {
	# force non-parallel make, Bug 196134 (confirmed valid for 0.9.0-r2)						@QA: works fine with 0.9.3a
#	emake -j1
#
#}

src_install() {
	emake DESTDIR="${D}" install

	newinitd "${FILESDIR}"/lircd-0.9.3 lircd
	newinitd "${FILESDIR}"/lircmd lircmd
	newconfd "${FILESDIR}"/lircd.conf.4 lircd

	insinto /etc/modprobe.d/
	newins "${FILESDIR}"/modprobed.lirc lirc.conf

	newinitd "${FILESDIR}"/irexec-initd irexec
	newconfd "${FILESDIR}"/irexec-confd irexec

	systemd_dounit "${FILESDIR}"/irexec.service

	if use doc ; then
		dohtml doc/html/*.html
		insinto /usr/share/doc/${PF}/images
		doins doc/images/*
	fi

	keepdir /etc/lirc
	if [[ -e "${D}"/etc/lirc/lircd.conf ]]; then
		newdoc "${D}"/etc/lirc/lircd.conf lircd.conf.example
	fi

	use static-libs || rm "${D}/usr/$(get_libdir)/liblirc_client.la"
}

pkg_preinst() {

	local dir="${EROOT}/etc/modprobe.d"
	if [[ -a "${dir}"/lirc && ! -a "${dir}"/lirc.conf ]]; then
		elog "Renaming ${dir}/lirc to lirc.conf"
		mv -f "${dir}/lirc" "${dir}/lirc.conf"
	fi

	# copy the first file that can be found
	if [[ -f "${EROOT}"/etc/lirc/lircd.conf ]]; then
		cp "${EROOT}"/etc/lirc/lircd.conf "${T}"/lircd.conf
	elif [[ -f "${EROOT}"/etc/lircd.conf ]]; then
		cp "${EROOT}"/etc/lircd.conf "${T}"/lircd.conf
		MOVE_OLD_LIRCD_CONF=1
	elif [[ -f "${D}"/etc/lirc/lircd.conf ]]; then
		cp "${D}"/etc/lirc/lircd.conf "${T}"/lircd.conf
	fi

	# stop portage from touching the config file
	if [[ -e "${D}"/etc/lirc/lircd.conf ]]; then
		rm -f "${D}"/etc/lirc/lircd.conf
	fi

}

pkg_postinst() {

	# copy config file to new location
	# without portage knowing about it
	# so it will not delete it on unmerge or ever touch it again
	if [[ -e "${T}"/lircd.conf ]]; then
		cp "${T}"/lircd.conf "${EROOT}"/etc/lirc/lircd.conf
		if [[ "$MOVE_OLD_LIRCD_CONF" = "1" ]]; then
			elog "Moved /etc/lircd.conf to /etc/lirc/lircd.conf"
			rm -f "${EROOT}"/etc/lircd.conf
		fi
	fi

	einfo "The new default location for lircd.conf is inside of"
	einfo "/etc/lirc/ directory"
}
