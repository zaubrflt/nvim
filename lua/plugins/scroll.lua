-- neoscroll.nvim - smooth page and half-page scrolling.

local ok, neoscroll = pcall(require, 'neoscroll')
if not ok then
  vim.notify('neoscroll.nvim not installed yet.', vim.log.levels.WARN)
  return
end

neoscroll.setup({
  mappings = {}, -- Define mappings explicitly so desc text stays accurate.
  respect_scrolloff = true,
  stop_eof = true,
  hide_cursor = true,
  easing_function = 'sine',
  ignored_filetypes = {
    'NvimTree',
    'aerial',
    'trouble',
    'toggleterm',
    'lazygit',
    'fzf',
  },
})

local map = vim.keymap.set

map({ 'n', 'x' }, '<C-f>', function()
  neoscroll.ctrl_f({ duration = 350 })
end, { desc = 'Page down smooth' })

map({ 'n', 'x' }, '<C-b>', function()
  neoscroll.ctrl_b({ duration = 350 })
end, { desc = 'Page up smooth' })

map({ 'n', 'x' }, '<C-d>', function()
  neoscroll.ctrl_d({ duration = 220 })
end, { desc = 'Half page down smooth' })

map({ 'n', 'x' }, '<C-u>', function()
  neoscroll.ctrl_u({ duration = 220 })
end, { desc = 'Half page up smooth' })
