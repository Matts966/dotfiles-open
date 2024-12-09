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

" sign表示時にカクつかないように
set signcolumn=yes

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

" dein, Make sure you use single quotes {{{
let s:dein_dir = $HOME . '/.cache/dein'
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'
if &runtimepath !~# '/dein.vim'
  if !isdirectory(s:dein_repo_dir)
    execute '!git clone git@github.com:Shougo/dein.vim.git' s:dein_repo_dir
  endif
  execute 'set runtimepath^=' . fnamemodify(s:dein_repo_dir, ':p')
endif
let g:dein#install_progress_type = has('nvim') ? 'title' : 'tabline'
let g:dein#enable_notification = 1
filetype plugin indent on
syntax enable
call dein#begin(s:dein_dir)
call dein#add('Shougo/dein.vim')

" VSCodeでも使うもの{{{

call dein#add('vim-denops/denops.vim', {'lazy': 1})

" Text Object系{{{

call dein#add('kana/vim-textobj-user', {'on_map': '<Plug>(textobj-'})
call dein#add('kana/vim-textobj-entire', {'on_event': 'VimEnter', 'depends': 'vim-textobj-user'})
call dein#add('kana/vim-operator-user', {'on_map': '<Plug>(operator-'})
call dein#add('kana/vim-operator-replace', {'on_map': '<Plug>(operator-replace', 'depends': 'vim-operator-user'})
map _ <Plug>(operator-replace)
call dein#add('haya14busa/vim-operator-flashy', {'on_map': '<Plug>(operator-flashy',
      \ 'depends': 'vim-operator-user'})
map y <Plug>(operator-flashy)
nmap Y <Plug>(operator-flashy)$

"}}}

" TODO: Fix broken gx
call dein#add('Matts966/gx-extended.vim', {'on_map': 'gx'})

call dein#add('andymass/vim-matchup', {'on_event': 'FileType'})
let g:matchup_matchparen_offscreen = {'method': 'popup'}

" 上書きされないようにdependsを指定
call dein#add('machakann/vim-sandwich', {
      \   'on_map': 's',
      \   'depends': ['vim-textobj-user', 'vim-operator-user'],
      \ })
" Toggle comment out with gcc and gc with selection.
call dein#add('tpope/vim-commentary', {'on_map': 'gc'})
" Jupyter on VSCode
autocmd MyAutoCmd BufEnter *.ipynb#* setlocal commentstring=#\ %s

call dein#add('itchyny/vim-highlighturl')

" Motion系{{{

if exists('g:vscode')
  " 表示が崩れて見づらくなってしまうので使わない
  "
else
  call dein#add('unblevable/quick-scope')
  autocmd MyAutoCmd ColorScheme * highlight QuickScopePrimary guifg=#00dfff ctermfg=45 gui=underline cterm=underline
  autocmd MyAutoCmd ColorScheme * highlight QuickScopeSecondary gui=underline cterm=underline
endif
if has('nvim')
  call dein#add('phaazon/hop.nvim', {
        \   'on_cmd': ['HopWord', 'HopWordVisual'],
        \   'hook_post_source': 'lua require"hop".setup()',
        \ })
  map  <Leader>j <Cmd>HopWord<CR>
  vmap <Leader>j <Cmd>HopWordVisual<CR>
else
  call dein#add('vim-easymotion/vim-easymotion')
  let g:EasyMotion_do_mapping = 0
  map  <Leader>j <Plug>(easymotion-bd-w)
  nmap <Leader>j <Plug>(easymotion-overwin-w)
endif

"}}}

" VSCodeの場合終了{{{

if exists('g:vscode')
  "Do not execute rest of init.vim, do not apply any configs
  call dein#end()
  finish
endif

"}}}

"}}}

" VSCodeでは使わないもの{{{

set cmdheight=0
" <CR> 待ち対策
" 消す時は<Plug>(ahc)も消すこと
call dein#add('utubo/vim-auto-hide-cmdline', {'on_map': '<Plug>(ahc'})

" SKK{{{

