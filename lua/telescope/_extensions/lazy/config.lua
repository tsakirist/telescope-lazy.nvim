local themes = require("telescope.themes")

local M = {}

M.extension_name = "Telescope lazy"

---@type TelescopeLazy.Config
M.defaults = {
  show_icon = true,
  mappings = {
    open_in_browser = "<C-o>",
    open_in_file_browser = "<M-b>",
    open_in_find_files = "<C-f>",
    open_in_live_grep = "<C-g>",
    open_in_terminal = "<C-t>",
    open_plugins_picker = "<C-b>",
    open_lazy_root_find_files = "<C-r>f",
    open_lazy_root_live_grep = "<C-r>g",
    change_cwd_to_plugin = "<C-c>d",
  },
  actions_opts = {
    open_in_browser = {
      auto_close = false,
    },
    change_cwd_to_plugin = {
      auto_close = false,
    },
  },
  terminal_opts = {
    relative = "editor",
    style = "minimal",
    border = "rounded",
    title = M.extension_name,
    title_pos = "center",
    width = 0.5,
    height = 0.5,
  },
}

---@type TelescopeLazy.Config
M.opts = {}

---@param opts? TelescopeLazy.Config
function M.setup(opts)
  opts = opts or {}

  if opts.theme and string.len(opts.theme) > 0 then
    if not themes["get_" .. opts.theme] then
      vim.notify(
        string.format("Could not apply provided telescope theme: '%s'", opts.theme),
        vim.log.levels.WARN,
        { title = M.extension_name }
      )
    else
      opts = themes["get_" .. opts.theme](opts)
    end
  end

  M.opts = vim.tbl_deep_extend("force", M.defaults, opts)
end

return M
