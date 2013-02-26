" Last Modified: 2013-01-21

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
nnoremap <leader><space> :noh<cr>
nnoremap <leader>w {gq}
" Add # at the beginning of all selected lines
vnoremap <leader>c :s/^/#/<cr>:noh<cr>
" Remove # at the beginning of all selected lines
vnoremap <leader>u :s/^#//<cr>:noh<cr>


set wrap
set textwidth=79
set formatoptions=qrn1

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

python from powerline.bindings.vim import source_plugin; source_plugin()

