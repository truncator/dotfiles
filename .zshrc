#
# ~/.zshrc
#

autoload -Uz compinit promptinit colors
compinit
promptinit
colors

#PROMPT="%F{black}[%T]%f %F{green}%n%B@%b%F{green}%m%f %B%F{blue}%~%f %F{green}$%f%b "
PROMPT=" %B%F{blue}%~%f %F{green}$%f%b "


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

# default editor
export EDITOR=vim


#
# zsh configuration
#

# arrow-key style completion
zstyle ':completion:*' menu select

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


#
# aliases
#

alias ls="ls -Apoh --color=auto"
alias grep="grep --color=auto"
alias dmesg="dmesg --color=auto"
alias svim="sudo -E vim"
alias ..="cd .."


#
# functions
#

# expand arbitrary number of ... into appropriate number of ../..
rationalize_dot()
{
	if [[ $LBUFFER = *.. ]] ; then
		LBUFFER+=/..
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

streaming()
{
	INRES="1920x1080" # input resolution
	OUTRES="1920x1080" # output resolution
	FPS="20" # target FPS
	GOP="40" # i-frame interval, should be double of FPS,
	GOPMIN="20" # min i-frame interval, should be equal to fps,
	THREADS="2" # max 6
	CBR="1500k" # constant bitrate (should be between 1000k - 3000k)
	QUALITY="ultrafast"  # one of the many FFMPEG preset
	AUDIO_RATE="44100"
	STREAM_KEY="$1" # use the terminal command Streaming streamkeyhere to stream your video to twitch or justin
	SERVER="live-dfw" # twitch server in frankfurt, see http://bashtech.net/twitch/ingest.php for list

	#
	#ffmpeg -f x11grab -s "$INRES" -r "$FPS" -i :0.0+1920,0 -f alsa -i pulse -f flv -ac 2 -ar $AUDIO_RATE \
	#	-vcodec libx264 -g $GOP -keyint_min $GOPMIN -b:v $CBR -minrate $CBR -maxrate $CBR -pix_fmt yuv420p\
	#	-s $OUTRES -preset $QUALITY -tune film -acodec libmp3lame -threads $THREADS -strict normal \
	#	-bufsize $CBR "rtmp://$SERVER.twitch.tv/app/$STREAM_KEY"

	ffmpeg -f x11grab -s "$INRES" -r "$FPS" -i :0.0+1920,0 -f alsa -f flv -ac 2 -ar $AUDIO_RATE \
		-vcodec libx264 -g $GOP -keyint_min $GOPMIN -b:v $CBR -minrate $CBR -maxrate $CBR -pix_fmt yuv420p\
		-s $OUTRES -preset $QUALITY -tune film -acodec libmp3lame -threads $THREADS -strict normal \
		-bufsize $CBR "rtmp://$SERVER.twitch.tv/app/$STREAM_KEY"
}

blank()
{
	MINS="$1"
	SECS="$(($MINS * 60))"
	xset s off
	xset dpms $SECS $SECS $SECS
	echo "Screen blank set to $MINS minutes."
}

cland()
{
	cd ~/repos/clandestine
	urxvt -cd /home/truncator/repos/clandestine/Binary/DebugEditor &
	svim
}

gitpush()
{
	echo $GITTOKEN | xclip
	git push origin master
}

source /usr/share/doc/pkgfile/command-not-found.zsh
