dotfiles
========

My dotfiles

Setting up on Windows 7
-----------------------

This is not a complete guide, just a few hints.

1. Clone repo to $HOME directory
2. Copy files from `windows` directory to $HOME directory

Setting up Babun/Cygwin
-----------------------

1. Install [Babun](https://babun.github.io/)
1. Install Source Code Pro font [modified for Powerline](https://github.com/powerline/fonts/tree/master/SourceCodePro).
1. Configure Babun to use `Sauce Code Powerline` font.
1. Create SSH key (`ssh-keygen -t rsa -b 4096`) and upload to GitHub.
1. Update `.babunrc` file as needed (proxies, user agent, etc.).
1. Reload `.babunrc` and verify Network connectivity and available updates.
    
    ```sh
    source .babunrc
    babun check
    ```
    
1. Clone dotfiles and run installation scripts.

    ```sh
    cd $HOME
    git clone git@github.com:gtback/dotfiles.git
    mv .zshrc .zshrc.bak
    mv .gitconfig .gitconfig.bak
    dotfiles/setup_env.py
    dotfiles/setup_vim.sh
    ```
    
1. Customize local installation.

    ```sh
    git config -f .gitconfig.local user.name "Greg Back"
    git config -f .gitconfig.local user.email gtback@users.noreply.github.com
    ```

1. Launch a new terminal to reload ZSH settings.  If you get error messages, you can try updating the completion files. Note that the file containing <COMPUTER NAME> should already exist; replace that file.

    ```sh
    compinit -y
    cp .zcompdump .zcompdump-<COMPUTER NAME>-5.0.6
    ```
    
1. Set up pip, virtualenvwrapper, and pipsi.
    
    ```sh
    curl https://bootstrap.pypa.io/get-pip.py | python
    pip install virtualenvwrapper
    curl https://raw.githubusercontent.com/mitsuhiko/pipsi/master/get-pipsi.py | python
    ```

1. Install other desired packages

    ```sh
    pact install tmux
    ```

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

For VirtualBox, to get shared folders to work, run `sudo adduser $USER vboxsf`

```sh
sudo apt-get update
sudo apt-get upgrade
sudo apt-get install -y build-essential cmake curl git python-dev tmux vim vim-gnome xclip zsh

ssh-keygen
```
Upload ~/.ssh/id_rsa.pub to GitHub.
```sh
git config --file ~/.gitconfig.local user.email "gtback@users.noreply.github.com"
git config --file ~/.gitconfig.local user.name "Greg Back"

cd $HOME
git clone git@github.com:gtback/dotfiles.git
python dotfiles/setup_env.py

# Vim Setup
source dotfiles/setup_vim.sh
$HOME/.vim/bundle/YouCompleteMe/install.py

# Oh-my-zsh setup
cd $HOME
chsh -s `which zsh`
git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh

# Python setup
git clone https://github.com/yyuu/pyenv.git ~/.pyenv
sudo apt-get install -y libbz2-dev libncurses5-dev libreadline-dev libsqlite3-dev libssl-dev llvm wget zlib1g-dev
pyenv install 2.7.11
pyenv install 3.5.1
pyenv rehash
echo "2.7.11\n3.5.1\nsystem\n" > ~/.pyenv/version

# Log out and back on to update Shell settings

~/.pyenv/versions/2.7.11/bin/pip install virtualenvwrapper

# Pipsi setup
pyenv rehash
curl https://raw.githubusercontent.com/mitsuhiko/pipsi/master/get-pipsi.py | ~/.pyenv/versions/2.7.11/bin/python
pipsi install autopep8
pipsi install flake8
pipsi install httpie
pipsi install pep8
pipsi install pylint
pipsi install tmuxp
pipsi install tox
pipsi install twine

# Terminal Colors and Fonts
# Create a new Terminal Profile and use it for all modifications below.
cd $HOME
mkdir src
cd src
git clone https://github.com/gnumoksha/gnome-terminal-colors
gnome-terminal-colors/install.sh

git clone https://github.com/powerline/fonts.git powerline-fonts
powerline-fonts/install.sh
# Configure the Terminal Profile to use  `Sauce Code Powerline Medium.otf`
```

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
