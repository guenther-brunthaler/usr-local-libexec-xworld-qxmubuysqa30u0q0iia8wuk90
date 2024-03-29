#! /bin/false
# *Source* this file from another file with the same name, only containing
# something like this:
#
# >#! /bin/sh
# >. /usr/local/libexec/xworld/sh/_AAA_DELETE_OUTDATED.sh
#
# (Obviously you might have to adjust the path.) Sourcing is necessary because
# this script will "touch" the script sourcing it in order to remain at the
# top of the directory listing when sorted by date.
#
# The script gets the number of days (to keep younger files than that) from
# the script name, or from the basename of the directory otherwise. Also
# deletes all empty directories. Updates its own modification time and that of
# its containing directory in order for both to stay on top of the file list
# when sorted descending by date.
#
# Version 2023.249
# Copyright (c) 2017-2023 Guenther Brunthaler. All rights reserved.
# 
# This script is free software.
# Distribution is permitted under the terms of the GPLv3.

set -e
trap 'test $? = 0 || echo "$0 failed!" >& 2' 0
trap 'exit $?' INT TERM QUIT HUP
command -v xmessage > /dev/null
xset q > /dev/null
cleanup() {
	rc=$?
	test -n "$T" && rm -- "$T"
	test $rc = 0 || xmessage "$0 failed!"
}
T=
trap cleanup 0

dir=`dirname -- "$0"`
script=`basename -- "$0"`
test -f "$dir/$script"
touch -- "$dir/$script" "$dir"
dname=`readlink -f -- "$dir"`; dname=`basename -- "$dname"`
keep_days=
for name in "$script" "$dname"
do
	for pat in '[Dd]\(ays\)\{0,1\}' '[Tt]\(agen\)\{0,1\}'
	do
		pat='.*[^0-9]\([0-9]\{1,\}\)[^[:alnum:]]*'$pat'[^[:alnum:]]'
		if pat=`expr x"$name" : x"$pat"`
		then
			keep_days=$pat
			break 2
		fi
	done
done
test -n "$keep_days"

prune_dirs() {
	find . -depth ! -path . -type d -exec rmdir -- {} + 2> /dev/null || :
}

cd "$dir"
T=`mktemp -- "${TMPDIR:-/tmp}/${0##*/}.XXXXXXXXXX"`
find . -type f -ctime +$keep_days ! -path ./"$script" | sed 's:^\./::' > "$T"
prune_dirs
if test ! -s "$T"
then
	xmessage "No files are older than $keep_days days!"
elif
	{
		fold -sw 66 <<- . | sed 's/ *$//'
		Delete the following files which were put here (and have not
		been changed since) more than $keep_days days ago?
.
		echo; cat -- "$T"
	} | xmessage -file - -buttons OK:`true && echo $?`,Cancel:`false || echo $?`
then
	while IFS= read -r f
	do
		rm -- "$f"
	done < "$T"
	prune_dirs
	xmessage "The files have been deleted successfully!"
fi
