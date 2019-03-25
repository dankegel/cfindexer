#!/bin/sh
SRCDIR=$(cd $(dirname $0); pwd)
for f in */cfnums.txt
do
   d=$(dirname $f)
   (cd $d && sh $SRCDIR/extract-cis.sh cfnums.txt)
done
sh $SRCDIR/report-topics.sh
sh $SRCDIR/report-index.sh
