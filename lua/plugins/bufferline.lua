-- bufferline.nvim - tabline visualisation of <S-h>/<S-l> + <leader>bd.
-- We don't add new keymaps here; the existing buffer-navigation keymaps in
-- core/keymaps.lua already cover navigation, this just gives them visual
-- feedback at the top of the screen.

local ok, bufferline = pcall(require, 'bufferline')
if not ok then
  vim.notify('bufferline.nvim not installed yet.', vim.log.levels.WARN)
  return
end

bufferline.setup({
  options = {
    mode                     = 'buffers',
    diagnostics              = 'nvim_lsp',
    diagnostics_indicator    = function(count, level)
      local prefix = level:match('error') and 'E' or (level:match('warn') and 'W' or 'I')
      return ' ' .. prefix .. count
    end,
    show_buffer_close_icons  = false,
    show_close_icon          = false,
    separator_style          = 'thin',
    always_show_bufferline   = true,
    -- Reserve space for nvim-tree on the left so the tabline doesn't overlap
    -- the file explorer.
    offsets = {
      {
        filetype   = 'NvimTree',
        text       = 'File Explorer',
        text_align = 'center',
        separator  = true,
      },
      {
        filetype   = 'aerial',
        text       = 'Outline',
        text_align = 'center',
        separator  = true,
      },
    },
    -- Visual cues for modified / readonly buffers.
    indicator       = { style = 'underline' },
    modified_icon   = '●',
    buffer_close_icon = '',
    close_icon      = '',
    left_trunc_marker  = '<',
    right_trunc_marker = '>',
    hover = { enabled = false },
  },
})

local map = vim.keymap.set
-- Quick jump to the Nth buffer (LazyVim convention; rarely used but cheap).
for i = 1, 9 do
  map('n', '<leader>' .. i, function()
    bufferline.go_to(i, true)
  end, { desc = 'Buffer ' .. i })
end

-- Buffer "close others" / pin / pick.
map('n', '<leader>bp', '<cmd>BufferLineTogglePin<cr>',          { desc = 'Buffer: toggle pin' })
map('n', '<leader>bP', '<cmd>BufferLineGroupClose ungrouped<cr>', { desc = 'Buffer: close non-pinned' })
map('n', '<leader>bo', '<cmd>BufferLineCloseOthers<cr>',        { desc = 'Buffer: close others' })
map('n', '<leader>br', '<cmd>BufferLineCloseRight<cr>',         { desc = 'Buffer: close to right' })
map('n', '<leader>bl', '<cmd>BufferLineCloseLeft<cr>',          { desc = 'Buffer: close to left' })
