#
# ~/.zprofile
#

[[ -f ~/.zshrc ]] && . ~/.zshrc


#
# environment variables
#

if [[ -z $XDG_DATA_HOME ]] ; then
	export XDG_DATA_HOME=$HOME/.local/share
fi

if [[ -z $XDG_CONFIG_HOME ]] ; then
	export XDG_CONFIG_HOME=$HOME/.config
fi

if [[ -z $XDG_CACHE_HOME ]] ; then
	export XDG_CACHE_HOME=$HOME/.cache
fi

if [[ -z $XDG_DATA_DIRS ]] ; then
	export XDG_DATA_DIRS=/usr/local/share:/usr/share
fi

if [[ -z $XDG_CONFIG_DIRS ]] ; then
	export XDG_CONFIG_DIRS=/etc/xdg
else
	export XDG_CONFIG_DIRS=/etc/xdg:$XDG_CONFIG_DIRS
fi

path=(~/bin $path)

# run mpd if not already running
[ ! -s ~/.config/mpd/pid ] && mpd ~/.config/mpd/mpd.conf

# run startx at login
[[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec ssh-agent startx > $HOME/.startx.log 2>&1
