#! /bin/false
# Usage:
#
# test -z "$RC_GOT_FUNCTIONS" || \
#	. /usr/local/libexec/xworld/sh/gentoo-functions.sh


. /usr/lib/portage/bin/isolated-functions.sh


sourcex_rr178tkua505tihzxvmy2rjsh() {
	if test "$1" = "-e"
	then
		shift
		test -e "$1" || return
	fi
	if ! . "$1"; then
		eerror "error loading $1"
		false; exit
	fi
}


sourcex_rr178tkua505tihzxvmy2rjsh /etc/init.d/functions.sh  
sourcex_rr178tkua505tihzxvmy2rjsh /lib64/rc/sh/rc-functions.sh
sourcex_rr178tkua505tihzxvmy2rjsh -e /etc/rc.conf

unset -f sourcex_rr178tkua505tihzxvmy2rjsh

RC_GOT_FUNCTIONS=yes
