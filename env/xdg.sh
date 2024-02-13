#!/bin/sh

[ -z "$XDG_CACHE_HOME" ] && export XDG_CACHE_HOME="$HOME/.cache"
[ -z "$XDG_CONFIG_HOME" ] && export XDG_CONFIG_HOME="$HOME/.config"
[ -z "$XDG_DATA_HOME" ] && export XDG_DATA_HOME="$HOME/.local/share"

export GNUPGHOME="$XDG_CONFIG_HOME/gnupg"

# Used for Vim and Neovim
# https://blog.joren.ga/tools/vim-xdg
export VIMINIT="source ${XDG_CONFIG_HOME}/vim/vimrc"

# By default, Poetry uses `~/Library/Caches/pypoetry` on macOS
# https://python-poetry.org/docs/configuration/#cache-directory
export POETRY_CACHE_DIR="${XDG_CACHE_HOME}/pypoetry"
# By default, Poetry uses `~/Library/Application Support/pypoetry` on macOS
# https://python-poetry.org/docs/configuration/#config-directory
export POETRY_CONFIG_DIR="${XDG_CONFIG_HOME}/pypoetry"
# By default, Poetry uses `~/Library/Application Support/pypoetry` on macOS
# https://python-poetry.org/docs/configuration/#data-directory
export POETRY_DATA_DIR="${XDG_DATA_HOME}/pypoetry"

export ANTIDOTE_HOME="${XDG_DATA_HOME}/antidote"

# https://git.zx2c4.com/password-store/about/
export PASSWORD_STORE_DIR="$XDG_DATA_HOME"/pass

export TEXMFHOME="${XDG_DATA_HOME}/texmf"
export TEXMFVAR="${XDG_CACHE_HOME}/texlive/texmf-var"
export TEXMFCONFIG="${XDG_CONFIG_HOME}/texlive/texmf-config"

export _ZO_DATA_DIR="${XDG_DATA_HOME}/zoxide"

export GOPATH="${XDG_DATA_HOME}/go"
export PATH="${PATH}:${GOPATH}/bin/"

export GRADLE_USER_HOME="${XDG_DATA_HOME}/gradle"

export KREW_ROOT="${XDG_DATA_HOME}/krew"

export MISE_DATA_DIR="${XDG_DATA_HOME}/mise"
export MISE_CACHE_DIR="${XDG_CACHE_HOME}/mise"

export PIPX_HOME="$XDG_DATA_HOME/pipx"
