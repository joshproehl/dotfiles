local conditions = require('heirline.conditions')
local utils = require('heirline.utils')

local function setup_colors()
    return {
      bright_bg = utils.get_highlight("Folded").bg,
      bright_fg = utils.get_highlight("Folded").fg,
      red = utils.get_highlight("DiagnosticError").fg,
      dark_red = utils.get_highlight("DiffDelete").bg,
      green = utils.get_highlight("String").fg,
      blue = utils.get_highlight("Function").fg,
      gray = utils.get_highlight("NonText").fg,
      orange = utils.get_highlight("Constant").fg,
      purple = utils.get_highlight("Statement").fg,
      cyan = utils.get_highlight("Special").fg,
      diag_warn = utils.get_highlight("DiagnosticWarn").fg,
      diag_error = utils.get_highlight("DiagnosticError").fg,
      diag_hint = utils.get_highlight("DiagnosticHint").fg,
      diag_info = utils.get_highlight("DiagnosticInfo").fg,
      git_del = utils.get_highlight("diffDeleted").fg,
      git_add = utils.get_highlight("diffAdded").fg,
      git_change = utils.get_highlight("diffChanged").fg,
    }
end

vim.api.nvim_create_augroup("Heirline", { clear = true })
vim.api.nvim_create_autocmd("ColorScheme", {
    callback = function()
        utils.on_colorscheme(setup_colors)
    end,
    group = "Heirline",
})

--local colors = require("catppuccin.palettes").get_palette "latte"
--require("heirline").load_colors(colors)

-- require("heirline").load_colors(setup_colors)
-- or pass it to config.opts.colors




-------------------------------------
-- Configure StatusLine components --
local FileNameBlock = {
  -- let's first set up some attributes needed by this component and it's children
  init = function(self)
    self.filename = vim.api.nvim_buf_get_name(0)
  end,
}
-- We can now define some children separately and add them later

local FileIcon = {
  init = function(self)
    local filename = self.filename
    local extension = vim.fn.fnamemodify(filename, ":e")
    self.icon, self.icon_color = require("nvim-web-devicons").get_icon_color(filename, extension, { default = true })
  end,
  provider = function(self)
    return self.icon and (self.icon .. " ")
  end,
  hl = function(self)
    return { fg = self.icon_color }
  end
}

