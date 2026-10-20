#!/bin/zsh
# shellcheck shell=bash

# https://docs.brew.sh/Shell-Completion#configuring-completions-in-zsh
# This must be done before `compinit` is called
if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH
fi

autoload -Uz compinit

# https://wiki.archlinux.org/title/XDG_Base_Directory#Hardcoded
compinit -d "$XDG_CACHE_HOME/zsh/zcompdump-$ZSH_VERSION"
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh/zcompcache"

# Include hidden files in completions
_comp_options+=(globdots)

autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C "${LOCAL_HIERARCHY:-/usr/local}/bin/vault" vault
complete -o nospace -C "${MISE_DATA_DIR}/installs/terraform/latest/bin/terraform" terraform

if command -v mise &>/dev/null; then
  if gcloud_path=$(mise where gcloud 2>/dev/null); then
    source-if-exists "$gcloud_path/path.zsh.inc"
    source-if-exists "$gcloud_path/completion.zsh.inc"
  fi
fi

source-if-exists "${LOCAL_HIERARCHY:-/usr/local}/etc/bash_completion.d/az"

# Source a tool's generated completion script from a cache instead of running
# the tool at every shell startup. (Running `op` at startup, for example,
# triggers a macOS "access data from other apps" prompt for the terminal.)
#
# The cache is regenerated when the tool's resolved binary path changes, so
# Homebrew upgrades and mise version switches are picked up. Tools run through
# a mise shim resolve to the mise binary, so those refresh only when mise
# itself changes; delete "$XDG_CACHE_HOME/zsh/completions-cache" to force it.
#
# Usage: _cached_completion <cmd> <completion args...>
# shellcheck disable=SC2154  # `commands` and `functions` are zsh parameters
_cached_completion() {
  local cmd=$1
  shift
  [[ -n ${commands[$cmd]} ]] || return 0

  local dir="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/completions-cache"
  local script="$dir/$cmd.zsh" stamp="$dir/$cmd.path"
  local bin=${commands[$cmd]:A}

  if [[ ! -s $script || ! -f $stamp || $(<"$stamp") != "$bin" ]]; then
    mkdir -p "$dir" || return 1
    "$cmd" "$@" >| "$script.tmp" 2>/dev/null && [[ -s $script.tmp ]] \
      && mv "$script.tmp" "$script" && print -r -- "$bin" >| "$stamp"
    rm -f "$script.tmp"
  fi

  # shellcheck disable=SC1090
  [[ -s $script ]] && source "$script"
  [[ -n ${functions[_$cmd]} ]] && compdef "_$cmd" "$cmd"
  return 0
}

_cached_completion op completion zsh
_cached_completion kubectl completion zsh
_cached_completion gmailctl completion zsh
_cached_completion dyff completion zsh

# The docker.plugin.zsh file from oh-my-zsh expects this variable to be defined
# and this directory to exist. See:
# - https://github.com/ohmyzsh/ohmyzsh/issues/11866
# - https://github.com/ohmyzsh/ohmyzsh/blob/2ef7c73cc884163367279e4b586136e3335b1c53/oh-my-zsh.sh#L56-L57
export ZSH_CACHE_DIR="${XDG_CACHE_HOME}/zsh"
mkdir -p "${ZSH_CACHE_DIR}/completions"
