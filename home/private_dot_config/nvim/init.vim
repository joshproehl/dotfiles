set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc

if filereadable(expand("~/.init.vim.local"))
  source ~/.init.vim.local
endif
