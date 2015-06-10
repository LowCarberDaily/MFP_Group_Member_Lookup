#!/bin/ksh

# This will be the directory where the full web-pages will be kept
DATA=${HOME}/Documents/Low-Carb-Daily-Member-List/data
BASE="http://community.myfitnesspal.com/en/group/members/394-low-carber-daily-forum-the-lcd-group/"
MAX=544;

usage() {
	echo "Usage:"
	echo "	Fetch new files:	"$0" --fetch [start] [end]"
	echo "	Search for members:	"$0" [name] [name] [name]" 
	echo "	Pages by member amount:	"$0" number_of_members"
}

count_pages() {
	if [ $1 -gt 0 ]; then
		dc -e "[la1+sa]sb $1 30/sa$1 30%0!=blap"
	fi
}

fetch_pages() {
		#
		# This first block grabs all the member pages
		#
		if [ $# -gt 0 ]; then
			min=$1;
		else
			min=1;
		fi
		if [ $# -gt 1 ]; then
			max=$2;
		else
			max=${MAX};
		fi
		PAGE=$min
		while (( PAGE <= $max ))
		do
			URL="${BASE}p${PAGE}?filter=members"
			((PAGE++))
			ftp $URL
		done
}

search_members() {
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
}

# Move into the data directory
cd $DATA


if [ 0 -eq $# ]; then
	usage
else
	case $1 in
		--help)
			usage;
			;;
		--count)
			shift;
			count_pages $@;
			;;
		--fetch)
			shift;
			fetch_pages $@;
			;;
		*)
			search_members $@;
			;;
	esac
fi
