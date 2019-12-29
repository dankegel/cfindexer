# Los Angeles Council File Monitoring

daily.sh: fetch latest data, generate new report, upload

grab-recent.sh: query for council files with recent action,
extract list of council file numbers to $today/cfnums.txt,
run grab-files.sh and extract-cis.sh on that file.

grab-files.sh: fetch council files named in given text file.

extract-cis.sh: for each council file named in given text file,
extract its URL and NC name to $foo.cis

report.sh: generate all HTML reports
report-all.sh: generate HTML report for all council files
report-cis.sh: generate HTML report for all council files with CIS's
report-committee.sh: generate HTML reports for each committee
report-topics.sh: generate HTML reports for each topic
report-one-cf.sh: given a council file number, output an HTML table row about it; used by report-*.sh
