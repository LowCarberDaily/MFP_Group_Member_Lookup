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
