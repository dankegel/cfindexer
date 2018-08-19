#!/bin/sh
set -ex
exec > /tmp/dank.cis.log 2>&1

echo $PATH
PATH=${PATH}:/usr/local/bin

SRCDIR=$(cd $(dirname $0); pwd)
cd ~/lacity/agendalinks
report=false
if sh $SRCDIR/grab-agenda.sh
then
  report=true
fi
mkdir -p hotsheets
cd hotsheets
if sh $SRCDIR/grab-hotsheet.sh
then
  report=true
fi
cd ..
if $report
then
  sh -x $SRCDIR/report.sh
fi
