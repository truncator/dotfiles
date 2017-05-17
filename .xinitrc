#!/bin/bash
#
# ~/.xinitrc
#

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
	for f in /etc/X11/xinit/xinitrc.d/* ; do
		[ -x "$f" ] && . "$f"
	done
	unset f
fi

# reload Xresources
[[ -f ~/.Xresources ]] && xrdb -merge ~/.Xresources

#xrandr --output HDMI1 --mode 1920x1080 --right-of eDP1

# set screen blank to 30 mins
xset s off
xset dpms 1800 1800 1800

# rebind caps lock to ctrl
setxkbmap -option ctrl:nocaps

# 250ms key repeate delay, 45 keys/sec
xset r rate 250 45

xsetroot -cursor_name left_ptr

sxhkd &
exec bspwm
