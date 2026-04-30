-- trouble.nvim v3 - pretty diagnostics / LSP references / quickfix list.
-- v3 uses `:Trouble {mode} {action}` syntax; do NOT use the legacy v2 commands.

local ok, trouble = pcall(require, 'trouble')
if not ok then
  vim.notify('trouble.nvim not installed yet.', vim.log.levels.WARN)
  return
end

trouble.setup({
  modes = {
    -- Buffer-scoped diagnostics shortcut, useful when the buffer is huge.
    buf_diagnostics = {
      mode = 'diagnostics',
      filter = { buf = 0 },
      title = 'Diagnostics (buffer)',
    },
  },
  -- Use simple ASCII icons; keep the config Nerd-Font-optional.
  icons = {
    indent = {
      top  = '│ ', middle = '├╴', last = '└╴',
      fold_open = ' ', fold_closed = ' ',
      ws = '  ',
    },
    folder_closed = ' ', folder_open = ' ',
    kinds = {},
  },
  use_diagnostic_signs = false,
  win = { border = 'rounded' },
})

local map = vim.keymap.set
map('n', '<leader>xx', '<cmd>Trouble diagnostics toggle<cr>',                          { desc = 'Trouble: workspace diagnostics' })
map('n', '<leader>xX', '<cmd>Trouble buf_diagnostics toggle<cr>',                      { desc = 'Trouble: buffer diagnostics' })
map('n', '<leader>xs', '<cmd>Trouble symbols toggle focus=false<cr>',                  { desc = 'Trouble: symbols (LSP)' })
map('n', '<leader>xl', '<cmd>Trouble lsp toggle focus=false win.position=right<cr>',   { desc = 'Trouble: LSP defs / refs / impls' })
map('n', '<leader>xL', '<cmd>Trouble loclist toggle<cr>',                              { desc = 'Trouble: location list' })
map('n', '<leader>xq', '<cmd>Trouble qflist toggle<cr>',                               { desc = 'Trouble: quickfix list' })
map('n', '<leader>xt', '<cmd>Trouble todo toggle<cr>',                                 { desc = 'Trouble: TODO comments' })

-- Navigate items inside a Trouble window, but also fall back to gracefully
-- jumping in the underlying buffer when the window is closed.
map('n', ']x', function()
  if trouble.is_open() then trouble.next({ skip_groups = true, jump = true })
  else vim.diagnostic.jump({ count = 1, float = true }) end
end, { desc = 'Trouble: next item / next diagnostic' })
map('n', '[x', function()
  if trouble.is_open() then trouble.prev({ skip_groups = true, jump = true })
  else vim.diagnostic.jump({ count = -1, float = true }) end
end, { desc = 'Trouble: prev item / prev diagnostic' })
