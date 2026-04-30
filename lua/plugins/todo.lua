-- todo-comments.nvim - highlight TODO/FIXME/HACK/NOTE/WARN/PERF in comments,
-- and provide jump / search helpers backed by Trouble or fzf-lua.

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

-- Workspace-level search.
map('n', '<leader>ft', function()
  local ok_fzf, fzf = pcall(require, 'fzf-lua')
  if ok_fzf then
    -- todo-comments stores its keyword regex pattern in opts; reuse it via
    -- a live grep search against ripgrep so we get the full multi-keyword set.
    fzf.grep({
      search = [[\b(KEYWORDS):]],
      no_esc = true,
      rg_glob = false,
      rg_opts = '--hidden --column --line-number --no-heading --color=always '
        .. "-e [[:space:]]*(TODO|FIXME|HACK|WARN|PERF|NOTE|FIX|BUG|ISSUE|XXX|OPTIM|TEST)[[:space:]]*:?",
      prompt = 'TODO ❯ ',
    })
  else
    vim.cmd('TodoQuickFix')
  end
end, { desc = 'Find: TODO / FIXME (workspace)' })

-- Send TODOs to Trouble (already wired in trouble.lua via <leader>xt).
