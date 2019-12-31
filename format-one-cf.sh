#!/bin/sh
# Given a council file number, if there are any CIS's for it,
# output corresponding html table rows.
#
# FIXME: this should probably just be part of extract-cis.sh

SRCDIR=$(cd $(dirname $0); pwd)

cf=$1
cftitle=$(cat ./"$cf".title | head -n 1 | cut -c1-105)
cfurl="https://cityclerk.lacity.org/lacityclerkconnect/index.cfm?fa=ccfi.viewrecord&cfnumber=$cf"
if test -f $cf.cis
then
   echo "Examining $cf.cis" >&2
   cat ./"$cf.cis" | sort -u | \
      while IFS= read -r line
      do
         cisurl=$(echo "$line" | sed 's/ .*//')
         cisnc=$(echo "$line" | sed -E 's/.*\.pdf *//' | $SRCDIR/canonicalize-nc.sh)
         # Extract date from filename
         # Make dates uniform; we could strip off the 20, or add it when missing...
         # Add missing dash if needed (e.g. 14-0656-S9_cis_12-1315.pdf should be 14-0656-S9_cis_12-13-15.pdf)
         # And, ugh, zero-extend.
         cisdate=$(echo "$cisurl" | sed -E 's/[a-z]?\.pdf//I;s/.*_//' | sed -E 's/^([0-9][0-9])-([0-9][0-9])([0-9][0-9])$/\1-\2-\3/' | sed -E 's/^([0-9])-/0\1-/;s/-([0-9])-/-0\1-/;s/-([0-6][0-9])$/-20\1/')
         # Date is M/D/Y but swizzle it to Y/M/D to be sortable
         # sorttable.js has date sorting, but it's broken, so I disabled it
         cisdate=$(echo "$cisdate" | awk -F- '{print $3"-"$1"-"$2}')
         echo "<tr><th align=left><a href=\"$cfurl\">$cf</a>"
         echo "<td><a href=\"$cfurl\">$cftitle</a>"
         echo "<td><a href=\"$cisurl\">$cisnc</a>"
         echo "<td>$cisdate"
      done
fi
