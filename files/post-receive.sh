#!/bin/bash

# driver script to run multiple post-receive "hooklets".  Each "hooklet" performs a
# specific (possibly site-local) check, and they *all* have to succeed for the
# push to succeed.

# HOW TO USE:

# (1) clone gitolite as you would for an upgrade (or install)
# (2) rename this file to remove the .sample extension
# (3) make the renamed file executable (chmod +x)
# (4) create a directory called post-receive.d in hooks/common
# (5) copy all the update "hooklets" you want (like update.detect-dup-pubkeys)
#     from contrib or wherever, to that directory
# (6) make them also executable (chmod +x)
# (7) install/upgrade gitolite as normal so all these files go to the server

# rules for writing a hooklet are in the sample hooklet called
# "update.detect-dup-pubkeys" in contrib

# ----

# NOTE: a hooklet runs under the same assumptions as the 'update' hook, so the
# starting directory must be maintained and arguments must be passed on.

[ -d hooks/post-receive.d ] || exit 0

UNIXSECONDS=`date +%s`
STDINFILE="/tmp/post-receive-$UNIXSECONDS"

# preserve stdin to pass to the commands
while read line ; do
  echo $line >> $STDINFILE
done

# all output from these "hooklets" must go to STDERR to avoid confusing the client
exec >&2

EXITCODE=0

for i in hooks/post-receive.d/*
do
    [ -x "$i" ] || continue
    # call the hooklet with the same arguments we got
    echo running $i $@
    "$i" "$@" < $STDINFILE  || {
        # hooklet failed; we need to log it...
        echo hooklet $i failed
        perl -I$GL_BINDIR -Mgitolite -e "log_it('hooklet $i failed')"
        # ...and send back some non-zero exit code ;-)
        export EXITCODE=1
    }
done

rm $STDINFILE

exit $EXITCODE

