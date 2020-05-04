#!/bin/bash

usage()
{
  echo "Usage:"
  echo "\$ $0 [-deh] <infiles>"
  echo "Optional:"
  echo "-d <directory>"
  echo "-e <extension>"
}

EXTENSION="jpg" # default to jpg
DIRECTORY='./'  # default to present directory
while getopts "d:e:h" opt # trailing colon specifies an argument is required
do
  case ${opt} in
    d ) # directory
      DIRECTORY="$OPTARG"
      ;;
    e ) # extension
      EXTENSION="$OPTARG"
      ;;
    h ) # help
      usage
      exit 0
      ;;
    \? ) # error
      echo "Invalid argument."
      usage
      exit 1
  esac
done

shift $((OPTIND - 1)) # shift to ignore already parsed command line arguments

if [ -z $1 ]
then
  echo "No files specified."
  usage
  exit 0
fi

CONVERT=heif-convert
# check for dependency
if ! [ -x "$(command -v $CONVERT)" ]
then
  echo 'it appears heif-convert is not installed on the system.'
  echo 'this command is available in the libheif package'
  exit 1
fi

START=$(date)
echo "start: $START"

for CASE in $*
do
  OUTNAME=$(echo $CASE | sed "s/heic/$EXTENSION/")
  $CONVERT $CASE $DIRECTORY/$OUTNAME > /dev/null
  echo "file: $CASE"
done

FINISH=$(date)
echo "finish: $FINISH"
