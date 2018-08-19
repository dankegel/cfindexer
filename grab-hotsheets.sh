#!/bin/sh
# Download the current city council hotsheet index.
# For each hotsheet URL in the index, download that url's contents,
# then extract its council file numbers to date.cfnums
# and call grab-files.sh on it.
# Also create grand list of all council file numbers in cfnums.txt.
# Exit status is true if new files were fetched.

set -e
SRCDIR=$(cd $(dirname $0); pwd)

result=false

for url in $(curl --fail 'https://ens3.lacity.org/enssubscribe/netdocs/index.cfm?catid=9&SI&SP&DS=2&DD=2&CSS=77113&rootcat=9' | grep href.*Refer | sed 's,</a.*,,;s/.*href="//;s/".*//' )
do
   date=$(echo "$url" | sed 's/.*_//;s/\.htm.*//' | sed -E 's/^(..)(..)(....)/\3\1\2/' )
   furl=$(basename $url)
   if ! test -s "$furl"
   then
      curl --fail "$url" > "$furl"
      # sometimes the date suffix in the URL is just wrong, causing confusion and delay, e.g. 
      # http://ens.lacity.org/clk/referralmemo/clkreferralmemo9119006_03232018.htm should be 02232018!
      tdate=$(grep 'valign.*For [A-Z][a-z]*,' < "$furl" | sed 's,</font.*,,;s/.*For [A-Z][a-z]*, //')
      xdate=$(date  -j -f '%B %d, %Y' "$tdate" +%Y%m%d)
      if test "$xdate" != "$date"
      then
          echo "Correcting incorrect date on $furl to be $xdate"
          date="$xdate"
      fi
      grep lacityclerkconnect.*index < "$furl" | sed 's,.*">,,;s/<.*//' > $date.cfnums
      # Pass --force to fetch them even if they already exist -- maybe they've been updated?
      if test -s $date.cfnums && sh $SRCDIR/grab-files.sh $date.cfnums && sh $SRCDIR/extract-cis.sh $date.cfnums
      then
         result=true
      fi
   fi
done

# For the benefit of report-*.sh, create an overall list of council file numbers
cat *.cfnums | sort -u > cfnums.txt

# Set exit status
$result
