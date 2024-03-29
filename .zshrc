export PATH="/usr/local/bin:/usr/bin:/bin:/home/santeri/bin:/usr/local/sbin:/usr/sbin:/sbin"
export EDITOR='vim'
export GIT_EDITOR='vim'
export SHELL='/bin/zsh'
export HISTFILE="$HOME/.zsh_history"
export SAVEHIST=500
export LESS=' -R '
export HISTORY_IGNORE="(ls|cd|pwd|exit|cd ..)"

# pyenv
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# pipx
export PATH="$PATH:/Users/santeri/.local/bin"

setopt correct
setopt automenu
setopt autocd
setopt cdablevars
setopt prompt_subst
set -o emacs

zstyle ':completion:*' list-colors "${(@s.:.)LS_COLORS}"
zstyle ':completion:*' menu select
zstyle ':vcs_info:git:*' formats '%b'

autoload -U compinit
autoload -U colours
autoload -Uz vcs_info
autoload -U select-word-style
select-word-style bash

bindkey '^I' first-tab
bindkey '^[[A' up-line-or-search
bindkey '^[[B' down-line-or-search

alias sudo="sudo "
alias clc="tput reset && clear"
alias ls="ls -G"
alias ll="ls -latrshFG"
alias wttr="curl wttr.in/Tampere'?'2qn"
alias digs="dig +short"
alias brewu="brew upgrade && brew update && brew autoremove && brew cleanup"
alias finder="open . -a finder"

## arrow keys suggestion nav ##
compinit

## prompts ##
## git rprompt from https://git-scm.com/book/en/v2/Appendix-A%3A-Git-in-Other-Environments-Git-in-Zsh ##
precmd_vcs_info() { vcs_info }
precmd_functions+=( precmd_vcs_info )
RPROMPT=%{%B%F{130}%}\$vcs_info_msg_0_%b
PROMPT='%{%F{067}%}%c%{%F{none}%} > '

function fastenv() {
  python3 -m venv venv
  venv/bin/python -m pip install --upgrade pip
  if [[ -f "requirements.txt" ]]; then
    venv/bin/python -m pip install -r requirements.txt
  fi
  source venv/bin/activate
}

function whohas() {
  dig +short -t a $1 | head -1 | xargs whois | grep -i "org-name\|orgname" | uniq
}

## from oh-my-zsh sources ##
function take() {
  mkdir -p $@ && cd ${@:$#}
}

## tab on empty line brings autocompletes cd + displays suggestions ##
## https://unix.stackexchange.com/a/32426 ##
function first-tab() {
    if [[ $#BUFFER == 0 ]]; then
        BUFFER="cd "
        CURSOR=3
        zle list-choices
    else
        zle expand-or-complete
    fi
}
zle -N first-tab

## enable syntax highlighting ##
## has to be at the end of zshrc ##
#source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
#source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/local/Cellar/zsh-syntax-highlighting/0.8.0/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
