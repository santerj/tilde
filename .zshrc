## shell vars ##
export HISTFILE="$HOME/.zsh_history"
export SAVEHIST=500
export SHELL='/usr/bin/zsh'
export EDITOR='vim'
export GIT_EDITOR='vim'
export LESS=' -R '
export PYTHON="$(which python3)"
export UNAME="$(uname -s)"

## aliases ##
alias sudo="sudo "
alias clc="tput reset && clear"
alias ls="ls -G"
alias la="ls -latrshFG"
alias wttr="curl wttr.in/Tampere'?'2qn"
alias digs="dig +short"
alias brewu="brew upgrade && brew update && brew autoremove && brew cleanup"

## system dependent aliases ##
case $UNAME in
  Darwin)
    alias finder="open . -a finder"
    ;;
  Linux)
    alias finder="xdg-open ."
    alias dnfu="sudo dnf upgrade --refresh -y && sudo dnf autoremove -y && sudo dnf clean all"
    ;;
esac

## path ##
typeset -U path
path=(
  /usr/local/bin
  /usr/bin
  /bin
  $HOME/bin
  /usr/local/sbin
  /usr/sbin
  /sbin
  $HOME/.local/bin  # for pipx
)

## emacs keybinds for shell ##
bindkey -e

## shell options ##
setopt correct            # correct typos
setopt automenu           # show completion menu on tab
setopt autocd             # cd with dir name
setopt cdablevars         # cd with var name
setopt prompt_subst       # prompt supports vars
setopt HIST_IGNORE_SPACE  # prefix space to avoid history


## completion styles ##
zstyle ':completion:*' list-colors "${(@s.:.)LS_COLORS}"  # apply color to lists
zstyle ':completion:*' menu select                        # interactive menu for tab
zstyle ':vcs_info:git:*' formats '%b'                     # git info shows branch only

## zsh modules ##
autoload -U compinit           # completion system
autoload -U colours            # enable named colors
autoload -Uz vcs_info          # git info for prompt
autoload -U select-word-style  # cursor movement by words
select-word-style bash         # ctrl+arrow moves by words
compinit                       # initialize completion system

## custom keybinds ##
bindkey '^I' first-tab              # tab on empty line autocompletes cd + shows suggestions
bindkey '^[[A' up-line-or-search    # arrow up to search history
bindkey '^[[B' down-line-or-search  # arrow down to search newer history

## prompts ##
## git rprompt from https://git-scm.com/book/en/v2/Appendix-A%3A-Git-in-Other-Environments-Git-in-Zsh ##
precmd_vcs_info() { vcs_info }            # look for git info before each prompt
precmd_functions+=( precmd_vcs_info )     # run above at each prompt
RPROMPT=%{%B%F{130}%}\$vcs_info_msg_0_%b  # branch on right in git dirs
PROMPT='%{%F{067}%}%c%{%F{none}%} > '     # trailing part of pwd + > (~ in home)

## custom functions ##

## don't add the usual stuff to history ##
function zshaddhistory() {
  [[ "$1" =~ '^(ls|cd|pwd|exit|cd ..)$' ]] && return 1
  return 0
}

## setup and source venv in python projects ##
function fastenv() {
  $PYTHON -m venv venv
  venv/bin/python -m pip install --upgrade pip
  if [[ -f "requirements.txt" ]]; then
    venv/bin/python -m pip install -r requirements.txt
  fi
  source venv/bin/activate
}

## mkdir and cd with single arg ##
## https://github.com/ohmyzsh/ohmyzsh/blob/58cba614652ce8115138fef5c7d80c8a0c0a58f4/lib/functions.zsh#L49 ##
function take() {
  mkdir -p $@ && cd ${@:$#}
}

## no command + tab shows cd with completions ##
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
## !! this has to be at the END of .zshrc ##
case $UNAME in
  Darwin)
    #source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
    #source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
    source /usr/local/Cellar/zsh-syntax-highlighting/0.8.0/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
    ;;
  Linux)
    source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
    ;;
esac
