local M = {}

local actions = require("telescope.actions")
local actions_state = require("telescope.actions.state")
local builtin = require("telescope.builtin")

local telescope_lazy_config = require("telescope._extensions.lazy.config")
local lazy_options = require("lazy.core.config").options

local function attach_mappings(_, map)
  map({ "i", "n" }, telescope_lazy_config.opts.mappings.open_plugins_picker, function()
    builtin.resume()
  end)
  return true
end

function M.open_in_browser()
  local open_cmd
  if vim.fn.executable("xdg-open") == 1 then
    open_cmd = "xdg-open"
  elseif vim.fn.executable("explorer") == 1 then
    open_cmd = "explorer"
  elseif vim.fn.executable("open") == 1 then
    open_cmd = "open"
  elseif vim.fn.executable("wslview") == 1 then
    open_cmd = "wslview"
  end

  if not open_cmd then
    vim.notify(
      "Open in browser is not supported by your operating system.",
      vim.log.levels.ERROR,
      { title = telescope_lazy_config.extension_name }
    )
  else
    local selected_entry = actions_state.get_selected_entry()
    local ret = vim.fn.jobstart({ open_cmd, selected_entry.url }, { detach = true })
    if ret <= 0 then
      vim.notify(
        string.format("Failed to open '%s'\nwith command: '%s' (ret: '%d')", selected_entry.url, open_cmd, ret),
        vim.log.levels.ERROR,
        { title = telescope_lazy_config.extension_name }
      )
    end
  end
end

function M.open_lazy_root_find_files()
  builtin.find_files({
    prompt_title = "Find files in lazy root",
    cwd = lazy_options.root,
    attach_mappings = attach_mappings,
  })
end

function M.open_lazy_root_live_grep()
  builtin.live_grep({
    prompt_title = "Grep files in lazy root",
    cwd = lazy_options.root,
    attach_mappings = attach_mappings,
  })
end

function M.open_in_find_files()
  local selected_entry = actions_state.get_selected_entry()
  builtin.find_files({
    prompt_title = string.format("Find files (%s)", selected_entry.name),
    cwd = selected_entry.path,
    attach_mappings = attach_mappings,
  })
end

function M.open_in_live_grep()
  local selected_entry = actions_state.get_selected_entry()
  builtin.live_grep({
    prompt_title = string.format("Grep files (%s)", selected_entry.name),
    cwd = selected_entry.path,
    attach_mappings = attach_mappings,
  })
end

function M.open_in_file_browser()
  local ok, file_browser = pcall(require, "telescope._extensions.file_browser")
  if not ok then
    vim.notify(
      "This action requires 'telescope-file-browser.nvim'. (https://github.com/nvim-telescope/telescope-file-browser.nvim)",
      vim.log.levels.ERROR,
      { title = telescope_lazy_config.extension_name }
    )
    return
  end
  local selected_entry = actions_state.get_selected_entry()
  file_browser.exports.file_browser({
    prompt_title = string.format("File browser (%s)", selected_entry.name),
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
        { title = telescope_lazy_config.extension_name }
      )
    end
  end)
end

return M
