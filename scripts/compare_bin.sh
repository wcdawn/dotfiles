#!/bin/bash

# compare the first word of the return arguments of COMPARE_TOOL
# this should work with md5sum or cksum
COMPARE_TOOL=md5sum

F1=$1
F2=$2

SUM1=$($COMPARE_TOOL $F1)
SUM2=$($COMPARE_TOOL $F2)

SUM1=$(echo $SUM1 | sed 's/ .*//')
SUM2=$(echo $SUM2 | sed 's/ .*//')

if [ $SUM1 == $SUM2 ]
then
  echo $COMPARE_TOOL "are the same"
else
  echo "ERROR: $COMPARE_TOOL DIFFER"
fi
