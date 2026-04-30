-- Neovim 0.12+ configuration entry point.
-- Keep this file minimal: just set leader keys and require modules.

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

require('core.options')
require('core.keymaps')
require('core.autocmds')
require('plugins')
