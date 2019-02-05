#!/bin/bash

# script to check if a restart is required on an ubuntu machine
# restart is requried if the file /var/run/reboot-required exists
# if the file exitsts, the file /var/run/reboot-required.pkgs contains a list of
# packages requiring restart

FILE=/var/run/reboot-required
LIST=/var/run/reboot-required.pkgs

if [ -f $FILE ]
then 
  cat $FILE
  echo 'the following packages require reboot.'
  cat $LIST
else
  echo 'no reboot required'
fi
