" Keys are mapped with the mapping with the time so
" important settings should be written earlier.
let mapleader = "\<Space>" " Remap <leader> key to space

augroup MyAutoCmd
    autocmd!
augroup END


if has('nvim')
    autocmd MyAutoCmd termopen * startinsert
    autocmd MyAutoCmd termopen * setlocal nonumber norelativenumber
    autocmd MyAutoCmd TermClose term://*
        \ if (expand('<afile>') !~ "fzf") &&
        \ (expand('<afile>') !~ "ranger") &&
        \ (expand('<afile>') !~ "coc") |
        \   call nvim_input('<CR>')  |
        \ endif
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

scriptencoding utf-8
set encoding=utf-8
set langmenu=en_US
let $LANG = 'en_US.UTF-8'
source $VIMRUNTIME/delmenu.vim
source $VIMRUNTIME/menu.vim
set updatetime=250

set background=dark

" Specify a directory for plugins
" - For Neovim: ~/.local/share/nvim/plugged
" - Avoid using standard Vim directory names like 'plugin'
if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd MyAutoCmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
call plug#begin('~/.vim/plugged')

" Make sure you use single quotes





Plug 'voldikss/vim-translator'
let g:translator_target_lang = 'ja'

Plug 'cocopon/vaffle.vim'
function! s:customize_vaffle_mappings() abort
    " Customize key mappings here
    nmap <buffer> <Tab> <Plug>(vaffle-toggle-current)
endfunction
autocmd MyAutoCmd FileType vaffle call s:customize_vaffle_mappings()
nnoremap <leader>V <Cmd>Vaffle<CR>

" For vscode
Plug 'asvetliakov/vim-easymotion'
let g:EasyMotion_do_mapping = 0
" Plug 'easymotion/vim-easymotion'
if has('nvim') && !exists('g:vscode')
    Plug 'Matts966/hop.nvim', { 'on': 'HopWord' }
    map  <Leader>j <CMD>HopWord<CR>
    vmap <Leader>j <CMD>HopWordVisual<CR>
else
    map  <Leader>j <Plug>(easymotion-bd-w)
    if !exists('g:vscode')
        nmap <Leader>j <Plug>(easymotion-overwin-w)
    endif
endif

Plug 'makerj/vim-pdf'

Plug 'stsewd/gx-extended.vim'

if has('nvim')
    Plug 'kevinhwang91/nvim-bqf'

    Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins', 'on': [] }
    autocmd MyAutoCmd InsertEnter * :call plug#load('deoplete.nvim')
    autocmd MyAutoCmd InsertEnter * :call plug#load('eskk.vim')
    autocmd MyAutoCmd InsertEnter * :call plug#load('deoplete-vim-lsp')
    autocmd MyAutoCmd InsertEnter * :call plug#load('vim-auto-save')
    let g:deoplete#enable_at_startup = 1
    Plug 'lighttiger2505/deoplete-vim-lsp', { 'on': [] }

    Plug 'raghur/vim-ghost', { 'do': ':GhostInstall', 'on': [] }
    let g:ghost_autostart = 1
    function! s:SetupGhostBuffer()
        let g:ghost_darwin_app = 'kitty'
        let g:ghost_cmd = 'tabedit'
        if match(expand("%:a"), '\v/ghost-(github|reddit|stackexchange|stackoverflow)\.com-')
            set ft=markdown
        endif
    endfunction
    autocmd MyAutoCmd User vim-ghost#connected call s:SetupGhostBuffer()
    autocmd MyAutoCmd CursorHold,CursorHoldI * :call plug#load('vim-ghost')

    Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
    Plug 'nvim-treesitter/nvim-treesitter-textobjects'

    Plug 'Shougo/denite.nvim', { 'do': ':UpdateRemotePlugins' }
endif

" eskk.vim
Plug 'tyru/eskk.vim', { 'on': [] }
let g:eskk#directory = "~/.skk"
" Note that google-ime-skk is not working if stopped with ;
let g:eskk#server = {
\	'host': '0.0.0.0',
\	'port': 55100,
\}
let g:eskk#dictionary = { 'path': "~/.skk-jisyo", 'sorted': 0, 'encoding': 'utf-8' }
let g:eskk#large_dictionary = { 'path': "~/.skk/SKK-JISYO.L", 'sorted': 1, 'encoding': 'euc-jp' }
let g:eskk#start_completion_length = 1
set imdisable
set formatexpr=autofmt#japanese#formatexpr()
Plug 'tyru/skkdict.vim', { 'for': 'skkdict' }

