# Shared shell configuration, sourced by both ~/.bashrc and ~/.zshrc.
# Keep everything in here POSIX-compatible: no bashisms, no zshisms.
# Shell-specific things (prompt, completion, history) live in bashrc/zshrc.

# Which shell are we in? Used for tool hooks that need to know.
if [ -n "$ZSH_VERSION" ]; then
  DOTFILES_SHELL=zsh
elif [ -n "$BASH_VERSION" ]; then
  DOTFILES_SHELL=bash
else
  DOTFILES_SHELL=sh
fi
export DOTFILES_SHELL

# Add to PATH only if the directory exists and isn't already there. This keeps
# PATH sane when the profile gets sourced more than once (login + interactive).
path_prepend() {
  [ -d "$1" ] || return 0
  case ":${PATH}:" in
    *":$1:"*) ;;
    *) PATH="$1:$PATH" ;;
  esac
}

path_append() {
  [ -d "$1" ] || return 0
  case ":${PATH}:" in
    *":$1:"*) ;;
    *) PATH="${PATH}:$1" ;;
  esac
}

# ---------------------------------------------------------------------------
# Homebrew
# ---------------------------------------------------------------------------

# Apple Silicon installs to /opt/homebrew, Intel to /usr/local.
for brew_prefix in /opt/homebrew /usr/local /home/linuxbrew/.linuxbrew; do
  if [ -x "$brew_prefix/bin/brew" ]; then
    eval "$("$brew_prefix/bin/brew" shellenv)"
    HOMEBREW_PREFIX="$brew_prefix"
    break
  fi
done
unset brew_prefix

# ---------------------------------------------------------------------------
# Aliases
# ---------------------------------------------------------------------------

# system/file navigation
alias ls="ls -G"
alias l="ls"
alias ll='ls -Ghlk'
alias la='ls -GAhlka'
alias ..="cd .."

# WiFi diagnostics
alias airport="/System/Library/PrivateFrameworks/Apple80211.framework/Versions/A/Resources/airport" # Use with -s

# OS X utils
alias flushdns="sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder"
alias updatedb="sudo /usr/libexec/locate.updatedb"
alias netstat_proc="sudo lsof -i -P"

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
alias grom='git rebase origin/$(git-default-branch)'
alias gromm='git rebase origin/$(git-default-branch) $(git-default-branch)'
alias glg="git greplog"
alias gls="git log --grep "
alias gwf='git show --pretty="format:" --name-only'
alias gsearch="git log --grep [query] | sed -n '/^commit/p' | cut -d\  -f 2 | xargs git show"
alias gbrecent="git for-each-ref --sort=committerdate refs/heads/"
# Delete every local branch except the default one. grep -vx so a branch
# named e.g. "main-experiment" isn't spared, and the sed strips the "* "
# marker so we never try to delete the branch we're on.
gbclean() {
  default=$(git-default-branch) || return 1
  branches=$(git branch | sed 's/^[* ] //' | grep -vx "$default" || true)
  if [ -z "$branches" ]; then
    echo "No branches to clean up."
    return 0
  fi
  echo "$branches" | xargs git branch -D
}

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

# Starts a local webserver in current dir
alias httpserver="python3 -m http.server"

# Grab all new png files in git repo and optimize them
alias crushpng="git diff --name-only origin/\$(git-default-branch) | grep '\.png$' | xargs -I xxx -P 10 -t pngbai xxx xxx2"

# ---------------------------------------------------------------------------
# Helpers shared by both prompts
# ---------------------------------------------------------------------------

parse_git_branch() {
  ref=$(git symbolic-ref HEAD 2> /dev/null) || return
  echo "("${ref#refs/heads/}")"
}

rbenv_version() {
  command -v rbenv > /dev/null || return
  rbenv version 2> /dev/null | sed -e 's/ .*//'
}

# ---------------------------------------------------------------------------
# PATH
# ---------------------------------------------------------------------------

path_prepend "/usr/local/sbin"
path_prepend "${HOME}/bin"

path_append "${HOME}/code/flutter/flutter/bin"
path_append "${HOME}/.pub-cache/bin"
path_append "/usr/local/mysql/bin"
path_append "/usr/local/mongodb/bin"
path_append "${HOME}/.cargo/bin"

# Android
export ANDROID_HOME="${HOME}/Library/Android/sdk"
path_append "${ANDROID_HOME}/platform-tools"
path_append "${ANDROID_HOME}/tools"

export PATH

# ---------------------------------------------------------------------------
# Build flags
# ---------------------------------------------------------------------------

if [ -n "$HOMEBREW_PREFIX" ]; then
  if [ -d "$HOMEBREW_PREFIX/opt/openssl/lib" ]; then
    export LIBRARY_PATH="${LIBRARY_PATH}:$HOMEBREW_PREFIX/opt/openssl/lib"
  fi
  if [ -d "$HOMEBREW_PREFIX/opt/zlib" ]; then
    export LDFLAGS="-L$HOMEBREW_PREFIX/opt/zlib/lib"
    export CPPFLAGS="-I$HOMEBREW_PREFIX/opt/zlib/include"
    export PKG_CONFIG_PATH="$HOMEBREW_PREFIX/opt/zlib/lib/pkgconfig"
  fi
fi

# ---------------------------------------------------------------------------
# Environment
# ---------------------------------------------------------------------------

export EDITOR='vim'
export VISUAL='vim'
export LESSEDIT='vim'
export LSCOLORS=dxfxcxdxbxegedabagacad
export CLICOLOR=1
export GPG_TTY=$(tty)

# ---------------------------------------------------------------------------
# Version managers and shell hooks
# ---------------------------------------------------------------------------

# This loads RVM into a shell session.
[ -s "$HOME/.rvm/scripts/rvm" ] && . "$HOME/.rvm/scripts/rvm"

if command -v rbenv > /dev/null; then
  eval "$(rbenv init - "$DOTFILES_SHELL")"
fi

if command -v direnv > /dev/null; then
  eval "$(direnv hook "$DOTFILES_SHELL")"
fi

# This loads a private profile if available (used for secret e.g. work related aliases)
[ -s "$HOME/.profile_private" ] && . "$HOME/.profile_private"
