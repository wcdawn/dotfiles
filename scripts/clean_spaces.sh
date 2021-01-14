#!/bin/bash

# this script will
#   - remove trailing whitespace
#   - remove blank lines at end of file
#   - remove repeated blank lines

for FNAME in $*
do
  # remove trailing whitespace
  sed -i 's/\s*$//' "$FNAME"

  # remove blank lines at end of file
  if [ -z "$(tail -c 1 "$FNAME")" ]
  then
    truncate -s -1 "$FNAME"
  fi

  # remove repeated blank lines
  cat -s "$FNAME" | tee "$FNAME" > /dev/null

done
