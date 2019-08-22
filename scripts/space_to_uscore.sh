#!/bin/bash

# if no filename input, operate recursively on the directory
# otherwise, operate only on the filename(s) specified

OIFS="$IFS"
IFS=$'\n'

if [ $# -eq 0 ]
then
  # no argument
  LIST="./*"
else
  LIST="$*"
fi

for FNAME in $LIST
do
  if [[ $FNAME == *' '* ]]
  then
    FNAME_NEW=$(echo $FNAME | sed 's/ /_/g')
    mv $FNAME $FNAME_NEW
  fi
done

IFS="$OIFS"
