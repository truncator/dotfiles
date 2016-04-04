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

Plug 'chriskempson/base16-vim'
"Plug 'jeaye/color_coded'
Plug 'tikhomirov/vim-glsl'
Plug 'neovimhaskell/haskell-vim'

Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-fugitive'

"Plug 'ajh17/vimcompletesme'
Plug '\~/repos/clone/vim-completion'

Plug 'ludovicchabant/vim-gutentags'
Plug 'haya14busa/incsearch.vim'
Plug 'bkad/camelcasemotion'
Plug 'jez/a.vim'

Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': 'yes \| ./install' }

call plug#end()

let g:ycm_extra_conf_globlist = ['~/repos/*','!~/*']
let g:ycm_key_list_selection_completion=['<TAB>', '<Down>']
let g:ycm_key_list_previous_completion=['<S-TAB>', '<Up>']

nnoremap <silent><F4> :OverCommandLine<CR>
vnoremap <silent><F4> <Esc> :OverCommandLine<CR>

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

let $NVIM_TUI_ENABLE_TRUE_COLOR=1

syntax enable
set background=dark
let base16colorspace=256
colorscheme base16-ocean

" hide ~ on nontext lines
hi NonText ctermfg=black


"
" options
"

"set nocompatible " use vim settings, not vi

set showmode        " show editor mode
set mouse=a         " enable mouse if terminal supports it
set cursorline      " underline current line
set showcmd         " show command in last line of screen
set ruler           " display line/col numbers
set laststatus=2
set showtabline=1

set hidden
set switchbuf=useopen,usetab
set confirm
set splitright

set tabstop=4
set shiftwidth=4
set shiftround " use multiple of shiftwidth when using '>' or '<'
set expandtab

set autoindent
set smartindent
set copyindent " copy previous indentation

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
set undofile         " store undo changes in .un file
set wildignore=*.swp,*.un\~,*.o,*.d
set title            " change terminal title
set visualbell       " no beeping
set noerrorbells     " no beeping

set completeopt-=preview " disable scratch preview
set completeopt+=longest

set cino+=(0

set clipboard=unnamed

set makeprg=make

filetype on
filetype plugin on
filetype indent on


"
" Remaps
"

let mapleader = "\<space>"

nnoremap ; :
nnoremap : ;

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

" select just-pasted text
nnoremap <leader>v V`]

" use black hole register
nnoremap <leader>b "_

" edit ~/.vimrc (this file!)
nnoremap <leader>ev :edit $MYVIMRC<CR>

nnoremap <leader>w :w<CR>
nnoremap <leader>o :o<CR>

" buffer operations
nnoremap <leader>x :w<CR> :bd<CR>
nnoremap <leader>t :enew<CR>
nnoremap <leader>q :bp\|bd#<CR>
nnoremap <leader>l :ls<CR>
nnoremap H :bprevious<CR>
nnoremap L :bnext<CR>

" CamelCaseMotion
nmap <silent> w <Plug>CamelCaseMotion_w
nmap <silent> b <Plug>CamelCaseMotion_b
nmap <silent> e <Plug>CamelCaseMotion_e

" FZF
function! QuickfixFZF()
    cclose
    call fzf#run({'down': '20%', 'sink': 'edit'})
endfunction
nnoremap <C-_> :call QuickfixFZF()<cR>
nnoremap ? :Tags<CR>

" exit from insert to normal mode
inoremap jk <ESC>

" prevent delete from overwriting register
nnoremap x "_x

" switch between header and source files
nnoremap <leader>h :A<CR>
nnoremap <leader>H :AV<CR>

cmap w!! w !sudo tee > /dev/null %

nnoremap <F10> :set invpaste paste?<CR>
set pastetoggle=<F10>

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
nnoremap <F9> :cc 1<CR>
nnoremap <F10> :cp<CR>
nnoremap <F11> :cn<CR>


"
" Functions
"

" exclude quickfix buffer from buffer list
augroup qf
	autocmd!
	autocmd FileType qf set nobuflisted
augroup END

function! s:tags_sink(line)
  let parts = split(a:line, '\t\zs')
  let excmd = matchstr(parts[2:], '^.*\ze;"\t')
  execute 'silent e' parts[1][:-2]
  let [magic, &magic] = [&magic, 0]
  execute excmd
  let &magic = magic
endfunction

function! s:tags()
  if empty(tagfiles())
    echohl WarningMsg
    echom 'Preparing tags'
    echohl None
    call system('ctags -R')
  endif

  call fzf#run({
  \ 'source':  'cat '.join(map(tagfiles(), 'fnamemodify(v:val, ":S")')).
  \            '| grep -v ^!',
  \ 'options': '+m -d "\t" --with-nth 1,4.. -n 1 --tiebreak=index',
  \ 'down':    '20%',
  \ 'sink':    function('s:tags_sink')})
endfunction

command! Tags call s:tags()

" Move between splits, creating new splits when moving past an edge.
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
endfu

nnoremap <silent> <C-h> :call MoveToOrCreateSplit('h')<cr>
nnoremap <silent> <C-j> :call MoveToOrCreateSplit('j')<cr>
nnoremap <silent> <C-k> :call MoveToOrCreateSplit('k')<cr>
nnoremap <silent> <C-l> :call MoveToOrCreateSplit('l')<cr>


"
" Syntax highlighting
"

let b:current_syntax = "cpp"

highlight todo_group ctermbg=9 ctermfg=8
highlight note_group ctermbg=10 ctermfg=8
highlight warn_group ctermbg=11 ctermfg=8
call matchadd('todo_group', 'TODO\|FIX')
call matchadd('note_group', 'NOTE')
call matchadd('warn_group', 'WARNING\|IMPORTANT')


"
" .un~/.swp directory handling as written here:
" http://stackoverflow.com/a/9528322/4354008
"

if isdirectory($HOME . '/.vim/backup') == 0
	:silent !mkdir -p ~/.vim/backup >/dev/null 2>&1
endif
set backupdir-=.
set backupdir+=.
set backupdir-=~/
set backupdir^=~/.vim/backup/
set backupdir^=./.vim-backup/
set backup
set nowritebackup

" Save your swp files to a less annoying place than the current directory.
" If you have .vim-swap in the current directory, it'll use that.
" Otherwise it saves it to ~/.vim/swap, ~/tmp or .
if isdirectory($HOME . '/.vim/swap') == 0
	:silent !mkdir -p ~/.vim/swap >/dev/null 2>&1
endif
set directory=./.vim-swap//
set directory+=~/.vim/swap//
set directory+=~/tmp//
set directory+=.

" viminfo stores the the state of your previous editing session
set viminfo+=n~/.config/nvim/.viminfo

if exists("+undofile")
	" undofile - This allows you to use undos after exiting and restarting
	" This, like swap and backups, uses .vim-undo first, then ~/.vim/undo
	" :help undo-persistence
	" This is only present in 7.3+
	if isdirectory($HOME . '/.vim/undo') == 0
		:silent !mkdir -p ~/.vim/undo > /dev/null 2>&1
	endif
	set undodir=./.vim-undo//
	set undodir+=~/.vim/undo//
	set undofile
endif
