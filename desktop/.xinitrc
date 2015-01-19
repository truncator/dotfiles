#!/bin/sh
#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)

if [ -d /etc/X11/xinit/xinitrc.d ]; then
	for f in /etc/X11/xinit/xinitrc.d/*; do
		[ -x "$f" ] && . "$f"
	done
	unset f
fi

# reload Xresources
[[ -f ~/.Xresources ]] && xrdb -merge ~/.Xresources

xsetroot -cursor_name left_ptr

# set wallpaper
feh --bg-fill ~/pictures/wallpapers/wallhaven-4389.jpg

# bar
. $HOME/.config/bar/bar.sh | bar -B "#ff141414" -g 1920x20+0+0 -f *terminus* &

# bspwm
sxhkd &
exec $HOME/.config/bspwm/wm
