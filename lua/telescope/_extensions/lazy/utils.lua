local M = {}

--- Path separator depending on the OS
M.path_separator = vim.loop.os_uname().sysname:match("Windows") and "\\" or "/"

--- Joins the passed arguments with the appropriate file separator.
---@vararg any: The paths to join.
---@return string: The joined path.
function M.join_paths(...)
  return table.concat({ ... }, M.path_separator)
end

return M
