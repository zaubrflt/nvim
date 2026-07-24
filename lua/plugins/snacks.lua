-- snacks.nvim - UX hub aligned with LazyVim module set (not LazyVim deps).
-- Setup early so Snacks.* is available to bufferline / toggles / picker keymaps.

local ok, snacks = pcall(require, 'snacks')
if not ok then
  vim.notify('snacks.nvim not installed yet.', vim.log.levels.WARN)
  return
end

snacks.setup({
  bigfile = { enabled = true },
  quickfile = { enabled = true },
  dashboard = { enabled = false },
  explorer = { enabled = true },
  indent = { enabled = true },
  input = { enabled = true },
  notifier = { enabled = true },
  picker = { enabled = true },
  scope = { enabled = true },
  scroll = { enabled = true },
  statuscolumn = { enabled = false },
  words = { enabled = true },
})

local map = vim.keymap.set

-- Explorer (replaces nvim-tree).
map('n', '<leader>e', function()
  snacks.explorer()
end, { desc = 'File tree: toggle' })
map('n', '<leader>fe', function()
  snacks.explorer.reveal()
end, { desc = 'File tree: locate current file' })

-- Terminal (replaces toggleterm). Float / split via win.position.
-- Snacks keys terminals by cmd/cwd/env/count — give each layout its own
-- count so <leader>th/tv do not reuse the floating terminal instance.
local function term_toggle(opts)
  return function()
    snacks.terminal.toggle(nil, opts)
  end
end

map({ 'n', 't' }, '<C-\\>', term_toggle({ win = { position = 'float' }, count = 1 }), {
  desc = 'Terminal: toggle floating',
})
map({ 'n', 't' }, '<leader>tf', term_toggle({ win = { position = 'float' }, count = 1 }), {
  desc = 'Terminal: floating',
})
map({ 'n', 't' }, '<leader>th', term_toggle({ win = { position = 'bottom' }, count = 2 }), {
  desc = 'Terminal: horizontal split',
})
map({ 'n', 't' }, '<leader>tv', term_toggle({ win = { position = 'right' }, count = 3 }), {
  desc = 'Terminal: vertical split',
})
map({ 'n', 't' }, '<leader>tt', term_toggle({ win = { position = 'float' }, count = 1 }), {
  desc = 'Terminal: toggle default',
})

-- Leave snacks terminal splits with the same keys as normal windows.
vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('user_snacks_terminal_keys', { clear = true }),
  pattern = 'snacks_terminal',
  callback = function()
    local opts = { buffer = true }
    vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
    vim.keymap.set('t', 'jk', [[<C-\><C-n>]], opts)
    vim.keymap.set('t', '<C-h>', [[<C-\><C-n><C-w>h]], opts)
    vim.keymap.set('t', '<C-j>', [[<C-\><C-n><C-w>j]], opts)
    vim.keymap.set('t', '<C-k>', [[<C-\><C-n><C-w>k]], opts)
    vim.keymap.set('t', '<C-l>', [[<C-\><C-n><C-w>l]], opts)
  end,
})

-- Lazygit (replaces lazygit.nvim). Requires system `lazygit` on PATH.
if vim.fn.executable('lazygit') == 1 then
  map('n', '<leader>gg', function()
    snacks.lazygit()
  end, { desc = 'Git: lazygit (cwd)' })
  map('n', '<leader>gG', function()
    local file = vim.api.nvim_buf_get_name(0)
    local cwd = (file ~= '' and vim.fn.fnamemodify(file, ':h')) or vim.fn.getcwd()
    snacks.lazygit({ cwd = cwd })
  end, { desc = 'Git: lazygit (current file dir)' })
  map('n', '<leader>gl', function()
    snacks.lazygit.log()
  end, { desc = 'Git: lazygit log (repo)' })
  map('n', '<leader>gL', function()
    snacks.lazygit.log_file()
  end, { desc = 'Git: lazygit log (file)' })
else
  vim.notify(
    'lazygit binary not found on PATH; <leader>g lazygit keymaps will be inert. '
      .. 'Install via your OS package manager or https://github.com/jesseduffield/lazygit.',
    vim.log.levels.WARN
  )
end

-- LSP reference words navigation.
map({ 'n', 't' }, ']]', function()
  snacks.words.jump(vim.v.count1)
end, { desc = 'Next reference' })
map({ 'n', 't' }, '[[', function()
  snacks.words.jump(-vim.v.count1)
end, { desc = 'Prev reference' })

-- Notifier history / dismiss.
map('n', '<leader>n', function()
  snacks.notifier.show_history()
end, { desc = 'Notification history' })
map('n', '<leader>un', function()
  snacks.notifier.hide()
end, { desc = 'Dismiss notifications' })

-- Phase D extras (dashboard stays disabled).
map({ 'n', 'x' }, '<leader>go', function()
  snacks.gitbrowse()
end, { desc = 'Git: browse' })
map('n', '<leader>cR', function()
  snacks.rename.rename_file()
end, { desc = 'Rename file' })
map('n', '<leader>.', function()
  snacks.scratch()
end, { desc = 'Toggle scratch buffer' })
map('n', '<leader>u.', function()
  snacks.scratch.select()
end, { desc = 'Select scratch buffer' })
