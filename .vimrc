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

  " To prevent unintended wincmd only
  tnoremap <C-W><C-O> <C-\><C-N><C-O>
  tnoremap <C-W>o <C-\><C-N><C-O>
  tnoremap <C-O> <C-\><C-N><C-O>

  set wildmode=longest:full

  set pumblend=30
  hi! link Pmenu icebergNormalFg
  hi! link PmenuSbar icebergNormalFg
  hi! link PmenuSel icebergNormalFg
  hi! link PmenuThumb icebergNormalFg
else
  " Auto completion on vim command line
  " This prevents popup mode on nvim
  set wildmode=list:longest
  source $VIMRUNTIME/defaults.vim
endif

nnoremap <leader>gg <CMD>silent! wa!<CR><CMD>tabnew<CR><CMD>terminal GIT_EDITOR="nvr --remote-tab" lazygit<CR>
nmap <leader>k <CMD>tabnew<CR><CMD>terminal k9s<CR><C-W>g<Tab>
command! -nargs=0 Sqlp tabedit % | terminal sqlp %
nnoremap <leader>sp <CMD>tabnew<CR><CMD>terminal spt<CR>
nnoremap <leader>T <Cmd>botright vsplit<CR><Cmd>terminal<CR>
command! -nargs=0 Marp tabedit % | terminal marp --preview %

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

scriptencoding utf-8
set encoding=utf-8
set langmenu=en_US
let $LANG = 'en_US.UTF-8'
source $VIMRUNTIME/delmenu.vim
source $VIMRUNTIME/menu.vim
set updatetime=250

set background=dark

set mouse=a

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




" SKK
Plug 'vim-denops/denops.vim', { 'do': ':UpdateRemotePlugins' }
Plug 'vim-skk/skkeleton'
Plug 'delphinus/skkeleton_indicator.nvim'
Plug 'Shougo/ddc.vim'
autocmd MyAutoCmd User skkeleton-initialize-pre call skkeleton#config({
    \ 'globalJisyo': '~/.skk/SKK-JISYO.L',
    \ 'useSkkServer': v:true,
    \ 'skkServerPort': 55100,
    \ })
    \ | call skkeleton#register_kanatable('rom', {
    \   "/": ["・", ""],
    \ })
autocmd MyAutoCmd User skkeleton-initialize-post call
    \ ddc#custom#patch_global('sources', ['skkeleton'])
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
    \ | lua require'skkeleton_indicator'.setup()
autocmd ColorScheme * highlight! SkkeletonIndicatorEiji guifg=#88c0d0 guibg=#2e3440 gui=bold
autocmd ColorScheme * highlight! SkkeletonIndicatorHira guifg=#2e3440 guibg=#a3be8c gui=bold
autocmd MyAutoCmd User skkeleton-enable-pre  call ddc#enable()
imap <C-j> <Plug>(skkeleton-toggle)
cmap <C-j> <Plug>(skkeleton-toggle)

" Plug 'tyru/eskk.vim', { 'on': [] }
" Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
" autocmd MyAutoCmd InsertEnter * :call plug#load('eskk.vim')
" autocmd MyAutoCmd User eskk-enable-pre :call deoplete#enable()
" autocmd MyAutoCmd User eskk-disable-pre :call deoplete#disable()
" let g:eskk#start_completion_length = 1
" let g:eskk#directory = "~/.skk"
" let g:eskk#server = {
" \    'host': '0.0.0.0',
" \    'port': 55100,
" \}
" let g:eskk#dictionary = { 'path': "~/.skk-jisyo", 'sorted': 0, 'encoding': 'utf-8' }
" let g:eskk#large_dictionary = { 'path': "~/.skk/SKK-JISYO.L", 'sorted': 1, 'encoding': 'euc-jp' }
" Plug 'tyru/skkdict.vim', { 'for': 'skkdict' }

let g:jukit_mappings = 0
Plug 'luk400/vim-jukit'
nnoremap <leader><C-CR> :call jukit#send#section(1)<CR>
nnoremap <leader><CR> :call jukit#send#section(0)<CR>
nnoremap <leader>on :call jukit#convert#notebook_convert("jupyter-notebook")<CR>
nnoremap <leader>os :tcd %:p:h<CR>:call jukit#splits#output()<CR><ESC>:tcd -<CR>
autocmd ColorScheme * highlight! jukit_textcell_bg_colors guibg=#131628 ctermbg=16
autocmd ColorScheme * highlight! jukit_cellmarker_colors guifg=#1d615a guibg=#1d615a ctermbg=22 ctermfg=22

" Use emoji-fzf and fzf to fuzzy-search for emoji, and insert the result
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

Plug 'rhysd/conflict-marker.vim'

Plug 'github/copilot.vim'

Plug 'tyru/open-browser-github.vim'
Plug 'tyru/open-browser.vim'

Plug 'iamcco/markdown-preview.nvim'
nnoremap <C-T> <Cmd>MarkdownPreviewToggle<CR>
function g:Open(url)
  silent execute('!open -ga Safari.app ' . a:url)
endfunction
let g:mkdp_browserfunc = 'g:Open'

" MarkdownPreivew with scrolling
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install' }

