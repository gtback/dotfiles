set nocompatible               " be iMproved
filetype off                   " required!

" Vundle (https://github.com/gmarik/vundle)
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

Bundle 'gmarik/vundle'

Bundle 'altercation/vim-colors-solarized'
"Bundle 'davidhalter/jedi-vim'
Bundle 'scrooloose/syntastic'
Bundle 'tpope/vim-commentary'
Bundle 'tpope/vim-fugitive'
Bundle 'tpope/vim-sensible'
Bundle 'Valloric/YouCompleteMe'
Bundle 'jmcantrell/vim-virtualenv'
Bundle 'airblade/vim-gitgutter'

filetype plugin indent on
