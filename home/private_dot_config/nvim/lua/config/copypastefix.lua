-- The following is taken from https://github.com/kriansa/dotfiles/commit/a0541224bdf18c115b18955abc53c64734d71140
-- which I found referenced in the neovim issue linked, while trying to solve the problem of wl-paste locking up
-- nvim/terminal on GNOME. (Fedora latest)
-- Check in on neovim/issues/24470 to see if this has been resolved and if the file can be removed.
------------------------------------------------------------------------------------------------------------------
--
-- This effectively replaces the `set clipboard=unnamedplus` option, which sets every yanked text to
-- the system clipboard. The problem with that is that when doing several deletes or changes in a
-- row, the clipboard will keep getting overwritten, as well as calling the system clipboard app
-- every time. On GNOME, this is particularly slow, blocks the UI and steals the focus, causing
-- events such as `FocusLost` and `FocusGained` to be triggered, which is not what we want.
--
-- This way, it will only copy to the system clipboard when the editor loses focus, which is
-- usually when you switch to another application. We also set a timer so we avoid conflicts while
-- alt-tabbing, especially on GNOME where the wl-clipboard steals the focus, causing an infinite
-- loop.
--
-- See: https://github.com/neovim/neovim/issues/11804
-- See: https://github.com/neovim/neovim/issues/24470
-- See: https://github.com/bugaevc/wl-clipboard/issues/90
function with_locked_clipboard(fn)
  return function()
    -- Only sets the register if the timer is not running
    if vim.g._clipboard_lock then
      return
    end

    fn()
    vim.g._clipboard_lock = true

    -- Starts the timer
    vim.defer_fn(function()
      vim.g._clipboard_lock = false
    end, 500)
  end
end

vim.api.nvim_create_autocmd("FocusLost", {
  pattern = "*",
  callback = with_locked_clipboard(function()
    vim.fn.setreg("+", vim.fn.getreg(0))
  end),
})

vim.api.nvim_create_autocmd("FocusGained", {
  pattern = "*",
  callback = with_locked_clipboard(function()
    vim.fn.setreg(0, vim.fn.getreg("+"))
  end),
})
