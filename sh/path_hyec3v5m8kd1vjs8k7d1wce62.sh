#! /bin/false
# Source this snippet for modifying $PATH.
#
# The arguments may consist of any number of
# action statements, they will all be performed in the
# order specified.
#
# Supported action statements:
#
# --append <path>
#   Add <path> at the end of $PATH, but only if <path> is actually an existing
#   directory and if it is not already part of $PATH.
#
# --prepend <path>
#   Insert <path> before the beginning of $PATH, but only if <path> is
#   actually an existing directory and if it is not already part of $PATH.
#
# written in 2008 by Guenther Brunthaler


# Process a single action statement.
path_helper_hyec3v5m8kd1vjs8k7d1wce62() {
	local TARGET RPATH PCOMP OPT_FRONT
	OPT_FRONT=; TARGET=
	while test $# != 0; do
		case $1 in
			--prepend) OPT_FRONT=1; TARGET=$2; shift;;
			--append) TARGET=$2; shift;;
			*) break;;
		esac
		shift
	done
	test ! -d "$TARGET" && return
	RPATH=$PATH
	while true; do
		PCOMP=${RPATH%%:*}
		test x"$PCOMP" = x"$TARGET" && return
		test x"$PCOMP" = x"$RPATH" && break
		RPATH=${RPATH#$PCOMP:}
	done
	if test -n "$OPT_FRONT"; then
		PATH=$TARGET${PATH:+:}$PATH
	else
		PATH=$PATH${PATH:+:}$TARGET
	fi
	export PATH
}


# Process a list of action statements.
path_hyec3v5m8kd1vjs8k7d1wce62() {
	while test $# != 0; do
		case $1 in
			--append | --prepend)
				path_helper_hyec3v5m8kd1vjs8k7d1wce62 \
					"$1" "$2"
				shift
				;;
			*)
				echo "Warning: Ignored arguments >>>$*<<<" \
					>& 2
				return 1
				;;
		esac
		shift
	done
}


# Avoid namespace pollution and symbol clashes.
path_hyec3v5m8kd1vjs8k7d1wce62 "$@"
unset -f path_hyec3v5m8kd1vjs8k7d1wce62 \
	path_helper_hyec3v5m8kd1vjs8k7d1wce62
