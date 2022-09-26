
" Reset the specified directory when installing dein.vim
let s:dein_dir = expand('~/.vim/dein')

" Set a directory for dein.vim
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
set matchpairs+=<:>,「:」,（:）,『:』,【:】
set autochdir


inoremap <silent> jj <ESC>
inoremap <silent> ｊｊ <ESC><ESC>
cnoremap jj <ESC>

vnoremap < <gv
vnoremap > >gv

noremap <C-Tab> :tabnext<CR>
noremap <S-C-Tab> :tabprevious<CR>
noremap <C-Right> :tabnext<CR>
noremap <C-Left> :tabprevious<CR>
noremap <C-Down> :q<CR>
tnoremap <C-Tab> <C-w>gt
tnoremap <S-C-Tab> <C-w>gT
noremap gr :tabnext<CR>
noremap gR :tabprevious<CR>
nnoremap <leader>h <C-6>

noremap j gj
noremap gj j
noremap k gk
noremap gk k

" Not yank when using x, X, or s in normal mode
nnoremap x "_x
nnoremap X "_X
nnoremap s "_s

nnoremap / /\v

" Change cursors according with mode
let &t_ti .= "\e[1 q"
let &t_SI .= "\e[5 q"
let &t_EI .= "\e[1 q"
let &t_te .= "\e[0 q"

let mapleader = "\<Space>"

" Set the indent inside the p tags
let g:html_indent_inctags = "p"

set completeopt=menuone
for k in split("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_",'\zs')
  exec "imap " . k . " " . k . "<C-N><C-P>"
endfor
imap <expr> <TAB> pumvisible() ? "\<Down>" : "\<Tab>"

augroup MyXML
  autocmd!
  autocmd Filetype xml inoremap <buffer> </ </<C-x><C-o>
  autocmd Filetype html inoremap <buffer> </ </<C-x><C-o>
augroup END

command -nargs=0 ClearUndo call <sid>ClearUndo()
function! s:ClearUndo()
  let old_undolevels = &undolevels
  set undolevels=-1
  exe "normal a \<BS>\<Esc>"
  let &undolevels = old_undolevels
  unlet old_undolevels
endfunction

if empty(globpath(&rtp, 'autoload/lsp.vim'))
  finish
endif
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

" Display results on the upper side with denite
let g:fzf_layout = { 'up': '~40%' }

" Search tags with <C-]>
nnoremap <silent> <C-]> :call fzf#vim#tags(expand('<cword>'))<CR>

" Make it possible to jump from fzf to the file
let g:fzf_buffers_jump = 1

" Dispaly clue in shakyo mode
nnoremap <leader>f :ShakyoClue<CR>

command! Vimrc :tabnew ~/.vimrc
command! Srrc  :source ~/.vimrc
command! DeinTOML :tabnew ~/.vim/rc/dein.toml

" Yank settings for WSL2
" augroup Yank
"     autocmd!
"     autocmd TextYankPost * :call system('win32yank -i --crlf', @")
" augroup END
" nnoremap <silent> p :call setreg('"',system('win32yank -o --lf'))<CR>""p
" nnoremap <silent> P :call setreg('"',system('win32yank -o --lf'))<CR>""P

