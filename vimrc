set nocompatible              " required
set nomodeline		      " security issue for v < 8.1.1365
filetype off                  " required

" Show line numbers.
set number

" This enables relative line numbering mode. With both number and
" relativenumber enabled, the current line shows the true line number, while
" all other lines (above and below) are numbered relative to the current line.
" This is useful because you can tell, at a glance, what count is needed to
" jump up or down to a particular line, by {count}k to go up or {count}j to go
" down.
set relativenumber

" Always show the status line at the bottom, even if you only have one window open.
set laststatus=2
" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim

let mapleader = ","

call vundle#begin()

" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'
Plugin 'tmhedberg/SimpylFold'
Plugin 'vim-scripts/indentpython.vim'
Plugin 'Valloric/YouCompleteMe'
Plugin 'nvie/vim-flake8'
Plugin 'scrooloose/nerdtree'
"Plugin 'kien/ctrlp.vim' "super searching
Plugin 'tpope/vim-fugitive' "git integration
"Plugin 'Lokaltog/powerline', {'rtp': 'powerline/bindings/vim/'}
Plugin 'elzr/vim-json'
Plugin 'JamshedVesuna/vim-markdown-preview'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'chrisbra/csv.vim'
"Plugin 'https://github.com/vim-scripts/XPath-Search.git'

"Plugin 'integralist/vim-mypy'
" add all your plugins here (note older versions of Vundle
" used Bundle instead of Plugin)

" ...

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
filetype plugin on

"VimPlug
call plug#begin('~/.vim/plugged')
Plug 'janko-m/vim-test'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
call plug#end()            " required

" Enable PEP8 indendation
au BufNewFile,BufRead *.py
    \ set tabstop=4 |
    \ set softtabstop=4 |
    \ set shiftwidth=4 |
    \ set textwidth=79 |
    \ set expandtab |
    \ set autoindent |
    \ set fileformat=unix

set ignorecase
set splitbelow
set splitright

"split navigations
    nnoremap <C-J> <C-W><C-J>
    nnoremap <C-K> <C-W><C-K>
    nnoremap <C-H> <C-W><C-H>
    nnoremap <C-L> <C-W><C-L>


" Enable folding
    set foldmethod=indent
    set foldlevel=99

" Enable folding with the spacebar
    nnoremap <space> za

" show first line of doc string when folding
let g:SimpylFold_docstring_preview=1

"no extraneous whitespace
"au BufRead,BufNewFile *.py,*.pyw,*.c,*.h match BadWhitespace /\s\+$/

" python syntax highlighting
let g:python_highlight_all = 1

set encoding=utf-8

" some options for auto-completion
let g:ycm_autoclose_preview_window_after_completion=1
map <leader>g  :YcmCompleter GoToDefinitionElseDeclaration<CR>

"pretty looking code
let python_highlight_all=1
syntax on

colors zenburn

set nu
set noswapfile


"copying to clipboard
vnoremap <C-c> "+y
map <C-P> "+p

"JSON formatiing
map <leader>jt  <Esc>:%!json_xs -f json -t json-pretty<CR>

"executing python script with by pressing "F9"
nnoremap <buffer> <F9> :exec '!python' shellescape(@%, 1)<cr>
"nnoremap <F9> :!%:p

"remove white space
nnoremap <F8> <:%s/\s\+$//e<cr>
"remove trailing white space at write operation
autocmd BufWritePre * %s/\s\+$//e

" insert pdb
imap <C-n> import pdb; pdb.set_trace()<Esc>

" tag completion for html
:iabbrev </ </<C-X><C-O>

"NERDTree
" open when vim starts up
" autocmd vimenter * NERDTree
map <leader>t :NERDTreeToggle<CR>

"
" Source Vim configuration file and install plugins
nnoremap <silent><leader>1 :source ~/.vimrc \| :PlugInstall<CR>

"file search using fzf excludes hidden
nnoremap <C-p> :GFiles<CR>

"text search using rg
nnoremap <C-g> :Rg<CR>
