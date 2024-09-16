local M = {}

local start = vim.health.start
local ok = vim.health.ok
local warn = vim.health.warn
local error = vim.health.error

---@class ExtensionPlugin
---@field name string
---@field module? string
---@field optional boolean

---@type table<ExtensionPlugin>
local plugins = {
  {
    name = "telescope",
    optional = false,
  },
  {
    name = "lazy",
    optional = false,
  },
  {
    name = "telescope-egrepify",
    module = "telescope._extensions.egrepify",
    optional = true,
  },
  {
    name = "telescope-file-browser",
    module = "telescope._extensions.file_browser",
    optional = true,
  },
}

---Checks the installation status of the specified plugin
---@param plugin ExtensionPlugin
local function check_plugin(plugin)
  local module = plugin.module or plugin.name
  local is_ok = pcall(require, module)
  if is_ok then
    ok(string.format("%s installed%s", plugin.name, plugin.optional and " (optional)" or ""))
  else
    local log = plugin.optional and warn or error
    log(string.format("%s not installed%s", plugin.name, plugin.optional and " (optional)" or ""))
  end
end

---Checks the installation status of all the plugins
local function check_plugins()
  start("Plugin installation status")
  for _, plugin in ipairs(plugins) do
    check_plugin(plugin)
  end
end

M.check = function()
  start("telescope-lazy.nvim")
  check_plugins()
end

return M
