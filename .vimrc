set nocompatible
filetype off
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

Plugin 'gmarik/vundle'
Plugin 'bling/vim-airline'


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


filetype plugin indent on
