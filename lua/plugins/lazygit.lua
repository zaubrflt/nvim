-- lazygit.nvim - thin wrapper that opens the system `lazygit` TUI in a
-- floating Neovim terminal. Complements gitsigns: gitsigns owns the buffer-
-- level git info, lazygit owns repository-wide operations (commit, rebase,
-- branch, merge conflict, stash, push/pull, …).
--
-- Hard requirement: `lazygit` binary on $PATH. See README for install.

if vim.fn.executable('lazygit') == 0 then
  vim.notify(
    'lazygit binary not found on PATH; <leader>g lazygit keymaps will be inert. '
      .. 'Install via your OS package manager or https://github.com/jesseduffield/lazygit.',
    vim.log.levels.WARN
  )
  return
end

-- Smaller floating window than the default 0.9 to leave the surrounding
-- buffer visible (useful when commit-amend'ing while comparing files).
vim.g.lazygit_floating_window_scaling_factor = 0.92
vim.g.lazygit_floating_window_border_chars   = { '╭', '─', '╮', '│', '╯', '─', '╰', '│' }
vim.g.lazygit_floating_window_use_plenary    = 0      -- avoid optional plenary dep
vim.g.lazygit_use_neovim_remote              = 1      -- only honored if nvr is on PATH

local map = vim.keymap.set
map('n', '<leader>gg', '<cmd>LazyGit<cr>',          { desc = 'Git: lazygit (repo)' })
map('n', '<leader>gG', '<cmd>LazyGitCurrentFile<cr>',{ desc = 'Git: lazygit (current file repo)' })
map('n', '<leader>gl', '<cmd>LazyGitFilter<cr>',    { desc = 'Git: lazygit log (repo)' })
map('n', '<leader>gL', '<cmd>LazyGitFilterCurrentFile<cr>', { desc = 'Git: lazygit log (file)' })
