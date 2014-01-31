#!/usr/bin/env bash

# Install Vundle
mkdir -p ~/.vim/bundle
[[ -d ~/.vim/bundle/vundle ]] || git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle 

vim -u ~/dotfiles/bundles.vim +BundleInstall +q

mkdir -p ~/.local/share/vim/undo
