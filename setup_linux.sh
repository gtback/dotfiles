#!/bin/sh

cd ~
ln -s dotfiles/_vimrc .
ln -s dotfiles/_gvimrc .
ln -s dotfiles/.tmux.conf .

echo "source ~/dotfiles/.bashrc" >> .bashrc
