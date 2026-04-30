-- Generic autocommands. Plugin-specific autocommands live with their plugin module.

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

autocmd('TextYankPost', {
  group = augroup('user_highlight_yank', { clear = true }),
  callback = function()
    vim.hl.on_yank({ higroup = 'IncSearch', timeout = 150 })
  end,
})

autocmd({ 'BufWritePre' }, {
  group = augroup('user_mkdir_on_save', { clear = true }),
  callback = function(args)
    if args.match:match('^%w+://') then return end
    local dir = vim.fn.fnamemodify(args.file, ':p:h')
    if vim.fn.isdirectory(dir) == 0 then
      vim.fn.mkdir(dir, 'p')
    end
  end,
})

autocmd('BufReadPost', {
  group = augroup('user_last_loc', { clear = true }),
  callback = function(args)
    local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
    local lcount = vim.api.nvim_buf_line_count(args.buf)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

autocmd('FileType', {
  group = augroup('user_close_with_q', { clear = true }),
  pattern = {
    'help', 'man', 'qf', 'lspinfo', 'checkhealth', 'startuptime',
    'notify', 'dap-float',
  },
  callback = function(args)
    vim.bo[args.buf].buflisted = false
    vim.keymap.set('n', 'q', '<cmd>close<cr>', { buffer = args.buf, silent = true })
  end,
})
