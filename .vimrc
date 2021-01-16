source $VIMRUNTIME/defaults.vim

scriptencoding utf-8
set encoding=utf-8

" Keys are mapped with the mapping with the time so
" important settings should be written earlier.
let mapleader = "\<Space>" " Remap <leader> key to space
"--------------------------------------------------------------------------

" Specify a directory for plugins
" - For Neovim: ~/.local/share/nvim/plugged
" - Avoid using standard Vim directory names like 'plugin'
if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
call plug#begin('~/.vim/plugged')

Plug 'junegunn/goyo.vim'
nnoremap <silent> <leader>go :Goyo<CR>
let g:goyo_width = 120

Plug 'tamuhey/vim-jupyter', { 'do': 'gh -R tamuhey/j2p2j release download'.
    \ ' --pattern \*j2p2j_darwin_amd64\* && mv j2p2j_darwin_amd64'.
    \ ' /usr/local/bin/j2p2j && chmod +x /usr/local/bin/j2p2j' }

Plug 'heavenshell/vim-pydocstring', { 'do': 'make install' }

Plug 'preservim/nerdtree'
nnoremap <C-e> :NERDTreeToggle<CR>
let NERDTreeShowHidden=1

Plug 'kana/vim-textobj-user'
Plug 'kana/vim-textobj-entire'

" Git related settings
Plug 'lambdalisue/gina.vim'
nnoremap [gina]  <Nop>
nmap <leader>g [gina]
nnoremap <silent> [gina]s :Gina status<CR>
nnoremap <silent> [gina]a :Gina add %<CR>
nnoremap <silent> [gina]c :Gina commit<CR>
nnoremap [gina]p :Gina pull<CR>
nnoremap [gina]P :Gina push<CR>
" Enable spell check only in git commit
set spelllang+=cjk
autocmd FileType gitcommit setlocal spell
nnoremap <leader>gg :vert term ++close lazygit<CR><C-W>|


Plug 'jiangmiao/auto-pairs'

let g:auto_save = 1  " enable AutoSave on Vim startup
Plug '907th/vim-auto-save'

Plug 'psliwka/vim-smoothie'

Plug 'thinca/vim-qfreplace'

" Make sure you use single quotes
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
let $FZF_DEFAULT_COMMAND = 'rg --files 2> /dev/null'
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
let $FZF_DEFAULT_OPTS = '--reverse --ansi --bind ctrl-a:select-all'
" Respect vim colorscheme.
function! s:update_fzf_colors()
  let rules =
  \ { 'fg':      [['Normal',       'fg']],
    \ 'bg':      [['Normal',       'bg']],
    \ 'hl':      [['Comment',      'fg']],
    \ 'fg+':     [['CursorColumn', 'fg'], ['Normal', 'fg']],
    \ 'bg+':     [['CursorColumn', 'bg']],
    \ 'hl+':     [['Statement',    'fg']],
    \ 'info':    [['PreProc',      'fg']],
    \ 'prompt':  [['Conditional',  'fg']],
    \ 'pointer': [['Exception',    'fg']],
    \ 'marker':  [['Keyword',      'fg']],
    \ 'spinner': [['Label',        'fg']],
    \ 'header':  [['Comment',      'fg']] }
  let cols = []
  for [name, pairs] in items(rules)
    for pair in pairs
      let code = synIDattr(synIDtrans(hlID(pair[0])), pair[1])
      if !empty(name) && code > 0
        call add(cols, name.':'.code)
        break
      endif
    endfor
  endfor
  let s:orig_fzf_default_opts = get(s:, 'orig_fzf_default_opts', $FZF_DEFAULT_OPTS)
  let $FZF_DEFAULT_OPTS = s:orig_fzf_default_opts . (empty(cols) ? '' : (' --color='.join(cols, ',')))
endfunction
augroup _fzf
  autocmd!
  autocmd ColorScheme * call <sid>update_fzf_colors()
augroup END

nnoremap <leader><C-r> :History:<CR>
nnoremap <leader><leader> :History<CR>

