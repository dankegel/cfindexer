#!/bin/sh
# Topic/committee search.
# Input: All .html files in ., plus topics and committees filters from $SRCDIR
# Output: for each topic or committee, creates $foo.cfnums containing one matching council file number per line.

SRCDIR=$(cd $(dirname $0); pwd)
set -e

# Committee names are in files named after the short version of the committee name
# The files should have commas everywhere one might be used.
# Missing commas in data files won't prevent a match.
for c in $SRCDIR/committees/*.comm
do
    cat=$(basename $c .comm)
    pat=$(sed 's/,/,?/' < $c)
    if ! $SRCDIR/list-files.sh |
        xargs egrep -w -li "$pat" |
        sed 's/.html//' |
        grep . > "$cat".cfnums
    then
        rm -f "$cat".cfnums
    fi
done

# Topic patterns are in files named after the topic
for patfile in $SRCDIR/topics/*.pat
do
    topic=$(basename $patfile .pat)
    antipatfile="$SRCDIR/topics/"$(basename $patfile .pat)".antipat"
    if ! test -f "$antipatfile"
    then
        antipatfile=/dev/null
    fi
    if ! $SRCDIR/list-files.sh |
        xargs egrep -w -i -L -f $antipatfile |
        xargs egrep -w -i -l -f $patfile |
        sed 's/\.html//' |
        grep . > "$topic".cfnums
    then
        rm "$topic".cfnums
    fi
done
