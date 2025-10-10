---@class TelescopeLazy.Config
---@field icon? string The icon to show on the first column of the picker.
---@field show_icon? boolean Whether or not to show the icon in the first column of the picker.
---@field mappings? TelescopeLazy.Mappings Mappings for the picker actions.
---@field actions_opts? TelescopeLazy.ActionsOpts Configuration options for the picker actions.
---@field terminal_opts? vim.api.keyset.win_config Configuration for the terminal window action.
---@field custom_actions? table<string, TelescopeLazy.CustomAction> Custom actions to be added to the picker.
---@field theme? TelescopeLazy.Theme The Telescope theme to use for the picker.

---@alias TelescopeLazy.CustomAction fun(prompt_bufnr: integer, selected_entry: TelescopeLazy.Plugin)
---@alias TelescopeLazy.Theme "dropdown" | "cursor" |"ivy"

---@class TelescopeLazy.Mappings
---@field open_in_browser? string
---@field open_in_file_browser? string
---@field open_in_find_files? string
---@field open_in_live_grep? string
---@field open_in_terminal? string
---@field open_plugins_picker? string
---@field open_lazy_root_find_files? string
---@field open_lazy_root_live_grep? string
---@field change_cwd_to_plugin? string

---@class TelescopeLazy.ActionOpts
---@field auto_close? boolean Automatically close the telescope window after the action is executed.

---@class TelescopeLazy.ActionsOpts
---@field open_in_browser TelescopeLazy.ActionOpts
---@field change_cwd_to_plugin TelescopeLazy.ActionOpts

---@class TelescopeLazy.Plugin
---@field path string
---@field name string
---@field readme string|nil
---@field url string
---@field lazy boolean
---@field dev boolean
