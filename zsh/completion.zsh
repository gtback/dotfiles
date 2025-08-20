#!/bin/zsh
# shellcheck shell=bash

# https://docs.brew.sh/Shell-Completion#configuring-completions-in-zsh
# This must be done before `compinit` is called
if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH
fi

# Load custom completions
fpath=("${XDG_CONFIG_HOME}/zsh/completions" "${fpath[@]}")

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

source-if-exists "$(mise where gcloud)/path.zsh.inc"
source-if-exists "$(mise where gcloud)/completion.zsh.inc"

source-if-exists "${LOCAL_HIERARCHY:-/usr/local}/etc/bash_completion.d/az"

eval "$(op completion zsh)"
compdef _op op

if command -v kubectl &>/dev/null; then
  # shellcheck disable=SC1090
  source <(kubectl completion zsh)
fi

# The docker.plugin.zsh file from oh-my-zsh expects this variable to be defined
# and this directory to exist. See:
# - https://github.com/ohmyzsh/ohmyzsh/issues/11866
# - https://github.com/ohmyzsh/ohmyzsh/blob/2ef7c73cc884163367279e4b586136e3335b1c53/oh-my-zsh.sh#L56-L57
export ZSH_CACHE_DIR="${XDG_CACHE_HOME}/zsh"
mkdir -p "${ZSH_CACHE_DIR}/completions"