call dein#add('Matts966/skk-vconv.vim', {'on_map': '<C-j>'})
call dein#add('vim-skk/skkeleton', {'on_event': ['InsertEnter', 'CursorHold'], 'depends': 'denops.vim' })
call dein#add('delphinus/skkeleton_indicator.nvim', {'on_event': ['InsertEnter', 'CursorHold'],
      \ 'hook_post_source': 'lua require"skkeleton_indicator".setup{ eijiText = "AaBb", hiraText = "Hira", kataText = "Kata" }'})

autocmd MyAutoCmd User skkeleton-initialize-pre call skkeleton#config({
    \ 'globalDictionaries': ['~/.skk/SKK-JISYO.L'],
    \ 'keepState': v:true,
    \ 'eggLikeNewline': v:true,
    \ 'immediatelyCancel': v:false,
    \ 'sources': ['skk_dictionary', 'google_japanese_input'],
    \ })
    \ | call skkeleton#register_kanatable('rom', {
    \   "/": ["・", ""],
    \   "~": ["〜", ""],
    \ })
    \ | call skkeleton#register_keymap('henkan', "\<BS>", 'henkanBackward')
    \ | call skkeleton#register_keymap('henkan', "\<C-h>", 'henkanBackward')

autocmd MyAutoCmd ColorScheme * highlight! SkkeletonIndicatorEiji guifg=#88c0d0 gui=bold
autocmd MyAutoCmd ColorScheme * highlight! SkkeletonIndicatorHira guifg=#a3be8c gui=bold
autocmd MyAutoCmd ColorScheme * highlight! SkkeletonIndicatorKata guifg=Orange gui=bold
imap <C-j> <Plug>(skkeleton-toggle)
cmap <C-j> <Plug>(skkeleton-toggle)

"}}}

call dein#add('github/copilot.vim', {'on_event': ['InsertEnter', 'CursorHold']})
let g:copilot_filetypes = #{
  \   gitcommit: v:true,
  \   markdown: v:true,
  \   text: v:true,
  \   yaml: v:true,
  \ }
let g:copilot_node_command = '~/.asdf/shims/node'
imap <D-Bslash> <M-\>
imap <D-]> <M-]>
imap <D-[> <M-[>

call dein#add('tpope/vim-repeat')
call dein#add('tpope/vim-unimpaired')

call dein#add('lambdalisue/fern.vim') "{{{
call dein#add('lambdalisue/fern-hijack.vim')
call dein#add('lambdalisue/fern-git-status.vim')
let g:fern#default_hidden = 1
function! s:init_fern() abort
  setlocal wrap
  nmap <buffer> D <Plug>(fern-action-remove=)y<CR>
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
  nmap <buffer> <Tab> <Plug>(fern-action-mark:toggle)j
  nnoremap <buffer> N N
  call fern#action#call('tcd:root')
endfunction
autocmd MyAutoCmd BufEnter fern://* call s:init_fern()
nnoremap <leader>D <Cmd>Fern -drawer -toggle -reveal=% -width=60 .<CR>
let g:fern#renderer#default#leaf_symbol = ' '
let g:fern#renderer#default#collapsed_symbol = '▸'
let g:fern#renderer#default#expanded_symbol = '▾'
"}}}

call dein#add('editorconfig/editorconfig-vim', {'on_event': 'FileType'})
nnoremap <leader>ss gg=G``

" Switch nvim/vim {{{

function! SetupWilder()
  call wilder#enable_cmdline_enter()
  set nowildmenu
  cmap <expr> <C-n> wilder#in_context() ? wilder#previous() : "\<C-n>"
  cmap <expr> <C-p> wilder#in_context() ? wilder#next() : "\<C-p>"
  call wilder#set_option('modes', [':', '/', '?'])
  call wilder#set_option('pipeline', [wilder#branch([
        \       wilder#check({_, x -> empty(x)}),
        \       wilder#history(),
        \     ],
        \     wilder#cmdline_pipeline(),
        \     wilder#search_pipeline(),
        \   ),
        \ ])
  let l:hl = wilder#make_hl('WilderAccent', 'Pmenu', [{}, {}, {'foreground': '#f4468f'}])
  call wilder#set_option('renderer', wilder#popupmenu_renderer(wilder#popupmenu_border_theme({
      \ 'highlighter': wilder#basic_highlighter(),
      \ 'highlights': {
      \   'border': 'Normal',
      \   'accent': l:hl,
      \ },
      \ 'border': 'rounded',
      \ 'reverse': v:true,
      \ })))
