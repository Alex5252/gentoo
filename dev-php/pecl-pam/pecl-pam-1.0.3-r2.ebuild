# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PHP_EXT_NAME="pam"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="no"
DOCS=( README )

USE_PHP="php5-6 php7-0"

inherit php-ext-pecl-r3 pam

KEYWORDS="~amd64 ~x86"

DESCRIPTION="This extension provides PAM (Pluggable Authentication Modules) integration"
LICENSE="PHP-2.02"
SLOT="0"
IUSE="debug"

DEPEND="sys-libs/pam"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/${PV}-php7.patch" )

src_prepare() {
	#Fix DOS line endings
	for slot in $(php_get_slots); do
		php_init_slot_env "${slot}"
		sed -i 's/\r$//' -- pam.c || die
	done
	php-ext-source-r3_src_prepare
}

src_configure() {
	local PHP_EXT_ECONF_ARGS=( --with-pam=/usr $(use_enable debug) )
	php-ext-source-r3_src_configure
}

src_install() {
	pamd_mimic_system php auth account password
	php-ext-pecl-r3_src_install
}
