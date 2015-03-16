#
# ~/.zshrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

autoload -U compinit promptinit colors
compinit
promptinit
colors

# arrow-key style completion
zstyle ':completion:*' menu select

# ignore duplicate history lines
setopt HIST_IGNORE_DUPS

# history search
[[ -n "${key[PageUp]}"   ]] && bindkey "${key[PageUp]}"   history-beginning-search-backward
[[ -n "${key[PageDown]}" ]] && bindkey "${key[PageDown]}" history-beginning-search-forward

[[ -n "${key[Home]}"   ]] && bindkey "${key[Home]}"   beginning-of-line
[[ -n "${key[End]}"    ]] && bindkey "${key[End]}"    end-of-line
[[ -n "${key[Insert]}" ]] && bindkey "${key[Insert]}" overwrite-mode
[[ -n "${key[Delete]}" ]] && bindkey "${key[Delete]}" delete-char
[[ -n "${key[Up]}"     ]] && bindkey "${key[Up]}"     up-line-or-history
[[ -n "${key[Down]}"   ]] && bindkey "${key[Down]}"   down-line-or-history
[[ -n "${key[Left]}"   ]] && bindkey "${key[Left]}"   backward-char
[[ -n "${key[Right]}"  ]] && bindkey "${key[Right]}"  forward-char

bindkey "\e[3~" delete-char
bindkey "^P" up-line-or-history

PROMPT="%F{black}[%T]%f %F{green}%n%B@%b%F{green}%m%f %B%F{blue}%~%f %F{green}$%f%b "

# default editor
export EDITOR=vim

# aliases
alias ..="cd .."
alias ls="ls -Apoh --color=auto"
alias please="sudo $(history -p !!)"
alias svim="sudo -E vim"
alias gitpw="echo $GITTOKEN | xclip"

export PATH=$HOME/bin:$PATH
export XDG_CONFIG_HOME=$HOME/.config

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

HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=5000
setopt appendhistory autocd extendedglob nomatch notify
unsetopt beep
bindkey -v

zstyle :compinstall filename '/home/truncator/.zshrc'

autoload -Uz compinit
compinit
