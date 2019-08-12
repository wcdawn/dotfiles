#!/bin/bash

# this script will
#   - remove trailing whitespace
#   - remove blank lines at end of file

for FNAME in $*
do
  # remove trailing whitespace
  sed -i 's/[ \t]*$//' "$FNAME"
  # remove blank lines at end of file
  # maybe find a better way than rewriting the whole file...
  TMP=$(sed -e :a -e '/^\n*$/{$d;N;};/\n$/ba' "$FNAME")
  echo $TMP > $FNAME
done
