export PATH="/usr/local/bin:/usr/bin:/bin:/home/santeri/bin:/usr/local/sbin:/usr/sbin"
export EDITOR='vim'
export GIT_EDITOR='vim'
export SHELL='/bin/zsh'
export HISTSIZE=500
export HISTFILE="$HOME/.zsh_history"
export SAVEHIST=$HISTSIZE
export LESSOPEN="| /usr/bin/src-hilite-lesspipe.sh %s"
export LESS=' -R '

setopt correct
setopt automenu
setopt autocd
setopt cdablevars
setopt prompt_subst

zstyle ':completion:*' list-colors "${(@s.:.)LS_COLORS}"
zstyle ':completion:*' menu select
zstyle ':vcs_info:git:*' formats '%b'

autoload -U compinit
autoload -U colours
autoload -Uz vcs_info

bindkey '^I' first-tab
bindkey '^[[A' up-line-or-search
bindkey '^[[B' down-line-or-search

alias sudo="sudo "
alias clc="tput reset && clear"
alias ll="ls -latrshF"
alias rfind="sudo find . -print | fgrep -i"
alias dush="sudo du -hs * 2>/dev/null"
alias ports="sudo netstat -tulpan | grep LISTEN"
alias wttr="curl wttr.in/Tampere'?'2qn"
alias password="head /dev/urandom | tr -dc A-Za-z0-9 | head -c 18 ; echo ''"
alias pretty="python -m json.tool"
alias digs="dig +short"

## arrow keys suggestion nav ##
compinit

function godoc() {
  go doc $@ | less
}

## from oh-my-zsh sources ##
function take() {
  mkdir -p $@ && cd ${@:$#}
}

## tab on empty line brings up cd + suggestions ##
## https://unix.stackexchange.com/a/32426 ##
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

## git branch prompt on right side ##
## from https://git-scm.com/book/en/v2/Appendix-A%3A-Git-in-Other-Environments-Git-in-Zsh ##
precmd_vcs_info() { vcs_info }
precmd_functions+=( precmd_vcs_info )
RPROMPT=%{%B%F{130}%}\$vcs_info_msg_0_%b

## prompt ##
PROMPT_SYMBOL='>'
PROMPT='%{%F{067}%}%c%{%F{none}%} $PROMPT_SYMBOL '

source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
