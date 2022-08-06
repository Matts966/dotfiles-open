" 共通標準設定{{{

" プラグインの組み合わせによって出たり出なかったりするので
" チラツキを抑えるためにスタートページを無効化
set shm+=I

" Keys are mapped with the mapping with the time so
" important settings should be written earlier.
let mapleader = "\<Space>" " Remap <leader> key to space

map <leader>w <Cmd>write<CR>

augroup MyAutoCmd
  autocmd!
augroup END

scriptencoding utf-8
set encoding=utf-8
set langmenu=en_US
let $LANG = 'en_US.UTF-8'
source $VIMRUNTIME/delmenu.vim
source $VIMRUNTIME/menu.vim
set updatetime=250

set background=dark

set mouse=a

set foldmethod=marker

set scrolloff=999

set preserveindent
set copyindent
set expandtab
set autoindent
set smartindent
set tabstop=2
set shiftwidth=2
set fileformats=

set cmdheight=0

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
"}}}

" Clear search result on <C-l>{{{
nnoremap <silent> <C-l> <Cmd>nohlsearch<CR><Cmd>GitGutter<CR><C-l>
"}}}

" コマンド履歴1000件に{{{
if &history < 1000
  set history=1000
endif
"}}}

" Mimic Emacs Line Editing in Insert and Ex Mode Only{{{
noremap! <C-A> <Home>
noremap! <C-F> <Right>
noremap! <C-B> <Left>
noremap! <C-E> <End>
"}}}

" vim-plug, Make sure you use single quotes {{{
" Specify a directory for plugins
" - For Neovim: ~/.local/share/nvim/plugged
" - Avoid using standard Vim directory names like 'plugin'
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd MyAutoCmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
call plug#begin('~/.vim/plugged')

" VSCodeでも使うもの{{{

" Text Object系{{{
Plug 'kana/vim-textobj-user'
Plug 'kana/vim-textobj-entire'
Plug 'kana/vim-operator-user'
Plug 'kana/vim-operator-replace'
map _ <Plug>(operator-replace)
Plug 'haya14busa/vim-operator-flashy'
map y <Plug>(operator-flashy)
nmap Y <Plug>(operator-flashy)$
"}}}

Plug 'stsewd/gx-extended.vim'

" コメント系
Plug 'machakann/vim-sandwich'
" Toggle comment out with gcc and gc with selection.
Plug 'tpope/vim-commentary'
" Terraform
autocmd MyAutoCmd FileType tf setlocal commentstring=#\ %s
" Jupyter on VSCode
autocmd MyAutoCmd BufEnter *.ipynb#* setlocal commentstring=#\ %s

Plug 'itchyny/vim-highlighturl'

Plug 'Yggdroot/indentLine'

" Motion系{{{
Plug 'unblevable/quick-scope'
if exists('g:vscode')
  highlight QuickScopePrimary guifg=#00dfff ctermfg=45 gui=underline cterm=underline
  highlight QuickScopeSecondary gui=underline cterm=underline
else
  autocmd MyAutoCmd ColorScheme * highlight QuickScopePrimary guifg=#00dfff ctermfg=45 gui=underline cterm=underline
  autocmd MyAutoCmd ColorScheme * highlight QuickScopeSecondary gui=underline cterm=underline
endif
if has('nvim')
  Plug 'phaazon/hop.nvim', { 'on': 'HopWord' }
  autocmd! MyAutoCmd User hop.nvim lua require'hop'.setup()
  map  <Leader>j <CMD>HopWord<CR>
  vmap <Leader>j <CMD>HopWordVisual<CR>
else
  Plug 'vim-easymotion/vim-easymotion'
  let g:EasyMotion_do_mapping = 0
  map  <Leader>j <Plug>(easymotion-bd-w)
  nmap <Leader>j <Plug>(easymotion-overwin-w)
endif
"}}}

" VSCodeの場合終了{{{
if exists('g:vscode')
  "Do not execute rest of init.vim, do not apply any configs
  call plug#end()
  finish
endif
"}}}

"}}}

" VSCodeでは使わないもの{{{

