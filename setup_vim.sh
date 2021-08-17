#!/bin/bash

bundleDir="${XDG_DATA_HOME}/vim/bundle"

# Install Vundle
mkdir -p "$bundleDir"

[[ -d "$bundleDir"/Vundle.vim ]] || git clone https://github.com/VundleVim/Vundle.vim.git "$bundleDir"/Vundle.vim

vim +PluginInstall! +qall
