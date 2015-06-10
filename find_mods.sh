#!/bin/ksh

BASE="http://community.myfitnesspal.com/en/group/members/394-low-carber-daily-forum-the-lcd-group/"

#
# This first block grabs all the member pages
#
max=544
min=1
PAGE=$min
while (( PAGE <= $max ))
do
	URL="${BASE}p${PAGE}?filter=members"
	((PAGE++))
#	ftp $URL
done

#
# This sections looks for the named members.
#
max=544
min=1
for NAME in FIT_Goat loridarling quux
do
	i=$max
	while (( i >= $min ))
	do
		file="p${i}?filter=members"
		grep -q "\"Card Card-Member\"><a title=\"${NAME}" $file && i=$min && echo "${NAME} is on page ${BASE}${file}"
		((i--))
	done
done
