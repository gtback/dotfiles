#!/bin/sh

[ -z "$XDG_CACHE_HOME" ] && export XDG_CACHE_HOME="$HOME/.cache"
[ -z "$XDG_CONFIG_HOME" ] && export XDG_CONFIG_HOME="$HOME/.config"
[ -z "$XDG_DATA_HOME" ] && export XDG_DATA_HOME="$HOME/.local/share"

export ASDF_CONFIG_FILE="$XDG_CONFIG_HOME/asdf/asdfrc"
export ASDF_DATA_DIR="$XDG_DATA_HOME/asdf"
export ASDF_DEFAULT_TOOL_VERSIONS_FILENAME="$XDG_CONFIG_HOME/asdf/tool-versions"

export GNUPGHOME="$XDG_CONFIG_HOME/gnupg"

# Used for Vim and Neovim
# https://blog.joren.ga/tools/vim-xdg
export VIMINIT="source ${XDG_CONFIG_HOME}/vim/vimrc"

# By default, Poetry uses `~/Library/Caches/pypoetry` on macOS
export POETRY_CACHE_DIR="${XDG_CACHE_HOME}/pypoetry"

export ANTIBODY_HOME="$XDG_DATA_HOME/antibody"

# https://git.zx2c4.com/password-store/about/
export PASSWORD_STORE_DIR="$XDG_DATA_HOME"/pass

export TEXMFHOME="${XDG_DATA_HOME}/texmf"
export TEXMFVAR="${XDG_CACHE_HOME}/texlive/texmf-var"
export TEXMFCONFIG="${XDG_CONFIG_HOME}/texlive/texmf-config"

export _ZO_DATA_DIR="${XDG_DATA_HOME}/zoxide"

export GOPATH="${XDG_DATA_HOME}/go"

export GRADLE_USER_HOME="${XDG_DATA_HOME}/gradle"

export KREW_ROOT="${XDG_DATA_HOME}/krew"
