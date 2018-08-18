#!/bin/sh
set -e

SRCDIR=$(cd $(dirname $0); pwd)

exec > report.html

cat <<_EOF_
<html>
<head>
<title>Los Angeles City Council Files</title>
</title>
<body>
<h1>Los Angeles City Council Files</h1>

The Los Angeles City Council records their work on each topic in
what's called a Council File, stored in the
<a href="https://cityclerk.lacity.org/lacityclerkconnect/">Council File Management System</a>.
Also, Council and committee meetings are recorded, and
you can play <a href="https://www.lacity.org/your-government/meeting-audiovideo/council-meeting-video">audio and video of past meetings</a>.
Both of those sources are searchable (try it!), but aren't great at giving an overview, especially if you're interested in neighborhood council Community
Impact Statements.
<p>
So we put together a simple spreadsheet of all files on the city council's agenda since 2013, showing which neighborhood councils have submitted CIS's.
Since that's really big, we also put together a smaller spreadsheet showing just council files with CIS's, as well as a few showing just
council files that mentioned certain major committees. (Since committee names change, those may not be complete; caveat lector.)
<p>
<h2>Council Files</h2>
<ul>
<li><a href="report-all.html">All</a>
<li><a href="report-cis.html">With Community Impact Statements</a>
_EOF_

for c in $SRCDIR/committees/*.comm
do
    cn="$(sed 's/\|.*//' < $c)"
    cat=$(basename $c .comm)
    echo "<li><a href=\"report-$cat.html\">Related to $cn"
done
echo "</table>"
echo "</body>"
echo "</html>"
