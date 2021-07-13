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





Plug 'editorconfig/editorconfig-vim'
nnoremap <leader>s gg=G``

if has('nvim')
  Plug 'Shougo/defx.nvim', { 'do': ':UpdateRemotePlugins' }
else
  Plug 'Shougo/defx.nvim'
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
endif
function! s:defx_my_settings() abort
  nnoremap <silent><buffer><expr> v
        \ defx#do_action('drop', 'vsplit')
  nnoremap <silent><buffer><expr> t
        \ defx#do_action('open','tabnew')
  nnoremap <silent><buffer><expr> l
        \ defx#do_action('drop')
  nnoremap <silent><buffer><expr> h
        \ defx#do_action('cd', ['..'])
  nnoremap <silent><buffer><expr> L
        \ defx#do_action('open_tree')
  nnoremap <silent><buffer><expr> H
        \ defx#do_action('close_tree')
  nnoremap <silent><buffer><expr> .
        \ defx#do_action('toggle_ignored_files')
  nnoremap <silent><buffer><expr> yy
        \ defx#do_action('yank_path')
  nnoremap <silent><buffer><expr> c
        \ defx#do_action('copy')
  nnoremap <silent><buffer><expr> m
        \ defx#do_action('move')
  nnoremap <silent><buffer><expr> p
        \ defx#do_action('paste')
  nnoremap <silent><buffer><expr> d
        \ defx#do_action('remove')
  nnoremap <silent><buffer><expr> r
        \ defx#do_action('rename')
  nnoremap <silent><buffer><expr> x
        \ defx#do_action('execute_system')
  nnoremap <silent><buffer><expr> i
        \ defx#do_action('new_file')
  nnoremap <silent><buffer><expr> o
        \ defx#do_action('new_directory')
  vnoremap <silent><buffer><expr> <CR>
        \ defx#do_action('toggle_select_visual') . 'j'
  nnoremap <silent><buffer><expr> <CR>
        \ defx#do_action('toggle_select') . 'j'
  nnoremap <silent><buffer><expr> *
        \ defx#do_action('toggle_select_all')
endfunction
autocmd MyAutoCmd FileType defx call s:defx_my_settings()
nnoremap <leader>D <Cmd>Defx -winwidth=50 -split=vertical -direction=topleft<CR>

Plug 'jparise/vim-graphql'

Plug 'itchyny/vim-highlighturl'

Plug 'jreybert/vimagit'

Plug 'gelguy/wilder.nvim', { 'do': ':UpdateRemotePlugins' }

Plug 'voldikss/vim-translator'
let g:translator_target_lang = 'ja'

if has('nvim')
  Plug 'Matts966/hop.nvim', { 'on': 'HopWord' }
  map  <Leader>j <CMD>HopWord<CR>
  vmap <Leader>j <CMD>HopWordVisual<CR>
else
  Plug 'vim-easymotion/vim-easymotion'
  let g:EasyMotion_do_mapping = 0
  map  <Leader>j <Plug>(easymotion-bd-w)
  nmap <Leader>j <Plug>(easymotion-overwin-w)
endif

Plug 'makerj/vim-pdf'

Plug 'stsewd/gx-extended.vim'

if has('nvim')
  Plug '907th/vim-auto-save'
  let g:auto_save = 1  " enable AutoSave on Vim startup
  autocmd MyAutoCmd FileType magit let b:auto_save = 0

  Plug 'raghur/vim-ghost', { 'do': ':GhostInstall', 'on': [] }
  let g:ghost_autostart = 1
  function! s:SetupGhostBuffer()
    let g:ghost_darwin_app = 'kitty'
    let g:ghost_cmd = 'tabedit'
    if match(expand("%:a"), '\v/ghost-(github|reddit|stackexchange|stackoverflow|calendar.google)\.com-')
      set ft=markdown
    endif
  endfunction
  autocmd MyAutoCmd User vim-ghost#connected call s:SetupGhostBuffer()
  autocmd MyAutoCmd CursorHold,CursorHoldI * :call plug#load('vim-ghost')

  Plug 'Shougo/denite.nvim', { 'do': ':UpdateRemotePlugins' }

  " Unused. would like to use this after black hole register related bugs
  " are fixed.
  " Plug 'tversteeg/registers.nvim'
  " else
  " Plug 'junegunn/vim-peekaboo'
endif

Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
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
  nmap <buffer> [q <Plug>(lsp-previous-diagnostic)
  nmap <buffer> ]q <Plug>(lsp-next-diagnostic)
  nmap <buffer> K <plug>(lsp-hover)
  nmap <buffer> <leader>dd <CMD>LspDocumentDiagnostic<CR>

  let g:lsp_format_sync_timeout = 1000
  if &ft == 'rust' || &ft == 'go' || &ft == 'typescript'
    nmap <buffer> <leader>s <CMD>LspDocumentFormatSync<CR>
  endif

  let g:lsp_settings = {
        \ 'pyls-all': { 'workspace_config': { 'pyls': { 'configurationSources': ['flake8'] } } }
        \ }
endfunction
" call s:on_lsp_buffer_enabled only for languages that has the server registered.
autocmd MyAutoCmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()

Plug 'psf/black', { 'branch': 'stable', 'for': ['python', 'vim-plug'] }
let g:black_linelength = 120
Plug 'fisadev/vim-isort', { 'for': ['python', 'vim-plug'] }
autocmd MyAutoCmd FileType python nmap <buffer> <leader>s <CMD>Black<CR><CMD>Isort<CR>

