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
set noexpandtab

set autoindent
set smartindent
set copyindent " copy previous indentation

set timeoutlen=1000
set ttimeoutlen=0

" disable line wrapping
set nowrap
set textwidth=0
set wrapmargin=0
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
set wildignore=*.swp,*.o,*.d
set title            " change terminal title
set visualbell       " no beeping
set noerrorbells     " no beeping

set completeopt-=preview " disable scratch preview

set cinkeys=0{,0},0),:,!^F,o,O,e " remove '#' from column 0 alignment

set clipboard=unnamed

"
" Remaps
"

" move cursor by screen line, not file line
map j gj
map k gk

" center screen on a line when jumped to
map gg gg zz

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

nnoremap <leader>w :w<CR>
nnoremap <leader>o :tabnew<CR>:e.<CR>
nnoremap <leader>q :q<CR>
nnoremap <leader>x :x<CR>

" ctrlp
nnoremap <C-_> :CtrlP<esc>
nnoremap ? :CtrlPTag<esc>

" tab navigation
nnoremap H gT
nnoremap L gt
nnoremap <C-h> :tabm -1<CR>
nnoremap <C-l> :tabm +1<CR>

" exit from insert to normal mode
inoremap jk <ESC>
inoremap jK <ESC>
inoremap Jk <ESC>
inoremap JK <ESC>

" prevent delete from overwriting register
nnoremap x "_x

" disable man page lookup
map <S-k> <Nop>

" switch between header and source files
map <leader>h :e %:p:s,.hpp$,.X123X,:s,.cpp$,.hpp,:s,.X123X$,.cpp,<CR>
map <leader>H :vsp %:p:s,.hpp$,.X123X,:s,.cpp$,.hpp,:s,.X123X$,.cpp,<CR>

cmap w!! w !sudo tee > /dev/null %

"
" Auto reload
"

" reload vim if ~/.vimrc changes
augroup myvimrc
    au!
    au BufWritePost .vimrc,_vimrc,vimrc,.gvimrc,_gvimrc,gvimrc,.nvimrc,_nvimrc,nvimrc so $MYVIMRC | if has('gui_running') | so $MYGVIMRC | endif
augroup END

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

" enable 256 color support
if $TERM == "rxvt-unicode-256color"
	set t_Co=256
endif

"
" Plugins
"

filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" required
Plugin 'gmarik/Vundle.vim'

"Plugin 'kevingoodsell/vim-csexact'
Plugin 'tikhomirov/vim-glsl'
Plugin 'morhetz/gruvbox'
Plugin 'yamafaktory/lumberjack.vim'
Plugin 'ajh17/spacegray.vim'
Plugin 'chriskempson/base16-vim'
Plugin 'justincampbell/vim-railscasts'
Plugin 'duythinht/vim-coffee'
Plugin 'antlypls/vim-colors-codeschool'

Plugin 'gcavallanti/vim-noscrollbar.git'

Plugin 'kien/ctrlp.vim'
Plugin 'Valloric/YouCompleteMe'
Plugin 'xolox/vim-misc'
Plugin 'xolox/vim-easytags'

"Plugin 'file:///home/trn/repos/cppclass'

call vundle#end()
filetype plugin indent on

" enable ctrlp tag searching
let g:ctrlp_extensions = ['tag']

" status line with scrollbar
set statusline=%<%f\ %h%m%r%=%-14.(%l,%c%V%)\ %{noscrollbar#statusline(20,'-','#')}

set background=dark
syntax enable
colorscheme standard

"
" Syntax highlighting
"
au BufNewFile,BufRead *.mat set filetype=json
au BufNewFile,BufRead *.gui set filetype=json
au BufNewFile,BufRead *.trnf set filetype=obj
au BufNewFile,BufRead *.prop set filetype=json
au BufNewFile,BufRead *.eff set filetype=json
