#!/bin/sh
# Look for new city council community impact statments.
# If any are found, create a directory with the date in the name,
# and save the council file numbers they're about to cfnums.txt.
# On success, run grab-files.sh and extract-cis in that directory.

set -e
SRCDIR=$(cd $(dirname $0); pwd)

mkdir -p ~/lacity/agendalinks
cd ~/lacity/agendalinks

nowish=update-$(date +%Y-%m-%d-%H-%M-%S)
mkdir $nowish
cd $nowish

# Fetch recent council file numbers that have interesting updates

last_week=$(date -v-1y "+%m/%d/%Y")
next_week=$(date -v+1y "+%m/%d/%Y")

# 2 referred
# 5 document submitted
# 22 community impact statment
# 25 referred - motion
# 34 introduced (rare)
( for action in 2 5 22 25 34
  do
    curl --data "btnAdvanced=Search&searchform=advanced&ActionTaken=$action&ActDateStart=$last_week&ActDateEnd=$next_week" 'https://cityclerk.lacity.org/lacityclerkconnect/index.cfm?fa=vcfi.doSearch' 2>/dev/null
  done
) | 
  tr ' ;"&' '\012' |
  grep cfnumber |
  sed 's/.*=//' |
  sort -u > cfnums.txt
if ! test -s cfnums.txt
then
   echo "Could not get council file numbers"
   rm -f cfnums.txt
   exit 1
fi

sh $SRCDIR/grab-files.sh cfnums.txt
sh $SRCDIR/extract-cis.sh cfnums.txt
