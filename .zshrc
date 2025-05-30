# HOTKEYS
# Ctrl + D - Fuzzy find and CD into dir
# Ctrl + G - Fuzzy find + preview
# Ctrl + F - Fuzzy find + preview + vi selected file
# Ctrl + R - Fuzzy find command history
# Ctrl + T - Fuzzy find filename into terminal


if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="powerlevel10k/powerlevel10k"


# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=1000
setopt inc_append_history

plugins=(git zsh-syntax-highlighting zsh-autosuggestions)

source $ZSH/oh-my-zsh.sh

alias ls=colorls
alias vi=nvim
alias ll='ls -l'
alias llrt='ls -lrt'
alias la='ls -a'
alias lla='ls -la'
alias cl='clear'

alias fig='find . -name "*.java"|xargs grep -il $1'
function vg() { vi `find . -name "*.java"|xargs grep -il "$1"`; }

function cd_up() {
if [ -z "$1" ]; then
    cd ..
else
    cd $(printf "%0.s../" $(seq 1 $1 ))
fi
}
alias 'up'='cd_up'

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
setopt ignoreeof
bindkey -r '^D'
#bindkey '^D' fzf-cd-widget

fzf_cd() {
  local dir
  dir=$(find . -type d 2>/dev/null | fzf) || return
  if [ -n "$dir" ]; then
    cd "$dir"
    zle reset-prompt
    zle accept-line   # Simulate pressing Enter
  fi
}
zle -N fzf_cd
bindkey '^D' fzf_cd

fzf_func() {
  fzf --preview 'bat --color=always {}' --preview-window '~3'
}

vifzf() {
  vi "$(fzf_func)"
}
vi_fzf_launch() {
  zle -I
  BUFFER="vifzf"
  zle accept-line
}
zle -N vi_fzf_launch
bindkey '^F' vi_fzf_launch
