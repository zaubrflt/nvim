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

-- When <leader>uS disables smooth scroll, fall back to native motions.
local function scroll(smooth_fn, keys)
  return function()
    if vim.g.user_smooth_scroll == false then
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(keys, true, false, true), 'n', false)
      return
    end
    smooth_fn()
  end
end

map({ 'n', 'x' }, '<C-f>', scroll(function()
  neoscroll.ctrl_f({ duration = 350 })
end, '<C-f>'), { desc = 'Page down smooth' })

map({ 'n', 'x' }, '<C-b>', scroll(function()
  neoscroll.ctrl_b({ duration = 350 })
end, '<C-b>'), { desc = 'Page up smooth' })

map({ 'n', 'x' }, '<C-d>', scroll(function()
  neoscroll.ctrl_d({ duration = 220 })
end, '<C-d>'), { desc = 'Half page down smooth' })

map({ 'n', 'x' }, '<C-u>', scroll(function()
  neoscroll.ctrl_u({ duration = 220 })
end, '<C-u>'), { desc = 'Half page up smooth' })