" SKK{{{
Plug 'Matts966/skk-vconv.vim'
Plug 'vim-denops/denops.vim', { 'do': ':UpdateRemotePlugins' }
Plug 'vim-skk/skkeleton'
Plug 'delphinus/skkeleton_indicator.nvim'
Plug 'Shougo/ddc.vim'
autocmd MyAutoCmd User skkeleton-initialize-pre call skkeleton#config({
    \ 'globalJisyo': '~/.skk/SKK-JISYO.L',
    \ 'useSkkServer': v:true,
    \ 'skkServerPort': 55100,
    \ 'keepState': v:true,
    \ 'eggLikeNewline': v:true,
    \ 'immediatelyCancel': v:false,
    \ })
    \ | call skkeleton#register_kanatable('rom', {
    \   "/": ["・", ""],
    \ })
    \ | call skkeleton#register_keymap('henkan', "\<BS>", 'henkanBackward')
    \ | call skkeleton#register_keymap('henkan', "\<C-h>", 'henkanBackward')
    \ | call ddc#enable()
    \ | call ddc#custom#patch_global('backspaceCompletion', v:true)
    \ | call ddc#custom#patch_global('sourceOptions', {
    \   '_': {
    \     'matchers': ['matcher_head'],
    \     'sorters': ['sorter_rank']
    \   },
    \   'skkeleton': {
    \     'mark': 'skkeleton',
    \     'matchers': ['skkeleton'],
    \     'sorters': [],
    \     'minAutoCompleteLength': 1,
    \   },
    \ })
autocmd VimEnter * lua require'skkeleton_indicator'.setup{ eijiText = 'AaBb', hiraText = 'Hira' }
autocmd MyAutoCmd User skkeleton-enable-pre call
    \ ddc#custom#patch_global('sources', ['skkeleton'])
autocmd MyAutoCmd User skkeleton-disable-post call
    \ ddc#custom#patch_global('sources', [])
" SKKは文字数が増えるとなぜか補完が起動しなくなる
" Google IMEでの補完が実装されたら使う
" inoremap <silent><expr> <C-n> ddc#map#manual_complete()
autocmd MyAutoCmd ColorScheme * highlight! SkkeletonIndicatorEiji guifg=#88c0d0 gui=bold
autocmd MyAutoCmd ColorScheme * highlight! SkkeletonIndicatorHira guifg=#a3be8c gui=bold
imap <C-j> <Plug>(skkeleton-toggle)
cmap <C-j> <Plug>(skkeleton-toggle)
"}}}

" Jupyter on Vim{{{
Plug 'luk400/vim-jukit'
let g:jukit_mappings = 0
nnoremap <leader><C-CR> :call jukit#send#section(1)<CR>
nnoremap <leader><CR> :call jukit#send#section(0)<CR>
nnoremap <leader>on :call jukit#convert#notebook_convert("jupyter-notebook")<CR>
nnoremap <leader>os :tcd %:p:h<CR>:call jukit#splits#output()<CR><ESC>:tcd -<CR>
autocmd ColorScheme * highlight! jukit_textcell_bg_colors guibg=#131628 ctermbg=16
autocmd ColorScheme * highlight! jukit_cellmarker_colors guifg=#1d615a guibg=#1d615a ctermbg=22 ctermfg=22
"}}}

" Use emoji-fzf and fzf to fuzzy-search for emoji, and insert the result{{{
function! InsertEmoji(emoji)
    let @a = system('cut -d " " -f 1 | emoji-fzf get', a:emoji)
    normal! "agP
endfunction
command! -bang Emoj
  \ call fzf#run(fzf#wrap({
      \ 'source': 'emoji-fzf preview',
      \ 'options': "--preview 'emoji-fzf get --name {1}' ".$FZF_DEFAULT_OPTS,
      \ 'sink': function('InsertEmoji')
      \ }))
map <C-x><C-e> :Emoj<CR>
imap <C-x><C-e> <C-o><C-x><C-e>
"}}}

Plug 'github/copilot.vim'

Plug 'tyru/open-browser-github.vim'
Plug 'tyru/open-browser.vim'

Plug 'tpope/vim-repeat'
Plug 'tpope/vim-unimpaired'

