
# system/file navigation
alias ls="ls -G"
alias l="ls"
alias ll='ls -Ghlk'
alias la='ls -GAhlka'
alias ..="cd .."

# freaking ios simulator is hidden away in Xcode 4.3.1
alias ios="open '/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/Applications/iPhone Simulator.app'"

# WiFi diagnostics
alias airport="/System/Library/PrivateFrameworks/Apple80211.framework/Versions/A/Resources/airport" # Use with -s

# OS X utils
alias flushdns="dscacheutil -flushcache"
alias updatedb="sudo /usr/libexec/locate.updatedb"
alias netstat_proc="sudo lsof -i -P"

# For OS X terminal title
PROMPT_COMMAND='echo -ne "\033]0; ${PWD##*/}\007"'

alias g='git'
alias gs='git s'
alias ga='git add'
alias gap='git ap'
alias gadd='git add'
alias gc='git commit'
alias gco='git checkout'
alias gw='git show'
alias gd='git d'
alias gl="git l"
alias gf='git f'
alias gdc='git dc'
alias gdo='git do'
alias gg='git g'
alias gp='git p'
alias gb='git symbolic-ref HEAD'
alias gr='git rebase'
alias gri='git rebase -i'
alias grom='git rebase origin/master'
alias gromm='git rebase origin/master master'
alias glg="git greplog"
alias gls="git log --grep "
alias gwf='git show --pretty="format:" --name-only'
alias gsearch="git log --grep [query] | sed -n '/^commit/p' | cut -d\  -f 2 | xargs git show"
alias gbrecent="git for-each-ref --sort=committerdate refs/heads/"
alias gbclean="git branch | grep -v "master" | xargs git branch -D"

# Ruby/Rails/rake
alias sc="script/console"
alias shotgun="shotgun --server=thin"
alias rt="RAILS_ENV=test rake"
alias rsc="rake spec cucumber"
alias rs="rake spec"
alias rc="rake cucumber"
alias brake="bundle exec rake"
alias brspec="bundle exec rspec"
alias cap="bundle exec cap"

if [ -f $HOME/.rvm/contrib/ps1_functions ]; then
  source "$HOME/.rvm/contrib/ps1_functions"
fi

if [ -f "/usr/local/etc/bash_completion.d" ]; then
  source "/usr/local/etc/bash_completion.d"
fi

function parse_git_branch {
  ref=$(git symbolic-ref HEAD 2> /dev/null) || return
    echo "("${ref#refs/heads/}")"
}

__rbenv_ps1 () {
    if which rbenv > /dev/null; then
      rbenv_ruby_version=`rbenv version | sed -e 's/ .*//'`
      printf $rbenv_ruby_version
    fi
}

run_fn() {
  [[ "$(declare -Ff "$1")" ]] || return
  echo "$($1)"
}

RED="\[\033[0;31m\]"
GREEN="\[\033[0;32m\]"
YELLOW="\[\033[0;33m\]"
BLUE="\[\033[0;34m\]"
PURPLE="\[\033[0;35m\]"
CYAN="\[\033[0;36m\]"

export PS1="$PURPLE\t \w$GREEN \$( run_fn \"ps1_rvm\" )\$( run_fn \"__rbenv_ps1\" )$YELLOW\$( run_fn \"parse_git_branch\" )$CYAN\$\[\033[00m\] "
export LSCOLORS=dxfxcxdxbxegedabagacad

export PATH=${PATH}:/usr/local/sbin:${HOME}/bin

# Mysql
MYSQL_HOME=/usr/local/mysql
if [ -d $MYSQL_HOME ]; then
  export PATH=${PATH}:${MYSQL_HOME}/bin
fi

# Mongodb
MONGO_HOME=/usr/local/mongodb
if [ -d $MONGO_HOME ]; then
  export PATH=${PATH}:${MONGO_HOME}/bin
fi

# Flash/Flex
export FLEXPATH=${HOME}/code/flex_4_13
export FLEX_HOME=${FLEXPATH}
if [ -d $FLEX_HOME ]; then
  export PATH=${PATH}:${FLEX_HOME}/bin
fi

# ImageMagick
IMAGE_MAGICK_HOME=/usr/local/Cellar/imagemagick/6.7.1-1
if [ -d $IMAGE_MAGIC_HOME ]; then
  export PATH=${PATH}:${IMAGE_MAGICK_HOME}/bin
fi

# Android
export ANDROID_HOME=${HOME}/code/adt-bundle-mac
if [ -L "$ANDROID_HOME" ]; then
  export PATH=${PATH}:${ANDROID_HOME}/platform-tools:${ANDROID_HOME}/tools
fi

# Node
NPM=/usr/local/share/npm/bin
if [ -d $NPM ]; then
  export PATH=${PATH}:${NPM}
fi

export EDITOR='vim'
export VISUAL='vim'
export LESSEDIT='vim'

# For TextMate
# export EDITOR='/usr/local/bin/mate -w'
# export VISUAL='/usr/local/bin/mate -w'
# export LESSEDIT='/usr/local/bin/mate -l %lm %f'

alias crushpng="git diff --name-only origin/master | grep '\.png$' | xargs -I xxx -P 10 -t pngbai xxx xxx2"

# This loads RVM into a shell session.
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"

# Load rbenv
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

# PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting

export GPG_TTY=$(tty)

# This loads a private profile if available (used for secret e.g. work related aliases)
[[ -s "$HOME/.profile_private" ]] && source "$HOME/.profile_private"

# direnv
eval "$(direnv hook bash)"

