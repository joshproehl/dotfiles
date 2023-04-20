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

require('nvim-web-devicons').setup {
  -- your personnal icons can go here (to override)
  -- DevIcon will be appended to `name`
  override = {
    zsh = {
      icon = "",
      color = "#428850",
      name = "Zsh",
    },
  };
  -- globally enable default icons (default to false)
  -- will get overriden by `get_icons` option
  default = true;
}

-- Change diagnostic signs.
vim.fn.sign_define("DiagnosticSignError", { text = "✗", texthl = "DiagnosticSignError" })
vim.fn.sign_define("DiagnosticSignWarn", { text = "!", texthl = "DiagnosticSignWarn" })
vim.fn.sign_define("DiagnosticSignInfo", { text = "", texthl = "DiagnosticSignInfo" })
vim.fn.sign_define("DiagnosticSignHint", { text = "", texthl = "DiagnosticSignHint" })

-- nvim-tree configuration --
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
  actions = {
    open_file = {
      quit_on_open = true,
    },
  },
})
-- END VimTree config --

-- LSP configuration
local lsp_status = require('lsp-status')
lsp_status.register_progress()

local navic = require('nvim-navic')

local lspconfig = require('lspconfig')
lspconfig.elixirls.setup{
    -- Unix
    cmd = { "/home/joshproehl/.lsp/elixir-ls/language_server.sh" };
    -- Windows
    --cmd = { "/path/to/elixir-ls/language_server.bat" };
    on_attach = function(client, bufnr)
      require('lsp-status').on_attach(client)
      navic.attach(client,bufnr)
    end
}
-- END LSP configuration

require('gitsigns').setup{
  on_attach = function(bufnr)
  end
}

-- heirline configuration --
require('heirline_config')
-- END heirline configuration --
