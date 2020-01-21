#!/bin/sh

# requries xdootool and xtitle

wid=$1
class=$2
instance=$3
title=$(xtitle "$wid")

echo $wid > /tmp/window
echo $class >> /tmp/window
echo $instance >> /tmp/window
echo $title >> /tmp/window

# get the first word of the title
set $title
first_title=$1
echo $first_title >> /tmp/window

if [ "$instance" = display ]
then
  echo cautght_if >> /tmp/window
  case "$first_title" in "ImageMagick:")
      echo caught_case >> /tmp/window
      echo "floating = on"
      xdotool windowmove $wid 25% 10% # units can be pixels or percents
      ;;
  esac
fi
