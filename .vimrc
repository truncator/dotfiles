"
" ~/.vimrc
"

" Auto reload
augroup myvimrc
    au!
    au BufWritePost .vimrc,_vimrc,vimrc,.gvimrc,_gvimrc,gvimrc,.nvimrc,_nvimrc,nvimrc,init.vim so $MYVIMRC | if has('gui_running') | so $MYGVIMRC | endif
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

"Plug 'valloric/youcompleteme'
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

" disable line wrapping
set nowrap
set textwidth=0
set wrapmargin=0
set sidescroll=1
set sidescrolloff=8
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

set cino+=(0

set clipboard=unnamed

"set makeprg=./build.sh
set makeprg=make

filetype on
filetype plugin on
filetype indent on


"
" Remaps
"

let mapleader = "\<space>"

nnoremap ; :

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
nnoremap <C-_> :call fzf#run({'down': '20%', 'sink': 'edit'})<CR>
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

nnoremap <F5> :Make<CR>
nnoremap <F6> :Make!<CR>
nnoremap <F7> :Dispatch ./run.sh<CR>
nnoremap <F8> :Dispatch! ./run.sh<CR>

" terminal
tnoremap jk <C-\><C-n>

" quickfix error navigation
nnoremap <F9> :cc 1<CR>
nnoremap <F10> :cp<CR>
nnoremap <F11> :cn<CR>


"
" Functions
"

" consolidate vim/tmux split navigation
if exists('$TMUX')
	function! TmuxOrSplitSwitch(wincmd, tmuxdir)
		let previous_winnr = winnr()
		silent! execute "wincmd " . a:wincmd
		if previous_winnr == winnr()
			call system("tmux select-pane -" . a:tmuxdir)
			redraw!
		endif
	endfunction

	let previous_title = substitute(system("tmux display-message -p '#{pane_title}'"), '\n', '', '')
	let &t_ti = "\<Esc>]2;vim\<Esc>\\" . &t_ti
	let &t_te = "\<Esc>]2;". previous_title . "\Esc>\\" . &t_te

	nnoremap <silent> <C-h> :call TmuxOrSplitSwitch('h', 'L')<cr>
	nnoremap <silent> <C-j> :call TmuxOrSplitSwitch('j', 'D')<cr>
	nnoremap <silent> <C-k> :call TmuxOrSplitSwitch('k', 'U')<cr>
	nnoremap <silent> <C-l> :call TmuxOrSplitSwitch('l', 'R')<cr>
else
	map <C-h> <C-w>h
	map <C-j> <C-w>j
	map <C-k> <C-w>k
	map <C-l> <C-w>l
endif

function! g:UltiSnips_Complete()
	call UltiSnips#ExpandSnippetOrJump()
	if g:ulti_expand_or_jump_res == 0
		if pumvisible()
			return "\<C-N>"
		else
			return "\<TAB>"
		endif
	endif

	return ""
endfunction

function! g:UltiSnips_Reverse()
	call UltiSnips#JumpBackwards()
	if g:ulti_jump_backwards_res == 0
		return "\<C-P>"
	endif

	return ""
endfunction

function! RunBinary()
	let b:current_dir = getcwd()
	let b:executable_name = fnamemodify(getcwd(), ':t')
	execute ":silent cd bin/debug"
	execute ":silent ! ./" . b:executable_name
	execute ":silent cd " . b:current_dir
endfunction

function! GetBinaryName()
	return fnamemodify(getcwd(), ':t')
endfunction

function! CppGrep(arg)
	let l:grep_cmd = "grep -F --color '" . a:arg . "' **/*.hpp **/*.cpp"
	silent execute l:grep_cmd
	copen
endfunction
command! -nargs=1 Grep call CppGrep('<args>')

function! s:_ReadMan(man_section, man_word, winpos)
    " If 'man_section' is 0, use empty string instead.
    " We perform this check because v:count is 0 by default
    let s:man_section = a:man_section
    if s:man_section == 0
        let s:man_section = ''
    endif
    " Open a new window
    execute ":wincmd n"
    execute ":wincmd " . a:winpos
    " Make the new window a scratch buffer
    execute ":setlocal buftype=nofile"
    execute ":setlocal bufhidden=hide"
    execute ":setlocal noswapfile"
    " Don't list the buffer either
    execute ":setlocal nobuflisted"
    " Read in the man page for 'man_word' (col -b is for formatting)
    execute ":r!man " . s:man_section . " " . a:man_word . " | col -b"
    execute ":set ft=c"
endfunction
"command! -nargs=1 Man call <SID>_ReadMan(v:count, expand('<cword>'), 'L')
command! -nargs=1 Man call <SID>_ReadMan(v:count, expand('<args>'), 'L')

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
set viminfo+=n~/.vim/viminfo

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
