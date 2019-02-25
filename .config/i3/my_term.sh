#!/bin/bash

# spawn a terminal where i am right now
# in $HOME/.bashrc -- export PROMPT_COMMAND="pwd > /tmp/whereami"
# using this temporary string file to keep track of location
WHEREAMI=$(cat /tmp/whereami)
urxvt -cd $WHEREAMI 
