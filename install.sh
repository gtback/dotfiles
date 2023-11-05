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

symlink sh "$XDG_CONFIG_HOME"

# Set up ZSH
symlink zsh "$XDG_CONFIG_HOME"
# .zshenv needs to be in $HOME to bootstrap ZDOTDIR
ln -svfn "$XDG_CONFIG_HOME/zsh/zshenv" ~/.zshenv
mkdir -p "$XDG_CACHE_HOME/zsh"
mkdir -p "$XDG_DATA_HOME/zsh"

# https://asdf-vm.com/#/
symlink asdf "$XDG_CONFIG_HOME"

symlink brewfile "$XDG_CONFIG_HOME"
symlink gh "$XDG_CONFIG_HOME"
symlink git "$XDG_CONFIG_HOME"
symlink gnupg "$XDG_CONFIG_HOME"
symlink krew "$XDG_CONFIG_HOME"
symlink pipx "$XDG_CONFIG_HOME"
symlink tmux "$XDG_CONFIG_HOME"
symlink vim "$XDG_CONFIG_HOME"

symlink _ackrc ~/.ackrc
symlink _alacritty.yml ~/.alacritty.yml
symlink _fzf.bash ~/.fzf.bash
symlink _fzf.zsh ~/.fzf.zsh
symlink _jsbeautifyrc ~/.jsbeautifyrc
symlink _pythonstartup ~/.pythonstartup

symlink starship.toml ~/.config/starship.toml

# Joplin does not respsect XDG_CONFIG_HOME, and puts both data and cache data in
# the hard-coded `~/.config/joplin-desktop/` directory.
# https://github.com/laurent22/joplin/issues/6524
mkdir -p ~/.config/joplin-desktop
symlink joplin-desktop/userchrome.css ~/.config/joplin-desktop/userchrome.css
symlink joplin-desktop/userstyle.css ~/.config/joplin-desktop/userstyle.css

symlink VSCode/keybindings.json "$HOME/Library/Application Support/Code/User/keybindings.json"
symlink VSCode/settings.json "$HOME/Library/Application Support/Code/User/settings.json"
symlink VSCode/tasks.json "$HOME/Library/Application Support/Code/User/tasks.json"

symlink espanso "${HOME}/Library/Preferences"

if grep -q 'source ~/dotfiles/_bashrc' "${HOME}/.bashrc"; then
    echo ".bashrc has already been modified"
else
    echo 'source ~/dotfiles/_bashrc' >>"${HOME}/.bashrc"
fi

# Symlink all virtualenvwrapper hooks
set +f
for f in virtualenvwrapper/*; do
    symlink "${f}" "${WORKON_HOME}"
done
set -f

popd >/dev/null