endfunction

if has('nvim')

  call dein#add('ldelossa/buffertag', {'hook_post_source': 'lua require("buffertag").setup({border = "rounded"})'})
  set laststatus=3
  autocmd! FileType fzf set laststatus=0
    \| autocmd BufLeave <buffer> set laststatus=3
  autocmd MyAutoCmd Colorscheme * highlight! VertSplit guibg=bg guifg=#444b71

  call dein#add('Shougo/denite.nvim', { 'on_cmd': 'Denite' })
  call dein#add('gelguy/wilder.nvim', {'on_map': ['/', '?', ':'],
        \ 'hook_post_source': 'call SetupWilder()'})

  call dein#add('NvChad/nvim-colorizer.lua', {'hook_post_source': 'lua require("colorizer").setup()'})

  call dein#add('kevinhwang91/nvim-hlslens', {'depends': ['hop.nvim'],
        \ 'on_map': ['/', '?'],
        \ 'on_event': 'CursorMoved',
        \ 'hook_post_source': 'lua require("hlslens").setup {}'})
  nnoremap n n<Cmd>lua require('hlslens').start()<CR>
  nnoremap N N<Cmd>lua require('hlslens').start()<CR>

  autocmd MyAutoCmd Colorscheme * highlight! link HlSearchNear HopNextKey
  autocmd MyAutoCmd Colorscheme * highlight! link HlSearchLens HopNextKey1
  autocmd MyAutoCmd Colorscheme * highlight! link HlSearchLensNear HopNextKey
  autocmd MyAutoCmd Colorscheme * highlight! link HlSearchFloat HopNextKey1
  autocmd MyAutoCmd Colorscheme * highlight! link Search HopNextKey1

else

  call dein#add('Shougo/denite.nvim', {'on_cmd': 'Denite'})
  call dein#add('gelguy/wilder.nvim', {'on_map': ['/', '?', ':'],
        \ 'hook_post_source': 'call SetupWilder()'})
  call dein#add('roxma/nvim-yarp')
  call dein#add('roxma/vim-hug-neovim-rpc')

  nnoremap n <Plug>(ahc)n
  nnoremap N <Plug>(ahc)N

endif

autocmd MyAutoCmd FileType denite call s:denite_my_settings()
function! s:denite_my_settings() abort
  nnoremap <silent><buffer><expr> <CR>
  \ denite#do_map('do_action')
  nnoremap <silent><buffer><expr> d
  \ denite#do_map('do_action', 'delete')
  nnoremap <silent><buffer><expr> q
  \ denite#do_map('quit')
  nnoremap <silent><buffer><expr> i
  \ denite#do_map('open_filter_buffer')
  nnoremap <silent><buffer><expr> <Tab>
  \ denite#do_map('toggle_select').'j'
endfunction
nnoremap <leader>b <Cmd>Denite buffer -auto-action=preview<CR>
nnoremap <leader>t <Cmd>Denite buffer -input=term:// -auto-action=preview<CR>

"}}}

" LSP{{{

if has('nvim')

