#!/bin/sh
set -ex

echo $PATH
PATH=${PATH}:/usr/local/bin

SRCDIR=$(cd $(dirname $0); pwd)

nowish=data-recent-$(date +%Y-%m-%d-%H-%M-%S)

# There are a lot of data files, so keep them down one level from the reports.
mkdir -p data
cd data
sh $SRCDIR/query-recent.sh > cfs-$nowish.txt
if ! test -s cfs-$nowish.txt
then
  rm cfs-$nowish.txt
  echo "No updated council files found"
  exit 0
fi
sh $SRCDIR/grab-files.sh --force cfs-$nowish.txt
sh $SRCDIR/extract-cis.sh cfs-$nowish.txt
sh $SRCDIR/find-topics.sh
sh $SRCDIR/report.sh
# Atomically update all the reports with a single mv.
mv report-*.html ..
cd ..
