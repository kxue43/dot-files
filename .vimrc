" Global settings adapted from $VIMRUNTIME/defaults.vim.

" Use Vim mode, not Vi mode.
set nocompatible

" Allow backspacing over everything in insert mode.
set backspace=indent,eol,start

set history=200		" keep 200 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set wildmenu		" display completion matches in a status line

set ttimeout		" time out for key codes
set ttimeoutlen=100	" wait up to 100ms after Esc for special key

" Show @@@ in the last line if it is truncated.
set display=truncate

" Show a few lines of context around the cursor.  Note that this makes the
" Text scroll if you mouse-click near the start or end of the window.
set scrolloff=5

" Do incremental searching when it's possible to timeout.
if has('reltime')
  set incsearch
endif

" Do not recognize octal numbers for Ctrl-A and Ctrl-X, most users find it
" Confusing.
set nrformats-=octal

" Don't use Q for Ex mode, use it for formatting.  Except for Select mode.
" Revert with ":unmap Q".
map Q gq
sunmap Q

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" So that you can undo CTRL-U after inserting a line break.
" Revert with ":iunmap <C-U>".
inoremap <C-U> <C-G>u<C-U>

" In many terminal emulators the mouse works just fine.  By enabling it you
" Can position the cursor, Visually select and scroll with the mouse.
" Only xterm can grab the mouse events when using the shift key, for other
" Terminals use ":", select text and press Esc.
if has('mouse')
  if &term =~ 'xterm'
    set mouse=a
  else
    set mouse=nvi
  endif
endif

" Enable file type detection.
" Use the default filetype settings, so that mail gets 'tw' set to 72,
" 'cindent' is on in C files, etc.
" Also load indent files, to automatically do language-dependent indenting.
" Revert with ":filetype off".
filetype plugin indent on

" Put these in an autocmd group, so that you can revert them with:
" ":autocmd! vimStartup"
augroup vimStartup
autocmd!

" When editing a file, always jump to the last known cursor position.
" Don't do it when the position is invalid, when inside an event handler
" (happens when dropping a file on gvim), for a commit or rebase message
" (likely a different one than last time), and when using xxd(1) to filter
" And edit binary files (it transforms input files back and forth, causing
" Them to have dual nature, so to speak)
autocmd BufReadPost *
\ let line = line("'\"")
\ | if line >= 1 && line <= line("$") && &filetype !~# 'commit'
\      && index(['xxd', 'gitrebase'], &filetype) == -1
\ |   execute "normal! g`\""
\ | endif

augroup END

" Quite a few people accidentally type "q:" instead of ":q" and get confused
" By the command line window.  Give a hint about how to get out.
" If you don't like this you can put this in your vimrc:
" ":autocmd! vimHints"
augroup vimHints
au!
autocmd CmdwinEnter *
  \ echohl Todo |
  \ echo gettext('You discovered the command-line window! You can close it with ":q".') |
  \ echohl None
augroup END

" Revert with ":syntax off".
syntax on

" I like highlighting strings inside C comments.
" Revert with ":unlet c_comment_strings".
" let c_comment_strings=1

" Convenient command to see the difference between the current buffer and the
" File it was loaded from, thus the changes you made.
" Only define it when not defined already.
" Revert with: ":delcommand DiffOrig".
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif

if has('langmap') && exists('+langremap')
  " Prevent that the langmap option applies to characters that result from a
  " mapping.  If set (default), this may break plugins (but it's backward
  " compatible).
  set nolangremap
endif
" ----------------------------------------------------------------------------
" Add the matchit package to runtimepath, but defer loading.
"
" The matchit plugin makes the % command work better, but it is not backwards
" Compatible.
" The ! means the package won't be loaded right away but when plugins are
" Loaded during initialization.
if has('syntax') && has('eval')
  packadd! matchit
endif
" ----------------------------------------------------------------------------
" Backup files settings.

" Put al three types of backup files in one directory ~/.vimdata.
set swapfile
let &directory = expand('~/.vimdata/swap/')

set backup
let &backupdir = expand('~/.vimdata/backup/')

set undofile
let &undodir = expand('~/.vimdata/undo/')

if !isdirectory(&undodir) | call mkdir(&undodir, "p") | endif
if !isdirectory(&backupdir) | call mkdir(&backupdir, "p") | endif
if !isdirectory(&directory) | call mkdir(&directory, "p") | endif
" ----------------------------------------------------------------------------
" Personal settings.

" Display row number by default.
set nu

" Use highlight search by default.
set hlsearch

" Use dark background.
set bg=dark

" Set no highlight until next search.
nnoremap <F2> :noh<CR>

" Turn on spell check for the local buffer.
nnoremap <F3> :setlocal spell spelllang=en_us<CR>

" Set filetype to shell for syntax highlight.
let g:is_bash = 1
nnoremap <F4> :set ft=sh<CR>
" ----------------------------------------------------------------------------
" Package settings from now on.

" Packages are manually mananged inside the ~/.vim/pack/*/start/* folders.
" Currently there are no opt files, only start.

" ~/.vim/pack
"   ├─ gruvbox/start/gruvbox
"   ├─ nerdtree/start/nerdtree
"   ├─ vim-airline/start/vim-airline
"   └─ vim-airline-themes/start/vim-airline-themes
" ----------------------------------------------------------------------------
" Nerdtree setting.

" Automatically open nerdtree.
" autocmd vimenter * NERDTree

" Close vim when the only window open is nerdtree.
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" Toggle nerdtree.
nmap <C-n> :NERDTreeToggle<CR>
" ----------------------------------------------------------------------------
" Gruvbox color scheme setting.

autocmd vimenter * ++nested colorscheme gruvbox
" ----------------------------------------------------------------------------
" Vim-airline setting.

" Show buffer info at the top as a tab line.
let g:airline#extensions#tabline#enabled = 1

" Airline theme.
let g:airline_theme='base16_gruvbox_dark_hard'
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif

let g:airline_left_sep = '▶'
let g:airline_right_sep = '◀'
let g:airline_symbols.colnr = ' ㏇:'
let g:airline_symbols.crypt = '🔒'
let g:airline_symbols.linenr = ' ␤:'
let g:airline_symbols.maxlinenr = ''
let g:airline_symbols.branch = '⎇'
let g:airline_symbols.paste = 'ρ'
let g:airline_symbols.spell = 'Ꞩ'
let g:airline_symbols.notexists = 'Ɇ'
let g:airline_symbols.whitespace = 'Ξ'
" ----------------------------------------------------------------------------
