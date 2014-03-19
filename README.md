dotfiles
========

My dotfiles

Setting up a new system
=======================

These are some steps I performed when setting up a new Ubuntu 12.04 system
recently.

    add-apt-repository ppa:fkrull/dead-snakes
    add-apt-repository ppa:git-core/ppa
    add-apt-repository ppa:pi-rho/dev

    apt-get install curl git openssh-server python-pip tmux vim vim-gnome zsh

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
    sudo pip install tmuxp
    pip install --user https://github.com/Lokaltog/powerline/archive/develop.zip

    wget https://github.com/Lokaltog/powerline-fonts/raw/master/Inconsolata/Inconsolata%20for%20Powerline.otf
