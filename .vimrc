set nocompatible

" Show line numbers
set number

" Show the multibyte accented Spanish
" characters (in Capitan Sevilla) correctly
" set encoding=iso-8859-1

set encoding=utf8
"set fileencodings=ucs-bom,utf-8,ucs-2le,latin1

set laststatus=2

" Allow chelper.vim to work on Windows
if has("win32") && !has('nvim')
set pythonthreedll=~\AppData\Local\Programs\Python\Python37-32\python37.dll
endif

call plug#begin('~/.vim/plugged')

" Plug 'mgedmin/chelper.vim'
Plug 'mgedmin/taghelper.vim'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'preservim/tagbar'
Plug 'wateret/ifdef-heaven.vim'

call plug#end()
" Show function name in status line using chelper.vim
" set statusline=%<%f\ %h%m%r\ %1*%{CTagInStatusLine()}%*%=%-14.(%l,%c%V%)\ %P

" Show function name in status line using taghelper.vim
set statusline=%<%f\ %h%m%r\ %1*%{taghelper#curtag()}%*%=%-14.(%l,%c%V%)\ %P

" Add parent directory to search dirs when looking up functions/variables
set tags+=../tags,../../tags

" Cppcheck quickfix message format
" set errorformat=[%f:%l]:%m

" Enable filetype plugins
" filetype off
" filetype plugin indent on
filetype plugin on
filetype indent on

" Enable Syntax Highlighting 
syntax on

" Allow backspacing over the start of lines
" https://stackoverflow.com/questions/5419848/backspace-doesnt-work-in-gvim-7-2-64-bit-for-windows
set backspace=indent,eol,start

" Enable mouse in terminal
if !has("gui_running")
    set mouse=a
endif

" Recognize Globulation 2 SCons files as Python scripts
au BufRead,BufNewFile SConstruct set filetype=python
au BufRead,BufNewFile SConscript set filetype=python

"set runtimepath^=~/.vim/bundle/ctrlp.vim

" Ctrl-P fuzzy file finder
" https://stackoverflow.com/a/17327372
if executable('ag')
  " Use Ag over Grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
endif

" Commented out since this doesn't seem to be working
" Attempt to detect file encoding with AutoFenc plugin, as suggested by
" https://vim.wikia.com/wiki/How_to_make_fileencoding_work_in_the_modeline
" Download AutoFenc at: https://www.vim.org/scripts/script.php?script_id=2721
" function! CheckFileEncoding()
"  if exists('b:fenc_at_read') && &fileencoding != b:fenc_at_read
"    exec 'e! ++enc=' . &fileencoding
"    unlet b:fenc_at_read
"  endif
"endfunction
"au BufRead     *.txt let b:fenc_at_read=&fileencoding
"au BufWinEnter *.txt call CheckFileEncoding()

if has('win32')
    source $VIMRUNTIME/mswin.vim
endif