Plug 'lambdalisue/fern.vim'
" Plug 'lambdalisue/fern-hijack.vim'
Plug 'lambdalisue/fern-git-status.vim'
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
  nnoremap <buffer> N N
endfunction
autocmd MyAutoCmd BufEnter fern://* call s:init_fern()
nnoremap <leader>F <Cmd>Fern -drawer -toggle -reveal=% -width=60 .<CR>
let g:fern#renderer#default#leaf_symbol = ' '
let g:fern#renderer#default#collapsed_symbol = '▸'
let g:fern#renderer#default#expanded_symbol = '▾'
function! s:OpenDrawer() abort
  if &modifiable && filereadable(expand('%'))
    execute 'FernDo -stay FernReveal ' . @%
  endif
endfunction
autocmd MyAutoCmd BufEnter * call s:OpenDrawer()

Plug 'editorconfig/editorconfig-vim'
nnoremap <leader>ss gg=G``

if has('nvim')
  Plug 'Shougo/defx.nvim', { 'do': ':UpdateRemotePlugins' }
else
  Plug 'Shougo/defx.nvim'
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
endif
Plug 'kristijanhusak/defx-git'

Plug 'jparise/vim-graphql'

Plug 'itchyny/vim-highlighturl'

Plug 'jreybert/vimagit'

Plug 'gelguy/wilder.nvim', { 'do': ':UpdateRemotePlugins' }

Plug 'voldikss/vim-translator'
let g:translator_target_lang = 'ja'

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

Plug 'makerj/vim-pdf'

Plug 'stsewd/gx-extended.vim'

Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
Plug 'prabirshrestha/vim-lsp'
Plug 'mattn/vim-lsp-settings'
autocmd ColorScheme * highlight! link LspErrorHighlight Error
autocmd ColorScheme * highlight! link LspWarningHighlight WarningMsg
autocmd ColorScheme * highlight! link LspInformationHighlight WarningMsg
autocmd ColorScheme * highlight! link LspHintHighlight WarningMsg
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


Plug 'psf/black', { 'branch': 'stable', 'for': ['python', 'vim-plug'] }
let g:black_linelength = 120
Plug 'fisadev/vim-isort', { 'for': ['python', 'vim-plug'] }
autocmd MyAutoCmd FileType python nmap <buffer> <leader>ss <CMD>Black<CR><CMD>Isort<CR>

Plug 'itchyny/lightline.vim'
Plug 'ojroques/vim-scrollstatus'
let g:lightline = {
      \   'active': { 'left': [ [ 'mode', 'paste' ], [ 'gitbranch', 'readonly', 'filename', 'modified' ], [ 'scrollbar' ] ] },
      \   'component_function': { 'scrollbar': 'ScrollStatus', 'gitbranch': 'gina#component#repo#branch' },
      \ }

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

" Plug 'tamuhey/vim-jupyter'

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
nnoremap <leader>b :Buffers<CR>

Plug 'dansomething/vim-hackernews'

Plug 'vimwiki/vimwiki'
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

Plug 'airblade/vim-gitgutter'


Plug 'cocopon/iceberg.vim'

" Initialize plugin system
call plug#end()

if $TERM_PROGRAM == 'Apple_Terminal'
  set notermguicolors
else
  set termguicolors
  colorscheme iceberg
  hi Normal guibg=NONE ctermbg=NONE
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
set fileformats=

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

" defx hijack
autocmd BufEnter * if !exists('b:defx') && isdirectory(expand('%'))
      \ | call defx#util#call_defx('Defx', escape(expand('%'), ' '))
      \ | endif
function! s:defx_my_settings() abort
  nnoremap <silent><buffer><expr> v
        \ defx#do_action('drop', 'vsplit')
  nnoremap <silent><buffer><expr> t
        \ defx#do_action('open','tabnew')
  nnoremap <silent><buffer><expr> L
        \ defx#do_action('drop')
  nnoremap <silent><buffer><expr> H
        \ defx#do_action('cd', ['..'])
  nnoremap <silent><buffer><expr> l
        \ defx#is_directory() ?
        \ defx#do_action('open_tree') :
        \ defx#do_action('drop')
  nnoremap <silent><buffer><expr> h
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
        \ defx#do_action('remove_trash')
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
call defx#custom#column('filename', {
	    \   'min_width': 10,
	    \   'max_width': 40,
	    \ })
call defx#custom#column('icon', {
	    \   'directory_icon': '▸',
	    \   'opened_icon': '▾',
	    \   'root_icon': ' ',
	    \ })

autocmd MyAutoCmd BufLeave,BufWinLeave \[defx\]*
      \ call defx#call_action('add_session')
nnoremap <leader>D <Cmd>Defx -winwidth=60 -split=vertical
      \ -direction=topleft -session-file=.defx_session.json -buffer-name=defx
      \ -columns=git:mark:indent:filename:type<CR>

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

if exists('g:neovide')
  let g:neovide_input_use_logo=v:true
  " copy
  vnoremap <D-c> "+y

  " paste
  nnoremap <D-v> p
  inoremap <D-v> <C-r>+
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

  tnoremap <C-CR> <CR>
  tnoremap <S-BS> <BS>
  tnoremap <C-BS> <BS>
  tnoremap <C-Tab> <Tab>
endif
