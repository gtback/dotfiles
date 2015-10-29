set nocompatible               " be iMproved
filetype off                   " required!

" Vundle (https://github.com/gmarik/vundle)
if has('win32')
  set rtp+=~/vimfiles/bundle/Vundle.vim/
  let path='~/vimfiles/bundle'
  call vundle#begin(path)
else
  set rtp+=~/.vim/bundle/vundle/
  call vundle#begin()
endif

Bundle 'gmarik/Vundle.vim'

Bundle 'altercation/vim-colors-solarized'
Bundle 'airblade/vim-gitgutter'
Bundle 'bitc/vim-bad-whitespace'
Bundle 'chase/vim-ansible-yaml'
Bundle 'fisadev/vim-isort'
Bundle 'jistr/vim-nerdtree-tabs'
Bundle 'jmcantrell/vim-virtualenv'
Bundle 'jnurmine/Zenburn'
Bundle 'kien/ctrlp.vim'
Bundle 'Lokaltog/powerline', {'rtp': 'powerline/bindings/vim/'}
Bundle 'mileszs/ack.vim'
Bundle 'nvie/vim-flake8'
Bundle 'plasticboy/vim-markdown'
if has('mac')
  Bundle 'rizzatti/dash.vim'
endif
Bundle 'rking/ag.vim'
Bundle 'saltstack/salt-vim'
Bundle 'scrooloose/syntastic'
Bundle 'scrooloose/nerdtree'
Bundle 'sjl/gundo.vim'
Bundle 'tmhedberg/SimpylFold'
Bundle 'tpope/vim-commentary'
Bundle 'tpope/vim-fugitive'
Bundle 'tpope/vim-repeat'
Bundle 'tpope/vim-sensible'
Bundle 'tpope/vim-surround'
if has('win32')
  Bundle 'davidhalter/jedi-vim'
elseif !has('win32unix')
  Bundle 'Valloric/YouCompleteMe'
endif
Bundle 'vim-scripts/indentpython.vim'

call vundle#end()

filetype plugin indent on
