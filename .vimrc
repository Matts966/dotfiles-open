" Keys are mapped with the mapping with the time so
" important settings should be written earlier.
let mapleader = "\<Space>" " Remap <leader> key to space

if has('nvim')
    augroup neovim-terminal
        autocmd!
        autocmd termopen * startinsert
        autocmd termopen * setlocal nonumber norelativenumber
        autocmd TermClose term://*
            \ if (expand('<afile>') !~ "fzf") &&
            \ (expand('<afile>') !~ "ranger") &&
            \ (expand('<afile>') !~ "coc") |
            \   call nvim_input('<CR>')  |
            \ endif
    augroup end
    tnoremap <C-W> <C-\><C-N><C-W>
    tnoremap <C-W>N <C-\><C-N>
    tnoremap <C-W>. <C-W>
    set wildmode=longest:full
    set winblend=30
    set pumblend=30
else
    " Auto completion on vim command line
    " This prevents popup mode on nvim
    set wildmode=list:longest
    source $VIMRUNTIME/defaults.vim
endif

augroup PDF
    autocmd!
    if executable('pdftotext')
        autocmd BufEnter *.pdf :enew | setlocal nobuflisted buftype=nofile bufhidden=wipe
            \ | 0read !pdftotext -layout -nopgbrk "#" -
    endif
augroup END

scriptencoding utf-8
set encoding=utf-8
set langmenu=en_US
let $LANG = 'en_US.UTF-8'
source $VIMRUNTIME/delmenu.vim
source $VIMRUNTIME/menu.vim

set background=dark

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





Plug 'stsewd/gx-extended.vim'

Plug 'raghur/vim-ghost', {'do': ':GhostInstall'}
let g:ghost_darwin_app = 'kitty'
let g:ghost_autostart = 1
let g:ghost_cmd = 'tabedit'
function! s:SetupGhostBuffer()
    if match(expand("%:a"), '\v/ghost-(github|reddit|stackexchange|stackoverflow)\.com-')
        set ft=markdown
    endif
endfunction
augroup vim-ghost
    au!
    au User vim-ghost#connected call s:SetupGhostBuffer()
augroup END

Plug 'cohama/lexima.vim'


if has('nvim')
    Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
else
    Plug 'Shougo/deoplete.nvim'
    Plug 'roxma/nvim-yarp'
    Plug 'roxma/vim-hug-neovim-rpc'
endif
let g:deoplete#enable_at_startup = 1

" eskk.vim
Plug 'tyru/eskk.vim'
let g:eskk#directory = "~/.skk"
" Note that google-ime-skk is not working if stopped with ;
let g:eskk#server = {
\	'host': '0.0.0.0',
\	'port': 55100,
\}
let g:eskk#dictionary = { 'path': "~/.skk-jisyo", 'sorted': 0, 'encoding': 'utf-8', }
let g:eskk#large_dictionary = { 'path': "~/.skk/SKK-JISYO.L", 'sorted': 1, 'encoding': 'euc-jp', }
let g:eskk#start_completion_length = 1
set imdisable
set formatexpr=autofmt#japanese#formatexpr()
Plug 'tyru/skkdict.vim'


" " This causes duplicate source lsp.
" Plug 'deoplete-plugins/deoplete-lsp'

Plug 'prabirshrestha/vim-lsp'
Plug 'mattn/vim-lsp-settings'
Plug 'lighttiger2505/deoplete-vim-lsp'
function! s:on_lsp_buffer_enabled() abort
    setlocal omnifunc=lsp#complete
    setlocal signcolumn=yes
    if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
    nmap <buffer> gd <plug>(lsp-definition)
    nmap <buffer> gs <plug>(lsp-document-symbol-search)
    nmap <buffer> gS <plug>(lsp-workspace-symbol-search)
    nmap <buffer> gr <plug>(lsp-references)
    nmap <buffer> gi <plug>(lsp-implementation)
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

Plug 'psf/black', { 'branch': 'stable' }
let g:black_linelength = 120
autocmd BufWritePre *.py execute ':Black'

Plug 'itchyny/lightline.vim'
Plug 'ojroques/vim-scrollstatus'
let g:lightline = {
\   'active': {
\       'left': [
\           [ 'mode', 'paste' ],
\           [ 'readonly', 'filename', 'modified' ],
\           [ 'scrollbar' ],
\       ]
\   },
\   'component_function': {'scrollbar': 'ScrollStatus'},
\}
Plug 'gkeep/iceberg-dark'
let g:lightline.colorscheme = 'icebergDark'


Plug 'voldikss/vim-floaterm'
Plug 'voldikss/fzf-floaterm'
let g:floaterm_autoclose = 1
let g:floaterm_keymap_toggle = '``'
let g:floaterm_gitcommit = 'split'
let g:floaterm_width = 0.9
let g:floaterm_height = 0.9
nnoremap <leader>gg <CMD>silent! wa!<CR><CMD>FloatermNew lazygit<CR>
nnoremap <leader>` <CMD>Floaterms<CR>
nnoremap <leader>d <CMD>FloatermNew<CR>

Plug 'mbbill/undotree'
nnoremap <leader>u <Cmd>UndotreeToggle<CR><Cmd>UndotreeFocus<CR>
if has("persistent_undo")
    if !isdirectory($HOME."/.vim/undo-dir")
        call mkdir($HOME."/.vim/undo-dir", "p", 0700)
    endif
    set undodir=~/.vim/undo-dir
    set undofile
endif

let g:auto_save = 1  " enable AutoSave on Vim startup
Plug '907th/vim-auto-save'
" Save only on leaving insert to prevent overwriting
" history on unde.
let g:auto_save_events = ["InsertLeave"]

Plug 'vim-jp/vimdoc-ja'

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
    autocmd BufEnter * call s:auto_goyo_length()
augroup END

if ! executable('j2p2j')
    !go install github.com/tamuhey/j2p2j
endif
Plug 'tamuhey/vim-jupyter'

Plug 'heavenshell/vim-pydocstring', { 'do': 'make install' }

" Toggle comment out with gcc and gc with selection.
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-repeat'

Plug 'kana/vim-textobj-user'
Plug 'kana/vim-textobj-entire'
Plug 'thinca/vim-textobj-between'
Plug 'kana/vim-operator-user'
Plug 'kana/vim-operator-replace'
map _ <Plug>(operator-replace)
Plug 'haya14busa/vim-operator-flashy'
map y <Plug>(operator-flashy)
nmap Y <Plug>(operator-flashy)$

Plug 'unblevable/quick-scope'

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

" Plug 'jiangmiao/auto-pairs'

Plug 'psliwka/vim-smoothie'

Plug 'thinca/vim-qfreplace'

Plug 'skanehira/gh.vim'

Plug 'junegunn/vim-peekaboo'


" fzf
Plug 'junegunn/fzf.vim'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
imap <c-x><c-k> <plug>(fzf-complete-word)
imap <c-x><c-f> <plug>(fzf-complete-path)
imap <c-x><c-j> <plug>(fzf-complete-file-ag)
imap <c-x><c-l> <plug>(fzf-complete-line)
Plug 'yuki-yano/fzf-preview.vim', { 'branch': 'release/rpc' }
Plug 'LeafCage/yankround.vim'
noremap <leader>b <Cmd>FzfPreviewBufferLinesRpc<CR>
noremap <leader>m <Cmd>FzfPreviewMruFilesRpc<CR>
noremap <leader><leader> <Cmd>FzfPreviewCommandPaletteRpc<CR>
let $FZF_PREVIEW_PREVIEW_BAT_THEME = $BAT_THEME

function! s:cd_repo(repo) abort
    let l:repo = trim(system('ghq root')) . '/' . a:repo
    if line('$') != 1 || getline(1) != ''
        tabnew
    endif
    exe 'tcd ' . repo
    edit README.md
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
nnoremap <leader>gr :Repo<CR>

" Git Grep with fzf by :GGrep
command! -bang -nargs=* GGrep
    \ call fzf#vim#grep(
        \ 'git grep --line-number -- '.shellescape(<q-args>), 0,
        \ fzf#vim#with_preview({'dir': systemlist(
            \ 'git rev-parse --show-toplevel')[0]}), <bang>0)
" Without fuzzy search with :RG
function! RipgrepFzf(query, fullscreen)
    let command_fmt = 'rg --column --line-number --no-heading'
        \ . ' --hidden --follow -g "!{node_modules,.git}" -- %s || true'
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
" Compatible with fzf default binding but ignore tag stack.
nnoremap <leader>p :GFiles<CR>

" Redirect any shell commands to fzf.vim.
command! -bang -complete=shellcmd -nargs=* F
    \ call fzf#run(fzf#wrap(<q-args>, {'source': <q-args>." 2>&1"}, <bang>0))


Plug 'dansomething/vim-hackernews'

Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() },
    \ 'for': ['markdown', 'vim-plug']}
Plug 'godlygeek/tabular'
if !exists('g:vscode')
    Plug 'plasticboy/vim-markdown'
endif

Plug 'airblade/vim-gitgutter'

Plug 'cocopon/iceberg.vim'

Plug 'basyura/TweetVim'
Plug 'mattn/favstar-vim'
Plug 'Shougo/unite.vim'
Plug 'basyura/bitly.vim'
Plug 'h1mesuke/unite-outline'
Plug 'mattn/webapi-vim'
Plug 'basyura/twibill.vim'
Plug 'tyru/open-browser.vim'
Plug 'Shougo/vimproc'

" Initialize plugin system
call plug#end()

set termguicolors
colorscheme iceberg
" Visible selection
hi Visual ctermbg=236 guibg=#363d5c

" netrw
let g:netrw_winsize=20
let g:netrw_liststyle=3
let g:netrw_localrmdir='rm -r'
let g:netrw_keepj=""

set fenc=utf-8
set nobackup
set noswapfile
set autoread
augroup vimrc-checktime
    autocmd!
    autocmd FocusGained,BufEnter,CursorHold,CursorHoldI *
        \ if !bufexists("[Command Line]") | checktime | endif
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
fun! TrimWhitespace()
    let l:save = winsaveview()
    keeppatterns %s/\s\+$//e
    call winrestview(l:save)
endfun
augroup remove_spaces
    autocmd!
    autocmd BufWritePre * :call TrimWhitespace()
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
nnoremap <silent> <C-l> :<Cmd>nohlsearch<CR>GitGutter<CR><C-l>

" Open .vimrc with <leader>,
function! s:OpenVimrc()
    let s:vimrc = glob('~/.vimrc')
    if line('$') == 1 && getline(1) == ''
        exe 'e' resolve(s:vimrc)
    else
        exe 'tabedit ' . resolve(s:vimrc)
    endif
    exe 'tcd %:h'
endfunction
command! -nargs=0 OpenVimrc call s:OpenVimrc()
map <leader>, :OpenVimrc<CR>
function! s:LoadPlugins()
    if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
        PlugInstall --sync
        quit
    endif
endfunction
augroup auto_load
    autocmd!
    autocmd VimEnter * call s:LoadPlugins()
    autocmd BufWritePost .vimrc source $MYVIMRC
augroup END
map <leader>w <Cmd>write<CR>
command! -nargs=0 LoadPlugins call s:LoadPlugins()
map <leader>r <Cmd>source $MYVIMRC<CR><Cmd>LoadPlugins<CR>

if &history < 1000
    set history=1000
endif

augroup HelpMode
    autocmd!
augroup END
function! s:init_help()
    nnoremap <buffer> <Space><Space> <C-]>
endfunction
autocmd HelpMode FileType help call s:init_help()
" Quit all read only buffers with q
nnoremap <expr> q (&modifiable && !&readonly ? 'q' : ':close!<CR>')
