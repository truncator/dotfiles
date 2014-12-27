#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
#PS1='[\u@\h \W]\$ ' # default
PS1='\[\e[0;32m\]\u\[\e[m\] \[\e[1;34m\]\w\[\e[m\] \[\e[1;32m\]\$\[\e[m\] \[\e[1;38m\]'


# default editor
export EDITOR=vim

# aliases
alias ..="cd .."
alias ls="ls -Apoh --color=auto"
alias please='sudo $(history -p !!)'

# cd when path is typed
shopt -s autocd

# redo text wrap on window resize
shopt -s checkwinsize

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
