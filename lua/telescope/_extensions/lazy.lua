local has_telescope, telescope = pcall(require, "telescope")
if not has_telescope then
  error("This extension requires 'telescope.nvim'. (https://github.com/nvim-telescope/telescope.nvim)")
end

local telescope_lazy_config = require("telescope._extensions.lazy.config")
local telescope_lazy_picker = require("telescope._extensions.lazy.picker")

return telescope.register_extension({
  setup = telescope_lazy_config.setup,
  exports = {
    lazy = telescope_lazy_picker.lazy_plugins_picker,
  },
})
