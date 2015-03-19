set nocompatible               " be iMproved
filetype off                   " required!

" Vundle (https://github.com/gmarik/vundle)
if has('win32')
set rtp+=~/vimfiles/bundle/vundle/
  let path='~/vimfiles/bundle'
  call vundle#rc(path)
else
  set rtp+=~/.vim/bundle/vundle/
  call vundle#rc()
endif

Bundle 'gmarik/vundle'

Bundle 'altercation/vim-colors-solarized'
Bundle 'airblade/vim-gitgutter'
Bundle 'jmcantrell/vim-virtualenv'
Bundle 'kien/ctrlp.vim'
Bundle 'mileszs/ack.vim'
Bundle 'plasticboy/vim-markdown'
if has('mac')
  Bundle 'rizzatti/dash.vim'
endif
Bundle 'rking/ag.vim'
Bundle 'saltstack/salt-vim'
Bundle 'scrooloose/syntastic'
Bundle 'sjl/gundo.vim'
Bundle 'tpope/vim-commentary'
Bundle 'tpope/vim-fugitive'
Bundle 'tpope/vim-repeat'
Bundle 'tpope/vim-sensible'
Bundle 'tpope/vim-surround'
if has('win32')
  Bundle 'davidhalter/jedi-vim'
else
  Bundle 'Valloric/YouCompleteMe'
endif

filetype plugin indent on
