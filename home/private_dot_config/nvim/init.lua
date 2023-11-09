-- Previous init.vim content --
vim.cmd([[
set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc

if filereadable(expand("~/.init.vim.local"))
  source ~/.init.vim.local
endif
]])

-- NVim config options --
-- disable unused external providers, just to clean up :checkhealth output
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0

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
---- Elixir-LS
--local lsp_status = require('lsp-status')
--lsp_status.register_progress()

--local navic = require('nvim-navic')

--local lspconfig = require('lspconfig')
--lspconfig.elixirls.setup{
    ---- Unix
    --cmd = { "/home/joshproehl/.lsp/elixir-ls/language_server.sh" };
    ---- Windows
    ----cmd = { "/path/to/elixir-ls/language_server.bat" };
    --on_attach = function(client, bufnr)
      --require('lsp-status').on_attach(client)
      --navic.attach(client,bufnr)
    --end
--}
---- END Elixir-LS
local lspconfig = require("lspconfig")
local configs = require("lspconfig.configs")

local lexical_config = {
  filetypes = { "elixir", "eelixir", },
  cmd = { "/home/joshproehl/.lsp/lexical/_build/dev/package/lexical/bin/start_lexical.sh" },
  settings = {},
}

if not configs.lexical then
  configs.lexical = {
    default_config = {
      filetypes = lexical_config.filetypes,
      cmd = lexical_config.cmd,
      root_dir = function(fname)
        return lspconfig.util.root_pattern("mix.exs", ".git")(fname) or vim.loop.os_homedir()
      end,
      -- optional settings
      settings = lexical_config.settings,
    },
  }
end

lspconfig.lexical.setup({})
-- END LSP configuration

require('gitsigns').setup{
  on_attach = function(bufnr)
  end
}

local rt = require("rust-tools")
rt.setup({
  server = {
    on_attach = function(_, bufnr)
      -- Hover actions
      vim.keymap.set("n", "<C-space>", rt.hover_actions.hover_actions, { buffer = bufnr })
      -- Code action groups
      vim.keymap.set("n", "<Leader>a", rt.code_action_group.code_action_group, { buffer = bufnr })
    end,
  },
})

-- heirline configuration --
require('heirline_config')
-- END heirline configuration --