" Markdown{{{
Plug 'iamcco/markdown-preview.nvim'
nnoremap <C-T> <Cmd>MarkdownPreviewToggle<CR>
function g:Open(url)
  silent execute('!open -ga Safari.app ' . a:url)
endfunction
let g:mkdp_browserfunc = 'g:Open'

" MarkdownPreivew with scrolling
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install' }
"}}}

Plug 'lambdalisue/fern.vim'"{{{
Plug 'lambdalisue/fern-hijack.vim'
Plug 'lambdalisue/fern-git-status.vim'
let g:fern#default_hidden = 1
function! s:init_fern() abort
  setlocal wrap
  nmap <buffer> d D
  nmap <buffer> c C
  nmap <buffer> p P
  nmap <buffer> m M
  nmap <buffer> <C-L> <Plug>(fern-action-reload)
  nmap <buffer> r <Plug>(fern-action-move)
  nmap <buffer> i <Plug>(fern-action-new-file)
  nmap <buffer> o <Plug>(fern-action-new-dir)
  nmap <buffer> . <Plug>(fern-action-hidden:toggle)
  nmap <buffer> H <Plug>(fern-action-leave)
  nmap <buffer> L <Plug>(fern-action-enter)
  nnoremap <buffer> N N
  call fern#action#call('tcd:root')
endfunction
autocmd MyAutoCmd BufEnter fern://* call s:init_fern()
nnoremap <leader>D <Cmd>Fern -drawer -toggle -reveal=% -width=60 .<CR>
let g:fern#renderer#default#leaf_symbol = ' '
let g:fern#renderer#default#collapsed_symbol = '▸'
let g:fern#renderer#default#expanded_symbol = '▾'
"}}}

Plug 'editorconfig/editorconfig-vim'
nnoremap <leader>ss gg=G``

" Denite{{{
if has('nvim')
  Plug 'Shougo/denite.nvim', { 'do': ':UpdateRemotePlugins' }
else
  Plug 'Shougo/denite.nvim'
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
endif
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
nnoremap <leader>b <Cmd>Denite buffer -auto-action=preview<CR>
nnoremap <leader>t <Cmd>Denite buffer -input=term:// -auto-action=preview<CR>
"}}}

Plug 'jparise/vim-graphql'

Plug 'jreybert/vimagit'

Plug 'gelguy/wilder.nvim', { 'do': ':UpdateRemotePlugins' }

Plug 'voldikss/vim-translator'
let g:translator_target_lang = 'ja'

Plug 'makerj/vim-pdf'

" LSP{{{
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
Plug 'prabirshrestha/vim-lsp'
Plug 'mattn/vim-lsp-settings'
autocmd ColorScheme * highlight! link LspErrorHighlight Error
autocmd ColorScheme * highlight! link LspWarningHighlight DiagnosticWarn
autocmd ColorScheme * highlight! link LspInformationHighlight DiagnosticInfo
autocmd ColorScheme * highlight! link LspHintHighlight DiagnosticHint
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
  nmap <buffer> K <plug>(lsp-hover)
  nmap <buffer> <leader>dd <CMD>LspDocumentDiagnostic<CR>
  nmap <buffer> <leader>da <CMD>LspDocumentDiagnostic --buffers=*<CR>
  nnoremap <buffer> <expr><c-j> lsp#scroll(+4)
  nnoremap <buffer> <expr><c-k> lsp#scroll(-4)
  nnoremap <buffer> <leader>A <CMD>LspCodeAction<CR>

  let g:lsp_format_sync_timeout = 1000
  if &ft == 'sql'
    nmap <buffer> <leader>ss <CMD>LspDocumentFormatSync<CR>
  endif
  if &ft == 'rust' || &ft == 'go' || &ft == 'dart' || matchstr(&ft, 'typescript*') != ''
    nmap <buffer> <leader>ss <CMD>LspDocumentFormatSync<CR><CMD>LspCodeAction source.organizeImports<CR>
  endif

  let g:lsp_settings = {
        \   'pyls-all': { 'workspace_config': { 'pyls': { 'configurationSources': ['flake8'] } } }
        \ }
endfunction
" call s:on_lsp_buffer_enabled only for languages that has the server registered.
autocmd MyAutoCmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
if !executable('texlab')
  au User lsp_setup call lsp#register_server({
        \ 'name': 'texlab',
        \ 'cmd': {server_info->['texlab']},
        \ 'whitelist': ['tex', 'bib', 'sty'],
        \ })
