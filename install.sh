#!/usr/bin/env bash

# /bin/bash on macOS is old and doesn't support `-e` escape codes

set -eufo pipefail
IFS=$'\n\t'

RED='\e[31m'
YELLOW='\e[33m'
GREEN='\e[32m'
RESET='\e[0m'

red() {
    echo -e "${RED}$1${RESET}"
}

yellow() {
    echo -e "${YELLOW}$1${RESET}"
}

green() {
    echo -e "${GREEN}$1${RESET}"
}

# If you don't pass a second argument, the first argument is symlinked into
# `$XDG_CONFIG_HOME`.
symlink() {
    SRC="$dotfiles_dir/$1"
    [ -e "$SRC" ] || (echo "No file named $SRC" && exit 1)
    DEST="${2:-$XDG_CONFIG_HOME/$1}"

    if [ -L "$DEST" ]; then
        # If $DEST is a symlink, check if it's already pointing to the right place.
        current_src="$(readlink -f "$DEST")"
        if [ "$current_src" != "$SRC" ]; then
            red "'$DEST' is symlink to '$current_src', not '$SRC'"
            return 1
        else
            green "'$DEST' is already a symlink to '$SRC'"
            return 0
        fi
    elif [ -d "$DEST" ]; then
        # If $DEST exists, but it's a directory, this is OK (we'll symlink
        # *into* that directory), but if it's a file, raise an error.
        new_dest="$DEST/$(basename $1)"
        if [ -L "$new_dest" ]; then
            green "'$new_dest' is already a symlink to '$SRC'"
            return 0
        elif [ -e "$new_dest" ]; then
            current_src="$(readlink -f "$new_dest")"
            if [ "$current_src" != "$SRC" ]; then
                red "'$new_dest' is symlink to '$current_src', not '$SRC'"
                return 1
            else
                green "'$new_dest' is already a symlink to '$SRC'"
                return 0
            fi
        else
            yellow "Creating $new_dest"
        fi
    elif [ -e "$DEST" ]; then
        red "File already exists at '$DEST'"
        return 1
    fi
    ln -svfFn "$SRC" "$DEST"
}

pushd "$HOME/dotfiles" >/dev/null
dotfiles_dir=$(git rev-parse --show-toplevel)

# If this is running for the first time, these variables won't be set.
set +u
source env/xdg.sh
set -u

# Ensure the primary XDG directories exist
mkdir -p "$XDG_CACHE_HOME" "$XDG_CONFIG_HOME" "$XDG_DATA_HOME"

# Set up directory with environment variables
symlink env

symlink sh

# Set up ZSH
symlink zsh
# .zshenv needs to be in $HOME to bootstrap ZDOTDIR
symlink zsh/zshenv ~/.zshenv
mkdir -p "$XDG_CACHE_HOME/zsh"
mkdir -p "$XDG_DATA_HOME/zsh"

symlink alacritty
symlink brewfile
symlink broot
symlink direnv
symlink gh
symlink git
symlink gnupg
symlink krew
symlink mise
symlink pip
symlink pipx
symlink pypoetry
symlink tmux
symlink vim

symlink _jsbeautifyrc ~/.jsbeautifyrc
symlink _pythonstartup ~/.pythonstartup

symlink starship.toml ~/.config/starship.toml

# Joplin does not respect XDG_CONFIG_HOME, and puts both data and cache data in
# the hard-coded `~/.config/joplin-desktop/` directory.
# https://github.com/laurent22/joplin/issues/6524
joplin_dir="$HOME/.config/joplin-desktop"
mkdir -p "$joplin_dir"
symlink joplin-desktop/userchrome.css "$joplin_dir/userchrome.css"
symlink joplin-desktop/userstyle.css "$joplin_dir/userstyle.css"

# TODO: Make this work outside of macOS
vscode_settings_dir="$HOME/Library/Application Support/Code/User"
mkdir -p "$vscode_settings_dir"
symlink VSCode/keybindings.json "$vscode_settings_dir/keybindings.json"
symlink VSCode/settings.json "$vscode_settings_dir/settings.json"
symlink VSCode/tasks.json "$vscode_settings_dir/tasks.json"

# TODO: Make this work outside of macOS
symlink espanso "$HOME/Library/Preferences"

if [ -e "$HOME/.bashrc" ] && grep -q 'source ~/dotfiles/_bashrc' "$HOME/.bashrc"; then
    green ".bashrc has already been modified"
else
    yellow "Updating .bashrc"
    echo 'source ~/dotfiles/_bashrc' >>"$HOME/.bashrc"
fi

# Symlink all virtualenvwrapper hooks
set +f
for f in virtualenvwrapper/*; do
    # TODO: Handle first time install (before this is defined) better
    [[ -z "${WORKON_HOME:-}" ]] || symlink "$f" "$WORKON_HOME"
done
set -f

launch_agents="$HOME/Library/LaunchAgents"
mkdir -p "$launch_agents"
symlink macos/com.local.KeyRemapping.plist "$launch_agents/com.local.KeyRemapping.plist"

popd >/dev/null
