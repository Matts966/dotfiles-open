" Keys are mapped with the mapping with the time so
" important settings should be written earlier.
let mapleader = "\<Space>" " Remap <leader> key to space

if has('nvim')
    augroup neovim-terminal
        autocmd!
        autocmd termopen * startinsert
    augroup end
    tnoremap <C-W> <C-U><C-\><C-N><C-W>
    tnoremap <C-W>N <C-U><C-\><C-N>
    tnoremap <C-W>. <C-W>
    nnoremap <leader>` <CMD>tabnew<CR><CMD>terminal<CR>
    autocmd TermOpen * setlocal nonumber norelativenumber
    nnoremap <leader>gg <CMD>tabnew<CR><CMD>terminal lazygit<CR>
else
    source $VIMRUNTIME/defaults.vim
    nnoremap <leader>` :tab terminal<CR>
    autocmd TerminalOpen * setlocal nonumber norelativenumber
    nnoremap <leader>gg :tab term ++close lazygit<CR>
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

Plug 'mbbill/undotree'
nnoremap <leader>u <Cmd>UndotreeToggle<CR><Cmd>UndotreeFocus<CR>
if has("persistent_undo")
    if !isdirectory($HOME."/.vim/undo-dir")
        call mkdir($HOME."/.vim/undo-dir", "p", 0700)
    endif
    set undodir=~/.vim/undo-dir
    set undofile
endif

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
    autocmd WinEnter * call s:auto_goyo_length()
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

Plug 'jiangmiao/auto-pairs'

let g:auto_save = 1  " enable AutoSave on Vim startup
Plug '907th/vim-auto-save'

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

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'yuki-yano/fzf-preview.vim', { 'branch': 'release/rpc' }
Plug 'LeafCage/yankround.vim'
noremap <leader><leader> <Cmd>FzfPreviewCommandPaletteRpc<CR>
let $FZF_PREVIEW_PREVIEW_BAT_THEME = $BAT_THEME

function! s:cd_repo(repo) abort
    let l:repo = trim(system('ghq root')) . '/' . a:repo
    exe 'lcd ' . repo
    if line('$') != 1 || getline(1) != ''
        tabnew
    endif
    Lexplore
endfunction
command! -bang -nargs=0 Repo
    \ call fzf#run(fzf#wrap({
        \ 'source': systemlist('ghq list'),
        \ 'sink': function('s:cd_repo')
    \ }, <bang>0))
nnoremap <leader>gr :Repo<CR>
nnoremap <leader>c :Commands<CR>

" Git Grep with fzf by :GGrep
command! -bang -nargs=* GGrep
    \ call fzf#vim#grep(
        \ 'git grep --line-number -- '.shellescape(<q-args>), 0,
        \ fzf#vim#with_preview({'dir': systemlist(
            \ 'git rev-parse --show-toplevel')[0]}), <bang>0)
nnoremap <C-f> :GGrep<CR>
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
" Make <CR> auto-select the first completion item and notify coc.nvim to
" format on enter, <cr> could be remapped by other vim plugin
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in
" location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)
" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
nmap <leader>rn <plug>(coc-rename)
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
let g:black_linelength = 80
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

augroup HelpMode
  autocmd!
augroup END
function! s:init_help()
  nnoremap <buffer> q <C-w>c
  nnoremap <buffer> <Space><Space> <C-]>
endfunction
autocmd HelpMode FileType help call s:init_help()

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