endif
let g:lsp_debug_servers = 1
au User lsp_setup call lsp#register_server({
      \ 'name': 'efm-langserver',
      \ 'cmd': {server_info->[&shell, &shellcmdflag, 'efm-langserver 2> /tmp/ok.log']},
      \ 'whitelist': ['sql'],
      \ })
"}}}

" Python fmt{{{
Plug 'psf/black', { 'branch': 'stable', 'for': ['python', 'vim-plug'] }
let g:black_linelength = 120
Plug 'fisadev/vim-isort', { 'for': ['python', 'vim-plug'] }
autocmd MyAutoCmd FileType python nmap <buffer> <leader>ss <CMD>Black<CR><CMD>Isort<CR>
"}}}

Plug 'itchyny/lightline.vim'"{{{
let g:lightline = {
      \   'active': {
      \     'left': [ [ 'mode', 'paste' ], [ 'gitbranch', 'readonly', 'filename', 'modified' ] ],
      \     'right': [ [ 'lineinfo' ],
      \                [ 'percent', 'fileformat', 'fileencoding', 'filetype' ]],
      \    },
      \   'component_function': { 'gitbranch': 'gina#component#repo#branch' },
      \ }
"}}}

Plug 'mbbill/undotree', { 'on': 'UndotreeToggle' }"{{{
nnoremap <leader>u <Cmd>UndotreeToggle<CR><Cmd>UndotreeFocus<CR>
if has("persistent_undo")
  if !isdirectory($HOME."/.vim/undo-dir")
    call mkdir($HOME."/.vim/undo-dir", "p", 0700)
  endif
  set undodir=~/.vim/undo-dir
  set undofile
endif
"}}}

Plug 'vim-jp/vimdoc-ja'

Plug 'junegunn/goyo.vim', { 'on': 'Goyo' }"{{{
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
"}}}

Plug 'heavenshell/vim-pydocstring', { 'do': 'make install', 'for': ['python', 'vim-plug'] }

" Git related settings{{{
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
"}}}

Plug 'psliwka/vim-smoothie'

Plug 'thinca/vim-qfreplace'

" fzf{{{
Plug 'junegunn/fzf.vim'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
imap <c-x><c-k> <plug>(fzf-complete-word)
imap <c-x><c-f> <plug>(fzf-complete-path)
" Relative path
" https://github.com/junegunn/fzf.vim/pull/628#issuecomment-766440334
inoremap <expr> <c-x><c-p> fzf#vim#complete("fd --hidden --exclude '.git' --exclude 'node_modules' --absolute-path --print0
      \ <Bar> xargs -0 realpath --relative-to " . shellescape(expand("%:p:h")) . " <Bar> sort -r")
imap <c-x><c-j> <plug>(fzf-complete-file-ag)
imap <c-x><c-l> <plug>(fzf-complete-line)
Plug 'yuki-yano/fzf-preview.vim', { 'branch': 'release/rpc' }
Plug 'LeafCage/yankround.vim'
noremap <leader>h <Cmd>History<CR>
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
      \   'ctrl-q': function('s:build_quickfix_list'),
      \   'ctrl-t': 'tab split',
      \   'ctrl-x': 'split',
      \   'ctrl-v': 'vsplit'
      \ }
nnoremap <leader>gr :Repo<CR>

function! s:cd_dir(dir) abort
  if line('$') != 1 || getline(1) != ''
    tabnew
  endif
  exe 'tcd ' . a:dir
  edit README.md
endfunction
command! -bang -nargs=0 Z
      \ call fzf#run(fzf#wrap({
      \ 'source': systemlist('cat ~/.z | cut -f1 -d"|"'),
      \ 'sink': function('s:cd_dir')
      \ }, <bang>0))
nnoremap <leader>z :Z<CR>

let rg_command = 'rg --hidden --column --line-number --no-heading --color=always --smart-case --glob "!.git" --glob "!node_modules" --glob "!vendor" -- '
command! -bang -nargs=* Rg
      \ call fzf#vim#grep(
      \   rg_command.shellescape(<q-args>), 1,
      \   fzf#vim#with_preview(), <bang>0)
