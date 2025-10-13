vim9script
set nocompatible
filetype plugin on
syntax on
set path+=**
set wildmenu
set tabstop=4
set shiftwidth=4
set ai
set number
set hlsearch
set ruler
set background=dark
set autoindent          # copy indent from current line when starting a new line

# map leader to Space
g:mapleader = " "

# make backspaces more powerfull
set backspace=indent,eol,start
# set statusline=%f
#  set tabline=%t
#  set laststatus=2
set showtabline=2
highlight Comment ctermfg=green
set guioptions-=m
set guioptions-=T

nnoremap H gT
nnoremap L gt

# nnoremap <Leader>l :tabmove +1<CR>
# nnoremap <Leader>h :tabmove -1<CR>

nnoremap <C-l> :tabmove +1<CR>
nnoremap <C-h> :tabmove -1<CR>
nnoremap <C-s> :wa<CR>
vnoremap <C-y> "+y<CR>
nnoremap <C-p> "+p<CR>
nnoremap <C-u> <C-u>zz
nnoremap <C-d> <C-d>zz
# open fzf (all files)
nnoremap <Leader><SPACE> :Files<CR>
# open fzf (git files)
nnoremap <Leader>g :GFiles<CR>
# open fzf-rg
nnoremap <Leader>f :RG<CR>

# reload .vimrc
nnoremap <Leader>rr :source $MYVIMRC<CR>
# add mapping for auto closing
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
# Use a line cursor within insert mode and a block cursor everywhere else.
#
# Reference chart of values:
#   Ps = 0 -> blinking block
#   Ps = 1 -> blinking block (default).
#   Ps = 2 -> steady block
#   Ps = 3 -> blinking underline
#   Ps = 4 -> steady block
#   Ps = 5 -> blinking bar (xterm).
#   Ps = 6 -> steady bar (xterm).
&t_SI = "\e[5 q"
&t_EI = "\e[2 q"

# var lspOpts = #{{autoHighlightDiags: v:true}}
# autocmd User LspSetup call LspOptionsSet({autoHighlightDiags: v:true})
# 
# var lspServers = [{
# 	'name': 'clang',
# 	'filetype': ['c', 'cpp'],
# 	'path': '/usr/bin/clangd',
# 	'args': ['--background-index']
# }]
# 
# autocmd User LspSetup call LspAddServers(lspServers)

call plug#begin()

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-surround'
#Plug 'StanAngeloff/php.vim'
#Plug 'girishji/vimcomplete'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
# Plug 'yegappan/lsp'

call plug#end()

g:fzf_action = { 'enter': 'tab split' }

#g:vimcompvare_tab_enable = 1
