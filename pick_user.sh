#!/bin/sh
# Pick User -  Randomly assign a list of tickets to two users. Used for quarterly sox tickets.
# 20220103 - jah - created
# 20220620 - jah - use gshuf on apple macos (requires macports coreutils install)

# macos check
[ `uname` = "Darwin" ] && alias shuf='gshuf'
 
USER1="USER1"
USER2="USER2"

[ "$1" = "" ] && echo "No list provided." && exit 1

shuf $1 >/dev/null 2>&1
[ $? -gt 0 ] && echo "Shuf test failed.  Something went wrong." && exit 1

echo "The List:"
cat $1

# randomize the list
cat $1 | shuf >$1.random

# do maths
COUNT=`cat $1 | wc -l`
HALFISH="$(( $COUNT / 2 ))" # toss the float
TAIL="$(( $COUNT - $HALFISH ))"
PICK=`shuf -n 1 -i 0-1` # flip a coin

# who goes first
[ $PICK -eq 0 ] && P1="$USER1" || P1="$USER2"
[ $P1 = "$USER1" ] && P2="$USER2" || P2="$USER1"

# split random list in two
{
echo;echo "----- Random Assigned -----"
echo "$P1"
head -$HALFISH $1.random
echo
echo "$P2"
cat $1.random | tail -$TAIL
} > $1.assigned
cat $1.assigned
echo

