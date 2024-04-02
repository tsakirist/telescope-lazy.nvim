local M = {}

local actions = require("telescope.actions")
local actions_state = require("telescope.actions.state")
local builtin = require("telescope.builtin")

local lazy_options = require("lazy.core.config").options
local telescope_lazy_config = require("telescope._extensions.lazy.config")
local telescope_lazy_terminal = require("telescope._extensions.lazy.terminal")

local function warn_no_selection_action()
  vim.notify(
    "Please make a valid selection before performing the action.",
    vim.log.levels.WARN,
    { title = telescope_lazy_config.extension_name }
  )
end

local function get_selected_entry()
  local selected_entry = actions_state.get_selected_entry()
  if not selected_entry then
    warn_no_selection_action()
  end
  return selected_entry
end

local function attach_mappings(_, map)
  map({ "n", "i" }, telescope_lazy_config.opts.mappings.open_plugins_picker, function()
    builtin.resume()
  end)
  return true
end

local live_grep = (function()
  local ok, egrepify = pcall(require, "telescope._extensions.egrepify")
  return ok and egrepify.exports.egrepify or builtin.live_grep
end)()

function M.change_cwd_to_plugin(prompt_bufnr)
  local selected_entry = get_selected_entry()
  if not selected_entry then
    return
  end

  if vim.fn.getcwd() == selected_entry.path then
    return
  end

  local ok, res = pcall(vim.cmd.cd, selected_entry.path)
  if ok then
    vim.notify(
      string.format("Changed cwd to: '%s'.", selected_entry.path),
      vim.log.levels.INFO,
      { title = telescope_lazy_config.extension_name }
    )
  else
    vim.notify(
      string.format("Could not change cwd to: '%s'.\nError: '%s'" .. selected_entry.path, res),
      vim.log.levels.ERROR,
      { title = telescope_lazy_config.extension_name }
    )
  end

  if telescope_lazy_config.opts.actions_opts.change_cwd_to_plugin.auto_close then
    actions.close(prompt_bufnr)
  end
end

function M.open_in_terminal()
  local selected_entry = get_selected_entry()
  if not selected_entry then
    return
  end

  local terminal = telescope_lazy_terminal.new()
  terminal:open(selected_entry.path, builtin.resume)
end

function M.open_in_browser(prompt_bufnr)
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
    local selected_entry = get_selected_entry()
    if not selected_entry then
      return
    end

    local ret = vim.fn.jobstart({ open_cmd, selected_entry.url }, { detach = true })
    if ret <= 0 then
      vim.notify(
        string.format("Failed to open '%s'\nwith command: '%s' (ret: '%d')", selected_entry.url, open_cmd, ret),
        vim.log.levels.ERROR,
        { title = telescope_lazy_config.extension_name }
      )
    end

    if telescope_lazy_config.opts.actions_opts.open_in_browser.auto_close then
      actions.close(prompt_bufnr)
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
  live_grep({
    prompt_title = "Grep files in lazy root",
    cwd = lazy_options.root,
    attach_mappings = attach_mappings,
  })
end

function M.open_in_find_files()
  local selected_entry = get_selected_entry()
  if not selected_entry then
    return
  end

  builtin.find_files({
    prompt_title = string.format("Find files (%s)", selected_entry.name),
    cwd = selected_entry.path,
    attach_mappings = attach_mappings,
  })
end

function M.open_in_live_grep()
  local selected_entry = get_selected_entry()
  if not selected_entry then
    return
  end

  live_grep({
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

  local selected_entry = get_selected_entry()
  if not selected_entry then
    return
  end

  file_browser.exports.file_browser({
    prompt_title = string.format("File browser (%s)", selected_entry.name),
    cwd = selected_entry.path,
    attach_mappings = attach_mappings,
  })
end

function M.default_action_replace(prompt_bufnr)
  actions.select_default:replace(function()
    local selected_entry = get_selected_entry()
    if not selected_entry then
      return
    end

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
