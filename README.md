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

## Debugging Neovim

- `:messages`: show errors and warnings from the current Neovim session.
- `:checkhealth`: run Neovim and plugin health checks. Use scoped checks such as `:checkhealth lazy`, `:checkhealth lsp`, or `:checkhealth provider` when debugging a specific area.
- `:echo stdpath('log')`: print Neovim's log directory. The main log file is usually `~/.local/state/nvim/log`.
- `:lua print(vim.lsp.get_log_path())`: print the LSP log file path.
- `:lua vim.lsp.set_log_level('debug')`: enable verbose LSP logging before reproducing an LSP issue.
- `:Lazy log`: inspect lazy.nvim install, update, and plugin operation logs.
- `:Lazy profile`: inspect plugin startup cost and loading order.
- `nvim --clean`: start Neovim without this config to check whether an issue comes from the local setup.
- `nvim --headless '+checkhealth' '+qa'`: run health checks from the shell.

## Notes

- Plugin versions are pinned in `lazy-lock.json`.
- Custom plugin specs live under `lua/plugins`.
- Core LazyVim bootstrap and defaults are configured in `lua/config/lazy.lua`.
