-- flash.nvim - jump to any visible target with two characters.
-- Replaces the limited reach of f/F/t/T and gives a treesitter-node selector.

local ok, flash = pcall(require, 'flash')
if not ok then
  vim.notify('flash.nvim not installed yet.', vim.log.levels.WARN)
  return
end

flash.setup({
  modes = {
    -- We don't want flash to take over `/` and `?`; the native search is
    -- already fine and conflicts with `n/N` zz centering keymaps.
    search = { enabled = false },
    -- Typing `f<char>` shows labels for every match line; ; and , then jump.
    char = {
      enabled = true,
      jump_labels = true,
      multi_line = true,
    },
  },
  label = {
    rainbow = { enabled = false },
  },
})

local map = vim.keymap.set

-- Free up the original `s` (which was 'substitute char', easily replaced
-- by `cl`) for the most useful flash motion.
map({ 'n', 'x', 'o' }, 's', function() flash.jump() end,        { desc = 'Flash jump' })
map({ 'n', 'x', 'o' }, 'S', function() flash.treesitter() end,  { desc = 'Flash treesitter node' })

-- Operator-pending only: jump to a target and operate on the line/word there.
map('o', 'r', function() flash.remote() end,                    { desc = 'Flash remote operator' })
map({ 'o', 'x' }, 'R', function() flash.treesitter_search() end,{ desc = 'Flash TS search' })

-- Toggle live flash inside `:`, useful when running `:s` searches.
map('c', '<C-s>', function() flash.toggle() end,                { desc = 'Toggle flash search' })
