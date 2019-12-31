#!/bin/sh
# For each council file number in $1:
#   Extract its title to $cfnum.title
#   Extract any CIS to $cfnum.cis, and create $cfnum.rows

case "$1" in
""|"-h"|"--help") echo "Usage: $0 cfnums.txt"; exit 1;;
*) ;;
esac

SRCDIR=$(cd $(dirname $0); pwd)
set -e

for cfnum in $(cat $1)
do
   grep 'id="title"' < ./$cfnum.html | sed 's/.*value="//;s/".*//' > ./$cfnum.title

   egrep -i "href.*Community Impact Statement (from|submitted by)" < ./$cfnum.html | sed -E 's/.*href="//;s/".*(submitted by|from)/ /I;s/<.*//' | sort -u >  ./$cfnum.cis
   if test -s ./$cfnum.cis
   then
      $SRCDIR/format-one-cf.sh $cfnum > $cfnum.rows
   else
      rm ./$cfnum.cis
   fi
done
