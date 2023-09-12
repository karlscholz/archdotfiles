#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

if shopt -q login_shell && [[ $(tty) =~ /dev/tty[0-9] ]]; then
    neofetch
fi

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '
alias ll='ls -alF'
setxkbmap de > /dev/null 2>&1
