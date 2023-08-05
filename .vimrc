if &encoding !=? 'utf-8'
  let &termencoding = &encoding
  set encoding=utf-8
endif

scriptencoding utf-8

if has('guess_encode')
  set fileencodings=ucs-bom,utf-8,iso-2022-jp,guess,euc-jp,cp932,latin1
else
  set fileencodings=ucs-bom,utf-8,iso-2022-jp,euc-jp,cp932,latin1
endif
set fileformats=unix,dos

" dein.vim
let s:dein_dir = expand('~/.vim/dein')
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'

" clone dein.vim when not having installed dein.vim
if &runtimepath !~# '/dein.vim'
  if !isdirectory(s:dein_repo_dir)
    execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_dir
  endif
  execute 'set runtimepath^=' . fnamemodify(s:dein_repo_dir, ':p')
endif

if dein#load_state(s:dein_dir)
  call dein#begin(s:dein_dir, [expand('~/.vimrc')])
  " Set directories for dein.toml and dein_lazy.toml
  let s:toml_dir = expand('~/.vim/rc')
  call dein#load_toml(s:toml_dir . '/dein.toml', {'lazy': 0})
  call dein#load_toml(s:toml_dir . '/dein_lazy.toml', {'lazy': 1})
  call dein#end()
  call dein#save_state()
endif

filetype plugin indent on
syntax enable

" If you want to install not installed plugins on startup.
if dein#check_install()
  call dein#install()
endif


" ddc.vim
call ddc#custom#patch_global('ui', 'native')
call ddc#custom#patch_global('sources', [
\   'around', 'buffer', 'file', 'skkeleton', 'vim-lsp'
\ ])
call ddc#custom#patch_global('sourceOptions', {
\   'around': {'mark': 'arnd'},
\   'buffer': {'mark': 'buf'},
\   'file': {
\     'mark': 'file',
\     'isVolatile': v:true,
\     'forceCompletionPattern': '\S/\S*',
\   },
\   'skkeleton': {
\     'mark': 'skk',
\     'matchers': ['skkeleton'],
\     'sorters': [],
\     'minAutoCompleteLength': 2,
\   },
\   'vim-lsp': {'mark': 'lsp'},
\   '_': {
\     'matchers': ['matcher_fuzzy', 'matcher_head'],
\     'sorters': ['sorter_fuzzy'],
\     'converters': ['converter_fuzzy'],
\   },
\ })


call ddc#custom#patch_global('sourceParams', {
\   'around': {'maxSize': 500},
\   'buffer': {
\     'requireSameFiletype': v:false,
\     'limitBytes': 5000000,
\     'fromAltBuf': v:true,
\     'forceCollect': v:true,
\   },
\ })

call ddc#custom#patch_filetype(['ps1', 'dosbatch', 'autohotkey', 'registry'], {
\   'sourceOptions': {
\     'file': {
\       'forceCompletionPattern': '\S\\\S*',
\     },
\   },
\   'sourceParams': {
\     'file': {
\       'mode': 'win32',
\     },
\   },
\ })

call ddc#enable()


" ddu.vim
call ddu#custom#patch_global({
\   'ui': 'filer',
\   'sources': [{'name': 'file', 'params': {}}],
\   'actionOptions': {
\     'narrow': {
\       'quit': v:false,
\     },
\   },
\   'sourceOptions': {
\     '_': {
\       'columns': ['filename'],
\     },
\   },
\   'kindOptions': {
\     'file': {
\       'defaultAction': 'open',
\     },
\   }
\ })

autocmd FileType ddu-filer call s:ddu_my_settings()
function! s:ddu_my_settings() abort
  nnoremap <buffer><silent> <CR>
  \       <Cmd>call ddu#ui#filer#do_action('itemAction')<CR>
  nnoremap <buffer><silent> <Space>
  \       <Cmd>call ddu#ui#filer#do_action('toggleSelectItem')<CR>
  nnoremap <buffer> o
  \       <Cmd>call ddu#ui#filer#do_action('expandItem',
  \       {'mode': 'toggle'})<CR>
  nnoremap <buffer><silent> q
  \       <Cmd>call ddu#ui#filer#do_action('quit')<CR>
endfunction


let mapleader = "\<Space>"