" Git Grep with fzf by :GGrep
command! -bang -nargs=* GGrep
            \ call fzf#vim#grep(
            \   'git grep --line-number -- '.shellescape(<q-args>), 0,
            \   fzf#vim#with_preview({'dir': systemlist('git rev-parse --show-toplevel')[0]}), <bang>0)
" Without fuzzy search with :RG
function! RipgrepFzf(query, fullscreen)
    let command_fmt = 'rg --column --line-number --no-heading -- %s || true'
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

" Redirect any shell commands to fzf.vim.
command! -bang -complete=shellcmd -nargs=* F
    \ call fzf#run(fzf#wrap(<q-args>, {'source': <q-args>." 2>&1"}, <bang>0))


" Toggle comment out with gcc and gc with selection.
Plug 'tpope/vim-commentary'

Plug 'thinca/vim-quickrun'
let g:quickrun_config = {'*': {'hook/time/enable': '1'},}

Plug 'tpope/vim-surround'

" LSP
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
Plug 'prabirshrestha/vim-lsp'
Plug 'mattn/vim-lsp-settings'
Plug 'mattn/vim-lsp-icons'
Plug 'hrsh7th/vim-vsnip'
Plug 'hrsh7th/vim-vsnip-integ'

let g:lsp_settings = {
\   'pyls-all': {
\       'workspace_config': {
\           'pyls': {
\             'configurationSources': ['flake8'],
\             'plugins': {
\                 'flake8': {
\                     'enabled': v:true,
\                     "ignore": ["#262", "E402", "E712"],
\                     "max-line-length": 120,
\                 },
\                 'black': {'enabled': v:true},
\             },
\         },
\     },
\   },
\ }

let g:lsp_diagnostics_echo_cursor = 1

function! s:on_lsp_buffer_enabled() abort
    setlocal omnifunc=lsp#complete
    setlocal signcolumn=yes
    if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
    nmap <buffer> gd <plug>(lsp-definition)
    nmap <buffer> gr <plug>(lsp-references)
    nmap <buffer> gi <plug>(lsp-implementation)
    nmap <buffer> <leader>rn <plug>(lsp-rename)
    nmap <buffer> <leader>dd <plug>(lsp-document-diagnostics)
    nmap <buffer> <silent> [g <Plug>(lsp-previous-diagnostic)
    nmap <buffer> <silent> ]g <Plug>(lsp-next-diagnostic)
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


Plug 'vim-airline/vim-airline'

Plug 'dansomething/vim-hackernews'

Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
Plug 'godlygeek/tabular'
Plug 'plasticboy/vim-markdown'


Plug 'crusoexia/vim-monokai'
augroup colorschema
    autocmd!
    autocmd ColorScheme * highlight Normal ctermbg=none
    autocmd ColorScheme * highlight LineNr ctermbg=none
augroup END
set termguicolors
colorscheme monokai

" Initialize plugin system
call plug#end()

set fenc=utf-8
set nobackup
set noswapfile
set autoread
augroup vimrc-checktime
    autocmd!
    autocmd InsertEnter,WinEnter * checktime
augroup END
set hidden
" Yank to clipboard
if system('uname -s') == "Darwin\n"
    set clipboard=unnamed "OSX
else
    set clipboard=unnamedplus "Linux
endif

set number
set relativenumber
set cursorline
set cursorcolumn
set autoindent
set visualbell
set showmatch
set wildmode=list:longest " Auto completion on vim command line
nnoremap j gj
nnoremap k gk

" Tab
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set list listchars=tab:\▸\-
set list
" Remove trailing spaces.
augroup remove_spaces
    autocmd!
    autocmd BufWritePre * :%s/\s\+$//e
augroup END

set ignorecase
set smartcase " Case Sensitive only with upper case
set wrapscan
set hlsearch

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

function! Cldo(command)
    try
        silent crewind
        while 1
            execute a:command
            silent cnext
        endwhile
    catch /^Vim\%((\a\+)\)\=:E\%(553\|42\):/
    endtry
endfunction
command! -nargs=1 Cldo :call Cldo(<q-args>)

" Open .vimrc with <leader>,
map <leader>, :tabedit $MYVIMRC<cr>
map <leader>r :source $MYVIMRC<cr>

if &history < 1000
    set history=1000
endif
