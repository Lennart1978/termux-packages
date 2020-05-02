TERMUX_PKG_HOMEPAGE=http://gtkwave.sourceforge.net/
TERMUX_PKG_DESCRIPTION="A wave viewer which reads LXT, LXT2, VZT, GHW and VCD/EVCD files"
TERMUX_PKG_LICENSE="GPL-2.0, MIT"
TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com>"
TERMUX_PKG_VERSION=3.3.104
TERMUX_PKG_REVISION=4
TERMUX_PKG_SRCURL=http://gtkwave.sourceforge.net/gtkwave-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=d20dd1a9307b908439c68122a9f81d3ff434a6bfa5439f0cb01398fec650894f
TERMUX_PKG_DEPENDS="bzip2, gtk2, desktop-file-utils, libandroid-shmem, xz-utils"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-tcl --disable-mime-update"