function! SetupMasonLspConfig()
lua <<EOF
require('mason-lspconfig').setup_handlers({ function(server)
  local opt = {
    -- Function executed when the LSP server startup
    on_attach = function(client, bufnr)
      -- Mappings.
      -- See `:help vim.lsp.*` for documentation on any of the below functions
      local bufopts = { noremap=true, silent=true, buffer=bufnr }
      vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, bufopts)
      vim.keymap.set('n', ']d', vim.diagnostic.goto_next, bufopts)
      vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, bufopts)
      vim.keymap.set('n', '<leader>dd', vim.diagnostic.setloclist, bufopts)
      vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
      vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
      vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
      vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
      vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
      vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
      vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
      vim.keymap.set('n', '<space>wl', function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
      end, bufopts)
      vim.keymap.set('n', '<space>gt', vim.lsp.buf.type_definition, bufopts)
      vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
      vim.keymap.set('n', '<space>A', vim.lsp.buf.code_action, bufopts)
      vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
      local non_lsp_fmt = { python=true, typescript=true }
      if vim.lsp.buf.formatting and not non_lsp_fmt[vim.bo.filetype] then
        vim.keymap.set('n', '<space>ss', vim.lsp.buf.formatting, bufopts)
      end

      -- trouble.nvim
      vim.keymap.set("n", "<leader>xx", "<cmd>TroubleToggle<cr>",
        {silent = true, noremap = true}
      )
      vim.keymap.set("n", "<leader>xw", "<cmd>TroubleToggle workspace_diagnostics<cr>",
        {silent = true, noremap = true}
      )
      vim.keymap.set("n", "<leader>xd", "<cmd>TroubleToggle document_diagnostics<cr>",
        {silent = true, noremap = true}
      )
      vim.keymap.set("n", "<leader>xl", "<cmd>TroubleToggle loclist<cr>",
        {silent = true, noremap = true}
      )
      vim.keymap.set("n", "<leader>xq", "<cmd>TroubleToggle quickfix<cr>",
        {silent = true, noremap = true}
      )
      vim.keymap.set("n", "gR", "<cmd>TroubleToggle lsp_references<cr>",
        {silent = true, noremap = true}
      )
    end,
    capabilities = require('cmp_nvim_lsp').default_capabilities(
      vim.lsp.protocol.make_client_capabilities()
    )
  }
  require('lspconfig')[server].setup(opt)

  vim.diagnostic.config({
    virtual_text = false,
    float = {
      border = "single",
      scope = "cursor",
    },
  })
end })
EOF
endfunction

autocmd MyAutoCmd CursorHold * lua vim.diagnostic.open_float(nil, { focusable = false })

function! SetupNvimCmp()
lua <<EOF
-- 3. completion (hrsh7th/nvim-cmp)
local cmp = require("cmp")
local lspkind = require('lspkind')
cmp.setup({
  formatting = {
    format = lspkind.cmp_format {
      mode = 'symbol_text',
      maxwidth = 50,
    },
  },
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  sources = {
    { name = "nvim_lsp" },
    { name = "skkeleton" },
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-p>"] = cmp.mapping.select_prev_item(),
    ["<C-n>"] = cmp.mapping.select_next_item(),
    ['<C-l>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ["<CR>"] = cmp.mapping.confirm { select = true },
  }),
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
})
EOF
endfunction

" For LSP line float diagnostics, this fixes the problem of untriggered CursorHold event
call dein#add('antoinemadec/FixCursorHold.nvim')
let g:cursorhold_updatetime = 250
call dein#add('https://git.sr.ht/~whynothugo/lsp_lines.nvim',
      \ {'hook_post_source': 'lua require("lsp_lines").setup()'})
call dein#add('kyazdani42/nvim-web-devicons')
call dein#add('folke/trouble.nvim', {'hook_post_source': 'lua require("trouble").setup()'})
call dein#add('j-hui/fidget.nvim', {'hook_post_source': 'lua require("fidget").setup()'})
call dein#add('neovim/nvim-lspconfig')
call dein#add('williamboman/mason.nvim', {'hook_post_source': 'lua require("mason").setup()'})
call dein#add('williamboman/mason-lspconfig.nvim', {'hook_post_source': 'call SetupMasonLspConfig()'})
call dein#add('onsails/lspkind.nvim')
call dein#add('hrsh7th/nvim-cmp', {'hook_post_source': 'call SetupNvimCmp()'})
call dein#add('rinx/cmp-skkeleton')
call dein#add('hrsh7th/cmp-nvim-lsp')
call dein#add('hrsh7th/vim-vsnip')
autocmd MyAutoCmd VimEnter * call dein#call_hook('post_source')

lua <<EOF
vim.fn.sign_define(
  'DiagnosticSignError',
  { texthl = 'DiagnosticSignError', text = ' ●', numhl = 'DiagnosticSignError' }
)
vim.fn.sign_define(
  'DiagnosticSignWarn',
  { texthl = 'DiagnosticSignWarn', text = ' ●', numhl = 'DiagnosticSignWarn' }
)
vim.fn.sign_define(
  'DiagnosticSignHint',
  { texthl = 'DiagnosticSignHint', text = ' ●', numhl = 'DiagnosticSignHint' }
)
vim.fn.sign_define(
  'DiagnosticSignInfo',
  { texthl = 'DiagnosticSignInfo', text = ' ●', numhl = 'DiagnosticSignInfo' }
)
EOF

