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
{ "nvim-telescope/telescope.nvim", dependencies = "tsakirist/telescope-lazy.nvim" }
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
        open_plugins_picker = "<C-b>", -- Works only after having called first another action
        open_lazy_root_find_files = "<C-r>f",
        open_lazy_root_live_grep = "<C-r>g",
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

| Mappings | Action                                                                        |
| -------- | ----------------------------------------------------------------------------- |
| `<C-o>`  | Open selected plugin repository in browser                                    |
| `<C-f>`  | Open selected plugin with find files                                          |
| `<C-g>`  | Open selected plugin with live grep                                           |
| `<C-b>`  | Open lazy plugins picker, works only after having called first another action |
| `<C-r>f` | Open lazy root with find files                                                |
| `<C-r>g` | Open lazy root with live grep                                                 |

## Acknowledgments

This extension is heavily inspired by
[telescope-packer](https://github.com/nvim-telescope/telescope-packer.nvim).
