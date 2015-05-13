#!/bin/bash
#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)

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

# set wallpaper based on ~/.config/envrc
if [ ! -z $WALLPAPER ] && [ ! -z $WALLPAPER_TILED ] ; then
	if [[ "$WALLPAPER_TILED" == "true" ]] ; then
		feh --bg-tile $WALLPAPER
	else
		feh --bg-fill $WALLPAPER
	fi
fi

if [ ! -z $SYSTEM ] && [[ "$SYSTEM" == "laptop" ]] ; then
	xrandr --output HDMI1 --mode 1920x1080 --right-of eDP1
fi

if [ ! -z $WM ] ; then
	if [[ $WM == "openbox" ]] ; then
		exec openbox-session
	fi

	if [[ $WM == "bspwm" ]] ; then
		# bar
		. $HOME/.config/bar/bar.sh | bar -B "#ff141414" -g 1920x20+0+0 -f *terminus* &

		# bspwm
		sxhkd &
		exec $HOME/.config/bspwm/wm
	fi
fi

xsetroot -cursor_name left_ptr &
