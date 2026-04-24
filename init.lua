-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
require("config.clang_indent").setup()

-- Set the color column at column 80 for C-family files
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "c", "cpp" },
  callback = function()
    vim.opt_local.colorcolumn = "80"
  end,
})
