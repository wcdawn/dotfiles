#!/bin/bash

# this script will
#   - remove trailing whitespace
#   - remove blank lines at end of file

SCRATCH=tmp.out

for FNAME in $*
do
  # remove trailing whitespace
  sed -i 's/[ \t]*$//' "$FNAME"
  # remove blank lines at end of file
  # maybe find a better way than rewriting the whole file...
  sed -e :a -e '/^\n*$/{$d;N;};/\n$/ba' "$FNAME" > $SCRATCH
  mv $SCRATCH $FNAME
done
