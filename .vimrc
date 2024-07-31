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

"Plugin 'tpope/vim-fugitive'              " git
if !has('nvim')
  Plugin 'kien/ctrlp.vim'                            " fuzzy finder
else
  Plugin 'nvim-lua/plenary.nvim'                     " Required for telescope
  Plugin 'nvim-treesitter/nvim-treesitter'           " Required for telescope
  Plugin 'nvim-telescope/telescope-fzf-native.nvim'  " Optional dependency of telescope
  Plugin 'nvim-telescope/telescope.nvim'
endif

Plugin 'preservim/nerdcommenter'
Plugin 'sonph/onehalf', { 'rtp': 'vim' } " colorscheme
Plugin 'sheerun/vim-polyglot'            " language packs (Syntax Highlighting)
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

"colorscheme onehalfdark
colorscheme onehalflight

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

" use F9 to run go files
autocmd FileType go nmap <F9> <Plug>(go-run)
autocmd FileType go nmap <C-A-R> <Plug>(go-run)

"
" NetRW (File Explorer)
"

let g:netrw_banner = 0


"
" NAVIGATION
"

" create new window at the right when splitting
set splitright
" create new window at the bottom when splitting
set splitbelow

" use escape to exit terminal mode
tnoremap <C-[> <C-\><C-n>

" improve pane navigation
tnoremap <C-M-h> <C-\><C-n><C-w>h
tnoremap <C-M-j> <C-\><C-n><C-w>j
tnoremap <C-M-k> <C-\><C-n><C-w>k
tnoremap <C-M-l> <C-\><C-n><C-w>l
nnoremap <C-M-h> <C-w>h
nnoremap <C-M-j> <C-w>j
nnoremap <C-M-k> <C-w>k
nnoremap <C-M-l> <C-w>l

" automatically switch to input mode when going to terminal
autocmd BufWinEnter,WinEnter * if &buftype == 'terminal' | silent! normal i | endif


"
" KEY BINDINGS
"

" set custom leader key
let mapleader = "\\"

" filefinder keybinds
if !has('nvim')
  nnoremap <leader>f :CtrlPBuffer<CR>
else
  nnoremap <leader>ff <cmd>Telescope find_files hidden=true<cr>
  nnoremap <leader>fg <cmd>Telescope live_grep<cr>
  nnoremap <leader>fb <cmd>Telescope buffers<cr>
  nnoremap <leader>fh <cmd>Telescope help_tags<cr>
endif

" open explore
nnoremap <leader>e :Explore<CR>

" buffers
nnoremap <leader>n :bn<CR>
nnoremap <leader>p :bp<CR>

" improve page navigation
nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz
