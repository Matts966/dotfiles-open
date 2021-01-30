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
    set winblend=30
    set pumblend=30
    set wildmode=longest:full
    nmap <leader>h :lua require("replacer").run()<cr>
else
    " Auto completion on vim command line
    " This prevents popup mode on nvim
    set wildmode=list:longest
    source $VIMRUNTIME/defaults.vim
endif

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





Plug 'gabrielpoca/replacer.nvim'

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

" skk.vim
"Plug 'tyru/skk.vim'
"map! <C-j> <Plug>(skk-toggle-im)
"let g:skk_large_jisyo = expand('~/.skk/SKK-JISYO.L')
"let g:skk_auto_save_jisyo = 1
""autofmt option
" set imdisable
" set formatexpr=autofmt#japanese#formatexpr()

" eskk.vim
Plug 'tyru/eskk.vim'
let g:eskk#directory = "~/.skk"
let g:eskk#dictionary = { 'path': "~/.skk-jisyo", 'sorted': 0, 'encoding': 'utf-8', }
let g:eskk#large_dictionary = { 'path': "~/.skk/SKK-JISYO.L", 'sorted': 1, 'encoding': 'euc-jp', }
let g:eskk#enable_completion = 1
set imdisable
set formatexpr=autofmt#japanese#formatexpr()

Plug 'voldikss/vim-floaterm'
Plug 'voldikss/fzf-floaterm'
let g:floaterm_autoclose = 1
let g:floaterm_keymap_toggle = '``'
let g:floaterm_gitcommit = 'split'
let g:floaterm_width = 0.9
let g:floaterm_height = 0.9
nnoremap <leader>gg <CMD>FloatermNew lazygit<CR>

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

Plug 'szw/vim-g'

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

Plug 'easymotion/vim-easymotion'
map <Leader>e <Plug>(easymotion-prefix)
Plug 'rhysd/clever-f.vim'
map ; <Plug>(clever-f-repeat-forward)
map , <Plug>(clever-f-repeat-back)

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

Plug 'terryma/vim-expand-region'
vmap v <Plug>(expand_region_expand)
vmap <C-v> <Plug>(expand_region_shrink)

Plug 'thinca/vim-qfreplace'

Plug 'skanehira/gh.vim'
" Use gh command token
let s:gh_token_path = glob('~/.config/gh/hosts.yml')
if !empty(s:gh_token_path)
    for line in readfile(s:gh_token_path, '')
        if line =~ 'oauth_token'
            let g:gh_token = matchlist(line, 'oauth_token: \(.*\)')[1]
            break
        endif
    endfor
endif

Plug 'junegunn/vim-peekaboo'

Plug 'junegunn/fzf.vim'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
imap <c-x><c-k> <plug>(fzf-complete-word)
imap <c-x><c-f> <plug>(fzf-complete-path)
imap <c-x><c-j> <plug>(fzf-complete-file-ag)
imap <c-x><c-l> <plug>(fzf-complete-line)
Plug 'yuki-yano/fzf-preview.vim', { 'branch': 'release/rpc' }
Plug 'LeafCage/yankround.vim'
noremap <leader><leader> <Cmd>FzfPreviewCommandPaletteRpc<CR>
let $FZF_PREVIEW_PREVIEW_BAT_THEME = $BAT_THEME

function! s:FzfCommandHistory()
    let s:INTERRUPT = "\u03\u0c" " <C-c><C-l>
    let s:SUBMIT = "\u0d" " <C-m>
    let s:cmdtype = getcmdtype()
    let s:args = string({
    \   "options": "--query=" . shellescape(getcmdline()),
    \ })
    if s:cmdtype == ':'
        return s:INTERRUPT . ":keepp call fzf#vim#command_history(" .  s:args . ")" . s:SUBMIT
    elseif s:cmdtype == '/' || s:cmdtype == '?'
        return s:INTERRUPT . ":keepp call fzf#vim#search_history(" .  s:args . ")" . s:SUBMIT
    else
        return ''
    endif
endfunction
cnoremap <expr> <C-R> <SID>FzfCommandHistory()
" Only works on nvim and prevents default behavior
" cnoremap <expr> <Tab> getcmdtype() == "/" \|\|
" \    getcmdtype() == "?" ? "<CR>/<C-r>/" : "<C-Z>"

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
let $FZF_DEFAULT_OPTS = '--reverse --ansi --bind ctrl-a:select-all'
nnoremap <leader>gr :Repo<CR>

