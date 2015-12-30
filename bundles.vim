" In a separate file because of:
" http://www.gmarik.info/blog/2011/chicken-or-egg-dilemma/

set nocompatible               " be iMproved
filetype off                   " required!

" Vundle (https://github.com/VundleVim/Vundle.vim)
if has('win32')
  set rtp+=~/vimfiles/bundle/Vundle.vim/
  let path='~/vimfiles/bundle'
  call vundle#begin(path)
else
  set rtp+=~/.vim/bundle/Vundle.vim/
  call vundle#begin()
endif

Plugin 'VundleVim/Vundle.vim'

Plugin 'altercation/vim-colors-solarized'
Plugin 'airblade/vim-gitgutter'
Plugin 'bitc/vim-bad-whitespace'
Plugin 'chase/vim-ansible-yaml'
Plugin 'fisadev/vim-isort'
Plugin 'jistr/vim-nerdtree-tabs'
Plugin 'jmcantrell/vim-virtualenv'
Plugin 'jnurmine/Zenburn'
Plugin 'kien/ctrlp.vim'
Plugin 'Lokaltog/powerline', {'rtp': 'powerline/bindings/vim/'}
Plugin 'mileszs/ack.vim'
Plugin 'nvie/vim-flake8'
Plugin 'plasticboy/vim-markdown'
if has('mac')
  Plugin 'rizzatti/dash.vim'
endif
Plugin 'rking/ag.vim'
Plugin 'saltstack/salt-vim'
Plugin 'scrooloose/syntastic'
Plugin 'scrooloose/nerdtree'
Plugin 'sjl/gundo.vim'
Plugin 'tmhedberg/SimpylFold'
Plugin 'tpope/vim-commentary'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-repeat'
Plugin 'tpope/vim-sensible'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-unimpaired'
Plugin 'tpope/vim-vinegar'
if has('win32')
  Plugin 'davidhalter/jedi-vim'
elseif !has('win32unix')
  Plugin 'Valloric/YouCompleteMe'
endif
Plugin 'vim-scripts/indentpython.vim'

call vundle#end()

filetype plugin indent on
