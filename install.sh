#!/bin/sh

set -euf

symlink() {
	SRC="$PWD/$1"
	[ -e "$SRC" ] || (echo "No file named $SRC" && exit 1)
	DEST="$2"
	echo "Linking $DEST -> $SRC"
	ln -sf "$SRC" "$DEST"
	#ls -l "$DEST"
}

symlink _zshrc ~/.zshrc
symlink _zsh_plugins.txt ~/.zsh_plugins.txt

symlink _aliases ~/.aliases
symlink _aliases.darwin ~/.aliases.darwin
symlink _aliases.linux ~/.aliases.linux
symlink _aliases.mingw32 ~/.aliases.mingw32
symlink _exports ~/.exports
symlink _exports.cygwin ~/.exports.cygwin
symlink _exports.darwin ~/.exports.darwin
symlink _exports.linux ~/.exports.linux

symlink _ackrc ~/.ackrc
symlink _alacritty.yml ~/.alacritty.yml
symlink _cvsignore ~/.cvsignore
symlink _gitconfig ~/.gitconfig
symlink _gvimrc ~/.gvimrc
symlink _jsbeautifyrc ~/.jsbeautifyrc
symlink _pipx.lock ~/.pipx.lock
symlink _pythonstartup ~/.pythonstartup
symlink _tmux.conf ~/.tmux.conf
symlink _tmux.darwin.conf ~/.tmux.darwin.conf
symlink _vimrc ~/.vimrc
symlink _yarnrc ~/.yarnrc

symlink VSCode/keybindings.json "$HOME/Library/Application Support/Code/User/keybindings.json"
symlink VSCode/settings.json "$HOME/Library/Application Support/Code/User/settings.json"
symlink VSCode/tasks.json "$HOME/Library/Application Support/Code/User/tasks.json"

if grep -q 'source ~/dotfiles/_bashrc' "${HOME}/.bashrc"; then
	echo ".bashrc has already been modified"
else
	echo 'source ~/dotfiles/_bashrc' >>"${HOME}/.bashrc"
fi
