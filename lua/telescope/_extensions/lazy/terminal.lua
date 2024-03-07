local telescope_lazy_config = require("telescope._extensions.lazy.config")
local telescope_lazy_floating_window = require("telescope._extensions.lazy.floating_window")

---@class Terminal
local M = {}

--- Creates a new Terminal instance.
---@param opts? table: An optional configuration.
---@return Terminal
function M.new(opts)
  local self = setmetatable({}, { __index = M })
  return self:init(opts)
end

function M:init(opts)
  self._window = telescope_lazy_floating_window.new(opts)
  return self
end

function M:open(path, resume_picker)
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

  self:set_keymaps(resume_picker)

  vim.schedule(function()
    vim.cmd.startinsert()
  end)
end

function M:close()
  self._window:close()
end

function M:set_keymaps(resume_picker)
  local opts = {
    nowait = true,
    buffer = self._window.buf,
  }

  vim.keymap.set("t", "<C-q>", function()
    self:close()
  end, opts)

  vim.keymap.set("t", telescope_lazy_config.opts.mappings.open_plugins_picker, function()
    self:close()
    resume_picker()
  end, opts)
end

return M
