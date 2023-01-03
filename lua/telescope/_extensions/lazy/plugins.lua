if not pcall(require, "lazy") then
  error("This extension requires 'lazy.nvim'. (https://github.com/folke/lazy.nvim)")
end

local lazy_config = require("lazy.core.config")
local util = require("telescope._extensions.lazy.utils")

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
          readme = util.join_paths(path, name)
          break
        end
      end
    end
  end

  return readme
end

---@alias Plugin {name:string, path: string, readme: string, url: string, lazy: boolean, icon: string}

--- Returns a table describing the plugins installed via the lazy package manager.
---@return table<Plugin>: A table with plugin properties.
function M.plugins()
  local plugins = {}

  for _, plugin in pairs(lazy_config.plugins) do
    local plugin_name = plugin.name
    local plugin_path = util.join_paths(lazy_config.options.root, plugin_name)
    local plugin_readme = find_readme(plugin_path)
    local plugin_url = plugin.url
    local plugin_lazy = plugin.lazy
    local plugin_icon = ""

    table.insert(plugins, {
      name = plugin_name,
      path = plugin_path,
      readme = plugin_readme,
      url = plugin_url,
      lazy = plugin_lazy,
      icon = plugin_icon,
    })
  end

  return plugins
end

return M
