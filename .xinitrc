#!/bin/sh
#
# ~/.xinitrc
#
# Executed by startx (executes the x11 session)

# Start a D-Bus session
source /etc/X11/xinit/xinitrc.d/30-dbus

# Start GNOME Keyring
eval $(/usr/bin/gnome-keyring-daemon --start --components=gpg,pkcsll,secrets,ssh)
export SSH_AUTH_SOCK
export GPG_AGENT_INFO
export GNOME_KEYRING_CONTROL
export GNOME_KEYRING_PID

# set mouse pointer
xsetroot -cursor_name left_ptr &

# screen powersave
xset +dpms
xset dpms 0 0 300

exec dbus-launch xmonad


