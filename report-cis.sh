#!/bin/sh
set -e

SRCDIR=$(cd $(dirname $0); pwd)

# Output is a single HTML table, with columns:
# CF#  NC-CIS  Title
# where title and cf# are links to the council file,
# and NC-CIS is a link to the CIS.

exec > report-cis.html
echo "<html>"
echo "<head>"
echo "<title>Los Angeles City Council files with Community Impact Statements</title>"
echo "</title>"
echo "<body>"
echo "<h1>Los Angeles City Council files with Community Impact Statements</h1>"
echo "<small><a href=".">Back to index</a></small><p>"
echo "Click on a column header to sort by that column.<p>"
echo "Covers Jan 1, 2013 to $(date)"
echo "<p>Note: this is a prototype, and may move to a more permanent location soon."
echo "<p>"
echo "<script src="sorttable.js"></script>"
echo "<table border=1 class=sortable>"
echo "<tr><th>CF #"
echo "<th>Council File Subject"
echo "<th>See CIS from ..."
echo "<th>CIS filed on"
echo "</tr>"

find . -name '*-*.cis' | sed 's/.cis//;s,^./,,' | sort -r | xargs -n 1 sh $SRCDIR/format-one-cf.sh

echo "</table>"
echo "<small><a href=".">Back to index</a></small><p>"
echo "</body>"
echo "</html>"
