#!/bin/bash

echo 'The time in Montana is:'
TZ='America/Denver' date

# weather in Missoula
MISSOULA="$(curl wttr.in/Missoula?0pquT 2>/dev/null)"
# echo "$MISSOULA"

# weather in Flathead County
FLATHEAD="$(curl wttr.in/Flathead?0pquT 2>/dev/null)"
# echo "$FLATHEAD"

paste <(printf %s "$MISSOULA") <(printf %s "$FLATHEAD") | column -t -s $'\t'

# days until next visit
FNAME=~/hailey/next_visit.txt
FUTURE_DATE=$(cat $FNAME)
NOW=$(date +%s)
THEN=$(date +%s --date $FUTURE_DATE)
DIFF=$(($THEN - $NOW))
DAYS=$((DIFF / (3600*24) + 1))
echo 'Days until next visit:' $DAYS
