# bash interactive shell config. Everything shell-agnostic lives in ~/.profile,
# which is shared with zsh — only bash-specific things belong here.

[ -s "$HOME/.profile" ] && source "$HOME/.profile"

# ---------------------------------------------------------------------------
# History
# ---------------------------------------------------------------------------

HISTSIZE=50000
HISTFILESIZE=50000
HISTCONTROL=ignoreboth   # skip duplicates and space-prefixed commands
shopt -s histappend      # don't clobber history from parallel shells

shopt -s checkwinsize
shopt -s cdspell

# ---------------------------------------------------------------------------
# Completion
# ---------------------------------------------------------------------------

if [ -n "$HOMEBREW_PREFIX" ]; then
  if [ -r "$HOMEBREW_PREFIX/etc/profile.d/bash_completion.sh" ]; then
    source "$HOMEBREW_PREFIX/etc/profile.d/bash_completion.sh"
  elif [ -d "$HOMEBREW_PREFIX/etc/bash_completion.d" ]; then
    for completion in "$HOMEBREW_PREFIX/etc/bash_completion.d/"*; do
      [ -r "$completion" ] && source "$completion"
    done
    unset completion
  fi
fi

# ---------------------------------------------------------------------------
# Prompt
# ---------------------------------------------------------------------------

if [ -f "$HOME/.rvm/contrib/ps1_functions" ]; then
  source "$HOME/.rvm/contrib/ps1_functions"
fi

# Echo a function's output, but only if that function is actually defined.
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
RESET="\[\033[00m\]"

export PS1="$PURPLE\t $BLUE\w$GREEN \$( run_fn \"ps1_rvm\" )\$( run_fn \"rbenv_version\" )$YELLOW\$( run_fn \"parse_git_branch\" )$CYAN\$$RESET "

# Terminal title: current directory
PROMPT_COMMAND='echo -ne "\033]0; ${PWD##*/}\007"'

# ---------------------------------------------------------------------------
# Private/local overrides
# ---------------------------------------------------------------------------

[ -s "$HOME/.bashrc_private" ] && source "$HOME/.bashrc_private"