else

call dein#add('prabirshrestha/asyncomplete.vim', {'on_event': ['InsertEnter', 'CursorHold']})
call dein#add('prabirshrestha/asyncomplete-lsp.vim', {'on_event': ['InsertEnter', 'CursorHold']})
call dein#add('prabirshrestha/vim-lsp')
call dein#add('mattn/vim-lsp-settings')
autocmd MyAutoCmd ColorScheme * highlight! link LspErrorHighlight Error
autocmd MyAutoCmd ColorScheme * highlight! link LspWarningHighlight DiagnosticWarn
autocmd MyAutoCmd ColorScheme * highlight! link LspInformationHighlight DiagnosticInfo
autocmd MyAutoCmd ColorScheme * highlight! link LspHintHighlight DiagnosticHint
function! s:on_lsp_buffer_enabled() abort
  setlocal omnifunc=lsp#complete
  if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
  nmap <buffer> gd <Plug>(ahc)<Plug>(lsp-definition)
  nmap <buffer> gs <Plug>(ahc)<Plug>(lsp-document-symbol-search)
  nmap <buffer> gS <Plug>(ahc)<Plug>(lsp-workspace-symbol-search)
  nmap <buffer> gr <Plug>(ahc)<Plug>(lsp-references)
  nmap <buffer> gi <Plug>(ahc)<Plug>(lsp-implementation)
  nmap <buffer> <leader>rn <Plug>(ahc)<Plug>(lsp-rename)
  nmap <buffer> K <Plug>(ahc)<Plug>(lsp-hover)
  nmap <buffer> <leader>dd <Plug>(ahc)<Cmd>LspDocumentDiagnostic<CR>
  nmap <buffer> <leader>da <Plug>(ahc)<Cmd>LspDocumentDiagnostic --buffers=*<CR>
  nnoremap <buffer> <expr><c-j> lsp#scroll(+4)
  nnoremap <buffer> <expr><c-k> lsp#scroll(-4)
  nnoremap <buffer> <leader>A <Plug>(ahc)<Plug>(lsp-code-action)

  let g:lsp_format_sync_timeout = 1000
  if &ft == 'sql'
    nmap <buffer> <leader>ss <Cmd>LspDocumentFormatSync<CR>
  endif
  if &ft == 'rust' || &ft == 'go' || &ft == 'dart' || matchstr(&ft, 'typescript*') != ''
    nmap <buffer> <leader>ss <Cmd>LspDocumentFormatSync<CR><Cmd>LspCodeAction source.organizeImports<CR>
  endif

  let g:lsp_settings = {
        \   'pyls-all': { 'workspace_config': { 'pyls': { 'configurationSources': ['flake8'] } } }
        \ }
endfunction
" call s:on_lsp_buffer_enabled only for languages that has the server registered.
autocmd MyAutoCmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
if !executable('texlab')
  autocmd MyAutoCmd User lsp_setup call lsp#register_server({
        \ 'name': 'texlab',
        \ 'cmd': {server_info->['texlab']},
        \ 'whitelist': ['tex', 'bib', 'sty'],
        \ })
endif
let g:lsp_debug_servers = 1
autocmd MyAutoCmd User lsp_setup call lsp#register_server({
      \ 'name': 'efm-langserver',
      \ 'cmd': {server_info->[&shell, &shellcmdflag, 'efm-langserver 2> /tmp/ok.log']},
      \ 'whitelist': ['sql'],
      \ })

endif

autocmd MyAutoCmd FileType python nnoremap <buffer> <leader>ss <Cmd>%!black -q -<CR><Plug>(ahc)<Cmd>%!isort -<CR>
call dein#add('hashivim/vim-terraform', {'on_ft': 'terraform'})

"}}}

call dein#add('farmergreg/vim-lastplace')

call dein#add('itchyny/lightline.vim') "{{{
set showtabline=2
function! LightlineGit()
  return FugitiveStatusline() . gina#component#traffic#preset("fancy")
endfunction
let g:lightline = {
      \   'active': {
      \     'left': [],
      \     'right': [],
      \    },
      \   'inactive': { 'right': [] },
      \   'component_function': { 'git': 'LightlineGit' },
      \   'separator': { 'left': '', 'right': '' },
      \   'subseparator': { 'left': '', 'right': '' },
      \ }
