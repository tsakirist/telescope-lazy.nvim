local telescope_lazy_config = require("telescope._extensions.lazy.config")

---@class FloatingWindow
local M = {}

--- Creates a new FloatingWindow instance.
---@param opts? table: An optional configuration.
---@return FloatingWindow
function M.new(opts)
  local self = setmetatable({}, { __index = M })
  return self:init(opts)
end

function M:init(opts)
  self.win_opts = vim.tbl_deep_extend("force", telescope_lazy_config.opts.terminal_opts, opts or {})
  self:create_window()
  self:focus()
  return self
end

function M:close()
  if self:win_is_valid() then
    vim.api.nvim_win_close(self.win, true)
  end
end

function M:win_is_valid()
  return self.win and vim.api.nvim_win_is_valid(self.win)
end

function M:buf_is_valid()
  return self.buf and vim.api.nvim_buf_is_valid(self.buf)
end

function M:focus()
  vim.api.nvim_set_current_win(self.win)
end

function M:create_window()
  local win_opts = self:get_window_dimensions()
  self.buf = vim.api.nvim_create_buf(false, true)
  self.win = vim.api.nvim_open_win(self.buf, false, win_opts)
end

function M:get_window_dimensions()
  local win_opts = self.win_opts
  win_opts.height = math.floor(vim.o.lines * self.win_opts.height)
  win_opts.width = math.floor(vim.o.columns * self.win_opts.width)
  win_opts.row = math.floor((vim.o.lines - win_opts.height) / 2)
  win_opts.col = math.floor((vim.o.columns - win_opts.width) / 2)
  return win_opts
end

function M:open_terminal(path, resume_picker)
  local ret = vim.fn.termopen(vim.o.shell, {
    cwd = path,
    on_exit = function()
      self:close()
    end,
  })

  if ret <= 0 then
    vim.notify(
      string.format("Failed to open terminal with cwd: '%s' (ret: '%d')", path, ret),
      vim.log.levels.ERROR,
      { title = telescope_lazy_config.extension_name }
    )
    return
  end

  self:set_terminal_keymaps(resume_picker)

  vim.schedule(function()
    vim.cmd.startinsert()
  end)
end

function M:set_terminal_keymaps(resume_picker)
  local opts = {
    nowait = true,
    buffer = self.buf,
  }

  vim.keymap.set("t", "<C-q>", function()
    vim.cmd.quit({ bang = true })
  end, opts)

  vim.keymap.set("t", telescope_lazy_config.opts.mappings.open_plugins_picker, function()
    self:close()
    resume_picker()
  end, opts)
end

return M
