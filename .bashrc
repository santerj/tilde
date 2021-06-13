# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

shopt -s autocd
shopt -s checkwinsize
bind 'set show-all-if-ambiguous on'
bind 'TAB:menu-complete'

# User specific aliases and functions
alias sudo="sudo "
alias clc="tput reset && clear"
alias ll="ls -latrshF"
alias rg="fgrep -r"
alias rfind="sudo find . -print | fgrep -i"
alias dush="sudo du -hs * 2>/dev/null"
alias ports="sudo netstat -tulpan | grep LISTEN"

function take () {
  mkdir -p -- "$1" && cd -P -- "$1"
}

export PS1="[\u@\h] \[$(tput sgr0)\]\[\033[38;5;111m\]\W\[$(tput sgr0)\] \\$ \[$(tput sgr0)\]"
#export PS1="\[\e[35m\]\u\[\e[m\]\[\e[35m\]@\[\e[m\]\[\e[35m\]\h\[\e[m\] \[\e[36m\][\[\e[m\]\[\e[36m\]\W\[\e[m\]\[\e[36m\]]\[\e[m\] >\[\e[37m\] \[\e[m\]"
