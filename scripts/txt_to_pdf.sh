#!/bin/bash

# Print *.txt to *.pdf
# Automatically fit page to width.
# First, try rotating from portrait to landscape.
# If that doesn't work, decrease the font until successful.
# If you can't fit to width, exit with code 1.
# Dependencies: enscript & ghostscript (ps2pdf)

usage()
{
  echo 'Usage:'
  echo "$0 <file_name>"
  exit 0
}

pdf_trunc()
{
  local ORIENTATION=$1
  local FONT=$2
  local NAME=$3

  local OUT=$((enscript -c ${ORIENTATION} -f${FONT} $NAME.txt --output=- | \
    ps2pdf - > $NAME.pdf) 2>&1)
  local TRUNC=$(echo $OUT | grep 'truncated')
  echo $TRUNC

}

# check for dependencies
if ! [ -x "$(command -v enscript)" ]
then
  echo 'it appears enscript is not installed on this system'
  echo 'this is a required dependency for this script'
  exit 1
elif ! [ -x "$(command -v ps2pdf)" ]
then
  echo 'it appears ps2pdf is not installed on this system'
  echo 'this is a required dependency for this script'
  exit 1
fi

FNAME=$1
if [ -z $FNAME ]
then
  usage
fi
NAME=$(echo $FNAME | sed 's/\.txt//')

ORIENTATION='-R' # default to portrait

FONT_SIZE=10
FONT='Courier'${FONT_SIZE}

OUT=$((enscript -c ${ORIENTATION} -f${FONT} $NAME.txt --output=- | ps2pdf - > $NAME.pdf) 2>&1)
TRUNC=$(echo $OUT | grep 'truncated')
TRUNC=$(pdf_trunc $ORIENTATION $FONT $NAME)

if [ "$TRUNC" > /dev/null ]
then
  ORIENTATION='-r' # try landscape
fi

TRUNC=$(pdf_trunc $ORIENTATION $FONT $NAME)

while [ "$TRUNC" > /dev/null ]
do
  FONT_SIZE=$((FONT_SIZE - 1))
  FONT='Courier'${FONT_SIZE}

  TRUNC=$(pdf_trunc $ORIENTATION $FONT $NAME)

  echo $FONT_SIZE

  if [ "$FONT_SIZE" -le 0 ]
  then
    echo "could not fit to width"
    exit 1
  fi

done
