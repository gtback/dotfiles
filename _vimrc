filetype off
syntax on

set nocompatible
set modelines=0

set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab

set encoding=utf-8
set scrolloff=3
set autoindent
set showmode
set showcmd
set hidden
set wildmenu
set wildmode=list:longest
set visualbell
set cursorline
set ttyfast
set ruler
set backspace=indent,eol,start
set laststatus=2

set foldmethod=indent

if v:version >= 703
    set relativenumber
    set colorcolumn=80
endif


let mapleader = ","

nnoremap / /\v
vnoremap / /\v
set ignorecase
set smartcase
set gdefault
set incsearch
set showmatch
set hlsearch
" Clear all highlights
nnoremap <leader><space> :noh<cr>
" Wrap curent paragraph
nnoremap <leader>w {gq}
" Prettify JSON
nnoremap <leader>j :%!python -m json.tool<cr>
" Select all
nnoremap <leader>a ggVG

" Show trailing whitespace with a <
set list
set listchars=tab:>.,trail:<

nnoremap <up> <nop>
nnoremap <down> <nop>
nnoremap <left> <nop>
nnoremap <right> <nop>
inoremap <up> <nop>
inoremap <down> <nop>
inoremap <left> <nop>
inoremap <right> <nop>
nnoremap j gj
nnoremap k gk
noremap ; :

nnoremap <F7> :bp<cr>
inoremap <F7> :bp<cr>
nnoremap <F8> :bn<cr>
inoremap <F8> :bn<cr>

inoremap jj <ESC>

inoremap <F9> <C-O>za
nnoremap <F9> za
onoremap <F9> <C-C>za
vnoremap <F9> zf

if has('win32')
  " Powerline (https://github.com/Lokaltog/powerline)
  set rtp+=C:\Python27\Lib\site-packages\powerline\bindings\vim
  " Vundle (https://github.com/gmarik/vundle)
  source $HOME/Documents/GitHub/dotfiles/bundles.vim
else
  set rtp+=$HOME/.local/lib/python2.7/site-packages/powerline/bindings/vim
  source ~/dotfiles/bundles.vim
endif


set background=dark
colorscheme solarized

set wrap
set textwidth=79
set formatoptions=tcroqnl

autocmd FileType html,htmldjango set ts=2 sts=2 sw=2
