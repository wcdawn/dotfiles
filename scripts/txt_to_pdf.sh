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

build_font()
{
  local FONT_SIZE=$1
  echo 'Courier'${FONT_SIZE}
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

DO_QUICK=''
ORIENTATION='-R' # default to portrait
FONT_SIZE=10 # default to enscript default
while getopts "s:o:h" opt # trailing colon specifies an argument is required
do
  case ${opt} in
    s) # font size
      FONT_SIZE="$OPTARG"
      DO_QUICK=${DO_QUICK}'s'
      ;;
    o) # orientation
      if [ "$OPTARG" == 'p' ]
      then
        ORIENTATION='-R'
      elif [ "$OPTARG" == 'l' ]
      then
        ORIENTATION='-r'
      else
        echo 'invalid orientation option'
        echo 'p for portrait'
        echo 'l for landscape'
        exit 1
      fi
      DO_QUICK=${DO_QUICK}'o'
      ;;
    h) # help
      usage
      exit 0
      ;;
    \?) # error
      echo 'invalid argument'
      usage
      exit 1
  esac
done

shift $((OPTIND - 1)) # shift to ignore already parsed command line arguments

# parse file name
FNAME=$1
if [ -z $FNAME ]
then
  usage
fi
NAME=$(echo $FNAME | sed 's/\.txt//')

if [ "$DO_QUICK" ]
then
  FONT=$(build_font $FONT_SIZE)
  TRUNC=$(pdf_trunc $ORIENTATION $FONT $NAME)
  echo $TRUNC
  exit 0
fi

FONT=$(build_font $FONT_SIZE)

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
  FONT=$(build_font $FONT_SIZE)

  TRUNC=$(pdf_trunc $ORIENTATION $FONT $NAME)

  echo $FONT_SIZE

  if [ "$FONT_SIZE" -le 0 ]
  then
    echo "could not fit to width"
    exit 1
  fi

done
