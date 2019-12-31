# Los Angeles Council File Monitoring

This will query lacouncilfile.com daily for changes, and
for each updated council file ID, create
ID.html, ID.title, and maybe ID.cis in the data subdirectory.
Then outputs giant static files report-html

The data directory gets quite large, so large that
things like ```ls *.html``` fail because of commandline limits.
These scripts use find and xargs to get around that problem.

Here's how the scripts are organized.
For debugging, run daily.sh in an empty directory to see what it does;
the other scripts are easy to run separately, too.
For production, run cronjob.sh from your crontab.

cronjob.sh calls:
 daily.sh

daily.sh calls:
 query-recent.sh: output IDs of council files with recent action
 grab-files.sh: fetch council files with given IDs to $ID.html
 extract-cis.sh: for council files with given IDs, extract their URL and NC name to $ID.cis, and title to $ID.title
 find-topics.sh: for each topic or committee, search *.html and *.title, save matches in $topic.cfnums
 report.sh: generate all HTML reports

report.sh calls:
 report-all.sh: generate HTML report for all council files
 report-cis.sh: generate HTML report for all council files with CIS's
 report-committee.sh: generate HTML reports for each committee
 report-topics.sh: generate HTML reports for each topic

report-*.sh calls:
 format-one-cf.sh: given a council file number, output an HTML table row about it; used by report-*.sh
