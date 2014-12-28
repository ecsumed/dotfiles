set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'gmarik/Vundle.vim'
Plugin 'bling/vim-airline'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on


" Put your non-Plugin stuff after this line

"--------------colors--------------------
"gutter colors
"highlight LineNr ctermfg=grey ctermbg=white

" font/colorscheme options "
set background=dark
set t_Co=256
colorscheme jellybeans
let g:airline_theme = 'jellybeans'

"---------------functions------------------
set nu
set showmatch

" do not wrap long lines by default
set nowrap

set autoindent

" Manual line folding
"set foldmethod=syntax
"set foldlevel=1
"set foldclose=all

"------------------status-line--------------
set laststatus=2
set statusline+=%F
