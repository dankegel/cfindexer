#!/bin/sh
# For each council file number in cfnums.txt:
#   Fetch its page to $cfnum.html
set -ex

for cfnum in $(cat cfnums.txt)
do
   wget "https://cityclerk.lacity.org/lacityclerkconnect/index.cfm?fa=ccfi.viewrecord&cfnumber=$cfnum" -O $cfnum.html
   sleep 1
done
