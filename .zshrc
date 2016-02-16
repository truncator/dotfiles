#
# ~/.zshrc
#

autoload -Uz compinit promptinit colors
compinit
promptinit
colors

#PROMPT="%F{black}[%T]%f %F{green}%n%B@%b%F{green}%m%f %B%F{blue}%~%f %F{green}$%f%b "
#PROMPT=$'\n'" %B%F{blue}%~%f %F{green}$%f%b "
precmd() { print "" }
PROMPT=" %B%F{blue}%~%f %F{green}$%f%b "

# default editor
export EDITOR=nvim

export TERM=xterm-termite


#
# zsh configuration
#

# ignore duplicate history lines
setopt HIST_IGNORE_DUPS

# history file
HISTFILE=$XDG_CACHE_HOME/.histfile
HISTSIZE=2000
SAVEHIST=10000

setopt autocd
setopt histignorealldups
setopt sharehistory
setopt extendedglob
unsetopt beep


#
# completion
#

#zstyle :compinstall filename '/home/truncator/.zshrc'
zstyle ":completion:*" auto-description "specify: %d"
zstyle ":completion:*" completer _expand _complete _correct _approximate
zstyle ":completion:*" format "Completing %d"
zstyle ":completion:*" group-name ""
zstyle ":completion:*" menu select=2
zstyle ":completion:*:default" list-colors ${(s.:.)LS_COLORS}
zstyle ":completion:*" list-colors ""
zstyle ":completion:*" list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ":completion:*" matcher-list "" "m:{a-z}={A-Z}" "m:{a-zA-Z}={A-Za-z}" "r:|[._-]=* r:|=* l:|=*"
zstyle ":completion:*" menu select=long
zstyle ":completion:*" select-prompt %SScrolling active: current selection at %p%s
zstyle ":completion:*" verbose true
zstyle ":completion:*:*:kill:*:processes" list-colors "=(#b) #([0-9]#)*=0=01;31"
zstyle ":completion:*:kill:*" command "ps -u $USER -o pid,%cpu,tty,cputime,cmd"


#
# keybinds
#

# vim style keybinds
bindkey -v

bindkey "$terminfo[khome]" beginning-of-line    # home
bindkey "$terminfo[kend]"  end-of-line          # end
bindkey "$terminfo[kich1]" overwrite-mode       # insert
bindkey "$terminfo[kdch1]" delete-char          # delete
bindkey "$terminfo[kcuu1]" up-line-or-history   # up
bindkey "$terminfo[kcud1]" down-line-or-history # down
bindkey "$terminfo[kcub1]" backward-char        # left
bindkey "$terminfo[kcuf1]" forward-char         # right

# ctrl-left, ctrl-right
#bindkey "\e[1;5D" backward-word
#bindkey "\e[1;5C" forward-word

# ctrl-backspace
#bindkey "^?" backward-delete-word

# shift-tab
bindkey "\e[Z" reverse-menu-complete

# ctrl-p
bindkey "^P" up-line-or-history

bindkey "^R" history-incremental-search-backward


#
# aliases
#

alias ls="ls -Apoh --color=auto"
alias grep="grep --color=auto"
alias dmesg="dmesg --color=auto"
alias svim="sudo -E vim"
alias tmux="tmux -2"
alias am="alsamixer"
alias mv="mv --no-clobber"


#
# functions
#

# expand arbitrary number of ... into appropriate number of ../..
rationalize_dot()
{
	if [[ $LBUFFER = *.. ]] ; then
		LBUFFER+=/../
	elif [[ $LBUFFER = *../ ]] ; then
		LBUFFER+=../
	else
		LBUFFER+=.
	fi
}
zle -N rationalize_dot
bindkey . rationalize_dot
bindkey -M isearch . self-insert

# cd + ls
cl()
{
	local dir="$1"
	local dir="${dir:=$HOME}"
	if [[ -d "$dir" ]]; then
		cd "$dir" >/dev/null; ls
	else
		echo "bash: cl: $dir: No such directory"
	fi
}

blank()
{
	MINS="$1"
	SECS="$(($MINS * 60))"
	xset s off
	xset dpms $SECS $SECS $SECS
	echo "Screen blank set to $MINS minutes."
}

gitpush()
{
	cat $HOME/doc/gittoken.txt | xclip
	git push origin master
}

scrots()
{
	cd ~/pic/scrot
	scrot -s
}

tempscrot()
{
    scrot -s /tmp/tempscrot.png
    gimp /tmp/tempscrot.png
}

# search for packages following a missing command
source /usr/share/doc/pkgfile/command-not-found.zsh

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
