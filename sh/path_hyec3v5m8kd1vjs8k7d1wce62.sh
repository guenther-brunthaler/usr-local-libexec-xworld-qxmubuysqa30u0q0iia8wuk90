#! /bin/false
# Source this snippet for modifying and exporting $PATH.
#
# The arguments may consist of any number of action statements. They will all
# be performed in the order specified. If the path to be added is already part
# of $PATH, it will be removed from its old position before the addition. If
# one of the specified paths does not exist this path will be ignored
# silently.
# 
#
# Note that passing arguments to the "." command is *not* portable!
#
# Use the "set" command to set the arguments for sourcing this script, use the
# --stop option to save old arguments after it.
#
# Supported action statements:
#
# --variable <VARNAME>
#   The environment variable to modify. Defaults to "PATH". If this option is
#   used at all, it must be the very first option.
#
# --append <path>
#   Add <path> at the end of $PATH, but only if <path> is actually an existing
#   directory.
#
# --prepend <path>
#   Insert <path> before the beginning of $PATH, but only if <path> is
#   actually an existing directory.
#
# Options only valid after all action statements:
#
# --stop
#   Stops argument processing, leaving the remaining arguments set as $1 and
#   onward. This is needed if it is required to "save" previous arguments
#   after the --stop, which will become the current arguments again after
#   sourcing this script. Typically used as '--stop "$@"'.
#
# Version 14.328
# Written in 2008 - 2014 by Guenther Brunthaler


# Process a list of action statements.
path_hyec3v5m8kd1vjs8k7d1wce62() {
	local target var path prefix cmd
	var=PATH; path=:$PATH:
	while test $# != 0
	do
		case $1 in
			--variable)
				var=$2; eval "path=:\$$var:"
				shift 2; continue
				;;
			--prepend | --append) cmd=$1;;
			--stop) break;;
			*)
				echo "Warning: Ignored arguments >>>$*<<<" \
					>& 2
				false || return
				;;
		esac
		test -d "$2" || cmd=
		target=:$2:; shift 2
		while
			prefix=${path%"$target"*}
			test x"$prefix" != x"$path"
		do
			path=$prefix:${path##*"$target"}
		done
		case $cmd in
			--prepend) path=$target$path;;
			--append) path=$path$target
		esac
	done
	while
		prefix=${path%::*}
		test x"$prefix" != x"$path"
	do
		path=$prefix:${path##*::}
	done
	path=${path%:}; path=${path#:}
	eval "$var=\$path"; export $var
}


# Avoid namespace pollution and symbol clashes.
path_hyec3v5m8kd1vjs8k7d1wce62 "$@"
while test $# != 0
do
	if test x"$1" = x"--stop"
	then
		shift; break
	fi
	shift
done
unset -f path_hyec3v5m8kd1vjs8k7d1wce62
