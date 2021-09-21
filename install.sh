#!/bin/bash

set -euf

symlink() {
    SRC="$PWD/$1"
    [ -e "$SRC" ] || (echo "No file named $SRC" && exit 1)
    DEST="$2"
    ln -svfFn "$SRC" "$DEST"
}

pushd "${HOME}/dotfiles" >/dev/null
# If this is running for the first time, these variables won't be set.
set +u
source env/xdg.sh
set -u

# Set up directory with environment variables
symlink env "$XDG_CONFIG_HOME"

# Set up ZSH
symlink zsh "$XDG_CONFIG_HOME"
# .zshenv needs to be in $HOME to bootstrap ZDOTDIR
ln -svfn "$XDG_CONFIG_HOME/zsh/zshenv" ~/.zshenv
mkdir -p "$XDG_CACHE_HOME/zsh"
mkdir -p "$XDG_DATA_HOME/zsh"

symlink _aliases ~/.aliases
symlink _aliases.darwin ~/.aliases.darwin
symlink _aliases.linux ~/.aliases.linux
symlink _aliases.mingw32 ~/.aliases.mingw32
symlink _exports ~/.exports
symlink _exports.cygwin ~/.exports.cygwin
symlink _exports.darwin ~/.exports.darwin
symlink _exports.linux ~/.exports.linux

# https://asdf-vm.com/#/
symlink asdf "$XDG_CONFIG_HOME"

symlink git "$XDG_CONFIG_HOME"
symlink gnupg "$XDG_CONFIG_HOME"
symlink tmux "$XDG_CONFIG_HOME"
symlink vim "$XDG_CONFIG_HOME"

symlink _ackrc ~/.ackrc
symlink _alacritty.yml ~/.alacritty.yml
symlink _fzf.bash ~/.fzf.bash
symlink _fzf.zsh ~/.fzf.zsh
symlink _jsbeautifyrc ~/.jsbeautifyrc
symlink _pipx.lock ~/.pipx.lock
symlink _pythonstartup ~/.pythonstartup

symlink starship.toml ~/.config/starship.toml

symlink VSCode/keybindings.json "$HOME/Library/Application Support/Code/User/keybindings.json"
symlink VSCode/settings.json "$HOME/Library/Application Support/Code/User/settings.json"
symlink VSCode/tasks.json "$HOME/Library/Application Support/Code/User/tasks.json"

symlink espanso "${HOME}/Library/Preferences"

if grep -q 'source ~/dotfiles/_bashrc' "${HOME}/.bashrc"; then
    echo ".bashrc has already been modified"
else
    echo 'source ~/dotfiles/_bashrc' >>"${HOME}/.bashrc"
fi

popd >/dev/null
