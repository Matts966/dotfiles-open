scriptencoding utf-8
set encoding=utf-8

filetype off
filetype plugin indent off

" Keys are mapped with the mapping with the time so
" important settings should be written earlier.
let mapleader = "\<Space>" " Remap <leader> key to space
"--------------------------------------------------------------------------

" Specify a directory for plugins
" - For Neovim: ~/.local/share/nvim/plugged
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.vim/plugged')

let g:auto_save = 1  " enable AutoSave on Vim startup
Plug '907th/vim-auto-save'

Plug 'psliwka/vim-smoothie'

Plug 'thinca/vim-qfreplace'

" Make sure you use single quotes
set rtp+=/opt/homebrew/opt/fzf
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
let $FZF_DEFAULT_OPTS = '--reverse'
let $FZF_DEFAULT_COMMAND = 'rg --files --hidden --follow --glob "!.git/*" 2> /dev/null'
" CTRL-A CTRL-Q to select all and build quickfix list
function! s:build_quickfix_list(lines)
  call setqflist(map(copy(a:lines), '{ "filename": v:val }'))
  copen
  cc
endfunction
let g:fzf_action = {
  \ 'ctrl-q': function('s:build_quickfix_list'),
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }
let $FZF_DEFAULT_OPTS = '--reverse --bind ctrl-a:select-all'
" Git Grep with fzf by :GGrep
command! -bang -nargs=* GGrep
  \ call fzf#vim#grep(
  \   'git grep --line-number -- '.shellescape(<q-args>), 0,
  \   fzf#vim#with_preview({'dir': systemlist('git rev-parse --show-toplevel')[0]}), <bang>0)
" Add hidden files in :Rg
command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --hidden --column --line-number --no-heading --color=always --smart-case -- '.shellescape(<q-args>), 1,
  \   fzf#vim#with_preview(), <bang>0)
" Without fuzzy search with :RG
function! RipgrepFzf(query, fullscreen)
  let command_fmt = 'rg --hidden --column --line-number --no-heading --color=always --smart-case -- %s || true'
  let initial_command = printf(command_fmt, shellescape(a:query))
  let reload_command = printf(command_fmt, '{q}')
  let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
  call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
endfunction
command! -nargs=* -bang RG call RipgrepFzf(<q-args>, <bang>0)
" Find with ripgrep
nnoremap <C-f> :RG<CR>
" Compatible with fzf default binding but ignore tag stack.
nnoremap <C-t> :GFiles<CR>


" Toggle comment out with gcc and gc with selection.
Plug 'tpope/vim-commentary'

" On-demand loading
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
" Close nerdtree when all windows are closed.
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
map <C-e> :NERDTreeToggle<CR>

Plug 'thinca/vim-quickrun'
let g:quickrun_config = {'*': {'hook/time/enable': '1'},}

Plug 'itchyny/lightline.vim'
set laststatus=2

Plug 'lu-ren/SerialExperimentsLain', {'do': 'mkdir -p ~/.vim/colors && cp colors/* ~/.vim/colors/'}


" LSP
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
Plug 'prabirshrestha/vim-lsp'
Plug 'mattn/vim-lsp-settings'
Plug 'mattn/vim-lsp-icons'
Plug 'hrsh7th/vim-vsnip'
Plug 'hrsh7th/vim-vsnip-integ'
Plug 'rafi/vim-venom', { 'for': 'python' }

function! s:on_lsp_buffer_enabled() abort
    setlocal omnifunc=lsp#complete
    setlocal signcolumn=yes
    if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
    nmap <buffer> gd <plug>(lsp-definition)
    nmap <buffer> gr <plug>(lsp-references)
    nmap <buffer> gi <plug>(lsp-implementation)
    nmap <buffer> gt <plug>(lsp-type-definition)
    nmap <buffer> <leader>rn <plug>(lsp-rename)
    nmap <buffer> [g <Plug>(lsp-previous-diagnostic)
    nmap <buffer> ]g <Plug>(lsp-next-diagnostic)
    nmap <buffer> K <plug>(lsp-hover)

    let g:lsp_format_sync_timeout = 1000
    autocmd! BufWritePre *.rs,*.go call execute('LspDocumentFormatSync')

    " refer to doc to add more commands
endfunction

augroup lsp_install
    au!
    " call s:on_lsp_buffer_enabled only for languages that has the server registered.
    autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END


Plug 'gabrielelana/vim-markdown'

Plug 'dansomething/vim-hackernews'

Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}

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
" Yank to clipboard
if system('uname -s') == "Darwin\n"
  set clipboard=unnamed "OSX
else
  set clipboard=unnamedplus "Linux
endif
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
set tabstop=4
set shiftwidth=4
set list
" Remove trailing spaces.
autocmd BufWritePre * :%s/\s\+$//e

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

" Create dir if not exists when writing new file.
augroup Mkdir
  autocmd!
  autocmd BufWritePre * call mkdir(expand("<afile>:p:h"), "p")
augroup END

" Mimic Emacs Line Editing in Insert Mode Only
inoremap <C-A> <Home>
inoremap <C-B> <Left>
inoremap <C-E> <End>
inoremap <C-F> <Right>

filetype plugin indent on
