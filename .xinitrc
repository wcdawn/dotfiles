# change default cursor from "X" to left pointer
xsetroot -cursor_name left_ptr &

# swap escape and caps lock keys
setxkbmap -option caps:swapescape &

exec bspwm 
