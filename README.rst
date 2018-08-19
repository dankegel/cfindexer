# Los Angeles Council File Monitoring

daily.sh: fetch latest data, generate new report, upload

grab-agenda.sh: fetch latest agenda, extract its list of council file
numbers to $n/cfnums.txt, run grab-files.sh on that file.

grab-hotsheet.sh: fetch latest hotsheet index, extract hotsheets to
$date.html, their council file numbers to $date.cfnums, and
call grab-files.sh on that file.

grab-files.sh: fetch council files named in given text file to $foo.html,
extract URL and NC name of any CIS to $foo.cis

report-cis.sh: generate HTML report of */*.cis

Note: want to extend back in time to before 2013?
grab-agenda.sh is good at staying up to date, and grab-hotsheets.sh is even better...
but not useful for previous years.
For historical council files, I used to manually search
http://cityclerk.lacity.org/cvvs/search/search.cfm,
saving the results for a previous year as YYYY/*.txt,
extract cf numbers with extract-cfnums.sh.
and manually running grab-files.sh in that directory.
Now I think a version of grab-hotsheet.sh that takes
a "archived referrals" URL from
from https://cityclerk.lacity.org/lacityclerkconnect/index.cfm?fa=c.search&tab=RJL
would be better, but I haven't set that up yet.
