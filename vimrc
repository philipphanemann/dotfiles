set nocompatible              " required
set nomodeline		      " security issue for v < 8.1.1365
filetype off                  " required

"---------------------
" Basic editing config
"---------------------
" smart case-sensitive search
set ignorecase
set smartcase
set lazyredraw " skip redrawing screen in some cases
set number " Show line numbers.
set relativenumber " relative line numbering, except selected line
set laststatus=2 " Always show the status line at the bottom, even if you only have one window open.
set encoding=utf-8
set nu " number lines
set noswapfile

"copying to clipboard
vnoremap <C-c> "+y
map <C-P> "+p

" Enable folding
set foldmethod=indent
set foldlevel=99

" Enable folding with the spacebar
nnoremap <space> za

" resolve issue with [>4;m[>4;2m characters
let &t_TI = ""
let &t_TE = ""


"--------------------
" Misc configurations
"--------------------
"
colors zenburn
" open new split panes to right and bottom
set splitbelow
set splitright

"window movements
nnoremap <C-j> <C-W><C-J>
nnoremap <C-k> <C-W><C-K>
nnoremap <C-h> <C-W><C-H>
nnoremap <C-l> <C-W><C-L>


let mapleader = ","

set rtp+=~/.vim/bundle/Vundle.vim " set the runtime path to include Vundle and initialize
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
Plugin 'airblade/vim-gitgutter'
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
Plug 'fatih/vim-go', { 'tag': '*', 'do': ':GoUpdateBinaries' }
Plug 'janko-m/vim-test'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'w0rp/ale'
Plug 'dhruvasagar/vim-table-mode'
Plug 'pprovost/vim-ps1'
Plug 'vim-test/vim-test'
call plug#end()            " required

"---------------------
" Plugin configuration
"---------------------

" NERDTree
" autocmd vimenter * NERDTree " open when vim starts up
nnoremap <leader>t :NERDTreeToggle<CR>


" YouCompleteMe
let g:ycm_autoclose_preview_window_after_completion=1
map <leader>g  :YcmCompleter GoToDefinitionElseDeclaration<CR>

"file search using fzf excludes hidden
nnoremap <C-p> :GFiles<CR>

"text search using rg
nnoremap <C-g> :Rg<CR>

" Source Vim configuration file and install Plug plugins
nnoremap <silent><leader>1 :source ~/.vimrc \| :PlugInstall<CR>

" ALE
let b:ale_fixers = ['black']


"markdown preview
let vim_markdown_preview_github=1


" vim-table-mode
function! s:isAtStartOfLine(mapping)
  let text_before_cursor = getline('.')[0 : col('.')-1]
  let mapping_pattern = '\V' . escape(a:mapping, '\')
  let comment_pattern = '\V' . escape(substitute(&l:commentstring, '%s.*$', '', ''), '\')
  return (text_before_cursor =~? '^' . ('\v(' . comment_pattern . '\v)?') . '\s*\v' . mapping_pattern . '\v$')
endfunction

inoreabbrev <expr> <bar><bar>
          \ <SID>isAtStartOfLine('\|\|') ?
          \ '<c-o>:TableModeEnable<cr><bar><space><bar><left><left>' : '<bar><bar>'
inoreabbrev <expr> __
              \ <SID>isAtStartOfLine('__') ?
              \ '<c-o>:silent! TableModeDisable<cr>' : '__'


" vim-test mappings
" these "Ctrl mappings" work well when Caps Lock is mapped to Ctrl
nmap <silent> t<C-n> :TestNearest<CR>
nmap <silent> t<C-f> :TestFile<CR>
nmap <silent> t<C-s> :TestSuite<CR>
nmap <silent> t<C-l> :TestLast<CR>
nmap <silent> t<C-g> :TestVisit<CR>


"---------------------
"vim-go settings
"---------------------
autocmd FileType go nnoremap <buffer> <F5> :GoRun<CR>



"---------------------
" Python settings
"---------------------
"
"
" Enable PEP8 indendation
au BufNewFile,BufRead *.py
    \ set tabstop=4 |
    \ set softtabstop=4 |
    \ set shiftwidth=4 |
    \ set textwidth=79 |
    \ set expandtab |
    \ set autoindent |
    \ set fileformat=unix


" python syntax highlighting
let g:python_highlight_all = 1

let python_highlight_all=1
syntax on

" insert pdb
imap <C-n> import pdb; pdb.set_trace()<Esc>



" show first line of doc string when folding
let g:SimpylFold_docstring_preview=1

"no extraneous whitespace
"au BufRead,BufNewFile *.py,*.pyw,*.c,*.h match BadWhitespace /\s\+$/


"JSON formatiing
map <leader>jt  <Esc>:%!json_xs -f json -t json-pretty<CR>

"executing python script with by pressing "F9"
nnoremap <buffer> <F9> :exec '!python' shellescape(@%, 1)<cr>
"nnoremap <F9> :!%:p

"remove white space
nnoremap <F8> <:%s/\s\+$//e<cr>
"remove trailing white space at write operation
autocmd BufWritePre * %s/\s\+$//e

" tag completion for html
:iabbrev </ </<C-X><C-O>

