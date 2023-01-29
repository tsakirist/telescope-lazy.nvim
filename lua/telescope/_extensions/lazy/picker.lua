local M = {}

local config = require("telescope.config").values
local entry_display = require("telescope.pickers.entry_display")
local finders = require("telescope.finders")
local pickers = require("telescope.pickers")
local previewers = require("telescope.previewers")

local telescope_lazy_actions = require("telescope._extensions.lazy.actions")
local telescope_lazy_config = require("telescope._extensions.lazy.config")
local telescope_lazy_plugins = require("telescope._extensions.lazy.plugins").plugins()

local function get_max_plugin_name_width()
  local max_plugin_name_width = 0
  for _, plugin in ipairs(telescope_lazy_plugins) do
    if #plugin.name > max_plugin_name_width then
      max_plugin_name_width = #plugin.name
    end
  end
  return max_plugin_name_width
end

function M.lazy_plugins_picker()
  local opts = telescope_lazy_config.opts

  local function displayer()
    local items = {
      { width = get_max_plugin_name_width() },
      { remaining = true },
    }

    if opts.show_icon then
      table.insert(items, 1, { width = 2 })
    end

    return entry_display.create({
      separator = " ",
      items = items,
    })
  end

  local function make_display(entry)
    local display = {
      { entry.name },
      { entry.lazy and "(lazy)" or "(start)", "Comment" },
    }

    if opts.show_icon then
      table.insert(display, 1, { entry.icon, "SpecialChar" })
    end

    return displayer()(display)
  end

  local function previewer(entry, bufnr)
    if entry.readme then
      local readme = vim.fn.readfile(entry.readme)
      vim.api.nvim_buf_set_option(bufnr, "filetype", "markdown")
      vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, readme)
    end
  end

  local function entry_maker(entry)
    return {
      value = entry,
      name = entry.name,
      path = entry.path,
      readme = entry.readme,
      url = entry.url,
      lazy = entry.lazy,
      icon = entry.icon,
      ordinal = entry.name,
      display = make_display,
      preview_command = previewer,
    }
  end

  local function finder()
    return finders.new_table({
      results = telescope_lazy_plugins,
      entry_maker = entry_maker,
    })
  end

  local function attach_mappings(prompt_bufnr, map)
    telescope_lazy_actions.default_action_replace(prompt_bufnr)
    map({ "i", "n" }, opts.mappings.open_in_browser, telescope_lazy_actions.open_in_browser)
    map({ "i", "n" }, opts.mappings.open_in_file_browser, telescope_lazy_actions.open_in_file_browser)
    map({ "i", "n" }, opts.mappings.open_in_find_files, telescope_lazy_actions.open_in_find_files)
    map({ "i", "n" }, opts.mappings.open_in_live_grep, telescope_lazy_actions.open_in_live_grep)
    map({ "i", "n" }, opts.mappings.open_lazy_root_find_files, telescope_lazy_actions.open_lazy_root_find_files)
    map({ "i", "n" }, opts.mappings.open_lazy_root_live_grep, telescope_lazy_actions.open_lazy_root_live_grep)
    return true
  end

  pickers
    .new(opts, {
      prompt_title = "Search plugin",
      results_title = "Installed plugins",
      finder = finder(),
      sorter = config.file_sorter(opts),
      previewer = previewers.display_content.new(opts),
      attach_mappings = attach_mappings,
    })
    :find()
end

return M
