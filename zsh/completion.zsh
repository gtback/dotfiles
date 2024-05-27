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
complete -o nospace -C /usr/local/bin/vault vault
complete -o nospace -C /usr/local/bin/terraform terraform

source-if-exists "$(brew --caskroom)/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc"
source-if-exists "$(brew --caskroom)/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc"

source-if-exists "$(brew --prefix)/share/zsh/site-functions/_todoist_fzf"

source-if-exists /usr/local/etc/bash_completion.d/az

eval "$(op completion zsh)"
compdef _op op

eval "$(register-python-argcomplete pipx)"

compdef _gmailctl gmailctl

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
