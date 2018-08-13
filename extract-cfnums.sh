#!/bin/sh
# For extracting council file numbers from 
# a http://cityclerk.lacity.org/cvvs/search/search.cfm
# report
cat *.txt | grep 'Council File #' | sed 's/.*	//' | tr ',' '\012' | sort -u | grep '[0-9]' > cfnums.txt
