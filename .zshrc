export ZSH="/home/santeri/.oh-my-zsh"
export PATH="/home/santeri/bin/anaconda3/condabin:/usr/local/bin:/usr/bin:/bin:/home/santeri/bin:/usr/local/sbin:/usr/sbin"
export EDITOR='vim'
export GIT_EDITOR='vim'
export SHELL='/bin/zsh'
export HISTSIZE=1500
export HISTFILE="$HOME/.zsh_history"
export SAVEHIST=$HISTSIZE
export ZSH_THEME="robbyrussell"

setopt correct
setopt automenu
setopt autocd
setopt cdablevars

plugins=(git)
source $ZSH/oh-my-zsh.sh

alias password="head /dev/urandom | tr -dc A-Za-z0-9 | head -c 18 ; echo ''"
alias wttr="curl wttr.in/Tampere'?'2qn"
alias clc=clear
alias ll="ls -ltr"
alias la="ls -latr"
alias lg="ls -latr | grep"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/santeri/bin/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/santeri/bin/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/home/santeri/bin/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/santeri/bin/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<
