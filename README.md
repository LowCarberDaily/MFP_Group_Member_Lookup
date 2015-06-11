# MFP_Group_Member_Lookup
A short shell script to help find and manage individual members for large
groups on MFP

It is nearly impossible to do simple per-user administration through the MFP
website. You need to find each person on the member list. For groups with
thousands of members, and hundreds of pages on their member lists, even
locating a member is difficult.  This is a quick hack to point you in the right
direction.

Howto Use This Script
----- --- ---- ------

First, edit the script and change the variable DATA to point to a directory
where you wish to store the data files.  This can be anywhere you have write
access. If you don't plan on using it repeatedly a directory under /tmp
might be fine. Be forewarned though, on many systems /tmp is emptied when
the system reboots.

Second, change the GROUP_URL to point to the group specific part of your
MFP URL.  This is the last segment when you're on the group homepage. It is
usually a number followed by the name of the group seperated by hyphens.

Save the script somewhere that your shell can find it and make sure it's
executable.  Then we need to initialize the data before we can search. Say
your group has 10,321 current members.  You need to first initialize the
page count by running find_members --count.

$ find_members.sh -c 10321

Then you will need to download the relevant member lists.

$ find_members.sh -f

After this runs, you should have all the files downloaded.  Assuming nothing
went wrong.  You can then search for a person or multiple people.

$ find_members.sh Jim1567 SueSlim Jimmy56

The program will print the URL of the webpage where you can find the member(s)
listed. If a person can't be found, it will tell you they don't exist.

The script searches backwards, from the most recently joined members to the
oldest members.  It quits as soon as a hit is found.  It works with just the
start of user names.  For example, you can enter FIT instead of FIT_Goat and
it will work. But, if there is another member like FIT215 who joined after
FIT_Goat, it will give you their page instead of the one you want. So, it is
best practice to put as much of the start of the username as you know (or all
of the username). Nothing stops you from taking shortcuts though.
