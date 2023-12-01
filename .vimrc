"
" VUNDLE CONFIGURATION
"
" see :h vundle for more details or wiki for FAQ

set nocompatible  " be iMproved, required
filetype off      " required for vundle

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim

call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

Plugin 'tpope/vim-fugitive'              " git
if !has('nvim')
  Plugin 'kien/ctrlp.vim'                  " fuzzy finder
endif
Plugin 'sainnhe/sonokai'                 " colorscheme
Plugin 'sonph/onehalf', { 'rtp': 'vim' } " colorscheme
Plugin 'sheerun/vim-polyglot'            " language packs (Syntax Highlighting)
Plugin 'vim-scripts/AutoComplPop'        " automatically complete while typing
Plugin 'ntpeters/vim-better-whitespace'  " highlight trailing spaces
Plugin 'fatih/vim-go'                    " golang integration
Plugin 'diepm/vim-rest-console'

" all of your Plugins must be added before the following line
call vundle#end()            " required

filetype plugin indent on    " required To ignore plugin indent changes, instead use: filetype plugin o


"
" COLORSCHEME SETTINGS
"

" enable full color support in terminal
"if has('termguicolors')
"  let &t_8f="\<Esc>[38;2;%lu;%lu;%lum"  " required for alacritty to display colors in tmux
"  let &t_8b="\<Esc>[48;2;%lu;%lu;%lum"  " required for alacritty to display colors in tmux
"  set termguicolors
"endif

"let g:sonokai_style = 'andromeda'
"let g:sonokai_enable_italic = 1          " italic causes bg color change in tmux
"let g:sonokai_disable_italic_comment = 1  "
"colorscheme sonokai

colorscheme onehalfdark

"
" VIM SETTINGS
"

" allow for easy pasting
set paste

" Show line and column numbers
set ruler

" use system clipboard when yanking
set clipboard=unnamedplus

" statusline
set laststatus=2

" tabs to spaces
set tabstop=4    " show existing tab with 4 spaces width
set shiftwidth=4 " when indenting with '>', use 4 spaces width
set expandtab    " on pressing tab, insert 4 spaces

set cursorline   " highlight current line
set cursorcolumn " highlight current column
":highlight CursorLine ctermbg=240 cterm=bold guibg=#333333 gui=bold   " custom cursorcolumn colors
":highlight Cursorcolumn ctermbg=222 cterm=bold guibg=#333333 gui=bold " custom cursorline colors

set number          " enable line numbers
set relativenumber  " show relative line numbers

set nowrap  " disable line wrapping
set tw=0    " don't automatically break lines due to textwidth

set nofixendofline  " don't fix end of line at the end of the file if it is missing

syntax on  " enable syntax highlighting

" remove trailing whitespace on file save
autocmd BufWritePre * :%s/\s\+$//e

" run flake8 after writing python files
autocmd BufWritePost *.py :!flake8 %

" use F9 to run python scripts
autocmd FileType python map <buffer> <F9> :w<CR>:exec '!python3' shellescape(@%, 1)<CR>
autocmd FileType python imap <buffer> <F9> <esc>:w<CR>:exec '!python3' shellescape(@%, 1)<CR>

"
" NetRW (File Explorer)
"

let g:netrw_banner = 0


"
" CODE SUGGESTION MENU
"

" Don't show menu when there is only one match
set completeopt=menuone

" Enter will no longer put a line break but just select the entry
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

inoremap <expr> <C-n> pumvisible() ? '<C-n>' :
  \ '<C-n><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'

inoremap <expr> <M-,> pumvisible() ? '<C-n>' :
  \ '<C-x><C-o><C-n><C-p><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'


"
" KEY BINDINGS
"

" set custom leader key
let mapleader = "\\"

" normal mode pane navigation
nnoremap <leader>h <C-w>h
nnoremap <leader>j <C-w>j
nnoremap <leader>k <C-w>k
nnoremap <leader>l <C-w>l

" ctrlp buffer pane
nnoremap <leader>f :CtrlPBuffer<CR>

" open explore
nnoremap <leader>e :Explore<CR>
