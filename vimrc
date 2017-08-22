set nocompatible
call pathogen#infect()

syntax enable
filetype plugin indent on

set number

set mouse=a

set autoindent
set backspace=indent,eol,start

set ttimeout
set ttimeoutlen=50

set incsearch
set hlsearch

set laststatus=2

set background=light
let g:solarized_termcolors=256
colorscheme solarized


"airline 
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1
"airline

"tagbar
"toggle tagbar with <f8>
nmap <F8> :TagbarToggle<CR>
"tagbar


"youcompleteme
map <C-l> :YcmCompleter GoTo<CR>
"!youcompleteme
