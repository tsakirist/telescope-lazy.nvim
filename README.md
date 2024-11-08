# telescope-lazy.nvim

[Telescope](https://github.com/nvim-telescope/telescope.nvim) extension that
provides handy functionality about plugins installed via
[lazy.nvim](https://github.com/folke/lazy.nvim).

## Demo

[Telescope-lazy-demo-new.webm](https://github.com/user-attachments/assets/416a928f-c13f-4e98-9365-c1173a3fa4ff)

## Dependencies

Required:

- [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)
- [lazy.nvim](https://github.com/folke/lazy.nvim)

Optional:

- [telescope-file-browser.nvim](https://github.com/nvim-telescope/telescope-file-browser.nvim)
- [telescope-egrepify.nvim](https://github.com/fdschmidt93/telescope-egrepify.nvim)

## Installation

### Lazy

```lua
{ "nvim-telescope/telescope.nvim", dependencies = "tsakirist/telescope-lazy.nvim" }
```

## Configuration

Example setup:

```lua
require("telescope").setup({
  extensions = {
    -- Type information can be loaded via 'https://github.com/folke/lazydev.nvim'
    -- by adding the below two annotations:
    ---@module "telescope._extensions.lazy"
    ---@type TelescopeLazy.Config
    lazy = {
      -- Optional theme (the extension doesn't set a default theme)
      theme = "ivy",
      -- The below configuration options are the defaults
      show_icon = true,
      mappings = {
        open_in_browser = "<C-o>",
        open_in_file_browser = "<M-b>",
        open_in_find_files = "<C-f>",
        open_in_live_grep = "<C-g>",
        open_in_terminal = "<C-t>",
        open_plugins_picker = "<C-b>",
        open_lazy_root_find_files = "<C-r>f",
        open_lazy_root_live_grep = "<C-r>g",
        change_cwd_to_plugin = "<C-c>d",
      },
      actions_opts = {
        open_in_browser = {
          auto_close = false,
        },
        change_cwd_to_plugin = {
          auto_close = false,
        },
      },
      terminal_opts = {
        relative = "editor",
        style = "minimal",
        border = "rounded",
        title = "Telescope lazy",
        title_pos = "center",
        width = 0.5,
        height = 0.5,
      },
      -- Other telescope configuration options
    },
  },
})

require("telescope").load_extension("lazy")
```

<details>
    <summary>Default settings</summary>

```lua
---@type TelescopeLazy.Config
local defaults = {
  -- Whether or not to show the icon in the first column
  show_icon = true,
  -- Mappings for the actions
  mappings = {
    open_in_browser = "<C-o>",
    open_in_file_browser = "<M-b>",
    open_in_find_files = "<C-f>",
    open_in_live_grep = "<C-g>",
    open_in_terminal = "<C-t>",
    open_plugins_picker = "<C-b>", -- Works only after having called first another action
    open_lazy_root_find_files = "<C-r>f",
    open_lazy_root_live_grep = "<C-r>g",
    change_cwd_to_plugin = "<C-c>d",
  },
  -- Extra configuration options for the actions
  actions_opts = {
    open_in_browser = {
      -- Close the telescope window after the action is executed
      auto_close = false,
    },
    change_cwd_to_plugin = {
      -- Close the telescope window after the action is executed
      auto_close = false,
    },
  },
  -- Configuration that will be passed to the window that hosts the terminal
  -- For more configuration options check 'nvim_open_win()'
  terminal_opts = {
    relative = "editor",
    style = "minimal",
    border = "rounded",
    title = "Telescope lazy",
    title_pos = "center",
    width = 0.5,
    height = 0.5,
  },
}
```

</details>

<details>
    <summary>Types</summary>

```lua
---@class TelescopeLazy.Config
---@field show_icon? boolean Whether or not to show the icon in the first column of the picker.
---@field mappings? TelescopeLazy.Mappings Mappings for the picker actions.
---@field actions_opts? TelescopeLazy.ActionsOpts Configuration options for the picker actions.
---@field terminal_opts? vim.api.keyset.win_config Configuration for the terminal window action.
---@field theme? TelescopeLazy.Theme The Telescope theme to use for the picker.

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
```

</details>

## Commands

`:Telescope lazy`

## Mappings

| Mappings | Action                                                                        |
| -------- | ----------------------------------------------------------------------------- |
| `<C-o>`  | Open selected plugin repository in browser                                    |
| `<M-b>`  | Open selected plugin with file-browser                                        |
| `<C-f>`  | Open selected plugin with find files                                          |
| `<C-g>`  | Open selected plugin with live grep (will use `egrepify` if installed)        |
| `<C-t>`  | Open selected plugin in a terminal                                            |
| `<C-b>`  | Open lazy plugins picker, works only after having called first another action |
| `<C-r>f` | Open lazy root with find files                                                |
| `<C-r>g` | Open lazy root with live grep (will use `egrepify` if installed)              |
| `<C-c>d` | Change the current working directory to the path of the selected plugin       |

## Acknowledgments

This extension is heavily inspired by
[telescope-packer](https://github.com/nvim-telescope/telescope-packer.nvim).
