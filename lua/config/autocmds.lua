-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

require("config.clang_indent").setup()

local c_family_group = vim.api.nvim_create_augroup("c_family_settings", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
  group = c_family_group,
  pattern = { "c", "cpp" },
  callback = function()
    vim.opt_local.colorcolumn = "80"
  end,
})

for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
  if vim.api.nvim_buf_is_loaded(bufnr) then
    local filetype = vim.bo[bufnr].filetype
    if filetype == "c" or filetype == "cpp" then
      vim.bo[bufnr].colorcolumn = "80"
    end
  end
end
