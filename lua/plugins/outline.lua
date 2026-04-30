-- aerial.nvim - code outline / symbol sidebar.
-- Backed by LSP first, then treesitter, then markdown headings - so it works
-- the moment clangd / rust-analyzer attaches.

local ok, aerial = pcall(require, 'aerial')
if not ok then
  vim.notify('aerial.nvim not installed yet.', vim.log.levels.WARN)
  return
end

aerial.setup({
  backends = { 'lsp', 'treesitter', 'markdown', 'man' },
  layout = {
    default_direction = 'right',
    min_width = 28,
    max_width = { 50, 0.3 },
    placement = 'edge',
  },
  attach_mode = 'global',
  show_guides = true,
  filter_kind = {
    'Class', 'Constructor', 'Enum', 'Function', 'Interface', 'Module',
    'Method', 'Struct', 'Trait', 'Field', 'Property', 'Constant',
    'Namespace', 'Package', 'TypeParameter', 'Variable',
  },
  highlight_on_jump = 200,
  autojump = false,

  on_attach = function(bufnr)
    local map = vim.keymap.set
    -- Inside the aerial window: navigate the outline tree.
    map('n', '{', '<cmd>AerialPrev<cr>', { buffer = bufnr, desc = 'Aerial: prev symbol' })
    map('n', '}', '<cmd>AerialNext<cr>', { buffer = bufnr, desc = 'Aerial: next symbol' })
  end,
})

local map = vim.keymap.set
map('n', '<leader>O', '<cmd>AerialToggle!<cr>', { desc = 'Outline: toggle sidebar' })
map('n', '<leader>fo', function()
  -- Fuzzy search the outline of the current buffer with fzf-lua's UI.
  local ok_fzf, _ = pcall(require, 'fzf-lua')
  if ok_fzf then vim.cmd('AerialNavToggle') else vim.cmd('AerialToggle') end
end, { desc = 'Find: outline (current buffer)' })
