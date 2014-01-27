set ts=2 sw=2 expandtab
imap jj <Esc>
map <F9> :source ~/vimfiles/vimrc<Enter>
map <C-F9> :o ~/vimfiles/vimrc<Enter>

set nocompatible
filetype off

set rtp+=~/vimfiles/bundle/vundle/
call vundle#rc()

Bundle 'gmarik/vundle'




filetype plugin indent on
syntax on


