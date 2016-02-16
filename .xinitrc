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

# load system-specific vars from ~/.config/envrc
if [ -f $HOME/.config/envrc ] ; then
	source $HOME/.config/envrc
else
	echo "[WARNING] No ~/.config/envrc exists."
fi

# handle dual monitors
if [ ! -z $SYSTEM ] ; then
	if [[ "$SYSTEM" == "laptop_dual" ]] ; then
		xrandr --output HDMI1 --mode 1920x1080 --right-of eDP1
	fi

	if [[ "$SYSTEM" == "desktop" ]] ; then
		xrandr --output DVI-1 --mode 1920x1080 --rate 144.00 --right-of HDMI-0
	fi
fi

# set wallpaper based on ~/.config/envrc
if [ ! -z $WALLPAPER ] && [ ! -z $WALLPAPER_TILED ] && [ ! -z $WALLPAPER_SOLID ] && [ ! -z $WALLPAPER_COLOR ] ; then
	if [[ "$WALLPAPER_SOLID" == "true" ]] ; then
		hsetroot -solid "$WALLPAPER_COLOR"
	else
		if [[ "$WALLPAPER_TILED" == "true" ]] ; then
			feh --bg-tile $WALLPAPER
		else
			feh --bg-fill $WALLPAPER
		fi
	fi
fi

# set screen blank to 30 mins
xset s off
xset dpms 1800 1800 1800

# rebind caps lock to ctrl
setxkbmap -option ctrl:nocaps

# 250ms key repeate delay, 45 keys/sec
xset r rate 250 45

xsetroot -cursor_name left_ptr

# start window manager
if [ ! -z $WM ] ; then
	if [[ $WM == "openbox" ]] ; then
		exec openbox-session
	fi

	if [[ $WM == "bspwm" ]] ; then
		sxhkd -n -f 100 &
		exec bspwm
	fi
fi
