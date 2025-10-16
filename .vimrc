"----------------------------------------------------------------------------
"defaults

" Get the defaults that most users want.
if !has('nvim')
  source $VIMRUNTIME/defaults.vim
endif

set hlsearch

set noswapfile
set nobackup
set undofile
"----------------------------------------------------------------------------
"personalizations

"display row number by default
set nu

"turn on spell check for the local buffer
nnoremap <F3> :setlocal spell spelllang=en_us<CR>

"set no highlight until next search
nnoremap <leader>n :noh<CR>

" set filetype to shell for syntax highlight
let g:is_bash = 1
nnoremap <F4> :set ft=sh<CR>
"----------------------------------------------------------------------------
"vim-plug

call plug#begin('~/.vim/plugged')

Plug 'preservim/nerdtree'

Plug 'morhetz/gruvbox'

Plug 'kxue43/showmd-vim-plugin', {'for': 'markdown'}

call plug#end()
"----------------------------------------------------------------------------
"nerdtree

"automatically open nerdtree
"autocmd vimenter * NERDTree

"close vim when the only window open is nerdtree
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

"toggle nerdtree
nmap <C-n> :NERDTreeToggle<CR>
"----------------------------------------------------------------------------
"gruvbox theme

"let g:gruvbox_contrast_dark = 'soft'
let g:gruvbox_contrast_light = 'soft'

autocmd vimenter * ++nested colorscheme gruvbox
set bg=dark
"----------------------------------------------------------------------------
