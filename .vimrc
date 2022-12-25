" Settings for dein.vim
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
  call dein#begin(s:dein_dir)
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


" Settings for ddc.vim
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


" Settings for ddu.vim
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
nnoremap <leader>F <Cmd>call ddu#start({})<cr>
runtime ftplugin/man.vim

inoremap <silent> jj <ESC>
inoremap <silent> ｊｊ <ESC><ESC>
cnoremap jj <ESC>

vnoremap < <gv
vnoremap > >gv

noremap  <C-Tab>   :tabnext<CR>
noremap  <S-C-Tab> :tabprevious<CR>
noremap  <C-Right> :tabnext<CR>
noremap  <C-Left>  :tabprevious<CR>
noremap  <C-Down>  :q<CR>
tnoremap <C-Tab>   <C-w>gt
tnoremap <S-C-Tab> <C-w>gT
noremap  gr        :tabnext<CR>
noremap  gR        :tabprevious<CR>

nnoremap <leader>h <C-6>
nnoremap <C-l> :noh<CR><C-l>

nnoremap <leader>m <Plug>(MatchitNormalForward)
vnoremap <leader>m <Plug>(MatchitVisualForward)
nnoremap <leader>q <Plug>(socrates-greed)


noremap  j gj
noremap gj  j
noremap  k gk
noremap gk  k
nnoremap <Up>   gk
nnoremap <Down> gj
inoremap <Up>   <C-o>gk
inoremap <Down> <C-o>gj

inoremap <Tab>   <C-n>
inoremap <S-Tab> <C-p>

nnoremap <expr> n (v:searchforward ? 'n' : 'N')
nnoremap <expr> N (v:searchforward ? 'N' : 'n')

" Change the size of windows
nnoremap <S-Left>  <C-w><<CR>
nnoremap <S-Right> <C-w>><CR>
nnoremap <S-Up>    <C-w>-<CR>
nnoremap <S-Down>  <C-w>+<CR>

" Not yank when using x, X, or s in normal mode
nnoremap x "_x
nnoremap X "_X
nnoremap s "_s

nnoremap Y y$

nnoremap / /\v

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
  autocmd Filetype xml inoremap <buffer> </ </<C-x><C-o><ESC>==o
  autocmd Filetype html inoremap <buffer> </ </<C-x><C-o><ESC>==o
augroup END

command -nargs=0 ClearUndo call <sid>ClearUndo()
function! s:ClearUndo()
  let old_undolevels = &undolevels
  set undolevels=-1
  exe "normal a \<BS>\<Esc>"
  let &undolevels = old_undolevels
  unlet old_undolevels
endfunction


function! s:on_lsp_buffer_enabled() abort
  setlocal omnifunc=lsp#complete
  setlocal signcolumn=yes
  nmap <buffer> gd <plug>(lsp-definition)
  nmap <buffer> <f2> <plug>(lsp-rename)
  " inoremap <expr> <cr> pumvisible() ? "\<c-y>\<cr>" : "\<cr>"
endfunction

augroup lsp_install
  au!
  autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END

command! LspDebug let lsp_log_verbose=1 | let lsp_log_file = expand('~/lsp.log')
let g:lsp_diagnostics_enabled = 1
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

" Dispaly clue in shakyo mode
nnoremap <leader>f :ShakyoClue<CR>

" Define a skk dictionary
call skkeleton#config({
\   'globalJisyo': '~/.skk/SKK-JISYO.L',
\   'globalDictionaries': [
\     ['~/.skk/SKK-JISYO.L', 'euc-jp'],
\     ['~/.skk/SKK-JISYO.geo', 'euc-jp'],
\     ['~/.skk/SKK-JISYO.jinmei', 'euc-jp'],
\     ['~/.skk/SKK-JISYO.propernoun', 'euc-jp'],
\     ['~/.skk/SKK-JISYO.station', 'euc-jp'],
\     ['~/.skk/SKK-JISYO.emoji.utf8', 'utf-8'],
\     ['~/.skk/zipcode/SKK-JISYO.zipcode', 'euc-jp']
\   ],
\   'markerHenkan': 'γ',
\   'markerHenkanSelect': 'Γ',
\   'registerConvertResult': v:true,
\   'showCandidatesCount': 1
\ })
call skkeleton#register_keymap('input', ';', 'henkanPoint')
call skkeleton#register_kanatable('rom', {
\   'jj': 'escape',
\   'mb': ['ん', 'b'],
\   'mm': ['ん', 'm'],
\   'mp': ['ん', 'p'],
\   'tch': ['っ', 'ch'],
\ })
imap <C-j> <Plug>(skkeleton-toggle)
cmap <C-j> <Plug>(skkeleton-toggle)

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

nnoremap  <C-a>  <Plug>(dps-dial-increment)
nmap      <C-x>  <Plug>(dps-dial-decrement)
xnoremap  <C-a>  <Plug>(dps-dial-increment)
xmap      <C-x>  <Plug>(dps-dial-decrement)
xnoremap g<C-a> g<Plug>(dps-dial-increment)
xmap     g<C-x> g<Plug>(dps-dial-decrement)

" Open automatically quickfix-window after excuting grep like commands
autocmd QuickFixCmdPost *grep* cwindow

command! Vimrc :tabnew ~/.vimrc
command! Srrc  :source ~/.vimrc
command! DeinTOML :tabnew ~/.vim/rc/dein.toml|:tabnew ~/.vim/rc/dein_lazy.toml
cabbr w!! w !sudo tee > /dev/null %
cabbr h tab :h

" Yank settings for WSL2
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
      autocmd TextYankPost * :call system('win32yank.exe -i --crlf', @")
  augroup END
  nnoremap <silent> p :call setreg('"',system('win32yank.exe -o --lf'))<CR>""p
  nnoremap <silent> P :call setreg('"',system('win32yank.exe -o --lf'))<CR>""P
  let g:previm_open_cmd = '/mnt/c/PROGRA~2/Google/Chrome/Application/chrome.exe'
  let g:previm_wsl_mode = 1
endif

set clipboard=exclude:.*
augroup LazyClipboardSetup
  autocmd!
  autocmd CursorHold,CursorMoved * :call serverlist() | set clipboard=unnamedplus
augroup END