nnoremap <leader>f :Rg<CR>
nnoremap <leader>p :Files<CR>
"}}}

Plug 'dansomething/vim-hackernews'

Plug 'vimwiki/vimwiki'"{{{
command! Links execute(':VimwikiGenerateLinks ' . glob(expand('%:h') . '/') . '*.md')
let g:vimwiki_key_mappings = {
      \   'all_maps': 0,
      \ }
let g:vimwiki_menu = '' " To disable No menu Vimwiki error
autocmd MyAutoCmd filetype vimwiki
      \  nmap <buffer> <CR> <Plug>VimwikiFollowLink|
      \  vmap <buffer> <CR> <Plug>VimwikiNormalizeLinkVisualCR|
      \  nmap <buffer> <C-n> <Plug>VimwikiNextLink|
      \  nmap <buffer> <C-p> <Plug>VimwikiPrevLink
autocmd MyAutoCmd FileType vimwiki imap <buffer><expr><silent> [[ fzf#vim#complete(fzf#wrap({
      \   'source': "fd --hidden --exclude '.git' --exclude 'node_modules' --absolute-path --print0
      \     <Bar> xargs -0 realpath --relative-to " . shellescape(expand("%:p:h")) . " <Bar> sort -r",
      \   'reducer': { lines -> '['. fnamemodify(lines[0], ":t:r") . '](' . lines[0] . ')' },
      \ }))
"}}}

Plug 'airblade/vim-gitgutter'

Plug 'cocopon/iceberg.vim'
"}}}

Plug 'dbinagi/nomodoro'

" Initialize plugin system
call plug#end()"}}}

" Colorscheme, plugin読み込み後に{{{
autocmd ColorScheme * highlight! Visual ctermbg=236 guibg=#363d5c
autocmd ColorScheme * highlight! VertSplit cterm=NONE
autocmd ColorScheme * highlight! Pmenu None
autocmd ColorScheme * highlight! PmenuSel guifg=black guibg=gray ctermfg=black ctermbg=gray
autocmd ColorScheme * highlight! CursorLIne cterm=None ctermbg=241 ctermfg=None guibg=None guifg=None

if $TERM_PROGRAM == 'Apple_Terminal'
  set notermguicolors
else
  set termguicolors
  autocmd ColorScheme * highlight! Normal guibg=NONE ctermbg=NONE
  let g:lightline.colorscheme = 'iceberg'
  " Transparent lightline
  let s:palette = g:lightline#colorscheme#{g:lightline.colorscheme}#palette
  let s:palette.normal.middle = [ [ 'NONE', 'NONE', 'NONE', 'NONE' ] ]
  let s:palette.inactive.middle = s:palette.normal.middle
  let s:palette.tabline.middle = s:palette.normal.middle
  colorscheme iceberg
endif
" Hide ~
set fillchars=eob:\ ,
" カーソルの強調
set cursorcolumn
set cursorline
"}}}

" netrw{{{
let g:netrw_liststyle=3
let g:netrw_keepj=""
"}}}

" widler, コマンドライン自動補完{{{
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
"}}}

" Create dir if not exists when writing new file.{{{
autocmd MyAutoCmd BufWritePre * call mkdir(expand("<afile>:p:h"), "p")
"}}}

" .vimrc自動読み込み{{{
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
command! -nargs=0 LoadPlugins call s:LoadPlugins()
map <leader>r <Cmd>silent! wa!<CR><Cmd>source $MYVIMRC<CR><Cmd>LoadPlugins<CR>
"}}}

" Quit all read only buffers with q{{{
nnoremap <expr> q (&modifiable && !&readonly ? 'q' : ':close!<CR>')
"}}}

" Help vertical{{{
autocmd MyAutoCmd BufEnter *.txt,*.jax if &filetype=='help' | wincmd L | endif
"}}}

