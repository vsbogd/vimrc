" Fast .vimrc editing
nnoremap <leader>ev :vsplit $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>

" Use only spaces
set expandtab " expand tabs into spaces
set tabstop=4 " set tabs to have 4 spaces
set shiftwidth=4 " when using the >> or << commands, shift lines by 4 spaces
set softtabstop=0 " disable inserting different number of spaces when <Tab> is pressed
" settings for specific filetypes
augroup tabgroup
	autocmd!
	autocmd FileType make setlocal noexpandtab " disable expanding tabs in Makefiles
	autocmd FileType hs setlocal expandtab " enable expanding tabs in Haskell files
augroup END

" Preserve indentation when it is possible
set autoindent " indent when moving to the next line while writing code
set preserveindent " preserve indent while editing the line
set copyindent " copy indent from current line when new line is added

syntax enable " enable syntax highlighting
set number " show line numbers
set showmatch " show the matching part of the pair for [] {} and ()
set textwidth=79 " wrap long lines
set colorcolumn=79 " display column to wrap after
set nowrap " don't display long lines wrapped
set wildmode=longest,list " completion mode, first complete till longest common, list all matches

" Detect file types
filetype on " enable file type detection
filetype plugin on " enable file type specific plugins
filetype indent on " enable file type specific indentation rules

" Search settings
set hlsearch " highlight search
set incsearch " search while typing

" Plug
call plug#begin('~/.vim/plugged')

" Common plugins
Plug 'https://github.com/scrooloose/nerdtree'
Plug 'https://github.com/tpope/vim-fugitive'
Plug 'https://github.com/mileszs/ack.vim'
Plug 'https://github.com/ctrlpvim/ctrlp.vim'

" Color schemes
Plug 'https://github.com/nanotech/jellybeans.vim'
Plug 'https://github.com/dracula/vim'
Plug 'https://github.com/NLKNguyen/papercolor-theme'

" Golang
Plug 'https://github.com/fatih/vim-go', { 'do': ':GoUpdateBinaries' }

" Solidity
Plug 'https://github.com/tomlion/vim-solidity'

" Tags
Plug 'https://github.com/vim-scripts/taglist.vim'

" List ends here. Plugins become visible to Vim after this call.
call plug#end()

" FileType specific settings
augroup configgroup
    autocmd!

    " Golang
    autocmd FileType go nnoremap <C-F11> :w<CR>:GoRun<CR>
    autocmd FileType go inoremap <C-F11> <ESC>:w<CR>:GoRun<CR>

    " C++
    autocmd BufNewFile,BufRead *.cxxtest setlocal syntax=cpp
    autocmd FileType cpp nnoremap <Leader>oh :e %<.h<CR>
    autocmd FileType cpp nnoremap <Leader>oc :e %<.cc<CR>
 
	" Python
	autocmd FileType python let python_highlight_all = 1
augroup END

" NERDTree
let NERDTreeIgnore=['\.o$', '\.pyc$', '\.swp', '\~$'] " ignore binary files
autocmd StdinReadPre * let s:std_in=1 " detect if vim started with stdin input
" open NERDTree if no arguments
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
" Check if NERDTree is open or active
function! IsNERDTreeOpen()
  return exists("t:NERDTreeBufName") && (bufwinnr(t:NERDTreeBufName) != -1)
endfunction
" Call NERDTreeFind iff NERDTree is active, current window contains a modifiable
" file, and we're not in vimdiff
function! SyncTree()
  if &modifiable && IsNERDTreeOpen() && strlen(expand('%')) > 0 && !&diff
    NERDTreeFind
    wincmd p
  endif
endfunction
" Highlight currently open buffer in NERDTree
autocmd BufEnter * call SyncTree()

" Fugitive
set statusline=%<%f\ %h%m%r%{FugitiveStatusline()}%=%-14.(%l,%c%V%)\ %P

" Ack
let g:ackprg = 'ag --nogroup --nocolor --column'

" CtrlP
let g:ctrlp_user_command = 'ag %s -l --nocolor --hidden -g ""'

" Color schemes
if has('gui_running')
    colorscheme PaperColor
    set guifont=Monospace\ 11
    set guioptions=-T
else
    colorscheme PaperColor
endif

" Use local .vim-project folder for project specific settings
if filereadable("./.vim-project/vimrc")
    source ./.vim-project/vimrc
endif
