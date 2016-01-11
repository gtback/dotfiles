#!/usr/bin/env bash

# Install Vundle
mkdir -p ~/.vim/bundle
[[ -d ~/.vim/bundle/Vundle.vim ]] || git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

vim +BundleInstall +qall

mkdir -p ~/.local/share/vim/undo
