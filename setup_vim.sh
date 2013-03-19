#!/usr/bin/env bash
# Install Pathogen
mkdir -p ~/.vim/autoload ~/.vim/bundle
curl -Sso ~/.vim/autoload/pathogen.vim https://raw.github.com/tpope/vim-pathogen/master/autoload/pathogen.vim

# Install sensible and fugitive
cd ~/.vim/bundle
git clone git://github.com/tpope/vim-sensible.git
git clone git://github.com/tpope/vim-fugitive.git
mkdir -p ~/.local/share/vim/undo
git clone git://github.com/altercation/vim-colors-solarized.git