local FileName = {
  provider = function(self)
    -- first, trim the pattern relative to the current directory. For other
    -- options, see :h filename-modifers
    local filename = vim.fn.fnamemodify(self.filename, ":.")
    if filename == "" then return "[No Name]" end
    -- now, if the filename would occupy more than 1/4th of the available
    -- space, we trim the file path to its initials
    -- See Flexible Components section below for dynamic truncation
    if not conditions.width_percent_below(#filename, 0.25) then
      filename = vim.fn.pathshorten(filename)
    end
    return filename
  end,
  hl = { fg = utils.get_highlight("Directory").fg },
}

local FileFlags = {
  {
    condition = function()
      return vim.bo.modified
    end,
    provider = "[+]",
    hl = { fg = "green" },
  },
  {
    condition = function()
      return not vim.bo.modifiable or vim.bo.readonly
    end,
    provider = "",
    hl = { fg = "orange" },
  },
}

-- Now, let's say that we want the filename color to change if the buffer is
-- modified. Of course, we could do that directly using the FileName.hl field,
-- but we'll see how easy it is to alter existing components using a "modifier"
-- component

local FileNameModifer = {
  hl = function()
    if vim.bo.modified then
      -- use `force` because we need to override the child's hl foreground
      return { fg = "cyan", bold = true, force=true }
    end
  end,
}

-- let's add the children to our FileNameBlock component
FileNameBlock = utils.insert(FileNameBlock,
FileIcon,
utils.insert(FileNameModifer, FileName), -- a new table where FileName is a child of FileNameModifier
FileFlags,
{ provider = '%<'} -- this means that the statusline is cut here when there's not enough space
)

local FileEncoding = {
  provider = function()
    local enc = (vim.bo.fenc ~= '' and vim.bo.fenc) or vim.o.enc -- :h 'enc'
    return enc ~= 'utf-8' and enc:upper()
  end
}

-- Git block (from heirline cookbook)
local Git = {
  condition = conditions.is_git_repo,

  init = function(self)
    self.status_dict = vim.b.gitsigns_status_dict
    self.has_changes = self.status_dict.added ~= 0 or self.status_dict.removed ~= 0 or self.status_dict.changed ~= 0
  end,

  hl = { fg = "orange" },


  {   -- git branch name
    provider = function(self)
      return " " .. self.status_dict.head
    end,
    hl = { bold = true }
  },
  -- You could handle delimiters, icons and counts similar to Diagnostics
  {
    condition = function(self)
      return self.has_changes
    end,
    provider = "("
  },
  {
    provider = function(self)
      local count = self.status_dict.added or 0
      return count > 0 and ("+" .. count)
    end,
    hl = { fg = "git_add" },
  },
  {
    provider = function(self)
      local count = self.status_dict.removed or 0
      return count > 0 and ("-" .. count)
    end,
    hl = { fg = "git_del" },
  },
  {
    provider = function(self)
      local count = self.status_dict.changed or 0
      return count > 0 and ("~" .. count)
    end,
    hl = { fg = "git_change" },
  },
  {
    condition = function(self)
      return self.has_changes
    end,
    provider = ")",
  },
}


-- We're getting minimalists here!
local Ruler = {
  -- %l = current line number
  -- %L = number of lines in the buffer
  -- %c = column number
  -- %P = percentage through file of displayed window
  provider = "%7(%l/%3L%):%2c %P",
}

-- I take no credits for this! :lion:
local ScrollBar ={
  static = {
    sbar = { '▁', '▂', '▃', '▄', '▅', '▆', '▇', '█' }
    -- Another variant, because the more choice the better.
    -- sbar = { '🭶', '🭷', '🭸', '🭹', '🭺', '🭻' }
  },
  provider = function(self)
    local curr_line = vim.api.nvim_win_get_cursor(0)[1]
    local lines = vim.api.nvim_buf_line_count(0)
    local i = math.floor((curr_line - 1) / lines * #self.sbar) + 1
    return string.rep(self.sbar[i], 2)
  end,
  hl = { fg = "blue", bg = "bright_bg" },
}

local LSPActive = {
  condition = conditions.lsp_attached,
  update = {'LspAttach', 'LspDetach'},

  -- You can keep it simple,
  -- provider = " [LSP]",

  -- Or complicate things a bit and get the servers names
  provider  = function()
    local names = {}
    for i, server in pairs(vim.lsp.get_active_clients({ bufnr = 0 })) do
      table.insert(names, server.name)
    end
    return " [" .. table.concat(names, " ") .. "]"
  end,
  hl = { fg = "green", bold = true },
}

-- I personally use it only to display progress messages!
-- See lsp-status/README.md for configuration options.

-- Note: check "j-hui/fidget.nvim" for a nice statusline-free alternative.
--local LSPMessages = {
  --    provider = require("lsp-status").status,
  --    hl = { fg = "gray" },
  --}


  ----------------------------------
  -- Configure TabLine components --
  local TablineBufnr = {
    provider = function(self)
      return tostring(self.bufnr) .. ". "
    end,
    hl = "Comment",
  }

  -- we redefine the filename component, as we probably only want the tail and not the relative path
  local TablineFileName = {
    provider = function(self)
      -- self.filename will be defined later, just keep looking at the example!
      local filename = self.filename
      filename = filename == "" and "[No Name]" or vim.fn.fnamemodify(filename, ":t")
      return filename
    end,
    hl = function(self)
      return { bold = self.is_active or self.is_visible, italic = true }
    end,
  }

  -- this looks exactly like the FileFlags component that we saw in
  -- #crash-course-part-ii-filename-and-friends, but we are indexing the bufnr explicitly
  -- also, we are adding a nice icon for terminal buffers.
  local TablineFileFlags = {
    {
      condition = function(self)
        return vim.api.nvim_buf_get_option(self.bufnr, "modified")
      end,
      provider = "[+]",
      hl = { fg = "green" },
    },
    {
      condition = function(self)
        return not vim.api.nvim_buf_get_option(self.bufnr, "modifiable")
        or vim.api.nvim_buf_get_option(self.bufnr, "readonly")
      end,
      provider = function(self)
        if vim.api.nvim_buf_get_option(self.bufnr, "buftype") == "terminal" then
          return "  "
        else
          return ""
        end
      end,
      hl = { fg = "orange" },
    },
  }

  -- Here the filename block finally comes together
  local TablineFileNameBlock = {
    init = function(self)
      self.filename = vim.api.nvim_buf_get_name(self.bufnr)
    end,
    hl = function(self)
      if self.is_active then
        return "TabLineSel"
        -- why not?
        -- elseif not vim.api.nvim_buf_is_loaded(self.bufnr) then
        --     return { fg = "gray" }
      else
        return "TabLine"
      end
    end,
    on_click = {
      callback = function(_, minwid, _, button)
        if (button == "m") then -- close on mouse middle click
          vim.schedule(function()
            vim.api.nvim_buf_delete(minwid, { force = false })
          end)
        else
          vim.api.nvim_win_set_buf(0, minwid)
        end
      end,
      minwid = function(self)
        return self.bufnr
      end,
      name = "heirline_tabline_buffer_callback",
    },
    TablineBufnr,
    FileIcon, -- turns out the version defined in #crash-course-part-ii-filename-and-friends can be reutilized as is here!
    TablineFileName,
    TablineFileFlags,
  }

  -- a nice "x" button to close the buffer
  local TablineCloseButton = {
    condition = function(self)
      return not vim.api.nvim_buf_get_option(self.bufnr, "modified")
    end,
    { provider = " " },
    {
      provider = "",
      hl = { fg = "gray" },
      on_click = {
        callback = function(_, minwid)
          vim.schedule(function()
            vim.api.nvim_buf_delete(minwid, { force = false })
          end)
          vim.cmd.redrawtabline()
        end,
        minwid = function(self)
          return self.bufnr
        end,
        name = "heirline_tabline_close_buffer_callback",
      },
    },
  }

  -- The final touch!
  local TablineBufferBlock = utils.surround({ "", "" }, function(self)
    if self.is_active then
      return utils.get_highlight("TabLineSel").bg
    else
      return utils.get_highlight("TabLine").bg
    end
  end, { TablineFileNameBlock, TablineCloseButton })

  -- this is the default function used to retrieve buffers
  local get_bufs = function()
    return vim.tbl_filter(function(bufnr)
      return vim.api.nvim_buf_get_option(bufnr, "buflisted")
    end, vim.api.nvim_list_bufs())
  end

  -- initialize the buflist cache
  local buflist_cache = {}

  -- setup an autocmd that updates the buflist_cache every time that buffers are added/removed
  vim.api.nvim_create_autocmd({ "VimEnter", "UIEnter", "BufAdd", "BufDelete" }, {
    callback = function()
      vim.schedule(function()
        local buffers = get_bufs()
        for i, v in ipairs(buffers) do
          buflist_cache[i] = v
        end
        for i = #buffers + 1, #buflist_cache do
          buflist_cache[i] = nil
        end

        -- check how many buffers we have and set showtabline accordingly
        if #buflist_cache > 1 then
          vim.o.showtabline = 2 -- always
        else
          vim.o.showtabline = 1 -- only when #tabpages > 1
        end
      end)
    end,
  })

  local BufferLine = utils.make_buflist(
  TablineBufferBlock,
  { provider = " ", hl = { fg = "gray" } },
  { provider = " ", hl = { fg = "gray" } },
  -- out buf_func simply returns the buflist_cache
  function()
    return buflist_cache
  end,
  -- no cache, as we're handling everything ourselves
  false
  )

  ----------------------
  -- Configure WinBar --
  local Navic = {
    condition = function() return require("nvim-navic").is_available() end,
    provider = function()
      return require("nvim-navic").get_location({highlight=true})
    end,
    update = 'CursorMoved'
  }

  local Diagnostics = {
	  condition = conditions.has_diagnostics,

	  static = {
		  error_icon = vim.fn.sign_getdefined("DiagnosticSignError")[1].text,
		  warn_icon = vim.fn.sign_getdefined("DiagnosticSignWarn")[1].text,
		  info_icon = vim.fn.sign_getdefined("DiagnosticSignInfo")[1].text,
		  hint_icon = vim.fn.sign_getdefined("DiagnosticSignHint")[1].text,
	  },

	  init = function(self)
		  self.errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
		  self.warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
		  self.hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
		  self.info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
	  end,

	  update = { "DiagnosticChanged", "BufEnter" },

	  {
		  provider = "![",
	  },
	  {
		  provider = function(self)
			  -- 0 is just another output, we can decide to print it or not!
			  return self.errors > 0 and (self.error_icon .. self.errors .. " ")
		  end,
		  hl = { fg = "diag_error" },
	  },
	  {
		  provider = function(self)
			  return self.warnings > 0 and (self.warn_icon .. self.warnings .. " ")
		  end,
		  hl = { fg = "diag_warn" },
	  },
	  {
		  provider = function(self)
			  return self.info > 0 and (self.info_icon .. self.info .. " ")
		  end,
		  hl = { fg = "diag_info" },
	  },
	  {
		  provider = function(self)
			  return self.hints > 0 and (self.hint_icon .. self.hints)
		  end,
		  hl = { fg = "diag_hint" },
	  },
	  {
		  provider = "]",
	  },
  }

  ----------------------------
  -- Configure StatusColumn --
  local LineNumber = {
    provider = function(self)
      if vim.opt.relativenumber and not vim.opt.number then
        return "%r"
      else
        return "%l"
      end
    end,
    hl = { fg = utils.get_highlight("Directory").fg },
  }

  local RelativeLine = {
    provider = function(self)
      return "%r"
    end,
    hl = { fg = utils.get_highlight("NonText").fg },
  }



  ---------------------------
  -- Bring it all together --

  local AlignRight = { provider = "%=" }
  local Space = { provider = " " }

  require("heirline").setup({
    statusline = {
      Git, Space,
      FileNameBlock, Space,
      AlignRight,
      LSPMesages, Space,
      LSPActive, Space,
      FileEncoding, Space,
      Ruler,
      ScrollBar,
    },
    winbar = {
      Navic,
      AlignRight, Diagnostics
    },
    tabline = {
      BufferLine,
    },
    statuscolumn = {
      LineNumber, Space, AlignRight, RelativeLine, Space,
    },
    opts = {
      colors = setup_colors,
      -- if the callback returns true, the winbar will be disabled for that window
      -- the args parameter corresponds to the table argument passed to autocommand callbacks. :h nvim_lua_create_autocmd()
      disable_winbar_cb = function(args)
        return conditions.buffer_matches({
          buftype = { "nofile", "prompt", "help", "quickfix" },
          filetype = { "^git.*", "fugitive", "Trouble", "dashboard" },
        }, args.buf)
      end,
    }
  })
