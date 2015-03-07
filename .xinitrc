#!/bin/sh
#
# ~/.xinitrc
#
# Executed by startx (executes the x11 session)

# Make java apps work (specifically android studio)
export _JAVA_AWT_WM_NONREPARENTING=1

# set mouse pointer
xsetroot -cursor_name left_ptr &


# screen powersave
xset +dpms
xset dpms 0 0 300

DEFAULT_SESSION=xmonad
case $1 in
  xmonad)
    exec xmonad
    ;;
  *)
    exec $DEFAULT_SESSION
    ;;
esac
