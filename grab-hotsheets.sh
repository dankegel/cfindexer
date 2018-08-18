#!/bin/sh
# Download the current city council hotsheet index.
# For each hotsheet URL in the index, create a file
#   date.url
# download that url's contents to
#   date.html
# then extract
#   date.cfnums: council file numbers mentioned in this hotsheet
# and call grab-files.sh on it.
# Also create grand list of all council file numbers in cfnums.txt.
# Exit status is true if new files were fetched.

set -ex
SRCDIR=$(cd $(dirname $0); pwd)

# Fetch urls of hotsheets
for url in $(curl --fail 'https://ens3.lacity.org/enssubscribe/netdocs/index.cfm?catid=9&SI&SP&DS=2&DD=2&CSS=77113&rootcat=9' | grep href.*Refer | sed 's,</a.*,,;s/.*href="//;s/".*//' )
do
   date=$(echo "$url" | sed 's/.*_//;s/\.htm.*//' | sed -E 's/^(..)(..)(....)/\3\1\2/' )
   echo "$url" > $date.url
done

result=false

# Fetch contents of hotsheets
for furl in *.url
do
   date=$(basename $furl .url)
   if ! test -s $date.html
   then
      url=$(cat $furl)
      curl --fail "$url" > $date.html
      grep lacityclerkconnect.*index < $date.html | sed 's,.*">,,;s/<.*//' > $date.cfnums
      # FIXME: Pass --force to fetch them even if they already exist -- maybe they've been updated?
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
