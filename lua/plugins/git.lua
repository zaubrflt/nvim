-- gitsigns.nvim - inline git signs, hunk navigation and staging.

local ok, gitsigns = pcall(require, 'gitsigns')
if not ok then
  vim.notify('gitsigns.nvim not installed yet.', vim.log.levels.WARN)
  return
end

gitsigns.setup({
  -- Colored bars (LazyVim-style); Nordic supplies GitSigns* highlights.
  signs = {
    add          = { text = '▎' },
    change       = { text = '▎' },
    delete       = { text = '' },
    topdelete    = { text = '' },
    changedelete = { text = '▎' },
    untracked    = { text = '▎' },
  },
  signcolumn = true,
  numhl = false,
  linehl = false,
  word_diff = false,
  watch_gitdir = { follow_files = true },
  current_line_blame = false,
  current_line_blame_opts = {
    delay = 600,
    virt_text_pos = 'eol',
  },
  preview_config = {
    border = 'rounded',
    style = 'minimal',
    relative = 'cursor',
    row = 0,
    col = 1,
  },

  on_attach = function(bufnr)
    local gs = require('gitsigns')
    local function map(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = 'Git: ' .. desc })
    end

    -- Hunk navigation.
    map('n', ']g', function()
      if vim.wo.diff then return ']g' end
      vim.schedule(function() gs.nav_hunk('next') end)
      return '<Ignore>'
    end, 'Next hunk')
    map('n', '[g', function()
      if vim.wo.diff then return '[g' end
      vim.schedule(function() gs.nav_hunk('prev') end)
      return '<Ignore>'
    end, 'Prev hunk')

    -- Hunk actions.
    map('n', '<leader>gs', gs.stage_hunk,    'Stage hunk')
    map('n', '<leader>gr', gs.reset_hunk,    'Reset hunk')
    map('v', '<leader>gs', function() gs.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') }) end, 'Stage hunk (visual)')
    map('v', '<leader>gr', function() gs.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') }) end, 'Reset hunk (visual)')
    map('n', '<leader>gS', gs.stage_buffer,  'Stage buffer')
    map('n', '<leader>gR', gs.reset_buffer,  'Reset buffer')
    map('n', '<leader>gu', gs.undo_stage_hunk, 'Undo stage hunk')
    map('n', '<leader>gp', gs.preview_hunk,  'Preview hunk')
    map('n', '<leader>gb', function() gs.blame_line({ full = true }) end, 'Blame line')
    map('n', '<leader>gB', gs.toggle_current_line_blame, 'Toggle blame inline')
    map('n', '<leader>gd', gs.diffthis,      'Diff against index')
    map('n', '<leader>gD', function() gs.diffthis('~') end, 'Diff against last commit')

    -- Text object: a hunk.
    map({ 'o', 'x' }, 'ih', '<cmd>Gitsigns select_hunk<cr>', 'Select hunk')
  end,
})
