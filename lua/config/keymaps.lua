-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- 切换 LSP inlay hints 显示状态
vim.keymap.set("n", "<leader>th", function()
  local bufnr = vim.api.nvim_get_current_buf()
  local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr })
  vim.lsp.inlay_hint.enable(not enabled, { bufnr = bufnr })
  print("Inlay hints " .. (not enabled and "enabled" or "disabled"))
end, { desc = "Toggle Inlay Hints" })

vim.keymap.set("n", "<leader>td", function()
  local config = vim.diagnostic.config()
  local new_state = not config.virtual_text
  vim.diagnostic.config({
    virtual_text = new_state,
    signs = new_state,
    underline = new_state,
  })
  vim.notify("Diagnostics " .. (new_state and "enabled" or "disabled"))
end, { desc = "Toggle diagnostics" })