Plug 'itchyny/lightline.vim'
Plug 'ojroques/vim-scrollstatus'
let g:lightline = {
      \   'active': { 'left': [ [ 'mode', 'paste' ], [ 'gitbranch', 'readonly', 'filename', 'modified' ], [ 'scrollbar' ] ] },
      \   'component_function': { 'scrollbar': 'ScrollStatus', 'gitbranch': 'gina#component#repo#branch' },
      \ }

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

Plug 'tamuhey/vim-jupyter'

Plug 'heavenshell/vim-pydocstring', { 'do': 'make install', 'for': ['python', 'vim-plug'] }

Plug 'machakann/vim-sandwich'
" Toggle comment out with gcc and gc with selection.
Plug 'tpope/vim-commentary'
autocmd MyAutoCmd FileType tf setlocal commentstring=#\ %s
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
autocmd MyAutoCmd FileType gitcommit setlocal spell
autocmd MyAutoCmd FileType gitcommit setlocal bufhidden=delete

Plug 'psliwka/vim-smoothie'

Plug 'thinca/vim-qfreplace'

Plug 'skanehira/gh.vim'

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

noremap <leader>b <Cmd>Buffers<CR>

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
      \   'ctrl-q': function('s:build_quickfix_list'),
      \   'ctrl-t': 'tab split',
      \   'ctrl-x': 'split',
      \   'ctrl-v': 'vsplit'
      \ }
nnoremap <leader>gr :Repo<CR>

let rg_command = 'rg --hidden --column --line-number --no-heading --color=always --smart-case --glob "!.git" --glob "!node_modules" -- '
command! -bang -nargs=* Rg
      \ call fzf#vim#grep(
      \   rg_command.shellescape(<q-args>), 1,
      \   fzf#vim#with_preview(), <bang>0)
nnoremap <leader>f :Rg<CR>
nnoremap <leader>p :Files<CR>

Plug 'dansomething/vim-hackernews'

Plug 'vimwiki/vimwiki'
let g:vimwiki_list = [{
      \     'path': '~/Library/Mobile Documents/iCloud~app~cyan~taio/Documents/Editor/private-diary/wiki',
      \     'syntax': 'markdown', 'ext': '.md'
      \   }
      \ ]
let g:vimwiki_key_mappings = {
      \   'all_maps': 0,
      \ }
let g:vimwiki_menu = '' " To disable No menu Vimwiki error
Plug 'michal-h21/vim-zettel'
let g:zettel_fzf_command = rg_command
autocmd MyAutoCmd filetype markdown
      \  nnoremap <buffer> <CR> <Cmd>VimwikiFollowLink<CR>|
      \  nnoremap <buffer> <C-n> <Cmd>VimwikiNextLink<CR>|
      \  nnoremap <buffer> <C-p> <Cmd>VimwikiPrevLink<CR>

Plug 'airblade/vim-gitgutter'


Plug 'cocopon/iceberg.vim'

" Initialize plugin system
call plug#end()

if $TERM_PROGRAM == 'Apple_Terminal'
  set notermguicolors
else
  set termguicolors
  colorscheme iceberg
  let g:lightline.colorscheme = 'iceberg'
endif

set scrolloff=999

" Visible selection
highlight Visual ctermbg=236 guibg=#363d5c
highlight VertSplit cterm=NONE
highlight Pmenu None
highlight PmenuSel guifg=black guibg=gray ctermfg=black ctermbg=gray
set cursorcolumn
set cursorline
highlight CursorLIne cterm=None ctermbg=241 ctermfg=None guibg=None guifg=None

if has('nvim')
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

set preserveindent
set copyindent
set expandtab
set autoindent
set smartindent
set tabstop=2
set shiftwidth=2

set fenc=utf-8
set nobackup
set noswapfile
set autoread
autocmd MyAutoCmd FocusGained,BufEnter,CursorHold,CursorHoldI *
      \   if !bufexists("[Command Line]") | checktime | endif
set hidden
" Yank to clipboard
set clipboard^=unnamed,unnamedplus

set visualbell
nnoremap j gj
nnoremap k gk

set ignorecase
set smartcase " Case Sensitive only with upper case
set wrapscan
set hlsearch

call wilder#enable_cmdline_enter()
" only / and ? are enabled by default
set wildcharm=<Tab>
" For :cd ~/<C-n> to complete path
cmap <expr> <C-n> wilder#in_context() ? wilder#previous() : "\<C-n>"
cmap <expr> <C-p> wilder#in_context() ? wilder#next() : "\<C-p>"
call wilder#set_option('modes', [':'])
call wilder#set_option('renderer', wilder#popupmenu_renderer({
      \ 'highlighter': wilder#basic_highlighter(),
      \ 'reverse': v:true,
      \ }))
call wilder#set_option('pipeline', [wilder#branch([
      \       wilder#check({_, x -> empty(x)}),
      \       wilder#history(),
      \     ],
      \     wilder#cmdline_pipeline(),
      \     wilder#search_pipeline(),
      \   ),
      \ ])

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
nnoremap <silent> <C-l> <Cmd>nohlsearch<CR><Cmd>GitGutter<CR><C-l>

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

" Help vertical
autocmd MyAutoCmd BufEnter *.txt,*.jax if &filetype=='help' | wincmd L | endif

autocmd MyAutoCmd FileType qf setlocal wrap
