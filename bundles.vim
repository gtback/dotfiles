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
Bundle 'kien/ctrlp.vim'
Bundle 'plasticboy/vim-markdown'
Bundle 'scrooloose/syntastic'
Bundle 'sjl/gundo.vim'
Bundle 'tpope/vim-commentary'
Bundle 'tpope/vim-fugitive'
Bundle 'tpope/vim-repeat'
Bundle 'tpope/vim-sensible'
if has('win32')
  Bundle 'davidhalter/jedi-vim'
else
  Bundle 'Valloric/YouCompleteMe'
endif
Bundle 'jmcantrell/vim-virtualenv'
Bundle 'airblade/vim-gitgutter'
Bundle 'saltstack/salt-vim'

filetype plugin indent on
