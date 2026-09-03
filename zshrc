# zsh interactive shell config. Everything shell-agnostic lives in ~/.profile,
# which is shared with bash — only zsh-specific things belong here.

[ -s "$HOME/.profile" ] && source "$HOME/.profile"

# ---------------------------------------------------------------------------
# History
# ---------------------------------------------------------------------------

HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000

setopt APPEND_HISTORY          # don't clobber history from parallel shells
setopt INC_APPEND_HISTORY      # write as we go, not only on exit
setopt SHARE_HISTORY           # share between running shells
setopt HIST_IGNORE_ALL_DUPS    # keep only the most recent copy of a command
setopt HIST_IGNORE_SPACE       # leading space keeps a command out of history
setopt HIST_REDUCE_BLANKS
setopt EXTENDED_HISTORY        # record timestamps

# ---------------------------------------------------------------------------
# Options
# ---------------------------------------------------------------------------

setopt AUTO_CD                 # `foo` cds into ./foo
setopt AUTO_PUSHD              # keep a directory stack
setopt PUSHD_IGNORE_DUPS
setopt EXTENDED_GLOB
setopt INTERACTIVE_COMMENTS    # allow # comments at the prompt
setopt NO_BEEP
unsetopt CORRECT_ALL           # "did you mean" is more annoying than helpful

# ---------------------------------------------------------------------------
# Completion
# ---------------------------------------------------------------------------

if [ -n "$HOMEBREW_PREFIX" ] && [ -d "$HOMEBREW_PREFIX/share/zsh/site-functions" ]; then
  fpath=("$HOMEBREW_PREFIX/share/zsh/site-functions" $fpath)
fi

autoload -Uz compinit
# Only do the full security check on the completion dump once a day; otherwise
# compinit adds noticeable startup lag.
if [[ -n $HOME/.zcompdump(#qN.mh+24) ]]; then
  compinit
else
  compinit -C
fi

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'   # case-insensitive
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# ---------------------------------------------------------------------------
# Key bindings
# ---------------------------------------------------------------------------

bindkey -e                              # emacs bindings, like bash
bindkey '^[[A' history-search-backward   # up-arrow searches on what's typed
bindkey '^[[B' history-search-forward
bindkey '^[[3~' delete-char

# ---------------------------------------------------------------------------
# Prompt
# ---------------------------------------------------------------------------

autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git:*' formats '(%b)'
zstyle ':vcs_info:git:*' actionformats '(%b|%a)'

# rbenv shells out, so only ask once per directory rather than per prompt.
_prompt_ruby_version=''
_prompt_ruby_pwd=''
prompt_ruby_version() {
  if [[ "$PWD" != "$_prompt_ruby_pwd" ]]; then
    _prompt_ruby_pwd="$PWD"
    _prompt_ruby_version="$(rbenv_version)"
  fi
  print -n "$_prompt_ruby_version"
}

# add-zsh-hook rather than defining precmd outright, so we play nicely with
# tools that install their own hooks (direnv, rbenv).
autoload -Uz add-zsh-hook
_prompt_precmd() {
  vcs_info
  print -Pn "\e]0;%1~\a"   # terminal title: current directory
}
add-zsh-hook precmd _prompt_precmd

setopt PROMPT_SUBST
PROMPT='%F{magenta}%*%f %F{blue}%~%f %F{green}$(prompt_ruby_version)%f %F{yellow}${vcs_info_msg_0_}%f%F{cyan}$%f '

# ---------------------------------------------------------------------------
# Private/local overrides
# ---------------------------------------------------------------------------

[ -s "$HOME/.zshrc_private" ] && source "$HOME/.zshrc_private"
