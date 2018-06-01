set nocompatible              " be iMproved, required
filetype off                  " required

filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line
"

syntax enable
set background=dark
" colorscheme solarized

"set statusline+=%#warningmsg#
"set statusline+=%{SyntasticStatuslineFlag()}
"set statusline+=%*

"let g:syntastic_always_populate_loc_list = 1
"let g:syntastic_auto_loc_list = 1
"let g:syntastic_check_on_open = 1
"let g:syntastic_check_on_wq = 0

nmap <silent> <C-D> :NERDTreeToggle<CR>

" My stuff "

set number
set mouse=a
set list
set listchars=eol:$,tab:>-,trail:~,extends:>,precedes:<
set pastetoggle=<F5>
nnoremap <F6> :set list!<CR>
" colorscheme zellner
set so=7
set autoread
if $COLORTERM == 'gnome-terminal'
	set t_Co=256
endif
filetype plugin on
filetype indent on
set encoding=utf8
set visualbell
set noerrorbells
set t_vb=
set tm=500
set wildignore=*.o,*~,*.pyc
set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store
set ruler
set cmdheight=2
set ignorecase
set hlsearch
set incsearch
set lazyredraw
set magic
set smartcase
set backspace=eol,start,indent
set whichwrap+=<,>,h,l
set foldcolumn=1
set showmatch
set mat=2
set nobackup
set nowb
set noswapfile
set smarttab
set shiftwidth=4
set tabstop=4
set lbr
set tw=500
set ai "Auto indent
set si "Smart indent
set wrap "Wrap linesswapfile
func! DeleteTrailingWS()
	exe "normal mz"
	%s/\s\+$//ge
	exe "normal `z"
endfunc
