"
" ~/.vimrc
"

" Auto reload
augroup myvimrc
    au!
    au BufWritePost .vimrc,_vimrc,vimrc,.nvimrc,_nvimrc,nvimrc,init.vim so $MYVIMRC
augroup END


"
" Plugins
"

call plug#begin('~/.vim/bundle')

Plug 'tpope/vim-dispatch'

Plug 'junegunn/vim-easy-align'
Plug 'jez/a.vim'

Plug 'chriskempson/base16-vim'

Plug 'morhetz/gruvbox'

call plug#end()

xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)


"
" colors
"

syntax enable
set background=dark
set termguicolors

"if filereadable(expand("~/.vimrc_background"))
"    let base16colorspace=256
"    source ~/.vimrc_background
"endif

colorscheme gruvbox

set guicursor=n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20
"set guicursor=n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50
"            \,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor
"            \,sm:block-blinkwait175-blinkoff150-blinkon175

" hide ~ on nontext lines
hi! NonText ctermfg=black


"
" options
"

set showmode
set mouse=a
set cursorline
set showcmd
set ruler
set laststatus=2
set showtabline=1

set hidden
set switchbuf=useopen,usetab
set confirm
set splitright

set tabstop=4
set shiftwidth=4
set shiftround
set expandtab
set smarttab

set autoindent
set smartindent
set copyindent

set timeout
set nottimeout
set timeoutlen=500
set ttimeoutlen=0
set matchtime=0

set nowrap
set textwidth=0
set wrapmargin=0
set sidescroll=1
set sidescrolloff=8
set synmaxcol=300

set number
set relativenumber
set noshowmatch
let loaded_matchparen = 1

set ignorecase
set smartcase
set hlsearch
set incsearch
set gdefault

set history=1000
set undolevels=1000
set wildignore=*.swp,*.un\~,*.o,*.d
set title
set novisualbell
set noerrorbells

set completeopt-=preview
set completeopt+=menu,longest

set cino+=(0

set clipboard=unnamed

set makeprg="make -j$(nproc)"

set path=.,**

filetype on
filetype plugin on
filetype indent on

set noswapfile
set nobackup
set nowritebackup
if !&diff
    set undodir=~/.vim/undo
    set undofile
endif


"
" Remaps
"

let mapleader = "\<space>"

" move cursor by screen line, not file line
nmap j gj
nmap k gk

" page up/down
nnoremap J <C-d>
vnoremap J <C-d>
nnoremap K <C-u>
vnoremap K <C-u>
" exit from insert to normal mode
inoremap jk <ESC>

" center screen on a line when jumped to
nmap gg gg zz

" switch between header and source files
nnoremap <leader>h :A<CR>
nnoremap <leader>H :AV<CR>

"nnoremap <C-_> :ls<CR>:b<space>
nnoremap <C-_> :find *


"
" Functions
"

function! EditConfig()
    :edit $MYVIMRC
endfunction

function! StripWhitespace()
    :%s/\s\+$//e
endfunction

function! SetMakePrg()
    if filereadable("Makefile")
        set makeprg=make
    elseif filereadable("build.sh")
        set makeprg=./build.sh
    else
        echoerr "No makefile or build script found."
    endif
endfunction

function! RunBinary(headless)
    let l:run_command = ""
    if filereadable("run.sh")
        let l:run_command = "./run.sh"
    else
        let l:dir_name = fnamemodify(getcwd(), ':t')
        let l:run_command = "./bin/" . l:dir_name
    endif

    if (a:headless)
        execute ":Dispatch!" run_command
    else
        execute ":Dispatch" run_command
    endif
endfunction

nnoremap <silent> <F5> :call SetMakePrg()<CR> :Make<CR>
nnoremap <F6> :Make!<CR>
nnoremap <F7> :call RunBinary(0)<CR>
nnoremap <F8> :call RunBinary(1)<CR>

" quickfix error navigation
nnoremap <silent> <F9> :cc 1<CR> <silent> :cn<CR> <silent> :cp<CR>
nnoremap <silent> <F10> :cp<CR>
nnoremap <silent> <F11> :cn<CR>
