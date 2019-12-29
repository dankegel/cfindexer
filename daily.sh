#!/bin/sh
set -ex
exec > /tmp/dank.cis.log 2>&1

echo $PATH
PATH=${PATH}:/usr/local/bin

SRCDIR=$(cd $(dirname $0); pwd)
cd ~/lacity/agendalinks
if sh -x $SRCDIR/grab-recent.sh
then
  sh -x $SRCDIR/report.sh
fi
