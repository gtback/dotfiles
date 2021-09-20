#!/bin/zsh

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

autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /usr/local/bin/vault vault
complete -o nospace -C /usr/local/bin/terraform terraform

source-if-exists "$(brew --caskroom)/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc"
source-if-exists "$(brew --caskroom)/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc"

source-if-exists "$(brew --prefix)/share/zsh/site-functions/_todoist_fzf"

eval "$(op completion zsh)"
compdef _op op

_toggl() {
  eval $(env COMMANDLINE="${words[1,$CURRENT]}" _TOGGL_COMPLETE=complete-zsh  toggl)
}
if [[ "$(basename -- ${(%):-%x})" != "_toggl" ]]; then
  compdef _toggl toggl
fi