let g:lightline.tabline = { 'left': [ [ 'tabs', 'git' ] ], 'right': [] }
let g:lightline.tab = {
      \ 'active': [ 'modified', 'filename' ],
      \ 'inactive': [  'modified', 'filename' ] }
function! LightlineModified(n)
  let winnr = tabpagewinnr(a:n)
  if gettabwinvar(a:n, winnr, '&modified')
    return '+'
  endif
  if gettabwinvar(a:n, winnr, '&modifiable')
    return ''
  endif
	return '-'
endfunction
let g:lightline.tab_component_function = {
      \ 'modified': 'LightlineModified',
      \ }
"}}}


call dein#add('sjl/gundo.vim', { 'on_cmd': 'Gundo' })"{{{
let g:gundo_prefer_python3 = 1
nnoremap <leader>u <Cmd>GundoToggle<CR>
if has("persistent_undo")
  if !isdirectory($HOME."/.vim/undo-dir")
    call mkdir($HOME."/.vim/undo-dir", "p", 0700)
  endif
  set undodir=~/.vim/undo-dir
  set undofile
endif
"}}}

call dein#add('vim-jp/vimdoc-ja', {'on_event': 'CmdlineEnter'})

call dein#add('junegunn/goyo.vim', { 'on_cmd': 'Goyo' })"{{{
nnoremap <silent> <leader>go <Cmd>Goyo<CR>
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
  " set relativenumber
endif
"}}}

" Git related settings{{{

function! GetTicket()
    let l:branch = system('git branch --show-current 2>/dev/null')
    let l:branch = substitute(l:branch, '\n', '', 'g') " 改行を削除
    if l:branch =~# '^[A-Z]\+-[0-9]\+$'
        return l:branch . ': '
    else
        return 'NO-ISSUE: '
    endif
endfunction
inoremap <C-t> <C-r>=GetTicket()<CR>

nnoremap [git] <Nop>
nmap <leader>g [git]

nnoremap [git]g <Cmd>silent! wa!<CR><Cmd>tabnew<CR><Cmd>terminal lazygit<CR>

if has('nvim')
  call dein#add('melkster/modicator.nvim', {'hook_post_source': 'lua require("modicator").setup()'})

  call dein#add('lewis6991/gitsigns.nvim', {'on_event': 'VimEnter', 'hook_post_source': 'lua require("gitsigns").setup {}'})
  nmap [c <Plug>(ahc)<Cmd>Gitsigns prev_hunk<CR>
  nmap ]c <Plug>(ahc)<Cmd>Gitsigns next_hunk<CR>
  nmap <leader>hs <Cmd>Gitsigns stage_hunk<CR>
  vmap <leader>hs :Gitsigns stage_hunk<CR>
  nmap <leader>hu <Cmd>Gitsigns undo_stage_hunk<CR>
  vmap <leader>hu :Gitsigns undo_stage_hunk<CR>
  nmap <leader>hr <Cmd>Gitsigns reset_hunk<CR>
  vmap <leader>hr <Cmd>Gitsigns reset_hunk<CR>

  " Clear search result on <C-l>
  " Use : instead of <Cmd> to clear nvim-hlslens
  nnoremap <silent> <C-l> :nohlsearch<CR><Cmd>Gitsigns refresh<CR><C-l>
else
  call dein#add('airblade/vim-gitgutter')
  nmap [c <Plug>(ahc)<Plug>(GitGutterPrevHunk)
  nmap ]c <Plug>(ahc)<Plug>(GitGutterNextHunk)
  " Clear search result on <C-l>
  nnoremap <silent> <C-l> <Cmd>nohlsearch<CR><Cmd>GitGutter<CR><C-l>
endif

call dein#add('tpope/vim-fugitive')
nnoremap [git]c <Plug>(ahc)<Cmd>Git commit<CR>

call dein#add('lambdalisue/gina.vim', {'on_cmd': 'Gina',
      \ 'hook_post_source': 'call gina#custom#command#option("log", "--opener", "tabedit")'})
