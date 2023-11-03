set background=dark
set relativenumber
set colorcolumn=+1
syntax on
filetype on
au BufRead,BufNewFile */COMMIT_EDITMSG set textwidth=72
au BufRead,BufNewFile *.patch set textwidth=72
