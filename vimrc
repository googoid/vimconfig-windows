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
" let g:ycm_server_use_vim_stdout=1
" Bundle 'Valloric/YouCompleteMe'
Bundle 'tpope/vim-surround'
" Snippets {{{
Bundle 'MarcWeber/vim-addon-mw-utils'
Bundle 'tomtom/tlib_vim'
Bundle 'garbas/vim-snipmate'
Bundle 'honza/vim-snippets'
" }}}
" Bundle 'xolox/vim-misc'
" Bundle 'xolox/vim-session'

Bundle 'amiorin/vim-project'
call project#rc('/')
Bundle 'Lokaltog/vim-easymotion'
let g:EasyMotion_leader_key = '<Leader>'

Bundle 'vim-scripts/Visual-Mark'
Bundle 'gregsexton/MatchTag'
" }}}

Bundle 'chriskempson/vim-tomorrow-theme'
Bundle 'nanotech/jellybeans.vim'

" Language support {{{
Bundle 'AndrewRadev/vim-coffee-script'
Bundle 'AndrewRadev/coffee_tools.vim'
Bundle 'groenewege/vim-less'
" }}}

" Visual Enhancements {{{
set guifont=Consolas:h11
" color Tomorrow-Night
color jellybeans

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

" set novisualbell
" set noerrorbells
" set visualbell
" set t_vb=


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
set noshowmatch
set ignorecase
set smartcase
set incsearch
"set hlsearch

" Session options {{{
"set sessionoptions=resize,curdir,localoptions,unix,winpos,winsize
"set sessionoptions-=buffers
"set sessionoptions-=blank

fu! SaveSess()
    execute 'mksession! ' . getcwd() . '/.session.vim'
endfunction

fu! RestoreSess()
if filereadable(getcwd() . '/.session.vim')
    execute 'so ' . getcwd() . '/.session.vim'
    if bufexists(1)
        for l in range(1, bufnr('$'))
            if bufwinnr(l) == -1
                exec 'sbuffer ' . l
            endif
        endfor
    endif
endif
endfunction

"autocmd VimLeave * call SaveSess()
"autocmd VimEnter * call RestoreSess()
" }}}
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

noremap <F3> :bp<Enter>
noremap <F4> :bn<Enter>

" toggle search highlighting
nnoremap <F12> :set hlsearch!<Enter>
" set pastetoggle=<F2>


map <Leader>x :Bclose<Enter> " delete current buffer
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
nnoremap <C-B> :Shell cake sbuild<Enter>

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

let g:project_use_nerdtree = 1

Project '/chatr/client', 'chatr-client'
Project '/chatr/server', 'chatr-server'
" Project '~/vimfiles/vimrc'		, 'vimrc'

fu! s:setWinDefaultSizePos()
  exe "set lines=53 columns=110"
  exe "winpos 5 5"
endfu

command! WinDef call s:setWinDefaultSizePos()

