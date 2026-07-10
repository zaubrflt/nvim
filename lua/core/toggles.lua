-- Runtime UI toggles via native Neovim APIs (no snacks.nvim).
-- Format-on-save still starts disabled; see lua/plugins/format.lua.

local map = vim.keymap.set

-- Smooth scroll defaults on; neoscroll mappings honor this flag.
vim.g.user_smooth_scroll = true

local function notify(name, enabled)
  vim.notify(string.format('%s %s', name, enabled and 'enabled' or 'disabled'), vim.log.levels.INFO)
end

local function toggle_wo(option, name)
  local win = vim.api.nvim_get_current_win()
  local new = not vim.api.nvim_get_option_value(option, { win = win })
  vim.api.nvim_set_option_value(option, new, { win = win })
  notify(name, new)
end

map('n', '<leader>ur', function()
  toggle_wo('relativenumber', 'Relative number')
end, { desc = 'Toggle relative number' })

map('n', '<leader>uw', function()
  toggle_wo('wrap', 'Wrap')
end, { desc = 'Toggle wrap' })

map('n', '<leader>us', function()
  toggle_wo('spell', 'Spell')
end, { desc = 'Toggle spell' })

map('n', '<leader>ud', function()
  local enabled = vim.diagnostic.is_enabled()
  vim.diagnostic.enable(not enabled)
  notify('Diagnostics', not enabled)
end, { desc = 'Toggle diagnostics' })

map('n', '<leader>uh', function()
  local bufnr = vim.api.nvim_get_current_buf()
  local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr })
  vim.lsp.inlay_hint.enable(not enabled, { bufnr = bufnr })
  notify('Inlay hints', not enabled)
end, { desc = 'Toggle inlay hints' })

map('n', '<leader>uf', function()
  vim.g.user_format_on_save = not vim.g.user_format_on_save
  notify('Format on save', vim.g.user_format_on_save)
end, { desc = 'Toggle format on save' })

map('n', '<leader>uS', function()
  vim.g.user_smooth_scroll = not vim.g.user_smooth_scroll
  notify('Smooth scroll', vim.g.user_smooth_scroll)
end, { desc = 'Toggle smooth scroll' })
