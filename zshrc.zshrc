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

#alias ls=colorls
#alias vi=nvim
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

#PLABS SPECIFIC___________________________________________________
sshagent() {
  rm -f ~/mysocket
  eval "$(ssh-agent -a ~/mysocket)" > /dev/null
}

sshadd() {
  ssh-add ~/.ssh/id_rsa > /dev/null 2>&1
  ssh-add ~/.ssh/muam_rsa > /dev/null 2>&1
  ssh-add ~/.ssh/att > /dev/null 2>&1
  ssh-add ~/.ssh/simplex > /dev/null 2>&1
  ssh-add ~/.ssh/wxf-att > /dev/null 2>&1
}

sshagent
sshadd

ssh-add -l 2>/dev/null | grep -q bJVHmcf9sOMeLJGu49Bn/DmAJa1+8g7yaNa5UawfG5Q || echo "There is something wrong with ssh-agent.  run sshagent alias ; run sshadd alias"
#PLABS SPECIFIC___________________________________________________

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

reset-work() {
  kill -9 $(lsof -t -i:2222)
}

lezwork(){
  ~/work/wxf/work.sh
}

mousemove(){
  ~/work/mouse_move.sh &
}

java21(){
   export JAVA_HOME=$(/usr/libexec/java_home -v 21)
 }

java8(){
  export JAVA_HOME=$(/usr/libexec/java_home -v 1.8)
}

check(){
  launchctl list | grep -iE "crowdstrike|falcon|carbon|sentinel|jamf|defender|sophos|cisco|protect"
}


web2-dependencies-jar-install(){
  # From your project root directory (/Users/wxf/dev/itp/web2)

# Install plabs-common
mvn install:install-file \
   -Dfile=lib/plabs-common-1.4.6.jar \
   -DgroupId=plabs-common \
   -DartifactId=plabs-common \
   -Dversion=1.4.6 \
   -Dpackaging=jar

# Install Oracle JDBC driver (using the actual filename)
mvn install:install-file \
   -Dfile=lib/ojdbc6.jar \
   -DgroupId=oracle-jdbc-driver \
   -DartifactId=oracle-jdbc-driver \
   -Dversion=12.1.0.1.0 \
   -Dpackaging=jar
 }

alias viz='vi ~/.zshrc && source ~/.zshrc'
alias src='source ~/.zshrc'
alias vic='vi ~/.ssh/config'


# Mac Power Management Functions
# Add these to your ~/.zshrc file

# 1. Set standard work schedule (wake 9AM weekdays, sleep 5:30PM weekdays)
mac_work_schedule() {
    echo "Setting work schedule: Wake at 9:00AM weekdays, Sleep at 5:30PM weekdays"
    sudo pmset repeat wake MTWRF 09:00:00 sleep MTWRF 17:30:00
    pmset -g sched
}

# 2. Disable sleep for today only
mac_no_sleep_today() {
    echo "Disabling sleep for today only..."
    # Cancel current schedule
    sudo pmset repeat cancel
    # Calculate tomorrow's date in MM/dd/yyyy format
    tomorrow=$(date -v+1d '+%m/%d/%Y')
    # Set sleep to resume tomorrow at 5:30 PM
    sudo pmset schedule sleep "$tomorrow 17:30:00"
    echo "Sleep disabled until tomorrow. Schedule set to resume $tomorrow at 5:30 PM"
    pmset -g sched
}

# 3. Disable sleep for this week
mac_no_sleep_week() {
    echo "Disabling sleep for this week..."
    # Cancel current schedule
    sudo pmset repeat cancel
    # Calculate next Monday's date
    next_monday=$(date -v+1w -v1 '+%m/%d/%Y')
    # Set sleep to resume next Monday at 5:30 PM
    sudo pmset schedule sleep "$next_monday 17:30:00"
    echo "Sleep disabled until next Monday. Schedule set to resume $next_monday at 5:30 PM"
    pmset -g sched
}

# 4. Disable all power scheduling permanently
mac_no_power_schedule() {
    echo "Disabling all power scheduling permanently..."
    sudo pmset repeat cancel
    echo "All power schedules removed. Mac will only sleep based on Energy Saver settings."
    pmset -g sched
}

# 5. Set wake only at 9AM weekdays (no automatic sleep)
mac_wake_only() {
    echo "Setting wake schedule only: 9:00AM weekdays (no automatic sleep)"
    sudo pmset repeat wake MTWRF 09:00:00
    pmset -g sched
}

# Bonus: Show current power schedule
mac_power_status() {
    echo "Current power schedule:"
    pmset -g sched
}


ssh-itp(){
   ssh -N -L 15210:10.69.124.30:1521 wxf@10.69.124.30
 }