set diffopt+=vertical
let g:gina#action#index#discard_directories = 1
nnoremap [git]p <Plug>(ahc)<Cmd>Gina pull<CR>
nnoremap [git]P <Plug>(ahc)<Cmd>Gina push<CR>
nnoremap [git]l <Cmd>Gina log<CR>
" Enable spell check only in git commit
set spelllang+=cjk
autocmd MyAutoCmd FileType gitcommit setlocal spell
autocmd MyAutoCmd FileType gitcommit setlocal bufhidden=delete

"}}}

" For neovide
" call dein#add('psliwka/vim-smoothie', {'on_map': ['<C-u>', '<C-d>']})

call dein#add('thinca/vim-qfreplace', {'on_cmd': 'Qfreplace'})

" fzf{{{

call dein#add('junegunn/fzf.vim')
call dein#add('junegunn/fzf', { 'build': './install --all', 'merged': 0 })
imap <c-x><c-k> <plug>(fzf-complete-word)
imap <c-x><c-f> <plug>(fzf-complete-path)
" Relative path
" https://github.com/junegunn/fzf.vim/pull/628#issuecomment-766440334
inoremap <expr> <c-x><c-p> fzf#vim#complete("fd --hidden --exclude '.git' --exclude 'node_modules' --absolute-path --print0
      \ <Bar> xargs -0 realpath --relative-to " . shellescape(expand("%:p:h")) . " <Bar> sort -r")
imap <c-x><c-j> <Plug>(fzf-complete-file-ag)
imap <c-x><c-l> <Plug>(fzf-complete-line)
call dein#add('yuki-yano/fzf-preview.vim', { 'rev': 'release/rpc' })
call dein#add('LeafCage/yankround.vim')
noremap <leader>h <Cmd>History<CR>
noremap <leader><leader> <Cmd>FzfPreviewCommandPaletteRpc<CR>
noremap <leader>m <Cmd>FzfPreviewProjectMruFilesRpc<CR>
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
nnoremap <leader>gr <Cmd>Repo<CR>

let rg_command = 'rg --hidden --column --line-number --no-heading --color=always --smart-case --glob "!.git" --glob "!node_modules" --glob "!vendor" -- '
command! -bang -nargs=* Rg
      \ call fzf#vim#grep(
      \   rg_command.shellescape(<q-args>), 1,
      \   fzf#vim#with_preview(), <bang>0)
nnoremap <leader>f <Cmd>Rg<CR>
nnoremap <leader>p <Cmd>Files<CR>
call dein#add('voldikss/vim-floaterm')
" skk使えない → ローマ字で書けば補完される
" Floaterm 依存 → fzf の s:execute が非公開なので。。
nnoremap <leader>G <Cmd>FloatermNew google<CR>

"}}}

call dein#add('vimwiki/vimwiki') "{{{
let g:vimwiki_key_mappings =
  \ {
  \   'all_maps': 0,
  \   'global': 0,
  \   'headers': 0,
  \   'text_objs': 0,
  \   'table_format': 0,
  \   'table_mappings': 0,
  \   'lists': 0,
  \   'links': 1,
  \   'html': 0,
  \   'mouse': 0,
  \ }
let g:vimwiki_menu = '' " To disable No menu Vimwiki error
"}}}

call dein#add('cocopon/iceberg.vim')

"}}}

" Initialize plugin system
call dein#end()
"}}}

" Colorscheme, plugin読み込み後に{{{

autocmd MyAutoCmd ColorScheme * highlight! Visual ctermbg=236 guibg=#363d5c
autocmd MyAutoCmd ColorScheme * highlight! Pmenu None
autocmd MyAutoCmd ColorScheme * highlight! PmenuSel guifg=black guibg=gray ctermfg=black ctermbg=gray
autocmd MyAutoCmd ColorScheme * highlight! CursorLIne cterm=None ctermbg=241 ctermfg=None guibg=None guifg=None
autocmd MyAutoCmd ColorScheme * highlight! LineNr guibg=None ctermbg=None
autocmd MyAutoCmd ColorScheme * highlight! SignColumn guibg=None ctermbg=None

if $TERM_PROGRAM == 'Apple_Terminal'
  set notermguicolors
else
  set termguicolors
  autocmd MyAutoCmd ColorScheme * highlight! Normal guibg=NONE ctermbg=NONE
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

"{{{VSCode以外の共通標準設定

autocmd MyAutoCmd FileType qf setlocal wrap

