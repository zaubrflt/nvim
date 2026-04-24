# LazyVim Config Starter

This repository is a personal Neovim starter built on top of [LazyVim](https://github.com/LazyVim/LazyVim).

## Highlights

- Uses `nordic.nvim` as the default colorscheme.
- Keeps `gruvbox-material`, `kanagawa.nvim`, and `nightfox.nvim` installed for manual switching.
- Applies a color column for C/C++ filetypes.
- Reads `.clang-format` to derive indentation for C/C++ projects.

## Themes

The default theme is `nordic`.

Installed themes can be switched with `:colorscheme`:

- `:colorscheme nordic`
- `:colorscheme gruvbox-material`
- `:colorscheme kanagawa`
- `:colorscheme nightfox`

## Custom Keymaps

In addition to the default LazyVim keymaps, this config defines:

- `<leader>th`: toggle LSP inlay hints for the current buffer
- `<leader>td`: toggle diagnostics display, including virtual text, signs, and underline

## Notes

- Plugin versions are pinned in `lazy-lock.json`.
- Custom plugin specs live under `lua/plugins`.
- Core LazyVim bootstrap and defaults are configured in `lua/config/lazy.lua`.
