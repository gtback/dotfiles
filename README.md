dotfiles
========

My dotfiles

Setting up a new system
=======================

These are some steps I performed when setting up a new Ubuntu 12.04 system
recently.

    apt-get install git python-pip openssh-server zsh vim vim-gnome curl

    git clone https://github.com/gtback/dotfiles.git
    cd dotfiles
    python setup_linux.py
    source setup_vim.sh

    cd ~
    ssh-keygen -t rsa
    chsh -s `which zsh`
    git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh

    sudo pip install -U pip
    sudo pip install virtualenvwrapper
    pip install --user https://github.com/Lokaltog/powerline/archive/develop.zip

    wget https://github.com/Lokaltog/powerline-fonts/raw/master/Inconsolata/Inconsolata%20for%20Powerline.otf

