local themes = require("telescope.themes")

local M = {}

M.extension_name = "Telescope lazy"

M.defaults = {
  show_icon = true,
  mappings = {
    open_in_browser = "<C-o>",
    open_in_find_files = "<C-f>",
    open_in_live_grep = "<C-g>",
    open_plugins_picker = "<C-b>",
  },
}

M.opts = {}

function M.setup(user_opts)
  user_opts = user_opts or {}
  if user_opts.theme and string.len(user_opts.theme) > 0 then
    if not themes["get_" .. user_opts.theme] then
      vim.notify(
        string.format("Could not apply provided telescope theme: '%s'", user_opts.theme),
        vim.log.levels.WARN,
        { title = M.extension_name }
      )
    else
      user_opts = themes["get_" .. user_opts.theme](user_opts)
    end
  end
  M.opts = vim.tbl_deep_extend("force", M.defaults, user_opts)
end

return M
