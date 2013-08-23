#!/usr/bin/env bash
# Install Pathogen
mkdir -p ~/.vim/autoload ~/.vim/bundle
cd ~/.vim/autoload
[[ -e pathogen.vim ]] || curl -Sso pathogen.vim https://raw.github.com/tpope/vim-pathogen/master/autoload/pathogen.vim

# Install sensible and fugitive
cd ~/.vim/bundle
[[ -d syntastic ]] || git clone https://github.com/scrooloose/syntastic.git
[[ -d vim-colors-solarized ]] || git clone https://github.com/altercation/vim-colors-solarized.git
[[ -d vim-commentary ]] || git clone https://github.com/tpope/vim-commentary.git
[[ -d vim-fugitive ]] || git clone https://github.com/tpope/vim-fugitive.git
[[ -d vim-sensible ]] || git clone https://github.com/tpope/vim-sensible.git

mkdir -p ~/.local/share/vim/undo
