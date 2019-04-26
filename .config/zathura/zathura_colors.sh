#!/bin/bash

# generates zathura configuration file

for x in "$(xrdb -query | grep color[0-9] | sed "s/.*\./export /g;s/:\s*/=\"/g;s/$/\"/g")"; do eval "$x"; done

background=$color8
foreground=$color12

cat <<CONF
set completion-bg "$background"
set completion-fg "$foreground"
set completion-group-bg "$background"
set completion-group-fg "$color2"
set completion-highlight-bg "$foreground"
set completion-highlight-fg "$background"
set default-bg "$background"
set default-fg "$foreground"
set inputbar-bg "$background"
set inputbar-fg "$foreground"
set notification-bg "$background"
set notification-fg "$foreground"
set notification-error-bg "$color1"
set notification-error-fg "$foreground"
set notification-warning-bg "$color1"
set notification-warning-fg "$foreground"
set statusbar-bg "$background"
set statusbar-fg "$foreground"
set index-bg "$background"
set index-fg "$foreground"
set index-active-bg "$foreground"
set index-active-fg "$background"
set render-loading-bg "$background"
set render-loading-fg "$foreground"

set window-title-home-tilde true
set statusbar-basename true
set selection-clipboard clipboard

set recolor true
set recolor-darkcolor "$color7"
set recolor-lightcolor "$background"
CONF

#set smooth-scroll true
