#!/bin/sh
set -ex
SRCDIR=$(cd $(dirname $0); pwd)

sh -x $SRCDIR/report-all.sh
sh -x $SRCDIR/report-cis.sh
sh -x $SRCDIR/report-committee.sh
sh -x $SRCDIR/report-topics.sh
sh -x $SRCDIR/report-index.sh
