#!/bin/bash

FILENAME=/tmp/whereami
MYTERM=st

# spawn a terminal where i am right now
# in $HOME/.bashrc -- export PROMPT_COMMAND="pwd > /tmp/whereami"
# using this temporary string file to keep track of location
if [ -e $FILENAME ]
then
  WHEREAMI=$(cat $FILENAME)
#   $MYTERM -cd "$WHEREAMI" # urxvt
  st sh -c "cd $WHEREAMI; bash" # st
else
  $MYTERM
fi
