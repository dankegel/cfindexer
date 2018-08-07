#!/bin/sh
set -e

SRCDIR=$(cd $(dirname $0); pwd)

# Output is a single HTML table, with columns:
# CF#  NC-CIS  Title
# where title and cf# are links to the council file,
# and NC-CIS is a link to the CIS.

for c in $SRCDIR/committees/*.comm
do
    cn="$(cat $c)"
    cat=$(basename $c .comm)
    exec > report-$cat.html
    echo "<html>"
    echo "<head>"
    echo "<title>Los Angeles City Council files related to the $cn</title>"
    echo "</title>"
    echo "<body>"
    echo "<h1>Los Angeles City Council files related to the $cn</h1>"
    echo "Click on a column header to sort by that column.<p>"
    echo "Covers time period from Jan 1, 2017 to $(date)"
    echo "<p>Note: this is a prototype, and will move to a more permanent location soon."
    echo "<p>"
    echo "<script src="sorttable.js"></script>"
    echo "<table border=1 class=sortable>"
    echo "<tr><th>CF #"
    echo "<th>Council File Subject"
    echo "<th>See CIS from ..."
    echo "<th>CIS filed on"
    echo "</tr>"

    for cf in $(cat ./*/$cat.cfnums | sort -u)
    do
       cftitle=$(cat ./*/"$cf".title | head -n 1 | cut -c1-70)
       cfurl="https://cityclerk.lacity.org/lacityclerkconnect/index.cfm?fa=ccfi.viewrecord&cfnumber=$cf"
       n=$(find . -name $cf.cis | wc -l)
       if test $n -gt 0
       then
          echo "Examining $cf.cis" >&2
          cat ./*/"$cf.cis" | sort -u | \
             while IFS= read -r line
             do
                cisurl=$(echo "$line" | sed 's/ .*//')
                cisnc=$(echo "$line" | sed -E 's/.*\.pdf  //;s/ Neighborhood (Development )?Council//I;s/the //')
                # Extract date from filename
                # Make dates uniform; we could strip off the 20, or add it when missing...
                # And, ugh, zero-extend.
                cisdate=$(echo "$cisurl" | sed -E 's/[a-z]?\.pdf//I;s/.*_//' | sed -E 's/^([0-9])-/0\1-/;s/-([0-9])-/-0\1-/;s/-([0-6][0-9])$/-20\1/')
                # Date is M/D/Y but swizzle it to Y/M/D to be sortable
                # sorttable.js has date sorting, but it's broken, so I disabled it
                cisdate=$(echo "$cisdate" | awk -F- '{print $3"-"$1"-"$2}')
                echo "<tr><th align=left><a href=\"$cfurl\">$cf</a>"
                echo "<td><a href=\"$cfurl\">$cftitle</a>"
                echo "<td><a href=\"$cisurl\">$cisnc NC</a>"
                echo "<td>$cisdate"
             done
       else
          echo "<tr><th align=left><a href=\"$cfurl\">$cf</a>"
          echo "<td><a href=\"$cfurl\">$cftitle</a>"
          echo "<td>"
          echo "<td>"
       fi
    done
    echo "</table>"
    echo "</body>"
    echo "</html>"
done
