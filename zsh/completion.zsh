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

# This needs to come before 'bashcompinit' so the `_npm_completion` uses compdef rather than complete
# shellcheck disable=SC1090
eval "$(npm completion)"

source "${XDG_CONFIG_HOME}/zsh/completions/_toggl"

autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /usr/local/bin/vault vault
complete -o nospace -C /usr/local/bin/terraform terraform

source-if-exists "$(brew --caskroom)/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc"
source-if-exists "$(brew --caskroom)/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc"

source-if-exists "$(brew --prefix)/share/zsh/site-functions/_todoist_fzf"

eval "$(op completion zsh)"
compdef _op op

eval "$(register-python-argcomplete pipx)"

compdef _gmailctl gmailctl
