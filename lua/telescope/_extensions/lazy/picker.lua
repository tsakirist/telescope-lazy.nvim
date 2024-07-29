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
      { entry.value.name },
      { entry.value.lazy and "(lazy)" or "(start)", "Comment" },
      { entry.value.dev and "(dev)" or "", "Comment" },
    }

    if opts.show_icon then
      table.insert(display, 1, { entry.value.icon, "SpecialChar" })
    end

    return displayer()(display)
  end

  local function previewer()
    return previewers.new_buffer_previewer({
      title = "[ Readme ]",
      dyn_title = function(_, entry)
        return "[ " .. entry.value.name .. " ]"
      end,
      define_preview = function(self, entry, status)
        if not entry.value.readme then
          return
        end
        vim.api.nvim_set_option_value("wrap", true, { win = status.preview_win })
        config.buffer_previewer_maker(entry.value.readme, self.state.bufnr, {
          winid = self.state.winid,
        })
      end,
    })
  end

  local function finder()
    return finders.new_table({
      results = telescope_lazy_plugins,
      entry_maker = function(entry)
        return {
          value = entry,
          ordinal = entry.name,
          display = make_display,
        }
      end,
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
      previewer = previewer(),
      attach_mappings = attach_mappings,
    })
    :find()
end

return M
