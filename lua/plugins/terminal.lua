-- toggleterm.nvim - floating / split terminals managed from inside Nvim.
-- On Windows, options.lua already configures pwsh + UTF-8 if available, so
-- toggleterm picks that up automatically via &shell.

local ok, toggleterm = pcall(require, 'toggleterm')
if not ok then
  vim.notify('toggleterm.nvim not installed yet.', vim.log.levels.WARN)
  return
end

toggleterm.setup({
  size = function(term)
    if term.direction == 'horizontal' then return 12
    elseif term.direction == 'vertical' then return math.floor(vim.o.columns * 0.4)
    end
  end,
  open_mapping = [[<C-\>]],
  shade_terminals = true,
  shading_factor = 2,
  start_in_insert = true,
  insert_mappings = true,
  terminal_mappings = true,
  persist_size = true,
  persist_mode = true,
  direction = 'float',
  close_on_exit = true,
  float_opts = {
    border = 'rounded',
    width  = function() return math.min(150, math.floor(vim.o.columns * 0.85)) end,
    height = function() return math.min(40,  math.floor(vim.o.lines   * 0.85)) end,
    winblend = 0,
  },
  winbar = { enabled = false },
})

-- Make terminal-mode escapes feel native: <esc> exits insert, then <C-h/j/k/l>
-- behaves like in normal buffers (delegates to smart-splits if installed).
local function set_terminal_keymaps()
  local opts = { buffer = 0 }
  vim.keymap.set('t', '<esc>', [[<C-\><C-n>]],          opts)
  vim.keymap.set('t', 'jk',    [[<C-\><C-n>]],          opts)
  vim.keymap.set('t', '<C-h>', [[<C-\><C-n><C-w>h]],    opts)
  vim.keymap.set('t', '<C-j>', [[<C-\><C-n><C-w>j]],    opts)
  vim.keymap.set('t', '<C-k>', [[<C-\><C-n><C-w>k]],    opts)
  vim.keymap.set('t', '<C-l>', [[<C-\><C-n><C-w>l]],    opts)
end
vim.api.nvim_create_autocmd('TermOpen', {
  group = vim.api.nvim_create_augroup('user_toggleterm_keymaps', { clear = true }),
  pattern = 'term://*toggleterm#*',
  callback = set_terminal_keymaps,
})

local Terminal = require('toggleterm.terminal').Terminal

-- Keep one persistent floating shell that survives between toggles.
local float_term = Terminal:new({ direction = 'float',      hidden = true })
local horiz_term = Terminal:new({ direction = 'horizontal', hidden = true })
local vert_term  = Terminal:new({ direction = 'vertical',   hidden = true })

local map = vim.keymap.set
map({ 'n', 't' }, '<leader>tf', function() float_term:toggle() end, { desc = 'Terminal: floating' })
map({ 'n', 't' }, '<leader>th', function() horiz_term:toggle() end, { desc = 'Terminal: horizontal split' })
map({ 'n', 't' }, '<leader>tv', function() vert_term:toggle()  end, { desc = 'Terminal: vertical split' })
map({ 'n', 't' }, '<leader>tt', '<cmd>ToggleTerm<cr>',              { desc = 'Terminal: toggle default' })
map('n',          '<leader>tn', '<cmd>TermSelect<cr>',              { desc = 'Terminal: select instance' })
