set nocompatible
filetype plugin on
syntax on
set path+=**
set wildmenu
set tabstop=4
set shiftwidth=4
set expandtab
set ai
set number
set hlsearch
set ruler
" set statusline=%f
set tabline=%t
" set laststatus=2
set showtabline=2
highlight Comment ctermfg=green
set guioptions -=m
set guioptions -=T
colorscheme slate
let g:airline#extensions#tabline#enabled = 1
nnoremap H gT
nnoremap L gt
let g:airline#extensions#tabline#formatter = 'unique_tail'
let g:airline#extensions#tabline#tabs_label = ''
let g:airline#extensions#tabline#buffers_label = ''
let g:airline#extensions#tabline#show_splits = 0 " let g:airline#extensions#tabline#exclude_buffers = 0 doesn't work
" (https://github.com/vim-airline/vim-airline/blob/master/doc/airline.txt)
