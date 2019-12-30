#!/bin/sh
# Given a council file number, output a table row about it.
# If arg 2 is --cisonly, only output a row if there is no CIS.

# Reads name of NC on stdin, outputs tidied name on stdout
# See test cases in nc-variants.txt
tidy_nc() {
   # Handle typos and variants
   # Remove prefixes/suffixes like NC, NDC, Council of, Council, Development Council, or Neighborhood Council
   # Remove prefixes like by or the
   # Remove duplicated phases separated by commas (go figure)
   # Remove keywords e, 1st Submittal, or 2nd Submittal
   neighborhood='Neighborhood|Neighbhood|Neighborghood|Neighborhodd|Neighborhoos|Neighbrohood|Neighhborhood|Neightborhood|Neughborhood'
   sed -E 's/(Bel Air Beverly Crest|Bel-Air Beverly Crest)/Bel Air-Beverly Crest/' |
   sed -E 's/(NoHo|Mid-Town North Hollywood|Mid Town North Hollywood)/North Hollywood/' |
   sed 's/Greater Echo Park Elysian/Echo Park/' |
   sed 's/Foothills/Foothill/;s/Glassel /Glassell /;s/Hils/Hills/;s/Hollwood/Hollywood/' |
   sed 's/Hostoric/Historic/;s/Playa Del Rey/Playa del Rey/;s/VIllage/Village/' |
   sed 's/United Neighborhoods of the Historic Arlington Heights/United Neighborhoods/' |
   sed 's/Voices of 90037/Voices/;s/WEST/West/' |
   sed 's/Wilshire Center-Koreatown/Wilshire Center Koreatown/' |
   sed 's/Woodland Hills-Warner Center/Woodland Hills Warner Center/' |
   sed -E "s/((Community|$neighborhood) )?(Development )?(Councils? ?)?(of )?//Ig" |
   sed 's/NDC//;s/NC//;s/by //;s/the //' |
   sed 's/\<\([A-Z a-z][A-Z a-z]*\) *,\1\>/\1/g' |
   sed 's/(e)//;s/(1st Submittal)//;s/(2nd Submittal)//;s/ - 2nd Submission//'
}

cf=$1
cftitle=$(cat ./*/"$cf".title | head -n 1 | cut -c1-105)
cfurl="https://cityclerk.lacity.org/lacityclerkconnect/index.cfm?fa=ccfi.viewrecord&cfnumber=$cf"
n=$(find . -name $cf.cis | wc -l)
if test $n -gt 0
then
   echo "Examining $cf.cis" >&2
   cat ./*/"$cf.cis" | sort -u | \
      while IFS= read -r line
      do
         cisurl=$(echo "$line" | sed 's/ .*//')
         cisnc=$(echo "$line" | sed -E 's/.*\.pdf *//' | tidy_nc)
         # Extract date from filename
         # Make dates uniform; we could strip off the 20, or add it when missing...
         # Add missing dash if needed (e.g. 14-0656-S9_cis_12-1315.pdf should be 14-0656-S9_cis_12-13-15.pdf)
         # And, ugh, zero-extend.
         cisdate=$(echo "$cisurl" | sed -E 's/[a-z]?\.pdf//I;s/.*_//' | sed -E 's/^([0-9][0-9])-([0-9][0-9])([0-9][0-9])$/\1-\2-\3/' | sed -E 's/^([0-9])-/0\1-/;s/-([0-9])-/-0\1-/;s/-([0-6][0-9])$/-20\1/')
         # Date is M/D/Y but swizzle it to Y/M/D to be sortable
         # sorttable.js has date sorting, but it's broken, so I disabled it
         cisdate=$(echo "$cisdate" | awk -F- '{print $3"-"$1"-"$2}')
         echo "<tr><th align=left><a href=\"$cfurl\">$cf</a>"
         echo "<td><a href=\"$cfurl\">$cftitle</a>"
         echo "<td><a href=\"$cisurl\">$cisnc</a>"
         echo "<td>$cisdate"
      done
elif test x"$2" != x"--cisonly"
then
   echo "<tr><th align=left><a href=\"$cfurl\">$cf</a>"
   echo "<td><a href=\"$cfurl\">$cftitle</a>"
   echo "<td>"
   echo "<td>"
fi
