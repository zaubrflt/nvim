-- resession.nvim - session management with named sessions and branch-scoped
-- auto-sessions. Replaces the older folke/persistence.nvim choice because
-- resession is what AstroNvim picked, and supports per-branch state which is
-- a big win in workflows that switch git branches frequently.

local ok, resession = pcall(require, 'resession')
if not ok then
  vim.notify('resession.nvim not installed yet.', vim.log.levels.WARN)
  return
end

resession.setup({
  -- Persist enough to recreate the workspace on next launch.
  options = {
    'binary', 'bufhidden', 'buflisted', 'cmdheight', 'diff', 'filetype',
    'modifiable', 'previewwindow', 'readonly', 'scrollbind', 'winfixheight',
    'winfixwidth',
  },
  buf_filter = function(bufnr)
    -- Skip non-real buffers (file explorers, dap-ui, terminals etc.) - they
    -- get re-created by their own setup code on demand.
    local buftype   = vim.bo[bufnr].buftype
    local filetype  = vim.bo[bufnr].filetype
    if buftype ~= '' and buftype ~= 'acwrite' then return false end
    if filetype == 'NvimTree' or filetype == 'aerial' or filetype == 'trouble'
        or filetype:match('^dapui_') or filetype == 'dap-repl'
        or filetype == 'toggleterm' or filetype == 'lazygit' then
      return false
    end
    return vim.api.nvim_buf_get_name(bufnr) ~= ''
  end,
  -- Save automatically when leaving Neovim.
  autosave = {
    enabled = true,
    interval = 60,
    notify = false,
  },
})

-- Compute the current "auto" session name from cwd + git branch (if any).
-- Sessions for different branches of the same repo therefore stay isolated.
local function auto_session_name()
  local cwd = vim.fn.fnamemodify(vim.fn.getcwd(), ':t')
  local branch = vim.fn.systemlist({ 'git', 'branch', '--show-current' })[1]
  if vim.v.shell_error ~= 0 or not branch or branch == '' then
    return cwd
  end
  return cwd .. '@' .. branch
end

-- Save on VimLeavePre, restore on VimEnter (only when Neovim was launched
-- without any file arguments - otherwise the user clearly wants to open
-- those specific files).
local group = vim.api.nvim_create_augroup('user_resession', { clear = true })
vim.api.nvim_create_autocmd('VimLeavePre', {
  group = group,
  callback = function() resession.save(auto_session_name(), { notify = false }) end,
})
vim.api.nvim_create_autocmd('VimEnter', {
  group = group,
  nested = true,
  callback = function()
    if vim.fn.argc() == 0 then
      resession.load(auto_session_name(), { silence_errors = true })
    end
  end,
})

local map = vim.keymap.set
map('n', '<leader>Ss', function()
  vim.ui.input({ prompt = 'Save session as: ', default = auto_session_name() },
    function(name) if name and name ~= '' then resession.save(name) end end)
end, { desc = 'Session: save (named)' })

map('n', '<leader>Sl', function() resession.load() end,                        { desc = 'Session: load (picker)' })
map('n', '<leader>SL', function() resession.load(auto_session_name()) end,     { desc = 'Session: load auto (cwd@branch)' })
map('n', '<leader>Sd', function() resession.delete() end,                      { desc = 'Session: delete' })
map('n', '<leader>Sa', function() resession.load(auto_session_name(), { attach = false }) end,
  { desc = 'Session: load auto (no attach)' })
