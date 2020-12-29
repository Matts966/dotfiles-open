scriptencoding utf-8
set encoding=utf-8
"--------------------------------------------------------------------------

" Specify a directory for plugins
" - For Neovim: ~/.local/share/nvim/plugged
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.vim/plugged')

" Make sure you use single quotes
set rtp+=/opt/homebrew/opt/fzf
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
let $FZF_DEFAULT_OPTS = '--reverse'

" On-demand loading
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
" Close nerdtree when all windows are closed.
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
map <C-e> :NERDTreeToggle<CR>

Plug 'thinca/vim-quickrun'
let g:quickrun_config = {'*': {'hook/time/enable': '1'},}

Plug 'itchyny/lightline.vim'

Plug 'lu-ren/SerialExperimentsLain', {'do': 'mkdir -p ~/.vim/colors && cp colors/* ~/.vim/colors/'}

" LSP
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
Plug 'prabirshrestha/vim-lsp'
Plug 'mattn/vim-lsp-settings'
Plug 'mattn/vim-lsp-icons'
Plug 'hrsh7th/vim-vsnip'
Plug 'hrsh7th/vim-vsnip-integ'

Plug 'gabrielelana/vim-markdown'

Plug 'dansomething/vim-hackernews'

autocmd ColorScheme * highlight Normal ctermbg=none
autocmd ColorScheme * highlight LineNr ctermbg=none
colorscheme SerialExperimentsLain

" Initialize plugin system
call plug#end()


set background=dark
set t_Co=256

set mouse=a
set fenc=utf-8
set nobackup
set noswapfile
set autoread
set hidden
set showcmd
set clipboard=unnamedplus,autoselect
set backspace=indent,eol,start

set number
set cursorline
set cursorcolumn
set smartindent
set visualbell
set showmatch
set wildmode=list:longest " Auto completion on vim command line
nnoremap j gj
nnoremap k gk
" Tab
set list listchars=tab:\▸\-
set list
set listchars=tab:>-,extends:<,trail:-,eol:<
set ignorecase
set smartcase " Case Sensitive only with upper case
set incsearch
set wrapscan
syntax on

" Set 256 colors
let s:saved_t_Co=&t_Co
if $COLORTERM == 'gnome-terminal'
  set t_Co=256
endif

" Restore t_Co for less command after vim quit
augroup restore_t_Co
  autocmd!
  if s:saved_t_Co == 8
    autocmd VimLeave * let &t_Co = 256
  else
    autocmd VimLeave * let &t_Co = 8
  endif
  autocmd VimLeave * let &t_Co = s:saved_t_Co
augroup END
