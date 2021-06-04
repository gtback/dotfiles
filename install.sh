#!/bin/bash

set -euf

symlink() {
    SRC="$PWD/$1"
    [ -e "$SRC" ] || (echo "No file named $SRC" && exit 1)
    DEST="$2"
    ln -svfn "$SRC" "$DEST"
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

symlink tmux "$XDG_CONFIG_HOME"

symlink _ackrc ~/.ackrc
symlink _alacritty.yml ~/.alacritty.yml
symlink _cvsignore ~/.cvsignore
symlink _fzf.bash ~/.fzf.bash
symlink _fzf.zsh ~/.fzf.zsh
symlink _gitconfig ~/.gitconfig
symlink _gvimrc ~/.gvimrc
symlink _jsbeautifyrc ~/.jsbeautifyrc
symlink _pipx.lock ~/.pipx.lock
symlink _pythonstartup ~/.pythonstartup
symlink _vimrc ~/.vimrc

symlink starship.toml ~/.config/starship.toml

# https://zork.net/~st/jottings/Rust_and_the_XDG_Base_Directory_Specification.html
# TODO: Move `CARGO_BIN_DIR` to somewhere that *just* cargo can use.
CARGO_BIN_DIR="$HOME/.local/bin"
CARGO_CACHE_DIR="$XDG_CACHE_HOME/cargo"
RUSTUP_CACHE_DIR="$XDG_CACHE_HOME/rustup"

# `$HOME/.local/bin` holds other executables, like those installed by pipx.
mkdir -p "$CARGO_BIN_DIR"
mkdir -p "$CARGO_CACHE_DIR"
mkdir -p "$HOME/.cargo"
mkdir -p "$HOME/.rustup"
mkdir -p "$RUSTUP_CACHE_DIR/downloads"
mkdir -p "$RUSTUP_CACHE_DIR/tmp"
mkdir -p "$RUSTUP_CACHE_DIR/toolchains"
mkdir -p "$RUSTUP_CACHE_DIR/update-hashes"

symlink rustup/settings.toml "$HOME/.rustup"

ln -svfn "$CARGO_BIN_DIR" "$HOME/.cargo/bin"
ln -svfn "$CARGO_CACHE_DIR" "$HOME/.cargo/registry"
ln -svfn "$HOME/.rustup" "$HOME/.multirust"
ln -svfn "$RUSTUP_CACHE_DIR/downloads" "$HOME/.rustup/downloads"
ln -svfn "$RUSTUP_CACHE_DIR/tmp" "$HOME/.rustup/tmp"
ln -svfn "$RUSTUP_CACHE_DIR/toolchains" "$HOME/.rustup/toolchains"
ln -svfn "$RUSTUP_CACHE_DIR/update-hashes" "$HOME/.rustup/update-hashes"

# To clean up:
#   - rm -rf ${XDG_CACHE_HOME}/{cargo,rustup}
#   - rm -rf ${HOME}/{.cargo,.rustup,.multirust}
# Don't remove `$HOME/.local/bin`

symlink VSCode/keybindings.json "$HOME/Library/Application Support/Code/User/keybindings.json"
symlink VSCode/settings.json "$HOME/Library/Application Support/Code/User/settings.json"
symlink VSCode/tasks.json "$HOME/Library/Application Support/Code/User/tasks.json"

symlink espanso.yml "${HOME}/Library/Preferences/espanso/default.yml"

if grep -q 'source ~/dotfiles/_bashrc' "${HOME}/.bashrc"; then
    echo ".bashrc has already been modified"
else
    echo 'source ~/dotfiles/_bashrc' >>"${HOME}/.bashrc"
fi

popd >/dev/null