" Git Grep with fzf by :GGrep
command! -bang -nargs=* GGrep
    \ call fzf#vim#grep(
        \ 'git grep --line-number -- '.shellescape(<q-args>), 0,
        \ fzf#vim#with_preview({'dir': systemlist(
            \ 'git rev-parse --show-toplevel')[0]}), <bang>0)
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
" Compatible with fzf default binding but ignore tag stack.
nnoremap <C-t> :GFiles<CR>

" Redirect any shell commands to fzf.vim.
command! -bang -complete=shellcmd -nargs=* F
    \ call fzf#run(fzf#wrap(<q-args>, {'source': <q-args>." 2>&1"}, <bang>0))

" LSP
Plug 'neoclide/coc.nvim', {'branch': 'release'}
" Lazily load coc for splash text
let g:coc_start_at_startup = v:false
autocmd FileType * CocStart
" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300
" Don't pass messages to |ins-completion-menu|.
set shortmess+=c
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction
" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in
" location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)
" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
nmap <leader>dd <Cmd>CocDiagnostics<CR>
nmap <leader>f  <Plug>(coc-format)
" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)
" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>
let g:coc_disable_transparent_cursor = 1
let g:coc_global_extensions = [
\   'coc-dictionary', 'coc-word', 'coc-emoji',
\   'coc-python', 'coc-rls', 'coc-vimlsp',
\   'coc-git', 'coc-tsserver', 'coc-sh',
\ ]
let g:coc_user_config = {
\   'diagnostic.warningSign': '>>',
\   'python.linting.pylintEnabled': 0,
\   'python.linting.flake8Enabled': 1,
\   'python.linting.enabled': 1,
\   'python.formatting.provider': 'black',
\ }
Plug 'psf/black', { 'branch': 'stable' }
let g:black_linelength = 120
autocmd BufWritePre *.py execute ':Black'

Plug 'gkeep/iceberg-dark'
Plug 'itchyny/lightline.vim'
function! CocErrors()
    let info = get(b:, 'coc_diagnostic_info', {})
    if get(info, 'error', 0)
        return '• ' . info['error']
    endif
    return ''
endfunction
function! CocWarnings()
    let info = get(b:, 'coc_diagnostic_info', {})
    if get(info, 'warning', 0)
        return '• ' . info['warning']
    endif
    return ''
endfunction
function! CocStatus()
    let info = get(b:, 'coc_diagnostic_info', {})
    if get(info, 'error', 0)
        return ''
    endif
    if get(info, 'warning', 0)
        return ''
    endif
    let s:msg = get(g:, 'coc_status', '')
    if s:msg
        return '• ' . s:msg
    endif
    return '•'
endfunction
let g:lightline = {
    \ 'colorscheme': 'icebergDark',
    \ 'active': {
    \     'left': [ [ 'mode', 'paste' ],
    \         [ 'readonly', 'filename', 'modified', 'coc_errors', 'coc_warnings', 'coc_ok' ] ]
    \ },
    \ 'component_expand': {
    \     'coc_errors': 'CocErrors',
    \     'coc_warnings': 'CocWarnings',
    \     'coc_ok': 'CocStatus'
    \ },
    \     'component_type': {
    \     'coc_warnings': 'warning',
    \     'coc_errors': 'error',
    \     'coc_ok': 'ok',
    \ },
\ }
augroup CocConf
    autocmd!
    autocmd User CocStatusChange,CocDiagnosticChange call lightline#update()
    " Highlight the symbol and its references when holding the cursor.
    autocmd CursorHold * silent call CocActionAsync('highlight')
augroup END
set laststatus=2


Plug 'dansomething/vim-hackernews'

Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() },
    \ 'for': ['markdown', 'vim-plug']}
Plug 'godlygeek/tabular'
if !exists('g:vscode')
    Plug 'plasticboy/vim-markdown'
endif

Plug 'airblade/vim-gitgutter'

Plug 'cocopon/iceberg.vim'

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
nnoremap <C-E> :Lexplore<CR>

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
map <leader>r <Cmd>write<CR><Cmd>source $MYVIMRC<CR>
map <leader>w <Cmd>write<CR>

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
