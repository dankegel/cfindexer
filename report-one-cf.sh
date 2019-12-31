#!/bin/sh
# Given a council file number, output at least one table row about it.
# Any interesting contents should already have been cached by
# format-one-cf.sh.

SRCDIR=$(cd $(dirname $0); pwd)

cf=$1
if test -f $cf.rows
then
   cat $cf.rows
else
   cftitle=$(cat ./"$cf".title | head -n 1 | cut -c1-105)
   cfurl="https://cityclerk.lacity.org/lacityclerkconnect/index.cfm?fa=ccfi.viewrecord&cfnumber=$cf"
   echo "<tr><th align=left><a href=\"$cfurl\">$cf</a>"
   echo "<td><a href=\"$cfurl\">$cftitle</a>"
   echo "<td>"
   echo "<td>"
fi
