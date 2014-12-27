#
# ~/.bash_profile
#

. ~/.profile
[[ -f ~/.bashrc ]] && . ~/.bashrc

# run startx at login
[[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec startx
