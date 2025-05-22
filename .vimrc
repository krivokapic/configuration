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
" set tabline=%t
" set laststatus=2
set showtabline=2
highlight Comment ctermfg=green
set guioptions -=m
set guioptions -=T
nnoremap H gT
nnoremap L gt
" reload .vimrc: \rr
nnoremap <Leader>rr :source $MYVIMRC<CR>
" add mapping for auto closing
" inoremap "<tab> ""<Left>
" inoremap '<tab> ''<Left>
" inoremap (<tab> ()<Left>
" inoremap [<tab> []<Left>
" inoremap {<tab> {}<Left>
inoremap " ""<left>
inoremap ' ''<left>
inoremap ( ()<left>
inoremap [ []<left>
inoremap {<tab> {}<Left>
inoremap {<CR> {<CR>}<ESC>O
inoremap {;<CR> {<CR>};<ESC>O
inoremap <C-h> <Left>
inoremap <C-j> <Down>
inoremap <C-k> <Up>
inoremap <C-l> <Right>
inoremap <C-c> <esc>
" Use a line cursor within insert mode and a block cursor everywhere else.
"
" Reference chart of values:
"   Ps = 0 -> blinking block
"   Ps = 1 -> blinking block (default).
"   Ps = 2 -> steady block
"   Ps = 3 -> blinking underline
"   Ps = 4 -> steady block
"   Ps = 5 -> blinking bar (xterm).
"   Ps = 6 -> steady bar (xterm).
let &t_SI = "\e[5 q"
let &t_EI = "\e[2 q"
