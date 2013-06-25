
# system/file navigation
alias ls="ls -G"
alias l="ls"
alias ll='ls -Ghlk'
alias la='ls -GAhlka'
alias ..="cd .."
alias G=" | grep "

# freaking ios simulator is hidden away in Xcode 4.3.1
alias ios="open '/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/Applications/iPhone Simulator.app'"

# OS X utils
alias flushdns="dscacheutil -flushcache"
alias updatedb="sudo /usr/libexec/locate.updatedb"
alias netstat_proc="sudo lsof -i -P"

# GIT (TODO: Clean this up, conflicts w/ git aliases)
alias g='git'
alias gs='git status'
alias ga='git add'
alias gap='git add -p'
alias gadd='git add'
alias gc='git commit'
alias gcam="git commit -a -m"
alias gco='git checkout'
alias gw='git show'
alias gg='git grep -i'
alias gd='git diff'
alias gdc='git diff --cached'
alias gdo='git diff origin/master'
alias gf='git fetch'
alias gp='git push'
alias gt='git stash'
#alias gsd="git stash show -p | git apply && git stash drop" # stash pop on dirty tree
alias gr='git rebase'
alias gri='git rebase -i'
alias griom='git rebase -i origin/master'
alias grom='git rebase origin/master'
alias gromm='git rebase origin/master master'
alias ggraph='git log --all --decorate --graph --pretty=oneline --abbrev-commit'
alias gl="ggraph"
alias glg="git log --decorate --pretty=oneline --abbrev-commit --grep "
alias gls="git log --grep "
alias gwf='git show --pretty="format:" --name-only'
alias gsearch="git log --grep [query] | sed -n '/^commit/p' | cut -d\  -f 2 | xargs git show"

export GITHUB_USER=$(security find-generic-password -s github.password | grep acct | cut -d= -f2 | tr -d \")
export GITHUB_PASSWORD=$(security find-generic-password -gs github.password 2>&1 >/dev/null | cut -d\  -f2 | tr -d \")


# Ruby/Rails/rake
alias sc="script/console"
alias shotgun="shotgun --server=thin"
alias rt="RAILS_ENV=test rake"
alias rsc="rake spec cucumber"
alias rs="rake spec"
alias rc="rake cucumber"
alias brake="bundle exec rake"
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

#export PS1='\[\033[33;1m\]\t \[\033[31;1m\]\u \[\033[32m\]\W\[\033[35;1m\]\[\033[32m\] $(ps1_rvm) \$\[\033[00m\] '
export PS1="$PURPLE\t \w$GREEN\$( run_fn \"ps1_rvm\" )$YELLOW\$( run_fn \"parse_git_branch\" )$CYAN\$\[\033[00m\] "
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
export FLEX_HOME=/usr/local/flex3
if [ -d $FLEX_HOME ]; then
  export PATH=${PATH}:${FLEX_HOME}/bin
fi

# ImageMagick
IMAGE_MAGICK_HOME=/usr/local/Cellar/imagemagick/6.7.1-1/bin/
if [ -d $IMAGE_MAGIC_HOME ]; then
  export PATH=${PATH}:${IMAGE_MAGICK_HOME}
fi

# Android
export ANDROID_HOME=${HOME}/code/adt-bundle-mac
if [ -d $ANDROID_HOME ]; then
  export PATH=${PATH}:${ANDROID_HOME}/sdk/platform-tools:${ANDROID_HOME}/sdk/tools
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
[[ -s "/Users/andy/.rvm/scripts/rvm" ]] && source "/Users/andy/.rvm/scripts/rvm"
