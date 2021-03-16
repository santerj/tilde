# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

shopt -s autocd
shopt -s checkwinsize

# User specific aliases and functions
alias sudo="sudo "
alias clc="tput reset"
alias ll="ls -ltF"
alias la="ls -latF"
alias lg="ls -la | grep"
alias rg="fgrep -r"
alias yeet="cp -i /dev/null"
alias rfind="sudo find . -print | fgrep -i"
alias duhs="sudo du -hs * 2>/dev/null"
alias dush="sudo du -hs * 2>/dev/null"
alias ports="sudo netstat -tulpan | grep LISTEN"

function take () {
  mkdir -p -- "$1" && cd -P -- "$1"
}

export PS1="\[\e[35m\]\u\[\e[m\]\[\e[35m\]@\[\e[m\]\[\e[35m\]\h\[\e[m\] \[\e[36m\][\[\e[m\]\[\e[36m\]\W\[\e[m\]\[\e[36m\]]\[\e[m\] >\[\e[37m\] \[\e[m\]"
