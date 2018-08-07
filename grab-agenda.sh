#!/bin/sh
# Look for new city council meeting calendar item.
# If one is found, download to los-angeles-city-council-agenda-N,
# create directory N, extract into that directory:
#   date.txt: meeting date
#   agenda.url: url of agenda
#   agenda.html: body of agenda
#   cfnums.txt: council file numbers mentioned in this agenda
# On success, run grab-files.sh in that directory.

set -ex
SRCDIR=$(cd $(dirname $0); pwd)

mkdir -p ~/lacity/agendalinks
cd ~/lacity/agendalinks
old=$(ls los-angeles-city-council-agenda-* | tail -n 1 | sed 's/.*agenda-//')
new=$((old + 1))

# Check calendar system for new meeting agenda
if ! wget https://calendar.lacity.org/event/los-angeles-city-council-agenda-$new
then
   echo No new agenda
   exit 1
fi
mkdir $new
cd $new

# Save date of meeting and url of agenda
cat ../los-angeles-city-council-agenda-$new | grep 'Event Date' | sed 's/.*dateTime[^>]*>//;s/ -.*//' > date.txt
grep href.*agendas < ../los-angeles-city-council-agenda-$new | sed 's,.*href=",,;s,".*,,' > agenda.url

sleep 1
if ! wget $(cat agenda.url)
then
   echo "Could not fetch new agenda"
   exit 1
fi

fname=$(cat agenda.url | sed 's,.*/,,')
mv $fname agenda.html
if ! grep https://cityclerk.lacity.org/lacityclerkconnect/index.cfm < agenda.html | sed 's/.*cfnumber=//;s,".*,,'  > cfnums.txt
then
   echo "Could not get council file numbers"
   rm -f cfnums.txt
   exit 1
fi

sh $SRCDIR/grab-files.sh
sh $SRCDIR/extract-cis.sh
