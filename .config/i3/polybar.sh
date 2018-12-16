#!/bin/bash

# terminate already running bar instances
killall -q polybar

# wait until the processes have been shut down
while pgrep -x polybar >/dev/null; do sleep 1; done

# launch polybar ON ALL MONITORS!
BAR=example
if type 'xrandr'
then
  for m in `xrandr --query | grep ' connected' | cut -d" " -f1`
  do
    MONITOR=$m polybar --reload $BAR &
  done
else
  polybar --reload $BAR
fi

