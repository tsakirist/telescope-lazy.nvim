local M = {}

local actions = require("telescope.actions")
local actions_state = require("telescope.actions.state")
local builtin = require("telescope.builtin")
local state = require("telescope.state")

local config = require("telescope._extensions.lazy.config")

M.cached_search_plugins_picker = nil

local function cache_search_plugins_picker()
  local cached_pickers = state.get_global_key("cached_pickers") or {}
  M.cached_search_plugins_picker = cached_pickers[1]
end

local function attach_mappings(_, map)
  local function open_plugins_picker()
    builtin.resume({ picker = M.cached_search_plugins_picker })
  end

  for _, mode in ipairs({ "i", "n" }) do
    map(mode, config.opts.mappings.open_plugins_picker, open_plugins_picker)
  end

  return true
end

function M.open_in_browser()
  local os = vim.loop.os_uname().sysname
  local open_cmd
  if os == "Linux" then
    open_cmd = "xdg-open"
  elseif os == "Windows" then
    open_cmd = "explorer"
  elseif os == "Darwin" then
    open_cmd = "open"
  end

  if not open_cmd then
    vim.notify(
      ("Open in browser is not supported by your operating system. (os: %s)"):format(os),
      vim.log.levels.ERROR,
      { title = config.extension_name }
    )
  else
    local selected_entry = actions_state.get_selected_entry()
    local ret = vim.fn.jobstart(open_cmd .. " " .. selected_entry.url, { detach = true })
    if ret <= 0 then
      vim.notify(
        string.format("Failed to open '%s'\nwith command: '%s' (ret: %d)", selected_entry.url, open_cmd, ret),
        vim.log.levels.ERROR,
        { title = config.extension_name }
      )
    end
  end
end

function M.open_in_find_files()
  local selected_entry = actions_state.get_selected_entry()
  cache_search_plugins_picker()
  builtin.find_files({
    prompt_title = string.format("Find files (%s)", selected_entry.name),
    cwd = selected_entry.path,
    attach_mappings = attach_mappings,
  })
end

function M.open_in_live_grep()
  local selected_entry = actions_state.get_selected_entry()
  cache_search_plugins_picker()
  builtin.live_grep({
    prompt_title = string.format("Grep files (%s)", selected_entry.name),
    cwd = selected_entry.path,
    attach_mappings = attach_mappings,
  })
end

function M.default_action_replace(prompt_bufnr)
  actions.select_default:replace(function()
    local selected_entry = actions_state.get_selected_entry()
    if selected_entry.readme then
      actions.close(prompt_bufnr)
      vim.cmd.edit(selected_entry.readme)
    else
      vim.notify(
        "Could not perform action. Readme file doesn't exist.",
        vim.log.levels.ERROR,
        { title = config.extension_name }
      )
    end
  end)
end

return M
