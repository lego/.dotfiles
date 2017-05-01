#!/bin/sh
#
# ~/.xinitrc
#
# Executed by startx (executes the x11 session)

# Make java apps work (specifically android studio)
export _JAVA_AWT_WM_NONREPARENTING=1

export GTK2_RC_FILES="$HOME/.gtkrc-2.0"


# set mouse pointer
xsetroot -cursor_name left_ptr &

# screen powersave
xset +dpms
xset dpms 0 0 300

xrandr --output DP1 --mode 1920x1080
xrandr --output DP1 --mode 3840x2160

exec xmonad
