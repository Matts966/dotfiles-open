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

" Make sure you use single quotes

Plug 'junegunn/goyo.vim'
nnoremap <silent> <leader>go :Goyo<CR>
function! s:auto_goyo_length()
    if &ft == 'python'
        " Python standard
        let g:goyo_width = 120
    else
        let g:goyo_width = 80
    endif
endfunction
augroup goyo_python
    autocmd!
    autocmd WinEnter * call s:auto_goyo_length()
augroup END

if ! executable('j2p2j')
    !go install github.com/tamuhey/j2p2j
endif
Plug 'tamuhey/vim-jupyter'

Plug 'heavenshell/vim-pydocstring', { 'do': 'make install' }

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
nnoremap <leader>gg :tab term ++close lazygit<CR>

Plug 'jiangmiao/auto-pairs'

let g:auto_save = 1  " enable AutoSave on Vim startup
Plug '907th/vim-auto-save'

Plug 'psliwka/vim-smoothie'

Plug 'thinca/vim-qfreplace'


Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'yuki-yano/fzf-preview.vim', { 'branch': 'release/rpc' }
Plug 'LeafCage/yankround.vim'
noremap <leader><leader> <Cmd>FzfPreviewCommandPaletteRpc<CR>
let $FZF_PREVIEW_PREVIEW_BAT_THEME = $BAT_THEME

function! s:cd_repo(repo) abort
    let l:repo = trim(system('ghq root')) . '/' . a:repo
    if line('$') == 1 && getline(1) == ''
        exe 'e' repo
    else
        exe 'tabedit ' . repo
    endif
    exe 'lcd ' . repo
endfunction
command! -bang -nargs=0 Repo
    \ call fzf#run(fzf#wrap({
        \ 'source': systemlist('ghq list'),
        \ 'sink': function('s:cd_repo')
    \ }, <bang>0))
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
" Without fuzzy search with :RG
function! RipgrepFzf(query, fullscreen)
    let command_fmt = 'rg --column --line-number --no-heading -- %s || true'
    let initial_command = printf(command_fmt, shellescape(a:query))
    let reload_command = printf(command_fmt, '{q}')
    let spec = {'options': ['--phony', '--query', a:query,
        \ '--bind', 'change:reload:'.reload_command]}
    call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec),
        \ a:fullscreen)
endfunction
command! -nargs=* -bang RG call RipgrepFzf(<q-args>, <bang>0)
" Find with ripgrep
nnoremap <C-f> :RG<CR>


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
Plug 'vim-airline/vim-airline-themes'
let g:airline_theme='minimalist'

Plug 'dansomething/vim-hackernews'

Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() },
    \ 'for': ['markdown', 'vim-plug']}
Plug 'godlygeek/tabular'
Plug 'plasticboy/vim-markdown'


Plug 'ErichDonGubler/vim-sublime-monokai'

" Initialize plugin system
call plug#end()

augroup colorschema
    autocmd!
    " Transparent Vim
    " autocmd ColorScheme * highlight Normal guibg=NONE ctermbg=NONE

    " Delete ~ char in the empty line
    autocmd ColorScheme * highlight NonText ctermfg=236 ctermbg=236
        \ guifg=#31322c guibg=#31322c
augroup END
set termguicolors
colorscheme sublimemonokai
" Prevent red fg and bg
hi SpellBad cterm=underline,bold ctermbg=none

" netrw
let g:netrw_winsize=20
let g:netrw_liststyle=3
let g:netrw_localrmdir='rm -r'
let g:netrw_keepj=""
nnoremap <C-E> :Lexplore<CR>
nnoremap <leader>` :botright terminal<CR>

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
    autocmd BufWritePre * :%s/!(^-)\s\+$//e
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

" Mimic Emacs Line Editing in Insert and Ex Mode Only
inoremap <C-A> <Home>
inoremap <C-F> <Right>
inoremap <C-B> <Left>
inoremap <C-E> <End>
cnoremap <C-A> <Home>
cnoremap <C-B> <Left>

" Clear search result on <C-l>
nnoremap <silent> <C-l> :<C-u>nohlsearch<CR><C-l>


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
function! s:OpenVimrc()
    if line('$') == 1 && getline(1) == ''
        exe 'e' resolve(expand($MYVIMRC))
    else
        exe 'tabedit ' . resolve(expand($MYVIMRC))
    endif
    exe 'lcd %:h'
endfunction
command! -nargs=0 OpenVimrc call s:OpenVimrc()
map <leader>, :OpenVimrc<CR>
map <leader>r :source $MYVIMRC<CR>

if &history < 1000
    set history=1000
endif

" Close terminals when quitting
autocmd ExitPre * call <sid>TermForceCloseAll()
function! s:TermForceCloseAll() abort
    let term_bufs = filter(range(1, bufnr('$')),
        \ 'getbufvar(v:val, "&buftype") == "terminal"')
    for t in term_bufs
            execute "bd! " t
    endfor
endfunction

" To open vim from terminal on vim
function! Tapi_vit(bufnum, arglist)
    let currfile = get(a:arglist, 0, '')
    if empty(currfile)
        return
    endif
    wincmd w
    execute 'e' currfile
endfunction
