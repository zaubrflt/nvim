-- conform.nvim - lightweight formatter runner.
-- Format-on-save is INTENTIONALLY DISABLED per requirement 10.
-- Use <leader>fm to format manually.

local ok, conform = pcall(require, 'conform')
if not ok then
  vim.notify('conform.nvim not installed yet.', vim.log.levels.WARN)
  return
end

conform.setup({
  formatters_by_ft = {
    c = { 'clang_format' },
    cpp = { 'clang_format' },
    objc = { 'clang_format' },
    objcpp = { 'clang_format' },
    cuda = { 'clang_format' },
    rust = { 'rustfmt' },
    lua = { 'stylua' },
  },

  -- format_on_save is deliberately not set: requirement 10 asks for save-time
  -- auto-formatting to be OFF for the supported languages.

  default_format_opts = {
    lsp_format = 'fallback',
    timeout_ms = 3000,
  },

  formatters = {
    rustfmt = {
      prepend_args = { '--edition', '2021' },
    },
  },
})

local function format_buf()
  conform.format({ async = true, lsp_fallback = true })
end

vim.keymap.set({ 'n', 'v' }, '<leader>fm', format_buf, { desc = 'Format buffer (manual)' })

-- User commands to enable / disable autoformat-on-save at runtime, in case the
-- user opts in temporarily without editing this file.
vim.api.nvim_create_user_command('FormatEnable', function()
  vim.g.user_format_on_save = true
  vim.notify('Format-on-save enabled', vim.log.levels.INFO)
end, { desc = 'Enable autoformat on save' })

vim.api.nvim_create_user_command('FormatDisable', function()
  vim.g.user_format_on_save = false
  vim.notify('Format-on-save disabled', vim.log.levels.INFO)
end, { desc = 'Disable autoformat on save' })

vim.g.user_format_on_save = false

vim.api.nvim_create_autocmd('BufWritePre', {
  group = vim.api.nvim_create_augroup('user_conform_on_save', { clear = true }),
  callback = function(args)
    if not vim.g.user_format_on_save then return end
    conform.format({ bufnr = args.buf, lsp_fallback = true, timeout_ms = 3000 })
  end,
})
