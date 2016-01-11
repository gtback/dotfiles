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
set autoread

set foldmethod=indent
set foldlevel=99

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
" Toggle Syntastic Mode
nnoremap <leader>s :SyntasticToggleMode<cr>
" Go to Definition
map <leader>g :YcmCompleter GoToDefinitionElseDeclaration<CR>

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
inoremap jj <ESC>

"split navigations
"https://realpython.com/blog/python/vim-and-python-a-match-made-in-heaven/
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

if has('win32')
  " Vundle (https://github.com/gmarik/vundle)
  source $HOME/dotfiles/bundles.vim
else
  source ~/dotfiles/bundles.vim
endif

if has('gui_running')
  set background=dark
  colorscheme solarized
else
  if filereadable("$HOME/.vim/bundle/Zenburn/colors/zenburn.vim")
    colorscheme zenburn
  endif
endif
call togglebg#map("<F2>")

nnoremap <F3> :NERDTreeToggle <CR>
nnoremap <F4> :CtrlP <CR>
nnoremap <F5> :GundoToggle<CR>
" Underline the current line with dashes in normal mode
nnoremap <F6> yyp<c-v>$r-
" Underline the current line with dashes in insert mode
inoremap <F6> <Esc>yyp<c-v>$r-A
nnoremap <F7> :bp<cr>
inoremap <F7> <Esc>:bp<cr>
nnoremap <F8> :bn<cr>
inoremap <F8> <Esc>:bn<cr>
inoremap <F9> <C-O>za
nnoremap <F9> za
nnoremap <space> za
onoremap <F9> <C-C>za
vnoremap <F9> zf

set nobackup

set wrap
set linebreak
set textwidth=79
set formatoptions=tcroqnl

let g:SimpylFold_docstring_preview=1
let NERDTreeIgnore=['\.pyc$', '\~$'] "ignore files in NERDTree

autocmd FileType html,htmldjango set ts=2 sts=2 sw=2
autocmd FileType yaml set ts=2 sts=2 sw=2
autocmd FileType mkd set ts=2 sts=2 sw=2 foldlevel=20
autocmd FileType gitcommit setlocal tw=72 colorcolumn=72
