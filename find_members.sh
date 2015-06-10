#!/bin/ksh
# This should be connected to my working folder now.

# This will be the directory where the full web-pages will be kept
DATA=${HOME}/Documents/Low-Carb-Daily-Member-List/data
BASE="http://community.myfitnesspal.com/en/group/members/394-low-carber-daily-forum-the-lcd-group/"
MAX=544;

usage() {
	echo "Usage:"
	echo "	Fetch new files:	"$0" --fetch [start] [end]"
	echo "	Pages by member amount:	"$0" --count number_of_members"
	echo "	Search for members:	"$0" [name] [name] [name]" 
}

# There are 30 people per page on MFP. This will take a number of members
# in the group and return how many pages you should fetch.
count_pages() {
	perpage=30;
	if [ $1 -gt 0 ]; then
		dc -e "[la1+sa]sb${1} ${perpage}/sa${1} ${perpage}%0!=blap"
	fi
}

# This will download all the member pages from MFP
fetch_pages() {
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

# This function looks for the named members. It looks for every name listed
# on the command line. I could probably use $* as I think MFP doesn't allow
# spaces in usernames, but I would rather be safe than sorry.
search_members() {
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

# Move into the data directory while we work. A lot of files are created and
# used in this process.
cd $DATA

if [ 0 -eq $# ]; then
	usage
else
	case $1 in
		--help|-h)
			usage;
			;;
		--count|-c)
			shift;
			count_pages $@;
			;;
		--fetch|-f)
			shift;
			fetch_pages $@;
			;;
		*)
			search_members $@;
			;;
	esac
fi
