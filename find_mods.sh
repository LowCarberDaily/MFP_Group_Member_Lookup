#!/bin/ksh

DATA=${HOME}/Documents/Low-Carb-Daily-Member-List/data
BASE="http://community.myfitnesspal.com/en/group/members/394-low-carber-daily-forum-the-lcd-group/"

# Move into the data directory
cd $DATA

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
# It looks for everyone on the command line.
#
max=544
min=1
for NAME in $@
do
	i=$max
	while (( i >= $min ))
	do
		file="p${i}?filter=members"
		grep -q "\"Card Card-Member\"><a title=\"${NAME}" $file && i=$min && echo "${NAME} is on page ${BASE}${file}"
		((i--))
	done
done
