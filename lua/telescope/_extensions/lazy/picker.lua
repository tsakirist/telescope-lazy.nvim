local config = require("telescope.config").values
local entry_display = require("telescope.pickers.entry_display")
local finders = require("telescope.finders")
local pickers = require("telescope.pickers")
local previewers = require("telescope.previewers")

local telescope_lazy_actions = require("telescope._extensions.lazy.actions")
local telescope_lazy_config = require("telescope._extensions.lazy.config")
local telescope_lazy_plugins = require("telescope._extensions.lazy.plugins").plugins()
local utils = require("telescope._extensions.lazy.utils")

local M = {}

function M.lazy_plugins_picker()
  local opts = telescope_lazy_config.opts

  local function displayer()
    local items = {
      { width = utils.max_plugin_name_length(telescope_lazy_plugins) },
      { width = 7 },
      { width = 5 },
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
      { entry.dev and "(dev)" or "", "Comment" },
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
      dev = entry.dev,
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

    local modes = { "n", "i" }
    for action, keymap in pairs(opts.mappings) do
      if keymap ~= "" and telescope_lazy_actions[action] ~= nil then
        map(modes, keymap, telescope_lazy_actions[action])
      end
    end

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
