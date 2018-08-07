#!/bin/sh
SRCDIR=$(cd $(dirname $0); pwd)
cd ~/lacity/agendalinks
if sh $SRCDIR/grab-agenda.sh
then
  sh -x $SRCDIR/report-cis.sh > report.html
fi
