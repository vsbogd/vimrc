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
	autocmd FileType haskell setlocal expandtab " enable expanding tabs in Haskell files
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

" Replacement
function ReplaceAll(from,to)
	execute "!ag -0 -l ".a:from." | xargs -0 sed -ri -e 's/".a:from."/".a:to."/g'"
endfunction

" Plug
call plug#begin('~/.vim/plugged')

" Common plugins
Plug 'https://github.com/scrooloose/nerdtree'
Plug 'https://github.com/tpope/vim-fugitive'
Plug 'https://github.com/mileszs/ack.vim'
Plug 'https://github.com/ctrlpvim/ctrlp.vim'
Plug 'https://github.com/vim-syntastic/syntastic'
Plug 'https://github.com/will133/vim-dirdiff.git'
Plug 'frazrepo/vim-rainbow'
Plug 'preservim/nerdcommenter'

" Color schemes
Plug 'https://github.com/nanotech/jellybeans.vim'
Plug 'https://github.com/dracula/vim'
Plug 'https://github.com/NLKNguyen/papercolor-theme'

" LSP support
Plug 'natebosch/vim-lsc'

" Golang
Plug 'https://github.com/fatih/vim-go'

" Solidity
Plug 'https://github.com/tomlion/vim-solidity'

" Tags
Plug 'https://github.com/vim-scripts/taglist.vim'

" Snippets
Plug 'https://github.com/SirVer/ultisnips'
Plug 'https://github.com/honza/vim-snippets'

" Rust
Plug 'rust-lang/rust.vim'

" List ends here. Plugins become visible to Vim after this call.
call plug#end()

" LSP settings, requires installation of language servers:
" Rust: https://github.com/rust-lang/rls
" Python: https://github.com/python-lsp/python-lsp-server
" CPP: https://clangd.llvm.org/installation
" Java: https://github.com/georgewfraser/java-language-server
let g:lsc_server_commands = { 'rust': 'rust-analyzer', 'python': 'pylsp', 'c': 'clangd', 'cpp': 'clangd', 'java': '/opt/java-language-server/lang_server_linux.sh' }
set completeopt-=preview
let g:lsc_auto_map = { 'defaults': v:true, 'PreviousReference': '' }

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
    autocmd FileType pyrex nnoremap <Leader>oh :e %<.pxd<CR>
    autocmd FileType pyrex nnoremap <Leader>oc :e %<.pyx<CR>

    " Jenkins
    autocmd BufNewFile,BufRead Jenkinsfile setlocal syntax=groovy

    " Metta
    autocmd BufNewFile,BufRead *.metta setlocal syntax=lisp
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

" Ack
let g:ackprg = 'ag --nogroup --nocolor --column'

" CtrlP
let g:ctrlp_user_command = 'ag %s -l --nocolor --hidden -g ""'
let g:ctrlp_by_filename = 1
let g:ctrlp_working_path_mode = 'a'

" Syntastic
let g:syntastic_mode_map = { "mode": "passive" }
let g:syntastic_java_checkers = []

" Snippets
let g:UltiSnipsSnippetDirectories = ["snips"]

" Color schemes
if has('gui_running')
    colorscheme PaperColor
    set guifont=Monospace\ 11
    set guioptions=-T
else
    colorscheme PaperColor
endif

" Status line
" Syntastic
set statusline=%#warningmsg#%{SyntasticStatuslineFlag()}%#statusline#
" ~/.../filename [Help][+][RO]
set statusline+=%<%f\ %h%m%r
" Fugitive
set statusline+=%{FugitiveStatusline()}
" 120, 3            74%
set statusline+=%=%-14.(%l,%c%V%)\ %P

" Debug
packadd termdebug
nmap <F2> :Break<CR>
nmap <F5> :Step<CR>
nmap <F6> :Over<CR>
nmap <F7> :Finish<CR>
nmap <F8> :Continue<CR>
nmap <F9> :Run<CR>

" Use local .vim-project folder for project specific settings
if filereadable("./.vim-project/vimrc")
    source ./.vim-project/vimrc
endif
