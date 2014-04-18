dotfiles
========

My dotfiles


Setting up Ubuntu GNOME 14.04
=======================

```sh
sudo add-apt-repository ppa:fkrull/dead-snakes
sudo add-apt-repository ppa:git-core/ppa
sudo add-apt-repository ppa:pi-rho/dev
sudo apt-get update
sudo apt-get upgrade
sudo apt-get install build-essential cmake curl git openssh-server python-pip tmux vim vim-gnome zsh

cd $HOME
ssh-keygen -t rsa
```
Upload ~/.ssh/id_rsa.pub to GitHub.
```sh
git clone git@github.com:gtback/dotfiles.git
python dotfiles/setup_linux.py
source dotfiles/setup_vim.sh

cd $HOME/.vim/bundle/YouCompleteMe
./install

cd $HOME
chsh -s `which zsh`
git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh

mkdir -p .cache/wheel .cache/pip
sudo pip install pep8 pyflakes pylint tmuxp virtualenvwrapper

mkdir src
cd src
git clone https://github.com/sigurdga/gnome-terminal-colors-solarized
gnome-terminal-colors-solarized/install.sh

git clone https://github.com/Lokaltog/powerline.git
pip install --user -e powerline

git clone https://github.com/Lokaltog/powerline-fonts.git
```
Install `~/src/powerline-fonts/SourceCodePro/Sauce Code Powerline Medium.otf` and configure the Terminal application to use it.

Log out and back in to ensure changes have taken effect.


Setting up a new Ubuntu 12.04 system
====================================

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