" Create dir if not exists when writing new file.
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
map <leader>, <Cmd>OpenVimrc<CR>
function! DeinInstall()
  call map(dein#check_clean(), { _, val -> delete(val, 'rf') })
  call dein#recache_runtimepath()
  if dein#check_install()
    call dein#install()
  endif
  call dein#source()
  if has('nvim')
    call dein#remote_plugins()
  endif
endfunction
autocmd MyAutoCmd BufWritePost .vimrc ++nested source $MYVIMRC
nnoremap <expr><leader>r DeinInstall()
nnoremap <leader>du <Cmd>call dein#update()<CR><Cmd>call dein#remote_plugins()<CR>

"}}}

" Quit all read only buffers with q{{{

nnoremap <expr> q (&modifiable && !&readonly ? 'q' : ':close!<CR>')

"}}}

" Help vertical{{{

autocmd BufEnter *.txt if &buftype == 'help' | wincmd L | endif

"}}}

" ターミナル移動{{{
" Comment out after " for automatically startinsert
autocmd BufWinEnter,WinEnter term://* startinsert

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

nnoremap <leader>T <Cmd>botright vsplit<CR><Cmd>terminal<CR>

"}}}

" Vim と Neovim の分岐設定{{{

if has('nvim')
  autocmd MyAutoCmd termopen * startinsert
  autocmd MyAutoCmd termopen * setlocal nonumber norelativenumber signcolumn=no
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

  set winblend=30
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
  let g:neovide_input_macos_option_key_is_meta=v:true

  " 複数タブがあれば、タブを消し、タブが一つであれば終了する
  nnoremap <expr> <D-w> tabpagenr('$')-1 ? "<Cmd>tabclose<CR>" : "<Cmd>silent! wa<CR><Cmd>bdelete!<CR><Cmd>%bdelete<CR><Cmd>quit<CR>"
  autocmd MyAutoCmd termopen * nnoremap <buffer> <D-w> i<C-u>exit<CR>
  tnoremap <D-w> <C-u>exit<CR>

  " copy
  vnoremap <D-c> "+y

  " paste
  nnoremap <D-v> p
  set pastetoggle=<F3>
  inoremap <D-v> <C-r><F3><C-r>+<C-r><F3>
  cnoremap <D-v> <C-r>+
  tnoremap <D-v> <C-\><C-n>pi

  " undo
  nnoremap <D-z> u
  inoremap <D-z> <Esc>ua

  let g:neovide_remember_window_size = v:true
  let g:neovide_cursor_vfx_mode = "railgun"

  " font size
  let g:gui_font_size = 14
  function! ResizeFont(delta)
    let g:gui_font_size = g:gui_font_size + a:delta
    execute('set guifont=Menlo:h'.g:gui_font_size)
  endfunction
  noremap <D-=> <Cmd>call ResizeFont(1)<CR>
  noremap <D--> <Cmd>call ResizeFont(-1)<CR>

  " transparency
  let g:neovide_transparency=0.8
  function! ChangeTransparency(delta)
    let g:neovide_transparency = g:neovide_transparency + a:delta
  endfunction
  noremap <D-]> <Cmd>call ChangeTransparency(0.01)<CR>
  noremap <D-[> <Cmd>call ChangeTransparency(-0.01)<CR>

  tnoremap <C-CR> <CR>
  tnoremap <S-BS> <BS>
  tnoremap <C-BS> <BS>
  tnoremap <C-Tab> <Tab>

  " Redraw on startup to apply transparency
  autocmd MyAutoCmd VimEnter * call timer_start(200, { id -> ResizeFont(0)}, { 'repeat': 5 })
  autocmd MyAutoCmd VimEnter * call timer_start(200, { tid -> execute('NeovideFocus') })
  autocmd MyAutoCmd VimEnter * call timer_start(200, { tid -> execute('source $MYVIMRC') })

  " New window
  noremap <D-n> <Cmd>!neovide --maximized<CR><CR>
endif

"}}}

"{{{ 最後に反映したい共通設定

" プラグインの影響を受け易いので最後に
" コメントを自動挿入しない
autocmd MyAutoCmd BufEnter * setlocal formatoptions-=c
      \ | setlocal formatoptions-=r
      \ | setlocal formatoptions-=o

"}}}