colorscheme desert
set ruler
set showcmd
set shortmess-=S
set smartindent
set display=lastline
set backspace=indent,eol,start
set nofixeol
set ignorecase
set smartcase
set tabpagemax=255
set whichwrap=b,s,h,l,<,>,[,]
set number
set list
set listchars=tab:>-,extends:<,trail:-
set hlsearch
set incsearch
set expandtab
set shiftwidth=2
set matchpairs+=<:>,「:」,（:）,『:』,【:】,《:》,〈:〉,｛:｝,［:］,【:】,‘:’,“:”
set autochdir
set spell
set spelllang& spelllang+=cjk
set spelloptions& spelloptions+=camel
set formatoptions+=M
set nrformats+=unsigned
set scrolloff=5

nnoremap <leader>s <Cmd>setlocal spell! spell?<CR>
nnoremap <leader>F <Cmd>call ddu#start({})<CR>
nnoremap <leader>D <Cmd>call dein#update()<CR>
nnoremap <leader>w :ShakyoClue<CR>
nnoremap <leader>f :Files<CR>
runtime ftplugin/man.vim

inoremap <silent> jj <ESC>
inoremap <silent> ｊｊ <ESC>
cnoremap jj <ESC>
vnoremap < <gv
vnoremap > >gv

noremap  <C-Tab>   :tabnext<CR>
noremap  <S-C-Tab> :tabprevious<CR>
noremap  <C-Right> :tabnext<CR>
noremap  <C-Left>  :tabprevious<CR>
noremap  <C-Down>  :q<CR>
tnoremap <C-Tab>   <C-w>gt<CR>:f<CR>
tnoremap <S-C-Tab> <C-w>gT<CR>:f<CR>
noremap  gr        :tabnext<CR>
noremap  gR        :tabprevious<CR>

nnoremap <leader>h <C-6>
nnoremap <C-L> :noh<CR><C-L>
" nnoremap <C-L> :noh<CR><C-L>:call setline(1, getline(1, '$'))<CR>
nnoremap * *``zz
nnoremap # #``zz

nnoremap <leader>m <Plug>(MatchitNormalForward)
vnoremap <leader>m <Plug>(MatchitVisualForward)
nnoremap <leader>q <Plug>(socrates-greed)

" vim-sandwich
let g:sandwich_no_default_key_mappings = 1
nmap <leader>a  <Plug>(sandwich-add)
xmap <leader>a  <Plug>(sandwich-add)
omap <leader>a  <Plug>(sandwich-add)
nmap <leader>d  <Plug>(sandwich-delete)
xmap <leader>d  <Plug>(sandwich-delete)
nmap <leader>db <Plug>(sandwich-delete-auto)
nmap <leader>r  <Plug>(sandwich-replace)
xmap <leader>r  <Plug>(sandwich-replace)
nmap <leader>rb <Plug>(sandwich-replace-auto)


noremap  j gj
noremap gj  j
noremap  k gk
noremap gk  k
nnoremap <Up>   gk
nnoremap <Down> gj
inoremap <Up>   <C-O>gk
inoremap <Down> <C-O>gj

inoremap <Tab>   <C-N>
inoremap <S-Tab> <C-P>

nnoremap <expr> n (v:searchforward ? 'n' : 'N')
nnoremap <expr> N (v:searchforward ? 'N' : 'n')

" Change the size of windows
nnoremap <S-Left>  <C-W><<CR>
nnoremap <S-Right> <C-W>><CR>
nnoremap <S-Up>    <C-W>-<CR>
nnoremap <S-Down>  <C-W>+<CR>

" Not yank when using x, X, or s in normal mode
nnoremap x "_x
nnoremap X "_X
nnoremap s "_s

nnoremap Y y$
nnoremap / /\v
nnoremap <C-G>  2<C-G>
nnoremap 2<C-G> <C-G>

