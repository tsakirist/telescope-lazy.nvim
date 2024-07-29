local M = {}

--- Path separator depending on the OS
M.path_separator = vim.loop.os_uname().sysname:match("Windows") and "\\" or "/"

--- Joins the passed arguments with the appropriate file separator.
---@vararg any: The paths to join.
---@return string: The joined path.
function M.join_paths(...)
  return table.concat({ ... }, M.path_separator)
end

--- Finds the length of the longest plugin name.
---@param plugins table<Plugin>: A table with all the plugins.
---@return number: The length of the longest plugin name.
function M.max_plugin_name_length(plugins)
  local max_length = 0
  for _, plugin in ipairs(plugins) do
    max_length = math.max(max_length, #plugin.name)
  end
  return max_length
end

return M
