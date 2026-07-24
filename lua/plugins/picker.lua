-- snacks.picker - fuzzy finder / select UI (replaces fzf-lua).
-- Keep this repo's <leader>f* prefix; semantics align with LazyVim pickers.

local ok = pcall(require, 'snacks')
if not ok then
  vim.notify('snacks.nvim not installed yet.', vim.log.levels.WARN)
  return
end

local map = vim.keymap.set

-- Files and content.
map('n', '<leader>ff', function() Snacks.picker.files() end, { desc = 'Find: files' })
map('n', '<leader>fg', function() Snacks.picker.grep() end, { desc = 'Find: live grep (cwd)' })
map('n', '<leader>fG', function() Snacks.picker.grep_buffers() end, { desc = 'Find: live grep (buffers)' })
map({ 'n', 'x' }, '<leader>fw', function() Snacks.picker.grep_word() end, {
  desc = 'Find: word / selection',
})
map('n', '<leader>fW', function()
  Snacks.picker.grep({ search = vim.fn.expand('<cWORD>') })
end, { desc = 'Find: WORD under cursor' })

-- Buffer / file history navigation.
map('n', '<leader>fb', function() Snacks.picker.buffers() end, { desc = 'Find: open buffers' })
map('n', '<leader>fr', function() Snacks.picker.recent() end, { desc = 'Find: recent files' })
map('n', '<leader>fl', function() Snacks.picker.lines() end, { desc = 'Find: lines (buffer)' })
map('n', '<leader>fL', function() Snacks.picker.grep_buffers() end, { desc = 'Find: lines (all buffers)' })

-- Help / keymap discovery.
map('n', '<leader>fh', function() Snacks.picker.help() end, { desc = 'Find: help tags' })
map('n', '<leader>fk', function() Snacks.picker.keymaps() end, { desc = 'Find: keymaps' })
map('n', '<leader>f:', function() Snacks.picker.command_history() end, { desc = 'Find: command history' })
map('n', '<leader>f/', function() Snacks.picker.search_history() end, { desc = 'Find: search history' })

-- LSP-backed pickers.
map('n', '<leader>fs', function() Snacks.picker.lsp_symbols() end, { desc = 'Find: document symbols' })
map('n', '<leader>fS', function() Snacks.picker.lsp_workspace_symbols() end, {
  desc = 'Find: workspace symbols',
})
map('n', '<leader>fd', function() Snacks.picker.lsp_definitions() end, { desc = 'Find: LSP definitions' })
map('n', '<leader>fR', function() Snacks.picker.lsp_references() end, { desc = 'Find: LSP references' })
map('n', '<leader>fi', function() Snacks.picker.lsp_implementations() end, {
  desc = 'Find: LSP implementations',
})
map('n', '<leader>fy', function() Snacks.picker.lsp_type_definitions() end, {
  desc = 'Find: LSP type defs',
})
map('n', '<leader>fa', function()
  -- Prefer LSP code action UI via vim.ui.select (wired to snacks picker).
  vim.lsp.buf.code_action()
end, { desc = 'Find: LSP code actions' })
map('n', '<leader>fD', function() Snacks.picker.diagnostics() end, {
  desc = 'Find: diagnostics (workspace)',
})

-- Git pickers (complement gitsigns + Snacks.lazygit).
map('n', '<leader>fgs', function() Snacks.picker.git_status() end, { desc = 'Find: git status' })
map('n', '<leader>fgc', function() Snacks.picker.git_log() end, { desc = 'Find: git commits (repo)' })
map('n', '<leader>fgC', function() Snacks.picker.git_log_file() end, {
  desc = 'Find: git commits (buffer)',
})
map('n', '<leader>fgb', function() Snacks.picker.git_branches() end, { desc = 'Find: git branches' })

-- Resume the last picker.
map('n', '<leader>f.', function() Snacks.picker.resume() end, { desc = 'Find: resume last picker' })
