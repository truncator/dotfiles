set nocompatible " use vim settings, not vi

set showmode        " show editor mode
set mouse=a         " enable mouse if terminal supports it
set cursorline      " underline current line
set showcmd         " show command in last line of screen
set ttyfast
set ruler           " display line/col numbers
set laststatus=2    " always display status bar
set showtabline=2   " always display tabs

set tabstop=4
set shiftwidth=4
set shiftround " use multiple of shiftwidth when using '>' or '<'

set autoindent
set smartindent
set copyindent " copy previous indentation

set timeoutlen=500
set ttimeoutlen=0

set relativenumber
set nowrap
set showmatch " show matching parenthesis
set smarttab  " insert tabs based on shiftwidth

set ignorecase " ignore case when searching
set smartcase " search is not case-sensitive if pattern is all lowercase
set hlsearch  " highlight search terms
set incsearch " show search matches as you type
set gdefault  " replace globally on line by default

set history=1000
set undolevels=1000
set undofile         " store undo changes in .un file
set wildignore=*.swp,*.o,*.d
set title            " change terminal title
set visualbell       " no beeping
set noerrorbells     " no beeping

set completeopt-=preview " disable scratch preview

set cinkeys=0{,0},0),:,!^F,o,O,e " remove '#' from column 0 alignment

"
" Remaps
"

" move cursor by screen line, not file line
map j gj
map k gk

let mapleader = "\<space>"
nnoremap <leader><space> :noh<cr>

" strip all trailing whitespace
nnoremap <leader>W :%s/\s\+$//<cr>:let @/=''<CR> 

" select just-pasted text
nnoremap <leader>v V`]

" use black hole register
nnoremap <leader>b "_

" edit ~/.vimrc (this file!)
nnoremap <leader>ev :tabnew $MYVIMRC<cr>

" nnoremap <leader><tab> :Scratch<CR>

nnoremap <leader>w :w<CR>
nnoremap <leader>o :tabnew<CR>:e.<CR>
nnoremap <leader>q :tabclose<CR>
nnoremap <leader>x :x<CR>
nnoremap ? :CtrlP<esc>

" tab navigation
nnoremap H gT
nnoremap L gt

" exit from insert to normal mode
inoremap jk <ESC>
inoremap jK <ESC>
inoremap Jk <ESC>
inoremap JK <ESC>

" switch between header and source files
map <leader>h :e %:p:s,.hpp$,.X123X,:s,.cpp$,.hpp,:s,.X123X$,.cpp,<CR>

"
" Auto reload
"

" reload vim if ~/.vimrc changes
augroup myvimrc
    au!
    au BufWritePost .vimrc,_vimrc,vimrc,.gvimrc,_gvimrc,gvimrc so $MYVIMRC | if has('gui_running') | so $MYGVIMRC | endif
augroup END

"
" Color scheme
"

if $TERM == "rxvt-unicode-256color"
	set t_Co=256
endif

colorscheme gruvbox
set background=dark
syntax enable

"
" Plugins
"

filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" required
Plugin 'gmarik/Vundle.vim'

Plugin 'tikhomirov/vim-glsl'
Plugin 'kien/ctrlp.vim'

call vundle#end()
filetype plugin indent on
