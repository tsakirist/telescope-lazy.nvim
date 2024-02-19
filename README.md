# telescope-lazy.nvim

[Telescope](https://github.com/nvim-telescope/telescope.nvim) extension that
provides handy functionality about plugins installed via
[lazy.nvim](https://github.com/folke/lazy.nvim).

## Demo

[Telescope-lazy-demo.webm](https://github.com/tsakirist/telescope-lazy.nvim/assets/20475201/d5f2a772-b45d-422f-b566-1d92359f7dba)

## Requirements

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
        open_in_file_browser = "<M-b>",
        open_in_find_files = "<C-f>",
        open_in_live_grep = "<C-g>",
        open_in_terminal = "<C-t>",
        open_plugins_picker = "<C-b>", -- Works only after having called first another action
        open_lazy_root_find_files = "<C-r>f",
        open_lazy_root_live_grep = "<C-r>g",
        change_cwd_to_plugin = "<C-c>d",
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
