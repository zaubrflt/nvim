-- General keymaps that don't depend on any plugin.

local map = vim.keymap.set

-- Quick save & quit.
map('n', '<leader>w', '<cmd>write<cr>', { desc = 'Save file' })
map('n', '<leader>q', '<cmd>quit<cr>', { desc = 'Quit window' })
map('n', '<leader>Q', '<cmd>qa!<cr>', { desc = 'Force quit all' })

-- Clear search highlight.
map('n', '<esc>', '<cmd>nohlsearch<cr>', { desc = 'Clear search highlight' })

-- Window navigation: <C-h/j/k/l> is owned by lua/plugins/splits.lua
-- (smart-splits) so the same keys traverse tmux / wezterm / kitty panes too.
-- <C-Up/Down/Left/Right> remain native window resizing.
map('n', '<leader>-', '<C-w>s', { desc = 'Split window below' })
map('n', '<leader>|', '<C-w>v', { desc = 'Split window right' })
map('n', '<C-Up>', '<cmd>resize +2<cr>', { desc = 'Resize up' })
map('n', '<C-Down>', '<cmd>resize -2<cr>', { desc = 'Resize down' })
map('n', '<C-Left>', '<cmd>vertical resize -2<cr>', { desc = 'Resize left' })
map('n', '<C-Right>', '<cmd>vertical resize +2<cr>', { desc = 'Resize right' })

-- Buffer navigation.
map('n', '<S-l>', '<cmd>bnext<cr>', { desc = 'Next buffer' })
map('n', '<S-h>', '<cmd>bprevious<cr>', { desc = 'Prev buffer' })
map('n', '<leader>bd', '<cmd>bdelete<cr>', { desc = 'Delete buffer' })

-- Stay in visual mode after indent.
map('v', '<', '<gv', { desc = 'Indent left' })
map('v', '>', '>gv', { desc = 'Indent right' })

-- Move selected lines.
map('v', 'J', ":m '>+1<cr>gv=gv", { desc = 'Move selection down' })
map('v', 'K', ":m '<-2<cr>gv=gv", { desc = 'Move selection up' })

-- Center cursor on search next.
map('n', 'n', 'nzzzv')
map('n', 'N', 'Nzzzv')

-- System clipboard helpers.
map({ 'n', 'v' }, '<leader>y', '"+y', { desc = 'Yank to system clipboard' })
map('n', '<leader>Y', '"+Y', { desc = 'Yank line to system clipboard' })
map({ 'n', 'v' }, '<leader>p', '"+p', { desc = 'Paste from system clipboard' })

-- Diagnostics (also re-bound on LspAttach but useful as global fallback).
map('n', '[d', function() vim.diagnostic.jump({ count = -1, float = true }) end, { desc = 'Prev diagnostic' })
map('n', ']d', function() vim.diagnostic.jump({ count = 1, float = true }) end, { desc = 'Next diagnostic' })
map('n', '<leader>cd', vim.diagnostic.open_float, { desc = 'Line diagnostics' })
map('n', '<leader>cl', vim.diagnostic.setloclist, { desc = 'Diagnostics to loclist' })
