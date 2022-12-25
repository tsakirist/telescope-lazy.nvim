# telescope-lazy.nvim

[Telescope](https://github.com/nvim-telescope/telescope.nvim) extension that
provides handy functionality about plugins installed via
[lazy.nvim](https://github.com/folke/lazy.nvim).

## Demo

[Demo.webm](https://user-images.githubusercontent.com/20475201/209448481-84bbd8a5-9d42-46be-bc46-18a481803474.webm)


## Requirements

- [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)
- [lazy.nvim](https://github.com/folke/lazy.nvim)

## Installation

### Lazy

```lua
{ "tsakirist/telescope-lazy.nvim", dependencies = "nvim-telescope/telescope.nvim" }
```

## Configuration

The extension comes with the following defaults:

```lua
require("telescope").setup({
  extensions = {
    lazy = {
      -- Optional theme (the extension doesn't set a default theme)
      theme = "ivy",
      -- Whether or not to show the icon in the first column
      show_icon = true,
      -- Mappings for the actions
      mappings = {
        open_in_browser = "<C-o>",
        open_in_find_files = "<C-f>",
        open_in_live_grep = "<C-g>",
        open_plugins_picker = "<C-b>", -- Works only after having called first open_in_find_files or open_in_live_grep
      },
      -- Other telescope configuration options
    },
  },
})

require("telescope").load_extension "lazy"
```

## Available Commands

`:Telescope lazy`

## Available mappings

| Mappings | Action                                                                |
| -------- | --------------------------------------------------------------------- |
| `<C-o>`  | Open plugin repository in browser                                     |
| `<C-f>`  | Open plugin with find files                                           |
| `<C-g>`  | Open plugin with live grep                                            |
| `<C-b>`  | Open lazy plugins picker after having called first `<C-f>` or `<C-g>` |

## Acknowledgments

This extension is heavily inspired by
[telescope-packer](https://github.com/nvim-telescope/telescope-packer.nvim).
