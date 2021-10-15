#!/bin/zsh
# shellcheck shell=bash

# Uncomment to enable profiling of zsh startup
# - https://blog.askesis.pl/post/2017/04/how-to-debug-zsh-startup-time.html
#zmodload zsh/zprof

for f in "$XDG_CONFIG_HOME"/env/*.sh; do
  if [ -r "$f" ]; then
    # shellcheck disable=SC1090
    . "$f"
  fi
done
unset f

# Allow editing the command line:
# https://thevaluable.dev/zsh-install-configure-mouseless/#editing-command-lines-in-vim
# See also: https://blog.thecodewhisperer.com/permalink/edit-then-execute
autoload edit-command-line
zle -N edit-command-line
bindkey -M vicmd v edit-command-line

setopt NO_NOMATCH

## History file configuration
HISTFILE="$XDG_DATA_HOME"/zsh/history
HISTSIZE=1000000 # Number of commands saved to file
# shellcheck disable=SC2034
SAVEHIST=1000000 # Number of commands saved in memory

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

# https://github.com/zsh-users/zsh-history-substring-search
# Turning off temporarily as I can't get this to work.
# bindkey '^[[A' history-substring-search-up
# bindkey '^[[B' history-substring-search-down

export KEYTIMEOUT=1

### Set up Directory Stack
# https://thevaluable.dev/zsh-install-configure-mouseless/#zsh-directory-stack
setopt AUTO_PUSHD        # Push the current directory visited on the stack.
setopt PUSHD_IGNORE_DUPS # Do not store duplicates in the stack.
setopt PUSHD_SILENT      # Do not print the directory stack after pushd or popd.
alias d='dirs -v'
for _index in {1..20}; do
  # shellcheck disable=SC2139
  alias "$_index=cd +${_index}"
done
unset _index

source-if-exists() {
  # shellcheck disable=SC1090
  [ -s "$1" ] && source "$1"
}

# Load shell aliases and environment variables

for dotfile in sh/aliases sh/exports zsh/completion.zsh; do
  file="${XDG_CONFIG_HOME}/${dotfile}"
  source-if-exists "${file}"
  source-if-exists "${file}.${os}"
  source-if-exists "${file}.$(hostname)"
  source-if-exists "${file}.local"
done

# Load other tools' configuration files

# source-if-exists $POWERLINE/bindings/zsh/powerline.zsh
source-if-exists "${HOME}/.nix-profile/etc/profile.d/nix.sh"
source-if-exists "${XDG_CONFIG_HOME}/broot/launcher/bash/br"

if [ "$TERM_PROGRAM" == "vscode" ]; then
  echo "Disabling shell environment managers (virtualenvwrapper) in Visual Studio Code"
else
  source-if-exists /usr/local/bin/virtualenvwrapper.sh
  source-if-exists "$(brew --prefix asdf)/asdf.sh"
fi

# https://github.com/junegunn/fzf
source-if-exists ~/.fzf.zsh

# Load prompt
if which starship &>/dev/null; then
  eval "$(starship init zsh)"
fi

source <(antibody init)
antibody bundle <"${ZDOTDIR}/plugins.txt"

# Uncomment to print results of startup profiling
#zprof
