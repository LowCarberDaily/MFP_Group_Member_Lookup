#!/bin/ksh

# This will be the directory where the full web-pages will be kept
DATA=${HOME}/Documents/Low-Carb-Daily-Member-List/data
BASE="http://community.myfitnesspal.com/en/group/members/394-low-carber-daily-forum-the-lcd-group/"
MAX=544;

# Move into the data directory
cd $DATA

if [ 0 -eq $# -o  "$1" = "--help" ]; then
	echo "Usage:"
	echo "	Fetch new files: "$0" --fetch [start] [end]"
	echo "	Search for memb: "$0" [name] [name] [name]" 
else
	if [ "$1" = "--fetch" ]; then
		#
		# This first block grabs all the member pages
		#
		if [ $# -gt 1 ]; then
			min=$2;
		else
			min=1;
		fi
		if [ $# -gt 2 ]; then
			max=$3;
		else
			max=${MAX};
		fi
		PAGE=$min
		while (( PAGE <= $max ))
		do
			URL="${BASE}p${PAGE}?filter=members"
			((PAGE++))
			echo ftp $URL
		done
	else
		#
		# This sections looks for the named members.
		# It looks for every name listed on the command line.
		# I could probably use $* as I think MFP doesn't allow spaces in usernames
		#
		max=${MAX}
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
	fi
fi
