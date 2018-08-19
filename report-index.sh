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
what's called a Council File.  These are stored in the
nicely searchable <a href="https://cityclerk.lacity.org/lacityclerkconnect/">Council File Management System</a>
and <a href="https://www.lacity.org/your-government/meeting-audiovideo/council-meeting-video">audio and video recording system</a>.
<p>
Upcoming meetings are listed on the <a href="https://www.lacity.org/your-government/la-calendars/public-meeting-calendar">Public
Meeting Calendar</a> along with links to the related agendas and council files.  New council files which have are not yet on the
calendar can be found in the <a href="https://cityclerk.lacity.org/lacityclerkconnect/index.cfm?fa=c.search&tab=RJL">Council and Committee Referral "Hot Sheet"</a>.
<p>
Those sources aren't great at giving an overview, especially if you're interested in neighborhood council Community Impact Statements,
so we put together a rough spreadsheet of city council file activity since 2013, including which neighborhood councils have submitted CIS's.
Since that's really big, we also put together a smaller spreadsheet showing just council files with CIS's, as well as a few showing just
council files that mentioned certain major committees. (Since committee names change, those may not be complete; caveat lector.)
<p>
The spreadsheets are a work in progress.  Please write dank@kegel.com with comments or suggestions.
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
