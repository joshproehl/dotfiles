-- Previous init.vim content --
vim.cmd([[
set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc

if filereadable(expand("~/.init.vim.local"))
  source ~/.init.vim.local
endif
]])


-- VimTree config --
-- disable netrw at the very start of your init.lua (strongly advised)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true

-- nvim-tree configuration
require("nvim-tree").setup({
  sort_by = "case_sensitive",
  view = {
    side = "right",
  },
  renderer = {
    group_empty = true,
  },
  filters = {
    dotfiles = true,
  },
})
-- END VimTree config --
