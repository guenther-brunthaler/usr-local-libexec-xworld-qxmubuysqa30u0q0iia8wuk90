#! /bin/false


# $1 must be set to the name of the service target.
# $2 must be the name of the service function to be called.
# (Will typically be "start" or "stop".)


test -z "$RC_GOT_FUNCTIONS" \
	&& . /usr/local/libexec/xworld/sh/gentoo-functions.sh
(
	SVCNAME=$1
	RC_QUIET_STDOUT=yes
	if test -f /etc/init.d/"$SVCNAME"
	then
		test -f /etc/conf.d/"$SVCNAME" && . /etc/conf.d/"$SVCNAME"
		. /etc/init.d/"$SVCNAME"
		"$2"
	fi
) > /dev/null 2>& 1
