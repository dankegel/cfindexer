#!/bin/sh
# Retrieve ids of recently updated city council files.
#
# Input: nothing
# Output: prints one council file number per line to stdout

set -e
SRCDIR=$(cd $(dirname $0); pwd)

# Fetch recent council file numbers that have interesting updates
# FIXME: handle queries that overflow
# Note: in the -v option to date, -1w means a week's worth of data.
# You can use -1m instead to get a month's worth of data... or -1d to get one day's.

last_week=$(date -v-1w "+%m/%d/%Y")
next_week=$(date -v+1w "+%m/%d/%Y")

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
  sort -u
