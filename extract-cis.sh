#!/bin/sh
# For each council file number in $1:
#   Extract its title to $cfnum.title
#   Extract any CIS to $cfnum.cis
#   Extract number of CFs with committee references to "$cat".cfnums

case "$1" in
""|"-h"|"--help") echo "Usage: $0 [--force] cfnums.txt"; exit 1;;
*) ;;
esac

SRCDIR=$(cd $(dirname $0); pwd)
set -ex

for cfnum in $(cat $1)
do
   grep 'id="title"' < ./$cfnum.html | sed 's/.*value="//;s/".*//' > ./$cfnum.title
   egrep -i "href.*Community Impact Statement (from|submitted by)" < ./$cfnum.html | sed -E 's/.*href="//;s/".*(submitted by|from)/ /I;s/<.*//' | sort -u >  ./$cfnum.cis
   if ! test -s ./$cfnum.cis
   then
      rm ./$cfnum.cis
   fi
done

# Committee names are in files named after the short version of the committee name
# The files should have commas everywhere one might be used.
# Missing commas in data files won't prevent a match.
# FIXME: Assumes council file numbers always have a dash in them, and
# any filename matching *-*.html is the contents of a council file.
for c in $SRCDIR/committees/*.comm
do
    cat=$(basename $c .comm)
    pat=$(sed 's/,/,?/' < $c)
    if ! egrep -li "$pat" *-*.html | sed 's/.html//' | grep '[0-9]' > "$cat".cfnums
    then
        rm -f "$cat".cfnums
    fi
done
