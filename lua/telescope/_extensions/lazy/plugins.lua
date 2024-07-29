if not pcall(require, "lazy") then
  error("This extension requires 'lazy.nvim'. (https://github.com/folke/lazy.nvim)")
end

local lazy_config = require("lazy.core.config")
local utils = require("telescope._extensions.lazy.utils")

local M = {}

--- Scans the target path directory for README files since they can have many different extensions.
---@param path string: The path to the plugin's directory.
---@return string|nil: The full path to the README file.
local function find_readme(path)
  local readme = nil

  local handle = vim.loop.fs_scandir(path)
  while handle do
    local name, type = vim.loop.fs_scandir_next(handle)
    if not name then
      break
    end
    if type == "file" then
      local index = string.find(name, "%.")
      if index then
        local n = string.sub(name, 1, index - 1)
        if string.lower(n) == "readme" then
          readme = utils.join_paths(path, name)
          break
        end
      end
    end
  end

  return readme
end

--- Creates an internal representation of a LazyPlugin.
---@param lazy_plugin any: An instance of a LazyPlugin.
---@return Plugin: An internal representation of the LazyPlugin as a Plugin.
local function create_plugin_from_lazy(lazy_plugin)
  ---@type Plugin
  ---@diagnostic disable-next-line: missing-fields
  local plugin = {}

  plugin.path = lazy_plugin.dir
  plugin.name = lazy_plugin.name
  plugin.readme = find_readme(plugin.path)
  plugin.url = lazy_plugin.url
  plugin.lazy = lazy_plugin.lazy
  plugin.icon = ""

  -- Use LazyPluginState `_` for determining whether the plugin is `dev` or not, instead of the `dev` field.
  -- This also accounts for plugins that use the `dir` option in their plugin specification.
  plugin.dev = lazy_plugin._.is_local

  return plugin
end

--- Returns a table describing the plugins installed via the lazy package manager.
---@return table<Plugin>: A table containing information about installed plugins.
function M.plugins()
  ---@type table<Plugin>
  local plugins = {}

  for _, lazy_plugin in pairs(lazy_config.plugins) do
    local plugin = create_plugin_from_lazy(lazy_plugin)
    table.insert(plugins, plugin)
  end

  return plugins
end

return M
