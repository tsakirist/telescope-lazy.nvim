local has_telescope, telescope = pcall(require, "telescope")
if not has_telescope then
  error("This extension requires 'telescope.nvim'. (https://github.com/nvim-telescope/telescope.nvim)")
end

local config = require("telescope._extensions.lazy.config")
local picker = require("telescope._extensions.lazy.picker")

return telescope.register_extension({
  setup = config.setup,
  exports = {
    lazy = picker.lazy_plugins_picker,
  },
})
