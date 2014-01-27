" windows behaviour {{{
source $VIMRUNTIME/mswin.vim
set guioptions-=m  "remove menu bar
set guioptions-=T  "remove toolbar
set guioptions-=r  "remove right-hand scroll bar
set guioptions-=L  "remove left-hand scroll bar
" }}}

set nocompatible
filetype off

" Vundle setup {{{
set rtp+=~/vimfiles/bundle/vundle/
call vundle#rc()
Bundle 'gmarik/vundle'
" }}}

" Load some plugins {{{
Bundle 'scrooloose/nerdtree'
Bundle 'zefei/buftabs'
Bundle 'kien/ctrlp.vim'
" https://bitbucket.org/Haroogan/vim-youcompleteme-for-windows/downloads/vim-ycm-cf62110-windows-x64.zip
let g:ycm_server_use_vim_stdout=1
Bundle 'Valloric/YouCompleteMe'
Bundle 'tpope/vim-surround'
" }}}

" Language support {{{
Bundle 'kchmck/vim-coffee-script'
Bundle 'groenewege/vim-less'
" }}}

" Visual Enhancements {{{
set guifont=Consolas,10
color Tomorrow-Night

" Some color fine tuning {{{
hi NonText                 guifg=#4a4a59 guibg=NONE
hi SpecialKey              guifg=#4a4a59
" }}}

" visually mark current line in insert mode
autocmd InsertLeave * set nocursorline
autocmd InsertEnter * set cursorline

set encoding=utf-8
set listchars=tab:›\ ,eol:¬

" }}}



" autoload vimrc after saving
" if has("autocmd")
"  autocmd BufWritePost vimrc source $MYVIMRC
" endif

filetype plugin indent on
syntax on

" Editor config {{{
set encoding=utf-8

set tabstop=4
set shiftwidth=4
set softtabstop=4
set noexpandtab
set shiftround

set noerrorbells


" file specific tab settings {{{
if has("autocmd")
  filetype on

  autocmd FileType php setlocal ts=4 sts=4 sw=4 noet
  autocmd FileType html,xml setlocal ts=2 sts=2 sw=2 et
  autocmd FileType javascript,coffee,json setlocal ts=2 sts=2 sw=2 et
  autocmd FileType css,less setlocal ts=2 sts=2 sw=2 et

  autocmd BufNewFile,BufRead *.phps setfiletype php
endif
" }}}

set nobackup
set noswapfile

set hidden
set number
set nowrap
set autoindent
set copyindent
set showmatch
set ignorecase
set smartcase
set incsearch
set hlsearch
" }}}


" Key bindings {{{

" leader key mappings
let mapleader=","
let maplocalleader=","

" Map Leader,t to clear trailing whitespaces
nnoremap <silent> <Leader>t :call <SID>StripTrailingWhitespaces()<CR>

" show invisible characters
nmap <leader>l :set list!<Enter>

map <F9> :source <C-R>=$MYVIMRC<CR><Enter> " reload vimrc
map <C-F9> :o <C-R>=$MYVIMRC<CR><Enter> " open vimrc
map <F1> :NERDTreeToggle<Enter>

imap jj <Esc>

" disable middle click
map <2-MiddleMouse> <Nop>
imap <2-MiddleMouse> <Nop>
map <3-MiddleMouse> <Nop>
imap <3-MiddleMouse> <Nop>
map <4-MiddleMouse> <Nop>
imap <4-MiddleMouse> <Nop>

" Set auto command to automatically wipe out trailing spaces for these files
autocmd BufWritePre *.php,*.js,*.css,*.html,*.xml,*.sh,*.less,*.coffee :call <SID>StripTrailingWhitespaces()


" toggle search highlighting
nnoremap <F3> :set hlsearch!<Enter>
set pastetoggle=<F2>


map <C-W> :Bclose<Enter> " delete current buffer
"map <C-S> :w<Enter> " save current file

" easy window movement
noremap <C-J>     <C-W>j
noremap <C-K>     <C-W>k
noremap <C-H>     <C-W>h
noremap <C-L>     <C-W>l

" better indentation in visual mode
vnoremap < <gv
vnoremap > >gv

" builds
nnoremap <F7> :Shell cake sbuild<Enter>

function! s:ExecuteInShell(command)
  let command = join(map(split(a:command), 'expand(v:val)'))
  let winnr = bufwinnr('^' . command . '$')
  silent! execute  winnr < 0 ? 'botright new ' . fnameescape(command) : winnr . 'wincmd w'
  setlocal buftype=nowrite bufhidden=wipe nobuflisted noswapfile nowrap number
  echo 'Execute ' . command . '...'
  silent! execute 'silent %!'. command
  silent! execute 'resize ' . line('$')
  silent! redraw
  silent! execute 'au BufUnload <buffer> execute bufwinnr(' . bufnr('#') . ') . ''wincmd w'''
  silent! execute 'nnoremap <silent> <buffer> <LocalLeader>r :call <SID>ExecuteInShell(''' . command . ''')<CR>'
  echo 'Shell command ' . command . ' executed.'
endfunction
command! -complete=shellcmd -nargs=+ Shell call s:ExecuteInShell(<q-args>)
" }}}

" StripTrailingWhitespaces() {{{
function! <SID>StripTrailingWhitespaces()
  " Preparation: save last search, and cursor position.
  let _s=@/
  let l = line(".")
  let c = col(".")

  " Do the business:
  %s/\s\+$//e

  " Clean up: restore previous search history, and cursor position
  let @/=_s
  call cursor(l, c)
endfunction
" }}}

