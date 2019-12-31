#!/bin/sh

# Reads names of NC on stdin, outputs tidied names on stdout
# See test cases in nc-variants.txt

neighborhood='Neighborhood|Neighbhood|Neighborghood|Neighborhodd|Neighborhoos|Neighbrohood|Neighhborhood|Neightborhood|Neughborhood'

# Handle typos and variants
# Remove prefixes/suffixes like NC, NDC, Council of, Council, Development Council, or Neighborhood Council
# Remove prefixes like by or the
# Remove duplicated phases separated by commas (go figure)
# Remove keywords e, 1st Submittal, or 2nd Submittal

sed -E 's/(Bel Air Beverly Crest|Bel-Air Beverly Crest)/Bel Air-Beverly Crest/' |
sed -E 's/(NoHo|Mid-Town North Hollywood|Mid Town North Hollywood)/North Hollywood/' |
sed -E 's/Community and Neighbors for Ninth District Unity|Community and Neighbor(hor)?s for Ninth District Unity \(CANNDU\)/CANNDU/' |
sed -E 's/Foothills? Trails?( District)?/Foothill Trails/' |
sed 's/Brentwood Community/Brentwood/' |
sed 's/Greater Echo Park Elysian/Echo Park/' |
sed 's/Glassel /Glassell /;s/Hils/Hills/;s/Hollwood/Hollywood/' |
sed 's/Hostoric/Historic/;s/Playa Del Rey/Playa del Rey/;s/VIllage/Village/' |
sed 's/United Neighborhoods of the Historic Arlington Heights/United Neighborhoods/' |
sed 's/Voices of 90037/Voices/;s/WEST/West/' |
sed 's/Wilshire Center-Koreatown/Wilshire Center Koreatown/' |
sed 's,Westchester-Playa del Rey,Westchester/Playa,' |
sed 's/Woodland Hills-Warner Center/Woodland Hills Warner Center/' |
sed -E "s/((Community|$neighborhood) )?(Development )?((Coucnil|Coun|Council|Councils) ?)?(of )?//Ig" |
sed -E "s/($neighborhood) *\$//" |
sed 's/Empp*owerment Congress//;s/NDC//;s/NC//;s/by //;s/the //;s/of *$//' |
sed 's/\<\([A-Z a-z][A-Z a-z]*\) *,\1\>/\1/g' |
sed 's/(e)//;s/(1st Submittal)//;s/(2nd Submittal)//;s/ - 2nd Submission//' |
sed 's/  / /g;s/^ //;s/ $//'