let g:auto_save = 1  " enable AutoSave on Vim startup
Plug '907th/vim-auto-save', { 'on': [] }
" Save only on leaving insert to prevent overwriting
" history on unde.
let g:auto_save_events = ["InsertLeave"]

Plug 'prabirshrestha/vim-lsp'
Plug 'mattn/vim-lsp-settings'
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
    autocmd MyAutoCmd BufWritePre *.rs,*.go call execute('LspDocumentFormatSync')

    let g:lsp_settings = {
    \   'pyls-all': {
    \     'workspace_config': {
    \       'pyls': {
    \         'configurationSources': ['flake8']
    \       }
    \     }
    \   },
    \}
endfunction
" call s:on_lsp_buffer_enabled only for languages that has the server registered.
autocmd MyAutoCmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()

Plug 'psf/black', { 'branch': 'stable', 'for': ['python', 'vim-plug'] }
let g:black_linelength = 120
Plug 'fisadev/vim-isort', { 'for': ['python', 'vim-plug'] }
autocmd MyAutoCmd BufWritePre *.py execute ':Black' | execute ':Isort'

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

nnoremap <leader>gg <CMD>silent! wa!<CR><CMD>tabnew<CR><CMD>terminal lazygit<CR>
command! -nargs=0 Marp tabedit % | terminal marp --preview %

Plug 'mbbill/undotree', { 'on': 'UndotreeToggle' }
nnoremap <leader>u <Cmd>UndotreeToggle<CR><Cmd>UndotreeFocus<CR>
if has("persistent_undo")
    if !isdirectory($HOME."/.vim/undo-dir")
        call mkdir($HOME."/.vim/undo-dir", "p", 0700)
    endif
    set undodir=~/.vim/undo-dir
    set undofile
endif

Plug 'vim-jp/vimdoc-ja'

Plug 'junegunn/goyo.vim', { 'on': 'Goyo' }
nnoremap <silent> <leader>go :Goyo<CR>
let g:goyo_width = 120
autocmd MyAutoCmd User GoyoEnter nested call <SID>goyo_enter()
autocmd MyAutoCmd User GoyoLeave nested call <SID>goyo_leave()
function! s:goyo_enter()
    let g:goyo_now = 1
endfunction
function! s:goyo_leave()
    let g:goyo_now = 0
endfunction
if get(g:, 'goyo_now', 0) == 0
    set number
    set relativenumber
endif

if ! executable('j2p2j')
    !go install github.com/tamuhey/j2p2j
endif
Plug 'tamuhey/vim-jupyter'

Plug 'heavenshell/vim-pydocstring', { 'do': 'make install', 'for': ['python', 'vim-plug'] }

Plug 'machakann/vim-sandwich'
" Toggle comment out with gcc and gc with selection.
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-unimpaired'

Plug 'kana/vim-textobj-user'
Plug 'kana/vim-textobj-entire'
Plug 'kana/vim-operator-user'
Plug 'kana/vim-operator-replace'
map _ <Plug>(operator-replace)
Plug 'haya14busa/vim-operator-flashy'
map y <Plug>(operator-flashy)
nmap Y <Plug>(operator-flashy)$
Plug 'unblevable/quick-scope'

" Git related settings
Plug 'lambdalisue/gina.vim', { 'on': 'Gina' }
nnoremap [gina]  <Nop>
nmap <leader>g [gina]
nnoremap <silent> [gina]s :Gina status<CR>
nnoremap <silent> [gina]a :Gina add %<CR>
nnoremap <silent> [gina]c :Gina commit<CR>
nnoremap [gina]p :Gina pull<CR>
nnoremap [gina]P :Gina push<CR>
" Enable spell check only in git commit
set spelllang+=cjk
autocmd MyAutoCmd FileType gitcommit setlocal spell
autocmd MyAutoCmd FileType gitcommit setlocal bufhidden=delete

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
noremap <leader>m <Cmd>History<CR>
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
nnoremap <leader>f :GGrep<CR>
nnoremap <leader>p :GFiles<CR>

Plug 'dansomething/vim-hackernews'

