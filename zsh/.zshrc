# shellcheck disable=SC1090,SC2034,SC2148,SC2154
# Uncomment to enable profiling of zsh startup
# - https://blog.askesis.pl/post/2017/04/how-to-debug-zsh-startup-time.html
#zmodload zsh/zprof

if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH
fi

for f in "$XDG_CONFIG_HOME"/env/*.sh; do
  if [ -r "$f" ]; then
    # echo "loading $f"
    . "$f"
  fi
done
unset f

autoload -Uz compinit

# https://wiki.archlinux.org/title/XDG_Base_Directory#Hardcoded
compinit -d "$XDG_CACHE_HOME/zsh/zcompdump-$ZSH_VERSION"
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh/zcompcache"

source <(antibody init)
antibody bundle < "${ZDOTDIR}/plugins.txt"

setopt NO_NOMATCH

## History file configuration
HISTFILE="$XDG_DATA_HOME"/zsh/history
HISTSIZE=1000000  # Number of commands saved to file
SAVEHIST=1000000  # Number of commands saved in memory

## History command configuration
setopt EXTENDED_HISTORY       # record timestamp of command in HISTFILE
setopt HIST_EXPIRE_DUPS_FIRST # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt HIST_IGNORE_DUPS       # ignore duplicated commands history list
setopt HIST_IGNORE_SPACE      # ignore commands that start with space
setopt HIST_REDUCE_BLANKS     # remove superfluous blanks from each command
setopt HIST_VERIFY            # show command with history expansion to user before running it
setopt INC_APPEND_HISTORY     # add commands to HISTFILE in order of execution

# By default, make `history` show all commands with a custom timestamp
alias history="fc -l -t '[%F %T]' 1"

os=$(uname | tr '[:upper:]' '[:lower:]' | sed -e 's/_.*//')

# From http://dougblack.io/words/zsh-vi-mode.html
bindkey -v
# bindkey '^P' up-history
# bindkey '^N' down-history
bindkey '^j' down-history
bindkey '^k' up-history
bindkey '^?' backward-delete-char
# bindkey '^h' backward-delete-char
bindkey '^w' backward-kill-word
bindkey '^r' history-incremental-search-backward
export KEYTIMEOUT=1

for dotfile in aliases exports; do
  file="$HOME/.${dotfile}"
  [ -e "${file}" ] && source "${file}"
  [ -e "${file}.${os}" ] && source "${file}.${os}"
  [ -e "${file}.$(hostname)" ] && echo "${file}.$(hostname)" && source "${file}.$(hostname)"
  [ -e "${file}.local" ] && source "${file}.local"
done

# https://github.com/zsh-users/zsh-history-substring-search
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# [ -e $POWERLINE/bindings/zsh/powerline.zsh ] && source $POWERLINE/bindings/zsh/powerline.zsh
if [ -e "${HOME}/.nix-profile/etc/profile.d/nix.sh" ]; then . "${HOME}/.nix-profile/etc/profile.d/nix.sh"; fi # added by Nix installer

if [ "$TERM_PROGRAM" == "vscode" ]; then
  echo "Disabling shell environment managers (virtualenvwrapper) in Visual Studio Code"
else
  [ -s /usr/local/bin/virtualenvwrapper.sh ] && source /usr/local/bin/virtualenvwrapper.sh
  [ -s "$(brew --prefix asdf)/asdf.sh" ] && source "$(brew --prefix asdf)/asdf.sh"
fi
which tmuxp.sh >/dev/null && source tmuxp.zsh

# https://github.com/junegunn/fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

if which starship &>/dev/null
then
  eval "$(starship init zsh)"
fi

autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /usr/local/bin/vault vault
complete -o nospace -C /usr/local/bin/terraform terraform

source "$(brew --caskroom)/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc"
source "$(brew --caskroom)/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc"

source "$(brew --prefix)/share/zsh/site-functions/_todoist_fzf"

# Uncomment to print results of startup profiling
#zprof
