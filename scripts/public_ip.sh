#!/usr/bin/sh

FNAME=/tmp/public_ip
CHANGE=0

if [ ! -e $FNAME ]
then
  curl -s ipecho.net/plain > $FNAME
  CHANGE=1
fi

NEW_IP=$(curl -s ipecho.net/plain)
OLD_IP=$(cat $FNAME)

if [ $NEW_IP != $OLD_IP ]
then
  echo $NEW_IP > $FNAME
  CHANGE=1
fi

if [ $CHANGE != 0 ]
then
  $HOME/scripts/send_email.py
fi
