#!/bin/sh
# For each council file number $cfnum in file $1:
#   create $cfnum.rows ready for inclusion in html reports.

case "$1" in
""|"-h"|"--help") echo "Usage: $0 cfnums.txt"; exit 1;;
*) ;;
esac
cfnumsfile="$1"

SRCDIR=$(cd $(dirname $0); pwd)
set -e

# Extract date from URL of CIS, canonicalize
cisurl_to_yyyymmdd() {
   # 1. Remove uninteresting parts of URL
   # 2. Add missing dash if needed (e.g. 14-0656-S9_cis_12-1315.pdf should be 14-0656-S9_cis_12-13-15.pdf)
   # 3. Zero-extend M, D.  Century-extend Y.
   # 4. Date is MM-DD-YYYY but swizzle it to YYYY-MM-DD to be sortable
   sed -E 's/[a-z]?\.pdf//I;s/.*_//' |
   sed -E 's/^([0-9][0-9])-([0-9][0-9])([0-9][0-9])$/\1-\2-\3/' |
   sed -E 's/^([0-9])-/0\1-/;s/-([0-9])-/-0\1-/;s/-([0-6][0-9])$/-20\1/' |
   awk -F- '{print $3"-"$1"-"$2}'
}

test_cisurl_to_yyyymmdd() {
   if test "$(echo http://clkrep.lacity.org/onlinedocs/2019/19-1464_CIS_12252019091441_12-25-19.pdf | cisurl_to_yyyymmdd)" != 2019-12-25
   then
      echo "cisurl_to_yyyymmdd is broken"
      exit 1
   fi
   if test "$(echo http://clkrep.lacity.org/onlinedocs/2014/14-0656-S9_cis_12-1315.pdf | cisurl_to_yyyymmdd)" != 2015-12-13
   then
      echo "cisurl_to_yyyymmdd is broken (dash)"
      exit 1
   fi
}
# Uncomment to run test.
#test_cisurl_to_yyyymmdd

# Output one row for a .rows file.
format_row() {
   echo "<tr><th align=left><a href=\"$cfurl\">$cfnum</a>"
   echo "<td><a href=\"$cfurl\">$cftitle</a>"
   case "$cisurl" in
   "")
      echo "<td>"
      echo "<td>"
      ;;
   *)
      echo "<td><a href=\"$cisurl\">$cisnc</a>"
      echo "<td>$cisdate"
      ;;
   esac
}

# Given a council file number, read its .html file, create its .rows file.
format_one_cf() {
   local cfnum=$1
   local cfhtmlfile="$cfnum.html"
   local cftitle="$(grep 'id="title"' < $cfhtmlfile | sed 's/.*value="//;s/".*//')"
   local cfurl="https://cityclerk.lacity.org/lacityclerkconnect/index.cfm?fa=ccfi.viewrecord&cfnumber=$cfnum"

   # Scrape the council file .html, transforming it into a series of lines
   # consisting of a url followed by a space and a neighborhood council file name.
   # Then iterate over those lines...
   grep -E -i "href.*Community Impact Statement (from|submitted by)" < $cfhtmlfile |
     sed -E 's/.*href="//;s/".*(from|submitted by)/ /I;s/<.*//' |
     sort -u |
     while IFS= read -r line
   do
      # Note: variables set in this block are local because it's in a subshell!
      # Split the line into CIS url and neighborhood council name.
      cisurl=$(echo "$line" | sed 's/ .*//')
      cisnc=$(echo "$line"  | sed 's/^[^ ]* //' | $SRCDIR/canonicalize-nc.sh)
      # Scrape the date from the CIS url.
      cisdate=$(echo "$cisurl" | cisurl_to_yyyymmdd)
      # Output them all as a row.
      format_row
   done > $cfnum.rows

   # No rows?  Output one without any CIS.
   if ! test -s $cfnum.rows
   then
      format_row > $cfnum.rows
   fi
}

# For each council file number in the given file, output its .rows file.
while read n
do
   format_one_cf $n
done < "$cfnumsfile"
