#!/bin/sh
set -ex
exec > /tmp/$LOGNAME.cis.log 2>&1

SRCDIR=$(cd $(dirname $0); pwd)

cd ~/lacity/agendalinks
sh $SRCDIR/daily.sh
