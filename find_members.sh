#!/bin/ksh

### The following are local configuration options and group specific ###
# This the directory where the full web-pages and datafile will be kept
DATA="${HOME}/Documents/Low-Carb-Daily-Member-List/data"
# The number of pages we're working with, set by running --count
PAGES="max_pages"
# This is the URL of the group on MFP
GROUP_URL="394-low-carber-daily-forum-the-lcd-group"

# These shouldn't need to be changed.
WEBSITE="http://community.myfitnesspal.com/en/group/members/"
BASE="${WEBSITE}${GROUP_URL}/"
LEADING='"Card Card-Member"><a title="'

# Make sure the max pages file is set and is a number gt 0.
check_max() {
	if [ -f ${DATA}/${PAGES} ]; then
		MAX=`cat ${DATA}/${PAGES}`
		if [ ${MAX} -lt 1 ]; then
			echo "Fatal Error: Rerun $0 --count";
			exit 1
		fi
	else
		echo "You must run '$0 --count' first.";
		exit 1
	fi
}

usage() {
	echo "Usage:"
	echo "	Fetch new files:	$0 --fetch [start] [end]"
	echo "	Pages by member amount:	$0 --count {number_of_members}"
	echo "	Search for members:	$0 [name] [name] [name]" 
}

# There are 30 people per page on MFP. This will take a number of members
# in the group and return how many pages you should fetch.
count_pages() {
	perpage=30;
	if [ $# -gt 0 ]; then
		if [ $1 -gt 0 ]; then
			count=`dc -e "[1+]sa${1} ${perpage}/${1}\
				${perpage}%0!=ap"`
			echo ${count} > ${DATA}/${PAGES}
			echo "${count} pages stored"
		fi
	else
		echo "Usage: $0 --check {number_of_members}"
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
			MAX=$2;
		fi
		PAGE=$min
		while (( PAGE <= ${MAX} ))
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
	min=1
	for NAME in $@
	do
		i=${MAX};
		found=0;
		while (( i >= ${min} ))
		do
			file="p${i}?filter=members";
			grep -q "${LEADING}${NAME}" ${file} &&
				i=${min} && found=1 &&
				echo "${NAME} is on page ${BASE}${file}";
			((i--))
		done
		if [ 0 -eq ${found} ]; then
			echo "${NAME} doesn't appear to be a member."
		fi
	done
}

# Move into the data directory while we work. A lot of files are created and
# used in this process.
cd $DATA

if [ 0 -eq $# ]; then
	usage;
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
			check_max;
			shift;
			fetch_pages $@;
			;;
		*)
			check_max;
			search_members $@;
			;;
	esac
fi
