-- todo-comments.nvim - highlight TODO/FIXME/HACK/NOTE/WARN/PERF in comments,
-- and provide jump / search helpers backed by Trouble or snacks.picker.

local ok, todo = pcall(require, 'todo-comments')
if not ok then
  vim.notify('todo-comments.nvim not installed yet.', vim.log.levels.WARN)
  return
end

todo.setup({
  signs = true,
  sign_priority = 8,
  keywords = {
    FIX  = { icon = 'F', color = 'error',   alt = { 'FIXME', 'BUG', 'ISSUE' } },
    TODO = { icon = 'T', color = 'info' },
    HACK = { icon = 'H', color = 'warning' },
    WARN = { icon = 'W', color = 'warning', alt = { 'WARNING', 'XXX' } },
    PERF = { icon = 'P', color = 'default', alt = { 'OPTIM', 'PERFORMANCE', 'OPTIMIZE' } },
    NOTE = { icon = 'N', color = 'hint',    alt = { 'INFO' } },
    TEST = { icon = '?', color = 'test',    alt = { 'TESTING', 'PASSED', 'FAILED' } },
  },
  highlight = {
    -- Plain text in source comments; signs and keyword colours are enough
    -- without colouring the body too.
    comments_only = true,
    multiline = false,
    keyword = 'wide',
    after = 'fg',
  },
})

local map = vim.keymap.set

-- Jump between todo items in the current buffer.
map('n', ']t', function() todo.jump_next() end, { desc = 'Next TODO comment' })
map('n', '[t', function() todo.jump_prev() end, { desc = 'Prev TODO comment' })

-- Workspace-level search via snacks picker grep over TODO/FIXME keywords.
map('n', '<leader>ft', function()
  Snacks.picker.grep({
    search = [[\b(TODO|FIXME|HACK|WARN|WARNING|PERF|NOTE|FIX|BUG|ISSUE|XXX|OPTIM|TEST)\b]],
    args = { '--glob', '!.git/' },
  })
end, { desc = 'Find: TODO / FIXME (workspace)' })

-- Send TODOs to Trouble (already wired in trouble.lua via <leader>xt).