nnoremap mm mQ
nnoremap mk `Q

" Change cursors according with mode
let &t_ti .= "\e[1 q"
let &t_SI .= "\e[5 q"
let &t_EI .= "\e[1 q"
let &t_te .= "\e[0 q"

" Enable bracketed-paste
if &term =~ 'screen'
  let &t_BE = "\e[?2004h"
  let &t_BD = "\e[?2004l"
  exec "set t_PS=\e[200~"
  exec "set t_PE=\e[201~"
endif

" Set the indent inside the p tags
let g:html_indent_inctags = 'p'

" Auto completion to close XML tags
augroup MyXML
  autocmd!
  autocmd Filetype html,xml inoremap <buffer> </ </<C-X><C-O><C-O><CR><ESC>==o
augroup END

command -nargs=0 ClearUndo call <sid>ClearUndo()
function! s:ClearUndo()
  let old_undolevels = &undolevels
  set undolevels=-1
  execute "normal! a \<BS>\<Esc>"
  let &undolevels = old_undolevels
  unlet old_undolevels
endfunction


function! s:on_lsp_buffer_enabled() abort
  setlocal omnifunc=lsp#complete
  setlocal signcolumn=yes
  nmap <buffer> gd <plug>(lsp-definition)
  nmap <buffer> <f2> <plug>(lsp-rename)
  " inoremap <expr> <CR> pumvisible() ? "\<C-Y>\<CR>" : "\<CR>"
endfunction

augroup lsp_install
  au!
  autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END

command! LspDebug let lsp_log_verbose=1 | let lsp_log_file = expand('~/lsp.log')
let g:lsp_diagnostics_enabled = 1
let g:lsp_diagnostics_virtual_text_enabled = v:false
let g:lsp_diagnostics_echo_cursor = 1
let g:asyncomplete_auto_popup = 1
let g:asyncomplete_auto_completeopt = 1
let g:asyncomplete_popup_delay = 200
let g:lsp_text_edit_enabled = 1
let g:lsp_settings_filetype_ruby = 'solargraph'


" Display results on the upper side with denite
let g:fzf_layout = { 'up': '~40%' }

" Search tags with <C-]>
nnoremap <silent> <C-]> :call fzf#vim#tags(expand('<cword>'))<CR>

" Make it possible to jump from fzf to the file
let g:fzf_buffers_jump = 1

" Specify a user snippet directory
let g:vsnip_snippet_dir = expand('~/.vim/vsnip')

" Define a skk dictionary
call skkeleton#azik#add_table('us')
call skkeleton#config({
\   'globalDictionaries': [
\     ['~/.skk/SKK-JISYO.L', 'euc-jp'],
\     ['~/.skk/SKK-JISYO.geo', 'euc-jp'],
\     ['~/.skk/SKK-JISYO.jinmei', 'euc-jp'],
\     ['~/.skk/SKK-JISYO.propernoun', 'euc-jp'],
\     ['~/.skk/SKK-JISYO.station', 'euc-jp'],
\     ['~/.skk/SKK-JISYO.emoji.utf8', 'utf-8'],
\     ['~/.skk/zipcode/SKK-JISYO.zipcode', 'euc-jp']
\   ],
\   'kanaTable': 'azik',
\   'eggLikeNewline': v:true,
\   'keepState': v:true,
\   'markerHenkan': 'γ',
\   'markerHenkanSelect': 'Γ',
\   'registerConvertResult': v:true,
\   'showCandidatesCount': 1,
\   'selectCandidateKeys': '12345qw',
\ })

call skkeleton#register_keymap('input', ';', 'henkanPoint')
augroup Skkeleton
  autocmd!
  autocmd InsertEnter * call skkeleton#register_kanatable('azik', {
    \   'jj': 'escape',
    \   ':': 'zenkaku',
    \   'q': 'katakana',
    \   '<s-q>': 'hankatakana',
    \   "'":  ["'", ''],
    \   'z~':  ['～', ''],
    \   'l':  ['っ', ''],
    \   'xi':  ['し', ''],
    \   'ci':  ['ち', ''],
    \   'xxa':  ['ぁ', ''],
    \   'xxi':  ['ぃ', ''],
    \   'xxu':  ['ぅ', ''],
    \   'xxe':  ['ぇ', ''],
    \   'xxo':  ['ぉ', ''],
    \   'xxya':  ['ゃ', ''],
    \   'xxyu':  ['ゅ', ''],
    \   'xxyo':  ['ょ', ''],
    \   'xxwa':  ['ゎ', ''],
    \   'tsa': ['つゃ', ''],
    \   'tsi': ['つぃ', ''],
    \   'tsu': ['つ', ''],
    \   'tse': ['つぇ', ''],
    \   'tso': ['つぉ', ''],
    \ })
  autocmd User skkeleton-enable-post lnoremap <buffer> <S-L>
  \ <Cmd>call skkeleton#handle('handleKey', {'key': ';'})<CR>
  \ <Cmd>call skkeleton#handle('handleKey', {'key': 'l'})<CR>
  autocmd User skkeleton-disable-post lunmap <buffer> <S-L>
augroup END

imap <C-J> <Plug>(skkeleton-toggle)
cmap <C-J> <Plug>(skkeleton-toggle)

" dps-dial.vim
" Define original sequences for dps_dial
let g:dps_dial#augends = [
\   'decimal',
\   'date-hyphen',
\   'date-slash',
\   {'kind': 'constant', 'opts': {'elements': ['true', 'false']}},
\   {'kind': 'constant', 'opts': {
\     'elements': ['月', '火', '水', '木', '金', '土', '日'],
\     'cyclic': v:true,
\     'word': v:false,
\   }},
\   {'kind': 'constant', 'opts': {
\     'elements': ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
\     'cyclic': v:true,
\     'word': v:true,
\   }},
\   {'kind': 'case', 'opts': {
\     'cases': ['camelCase', 'snake_case', 'SCREAMING_SNAKE_CASE'],
\     'cyclic': v:true,
\   }},
\   {'kind': 'date', 'opts': { 'format': 'yyyy-MM-dd', 'only_valid': v:false }},
\ ]

nnoremap  <C-A>  <Plug>(dps-dial-increment)
nmap      <C-X>  <Plug>(dps-dial-decrement)
xnoremap  <C-A>  <Plug>(dps-dial-increment)
xmap      <C-X>  <Plug>(dps-dial-decrement)
xnoremap g<C-A> g<Plug>(dps-dial-increment)
xmap     g<C-X> g<Plug>(dps-dial-decrement)

" kensaku.vim/kensaku-search.vim
cnoremap JJ <Plug>(kensaku-search-replace)<CR>

" capture.vim
cnoremap <C-C> <Home>Capture <CR>

" Open automatically quickfix-window after excuting grep like commands
autocmd QuickFixCmdPost *grep* cwindow

command! Vimrc :tabnew ~/.vimrc
command! Srrc  :source ~/.vimrc
command! DeinTOML :tabnew ~/.vim/rc/dein.toml|:tabnew ~/.vim/rc/dein_lazy.toml
cabbr w!! w !sudo tee > /dev/null %
cabbr h tab :help
cabbr encto edit ++encoding=
cabbr qaa tabdo windo if !&modified \| close \| endif

" Yank
" set clipboard=exclude:.*
nnoremap <silent> p      <Cmd>call setreg('"', system('wl-paste -n'))<CR>""p
nnoremap <silent> P      <Cmd>call setreg('"', system('wl-paste -n'))<CR>""P
xnoremap <silent> p      <Cmd>call setreg('"', system('wl-paste -n'))<CR>""P
xnoremap <silent> P      <Cmd>call setreg('"', system('wl-paste -n'))<CR>""p
cnoremap <C-R>"          <Cmd>call setreg('"', system('wl-paste -n'))<CR><C-R>"<Cmd>redraw!<CR>
inoremap <silent> <C-R>" <C-O><Cmd>call setreg('"', system('wl-paste -n'))<CR><C-R>"
nnoremap <silent> R <Plug>(operator-replace)
xnoremap <silent> R <Plug>(operator-replace)
nnoremap <silent> RR R

set clipboard^=unnamed
augroup LazyClipboardSetup
  autocmd!
  autocmd TextYankPost * silent call job_start(['wl-copy', getreg('*')])
  " autocmd CursorHold,CursorMoved * ++once call serverlist() | set clipboard^=unnamed
augroup END

" Yank for WSL2
function! IsWSL()
  if has('unix')
    let lines = readfile('/proc/version')
    if lines[0] =~ 'Microsoft'
      return 1
    endif
  endif
  return 0
endfunction

if IsWSL()
  augroup Yank
      autocmd!
      autocmd TextYankPost * silent call job_start(['win32yank.exe', '-i', ' --crlf', getreg('"')])
  augroup END
  nnoremap <silent> p :call setreg('"',system('win32yank.exe -o --lf'))<CR>""p
  nnoremap <silent> P :call setreg('"',system('win32yank.exe -o --lf'))<CR>""P
  let g:previm_open_cmd = '/mnt/c/PROGRA~2/Google/Chrome/Application/chrome.exe'
  let g:previm_wsl_mode = 1
endif

" DeepL
let g:deepl#endpoint = "https://api-free.deepl.com/v2/translate"
let g:deepl#auth_key = ""

" replace a visual selection
" vmap tle <Cmd>call deepl#v("EN")<CR>
vmap tlj <Cmd>call deepl#v("JA")<CR><ESC>

" translate a current line and display on a new line
" nmap tle yypV<Cmd>call deepl#v("EN")<CR>
nmap tlj yypV<Cmd>call deepl#v("JA")<CR><ESC>


if filereadable(expand('~/.vimrc.local'))
  source ~/.vimrc.local
endif

