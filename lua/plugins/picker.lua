-- fzf-lua - fuzzy finder over the system `fzf` binary.
-- Replaces telescope here because the C-based backend stays snappy on
-- million-line C++/Rust trees.

local ok, fzf = pcall(require, 'fzf-lua')
if not ok then
  vim.notify('fzf-lua not installed yet.', vim.log.levels.WARN)
  return
end

fzf.setup({
  -- 'default-title' is the same layout as 'default' but with a title bar that
  -- shows what the current picker is - much easier to skim.
  'default-title',
  winopts = {
    border = 'rounded',
    preview = {
      border = 'rounded',
      scrollbar = 'float',
      delay = 80,
      layout = 'flex',
      flip_columns = 130,
    },
  },
  fzf_opts = {
    ['--layout'] = 'reverse',
    ['--info']   = 'inline-right',
  },
  files = {
    formatter = 'path.filename_first',
  },
  grep = {
    -- `rg --hidden --no-ignore-vcs` would also surface .git/objects; skip it.
    rg_opts = '--hidden --column --line-number --no-heading --color=always '
      .. '--smart-case --max-columns=4096 -g "!.git/" -g "!node_modules/" -g "!target/"',
  },
  -- Wire fzf-lua into Neovim's UI hooks so vim.ui.select() (used by
  -- vim.lsp.buf.code_action and friends) renders inside an fzf popup.
  defaults = {
    formatter = 'path.filename_first',
  },
})

-- Register fzf-lua as the vim.ui.select implementation; this gives us a
-- consistent popup for code actions, plugin pickers, etc.
fzf.register_ui_select()

local map = vim.keymap.set

-- Files and content.
map('n', '<leader>ff', function() fzf.files() end,                 { desc = 'Find: files' })
map('n', '<leader>fg', function() fzf.live_grep() end,             { desc = 'Find: live grep (cwd)' })
map('n', '<leader>fG', function() fzf.lgrep_curbuf() end,          { desc = 'Find: live grep (buffer)' })
map('n', '<leader>fw', function() fzf.grep_cword() end,            { desc = 'Find: word under cursor' })
map('n', '<leader>fW', function() fzf.grep_cWORD() end,            { desc = 'Find: WORD under cursor' })
map('v', '<leader>fw', function() fzf.grep_visual() end,           { desc = 'Find: selection' })

-- Buffer / file history navigation.
map('n', '<leader>fb', function() fzf.buffers() end,               { desc = 'Find: open buffers' })
map('n', '<leader>fr', function() fzf.oldfiles() end,              { desc = 'Find: recent files' })
map('n', '<leader>fl', function() fzf.blines() end,                { desc = 'Find: lines (buffer)' })
map('n', '<leader>fL', function() fzf.lines() end,                 { desc = 'Find: lines (all buffers)' })

-- Help / keymap discovery.
map('n', '<leader>fh', function() fzf.help_tags() end,             { desc = 'Find: help tags' })
map('n', '<leader>fk', function() fzf.keymaps() end,               { desc = 'Find: keymaps' })
map('n', '<leader>f:', function() fzf.command_history() end,       { desc = 'Find: command history' })
map('n', '<leader>f/', function() fzf.search_history() end,        { desc = 'Find: search history' })

-- LSP-backed pickers (only meaningful inside a buffer with a server attached).
map('n', '<leader>fs', function() fzf.lsp_document_symbols() end,  { desc = 'Find: document symbols' })
map('n', '<leader>fS', function() fzf.lsp_live_workspace_symbols() end, { desc = 'Find: workspace symbols' })
map('n', '<leader>fd', function() fzf.lsp_definitions() end,       { desc = 'Find: LSP definitions' })
map('n', '<leader>fR', function() fzf.lsp_references() end,        { desc = 'Find: LSP references' })
map('n', '<leader>fi', function() fzf.lsp_implementations() end,   { desc = 'Find: LSP implementations' })
map('n', '<leader>fy', function() fzf.lsp_typedefs() end,          { desc = 'Find: LSP type defs' })
map('n', '<leader>fa', function() fzf.lsp_code_actions() end,      { desc = 'Find: LSP code actions' })
map('n', '<leader>fD', function() fzf.diagnostics_workspace() end, { desc = 'Find: diagnostics (workspace)' })

-- Git pickers (complement gitsigns + lazygit).
map('n', '<leader>fgs', function() fzf.git_status() end,           { desc = 'Find: git status' })
map('n', '<leader>fgc', function() fzf.git_commits() end,          { desc = 'Find: git commits (repo)' })
map('n', '<leader>fgC', function() fzf.git_bcommits() end,         { desc = 'Find: git commits (buffer)' })
map('n', '<leader>fgb', function() fzf.git_branches() end,         { desc = 'Find: git branches' })

-- Resume the last picker (huge time saver after one accidental <esc>).
map('n', '<leader>f.', function() fzf.resume() end,                { desc = 'Find: resume last picker' })
