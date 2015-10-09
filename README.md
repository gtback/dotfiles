dotfiles
========

My dotfiles

Setting up on Windows 7
-----------------------

This is not a complete guide, just a few hints.

1. Clone repo to $HOME directory
2. Copy files from `windows` directory to $HOME directory

OS X Setup hints
----------------

1. Install Homebrew
1. Install `python` and `vim` with Homebrew: `brew install python vim`
1. Install virtualenvwrapper with Homebrew pip: `sudo -H /usr/local/bin/pip install virtualenvwrapper`
1. Install `isort` so that Vim can get to it: `sudo -H /usr/local/bin/pip install isort`
1. Install [`pipsi`](https://github.com/mitsuhiko/pipsi) with Homebrew Python: 

    `curl https://raw.githubusercontent.com/mitsuhiko/pipsi/master/get-pipsi.py | /usr/local/bin/python`
    
1. Install powerline with pipsi: `pipsi install powerline-status`

Setting up Ubuntu GNOME 14.04
-----------------------------

```sh
sudo add-apt-repository ppa:fkrull/dead-snakes
sudo add-apt-repository ppa:git-core/ppa
sudo add-apt-repository ppa:pi-rho/dev
sudo apt-get update
sudo apt-get upgrade
sudo apt-get install build-essential cmake curl git openssh-server python-pip tmux vim vim-gnome xclip zsh

cd $HOME
ssh-keygen -t rsa
```
Upload ~/.ssh/id_rsa.pub to GitHub.
```sh
git clone git@github.com:gtback/dotfiles.git
python dotfiles/setup_env.py
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
------------------------------------

These are some steps I performed when setting up a new Ubuntu 12.04 system
recently.

    add-apt-repository ppa:fkrull/dead-snakes
    add-apt-repository ppa:git-core/ppa
    add-apt-repository ppa:pi-rho/dev

    apt-get install curl git openssh-server python-pip tmux vim vim-gnome zsh

    git clone https://github.com/gtback/dotfiles.git
    cd dotfiles
    python setup_env.py
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