if !exists('g:vscode')
    Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() },
        \ 'for': ['markdown', 'vim-plug']}
    Plug 'godlygeek/tabular', { 'for': ['markdown', 'vim-plug'] }
    Plug 'plasticboy/vim-markdown', { 'for': ['markdown', 'vim-plug'] }
    let g:vim_markdown_new_list_item_indent = 2
    let g:vim_markdown_folding_disabled = 1
    autocmd MyAutoCmd filetype markdown setlocal tabstop=2 softtabstop=2 shiftwidth=2 |
    \    nnoremap <buffer> <Tab> >>|
    \    inoremap <buffer> <Tab> <C-t>|
    \    vnoremap <buffer> <Tab> >gv|
    \    nnoremap <buffer> <S-Tab> <<|
    \    inoremap <buffer> <S-Tab> <C-d>|
    \    vnoremap <buffer> <S-Tab> <gv
endif

Plug 'airblade/vim-gitgutter'

Plug 'cocopon/iceberg.vim'

" Initialize plugin system
call plug#end()

set scrolloff=999

set termguicolors
colorscheme iceberg
" Visible selection
hi Visual ctermbg=236 guibg=#363d5c

if has('nvim')
    lua <<EOF
require'nvim-treesitter.configs'.setup {
    ensure_installed = "maintained", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
    indent = {
        enable = true,
    },
    textobjects = {
        select = {
            enable = true,
            keymaps = {
                -- You can use the capture groups defined in textobjects.scm
                ["af"] = "@function.outer",
                ["if"] = "@function.inner",
                ["ac"] = "@class.outer",
                ["ic"] = "@class.inner",
                ["ab"] = "@block.outer",
                ["ib"] = "@block.inner",
            }
        }
    }
}
EOF

    noremap <leader>b <Cmd>Denite buffer<CR>
    noremap <leader>t <Cmd>Denite buffer -input=term://<CR>
    call denite#custom#option('default', {
    \   'auto_action': 'preview',
    \})
    " Define mappings
    autocmd FileType denite call s:denite_my_settings()
    function! s:denite_my_settings() abort
        nnoremap <silent><buffer><expr> <CR>
                    \ denite#do_map('do_action')
        nnoremap <silent><buffer><expr> d
                    \ denite#do_map('do_action', 'delete')
        nnoremap <silent><buffer><expr> q
                    \ denite#do_map('quit')
        nnoremap <silent><buffer><expr> i
                    \ denite#do_map('open_filter_buffer')
        nnoremap <silent><buffer><expr> <Space>
                    \ denite#do_map('toggle_select').'j'
    endfunction
endif

" netrw
let g:netrw_liststyle=3
let g:netrw_keepj=""

set fenc=utf-8
set nobackup
set noswapfile
set autoread
autocmd MyAutoCmd FocusGained,BufEnter,CursorHold,CursorHoldI *
\   if !bufexists("[Command Line]") | checktime | endif
set hidden
" Yank to clipboard
set clipboard^=unnamed,unnamedplus

set cursorline
set cursorcolumn
set visualbell
nnoremap j gj
nnoremap k gk

" Tab
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set autoindent
autocmd MyAutoCmd FileType typescript, typescriptreact setlocal tabstop=2 softtabstop=2 shiftwidth=2

" Remove trailing spaces.
fun! TrimWhitespace()
    let l:save = winsaveview()
    keeppatterns %s/\s\+$//e
    call winrestview(l:save)
endfun
autocmd MyAutoCmd BufWritePre * :call TrimWhitespace()

set ignorecase
set smartcase " Case Sensitive only with upper case
set wildcharm=<Tab>
cnoremap <expr> <Tab> '<Cmd>set nosmartcase<CR><Tab><Cmd>let &smartcase = ' .. &smartcase .. '<CR>'
set wrapscan
set hlsearch

" Create dir if not exists when writing new file.
autocmd MyAutoCmd BufWritePre * call mkdir(expand("<afile>:p:h"), "p")

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
autocmd MyAutoCmd VimEnter * call s:LoadPlugins()
autocmd MyAutoCmd BufWritePost .vimrc ++nested source $MYVIMRC
map <leader>w <Cmd>write<CR>
command! -nargs=0 LoadPlugins call s:LoadPlugins()
map <leader>r <Cmd>silent! wa!<CR><Cmd>source $MYVIMRC<CR><Cmd>LoadPlugins<CR>

if &history < 1000
    set history=1000
endif

" Quit all read only buffers with q
nnoremap <expr> q (&modifiable && !&readonly ? 'q' : ':close!<CR>')