" ターミナル移動{{{
" Comment out after " for automatically startinsert
nnoremap ]t <Cmd>call g:NextTerm()<CR> " <Cmd>if &buftype ==# 'terminal' <Bar> startinsert <Bar> endif<CR>
nnoremap [t <Cmd>call g:PrevTerm()<CR> " <Cmd>if &buftype ==# 'terminal' <Bar> startinsert <Bar> endif<CR>
tnoremap ]t <Cmd>call g:NextTerm()<CR>
tnoremap [t <Cmd>call g:PrevTerm()<CR>
function g:NextTerm()
  let current = bufnr('%')
  while v:true
    bnext
    if &buftype ==# 'terminal'
      break
    endif
    if current ==# bufnr('%')
      break
    endif
  endwhile
endfunction
function g:PrevTerm()
  let current = bufnr('%')
  while v:true
    bprevious
    if &buftype ==# 'terminal'
      break
    endif
    if current ==# bufnr('%')
      break
    endif
  endwhile
endfunction
"}}}

" ターミナル系コマンド{{{
nnoremap <leader>gg <CMD>silent! wa!<CR><CMD>tabnew<CR><CMD>terminal GIT_EDITOR="nvr --remote-tab" lazygit<CR>
nmap <leader>k <CMD>tabnew<CR><CMD>terminal k9s<CR><C-W>g<Tab>
command! -nargs=0 Sqlp tabedit % | terminal sqlp %
nnoremap <leader>sp <CMD>tabnew<CR><CMD>terminal spt<CR>
nnoremap <leader>T <Cmd>botright vsplit<CR><Cmd>terminal<CR>
command! -nargs=0 Marp tabedit % | terminal marp --preview %
"}}}

autocmd MyAutoCmd FileType qf setlocal wrap"{{{
"}}}

" Vim と Neovim の分岐設定{{{
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

  " To prevent unintended wincmd only
  tnoremap <C-W><C-O> <C-\><C-N><C-O>
  tnoremap <C-W>o <C-\><C-N><C-O>
  tnoremap <C-O> <C-\><C-N><C-O>

  set wildmode=longest:full

  set pumblend=30
else
  " Auto completion on vim command line
  " This prevents popup mode on nvim
  set wildmode=list:longest
  source $VIMRUNTIME/defaults.vim
endif
"}}}

" Neovide 設定{{{
if exists('g:neovide')
  let g:neovide_input_use_logo=v:true
  " copy
  vnoremap <D-c> "+y

  " paste
  nnoremap <D-v> p
  set pastetoggle=<F3>
  inoremap <D-v> <F3><C-r>+<F3>
  cnoremap <D-v> <C-r>+
  tnoremap <D-v> <C-\><C-n>pi

  " undo
  nnoremap <D-z> u
  inoremap <D-z> <Esc>ua

  let g:neovide_remember_window_size = v:true
  let g:neovide_cursor_vfx_mode = "railgun"

  " font size
  let g:gui_font_size = 12
  silent! execute('set guifont=Menlo:h'.g:gui_font_size)
  function! ResizeFont(delta)
    let g:gui_font_size = g:gui_font_size + a:delta
    execute('set guifont=Menlo:h'.g:gui_font_size)
  endfunction
  noremap <expr><D-=> ResizeFont(1)
  noremap <expr><D--> ResizeFont(-1)

  " transparency
  let g:neovide_transparency=0.8
  function! ChangeTransparency(delta)
    let g:neovide_transparency = g:neovide_transparency + a:delta
  endfunction
  noremap <expr><D-]> ChangeTransparency(0.01)
  noremap <expr><D-[> ChangeTransparency(-0.01)

  " " transparency
  " let g:neovide_transparency=0.0
  " let g:neovide_transparency_point=0.8
  " let g:neovide_background_color = '#0f1117'.printf('%x', float2nr(255 * g:neovide_transparency_point))
  " function! ChangeTransparency(delta)
  "   let g:neovide_transparency_point = g:neovide_transparency_point + a:delta
  "   let g:neovide_background_color = '#0f1117'.printf('%x', float2nr(255 * g:neovide_transparency_point))
  " endfunction
  " noremap <expr><D-]> ChangeTransparency(0.01)
  " noremap <expr><D-[> ChangeTransparency(-0.01)

  tnoremap <C-CR> <CR>
  tnoremap <S-BS> <BS>
  tnoremap <C-BS> <BS>
  tnoremap <C-Tab> <Tab>
endif
"}}}
