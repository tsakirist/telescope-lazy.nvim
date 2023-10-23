local themes = require("telescope.themes")

local M = {}

M.extension_name = "Telescope lazy"

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
    change_directory_to_plugin = "<C-c>d",
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
