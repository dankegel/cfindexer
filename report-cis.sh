#!/bin/sh
set -e

# Output is a single HTML table, with columns:
# CF#  NC-CIS  Title
# where title and cf# are links to the council file,
# and NC-CIS is a link to the CIS.

echo "<html>"
echo "<head>"
echo "<title>Los Angeles City Council files with Community Impact Statements</title>"
echo "</title>"
echo "<body>"
echo "<h1>Los Angeles City Council files with Community Impact Statements</h1>"
echo "Click on a column header to sort by that column.<p>"
echo "Covers time period from Jan 1, 2017 to $(date)"
echo "<p>Note: this is a prototype, and will move to a more permanent location soon."
echo "<p>"
echo "<script src="sorttable.js"></script>"
echo "<table border=1 class=sortable>"
echo "<tr><th>CF #"
echo "<th>Council File Subject"
echo "<th>See CIS from ..."
echo "</tr>"

for cf in $(cat ./*/cfnums.txt | sort -u)
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
            cisnc=$(echo "$line" | sed 's/.*\.pdf  //;s/ Neighborhood Council//I;s/the //')
            echo "<tr><th align=left><a href=\"$cfurl\">$cf</a>"
            echo "<td><a href=\"$cfurl\">$cftitle</a>"
            echo "<td><a href=\"$cisurl\">$cisnc NC</a>"
         done
   fi
done
echo "</table>"
echo "</body>"
echo "</html>"
