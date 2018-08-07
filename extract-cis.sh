#!/bin/sh
# For each council file number in cfnums.txt:
#   Extract its title to $cfnum.title
#   Extract any CIS to $cfnum.cis
set -ex

for cfnum in $(cat cfnums.txt)
do
   grep 'id="title"' < ./$cfnum.html | sed 's/.*value="//;s/".*//' > ./$cfnum.title
   grep -i "href.*Community Impact Statement submitted by" < ./$cfnum.html | sed 's/.*href="//;s/".*.ubmitted .y/ /;s/<.*//' | sort -u >  ./$cfnum.cis
   if ! test -s ./$cfnum.cis
   then
      rm ./$cfnum.cis
   fi
done
