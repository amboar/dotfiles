set relativenumber
set textwidth=80
set colorcolumn=+1
set runtimepath^=~/.vim
let &packpath = &runtimepath

lua require('plugins')
lua require('lsp')
