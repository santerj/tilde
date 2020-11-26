export PATH="/home/santeri/bin/anaconda3/condabin:/usr/local/bin:/usr/bin:/bin:/home/santeri/bin:/usr/local/sbin:/usr/sbin"
export EDITOR='vim'
export GIT_EDITOR='vim'
export SHELL='/bin/zsh'
export HISTSIZE=1500
export HISTFILE="$HOME/.zsh_history"
export SAVEHIST=$HISTSIZE

setopt correct
setopt automenu
setopt autocd
setopt cdablevars
setopt prompt_subst

alias sudo="sudo "
alias clc="tput reset"
alias ll="ls -ltF"
alias la="ls -latF"
alias lg="ls -la | grep"
alias fwd='echo "$(tput setaf 6)[$(pwd)]"'
alias yeet="cp -i /dev/null"
alias rfind="sudo find . -print | fgrep -i"
alias {duhs,dush}="sudo du -hs * 2>/dev/null"
alias ports="sudo netstat -tulpan | grep LISTEN"
alias wttr="curl wttr.in/Tampere'?'2qn"
alias password="head /dev/urandom | tr -dc A-Za-z0-9 | head -c 18 ; echo ''"
# alias rg="fgrep -r"

## search history with arrow keys ##
bindkey '^[[A' up-line-or-search
bindkey '^[[B' down-line-or-search
bindkey '^I' first-tab

## from oh-my-zsh sources ##
function take() {
  mkdir -p $@ && cd ${@:$#}
}

## tab on empty line brings up cd + suggestions ##
first-tab() {
    if [[ $#BUFFER == 0 ]]; then
        BUFFER="cd "
        CURSOR=3
        zle list-choices
    else
        zle expand-or-complete
    fi
}
zle -N first-tab

branch_colour() {
#  if [[ $(ls -a | grep -x .git) != "" ]]; then
#    git fetch > /dev/null 2>&1
#  fi
  local STATUS=$(git status -uno 2> /dev/null | fgrep "up to date")
  
  if [[ $STATUS != "" ]]; then
    echo ""
  else
    echo "red"
  fi
}

## from https://git-scm.com/book/en/v2/Appendix-A%3A-Git-in-Other-Environments-Git-in-Zsh ##
autoload -Uz vcs_info
precmd_vcs_info() { vcs_info }
precmd_functions+=( precmd_vcs_info )
RPROMPT=%{%B%F{130}%}\$vcs_info_msg_0_%b
zstyle ':vcs_info:git:*' formats '%b%u%c'

PROMPT='%{%F{067}%}[%c]%{%F{none}%} %(!.#.)> '

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




## VANHAA PASKAA ##
#git_branch() {
#  local br=$(git symbolic-ref --short HEAD 2> /dev/null)
#  if [[ $br == "" ]]; then
#    echo -n " "
#  else
#    echo -n " $br "
#  fi
#}
#
## use with git autofetch ##
#branch_colour() {
##  if [[ $(ls -a | grep -x .git) != "" ]]; then
##    git fetch > /dev/null 2>&1
##  fi
#
#  local STATUS=$(git status -uno 2> /dev/null | fgrep "up to date")
#  
#  if [[ $STATUS != "" ]]; then
#    echo "green"
#  else
#    echo "red"
#  fi
#}
#PROMPT='%{%F{cyan}%}[%c]%{%B%F{yellow}%}$(git_branch)%b%{%F{none}%}%(!.#.)> '