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

Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-dispatch'

Plug 'junegunn/vim-easy-align'
Plug 'haya14busa/incsearch.vim'
Plug 'jez/a.vim'

Plug 'chriskempson/base16-vim'
Plug 'tikhomirov/vim-glsl'
Plug 'beyondmarc/opengl.vim'

call plug#end()

xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)

let g:incsearch#auto_nohlsearch=1
map / <Plug>(incsearch-forward)
map ? <Plug>(incsearch-backward)
map n <Plug>(incsearch-nohl-n)
map N <Plug>(incsearch-nohl-N)
map * <Plug>(incsearch-nohl-*)
map # <Plug>(incsearch-nohl-#)
map g* <Plug>(incsearch-nohl-g*)
map g# <Plug>(incsearch-nohl-g#)


"
" colors
"

"let $NVIM_TUI_ENABLE_TRUE_COLOR=1
let $NVIM_TUI_ENABLE_CURSOR_SHAPE=1

syntax enable
set background=dark

if filereadable(expand("~/.vimrc_background"))
    let base16colorspace=256
    source ~/.vimrc_background
endif

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
" set formatoptions-=t

set number
set relativenumber
set showmatch " show matching parenthesis
set smarttab  " insert tabs based on shiftwidth

set ignorecase " ignore case when searching
set smartcase " search is not case-sensitive if pattern is all lowercase
set hlsearch  " highlight search terms
set incsearch " show search matches as you type
set gdefault  " replace globally on line by default

set history=1000
set undolevels=1000
set wildignore=*.swp,*.un\~,*.o,*.d
set title            " change terminal title
set visualbell       " no beeping
set noerrorbells     " no beeping

set completeopt-=preview " disable scratch preview
set completeopt+=menu,longest

set cino+=(0

set clipboard=unnamed

set makeprg="make -j$(nproc)"

filetype on
filetype plugin on
filetype indent on

set tags+=./tags;
set tags+=~/.vim/tags/gl
set tags+=~/.vim/tags/stdio
set tags+=~/.vim/tags/stdlib
set tags+=~/.vim/tags/stdint

let g:fzf_command_prefix = 'Fzf'
let g:fzf_source = 'find . -type f -name (*.hpp -o *.cpp)'
let g:fzf_layout = { 'window': 'enew' }
let g:fzf_buffers_jump = 1


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

" center screen on a line when jumped to
nmap gg gg zz

" strip all trailing whitespace
nnoremap <leader>W :%s/\s\+$//<cr>:let @/=''<CR> 

" edit ~/.vimrc (this file!)
nnoremap <leader>ev :edit $MYVIMRC<CR>

" FZF
nnoremap <C-_> :call fzf#vim#files('', {'source': 'find . -type f -name "*.h" -o -name "*.c" -o -name "*.hpp" -o -name "*.cpp" -o -name "*.vert" -o -name "*.frag" -o -name "*.glsl" -o -name "*.lang"'})<CR>

" exit from insert to normal mode
inoremap jk <ESC>

" switch between header and source files
nnoremap <leader>h :A<CR>
nnoremap <leader>H :AV<CR>

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

" terminal
tnoremap jk <C-\><C-n>

" quickfix error navigation
nnoremap <silent> <F9> :cc 1<CR> <silent> :cn<CR> <silent> :cp<CR>
nnoremap <silent> <F10> :cp<CR>
nnoremap <silent> <F11> :cn<CR>


"
" Functions
"

function! MoveToOrCreateSplit(key)
    let t:curwin = winnr()
    exec "wincmd ".a:key
    if (t:curwin == winnr())
        if (match(a:key,'[jk]'))
            wincmd v
        else
            wincmd s
        endif
        exec "wincmd ".a:key
    endif
endfunction

nnoremap <silent> <C-h> :call MoveToOrCreateSplit('h')<CR>
nnoremap <silent> <C-j> :call MoveToOrCreateSplit('j')<CR>
nnoremap <silent> <C-k> :call MoveToOrCreateSplit('k')<CR>
nnoremap <silent> <C-l> :call MoveToOrCreateSplit('l')<CR>


set noswapfile
set nobackup
set nowritebackup
if !&diff
    set undodir=~/.vim/undo
    set undofile
endif
