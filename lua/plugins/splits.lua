-- smart-splits.nvim - multiplexer-aware <C-h/j/k/l> navigation.
-- When the cursor is at the edge of an Nvim split, smart-splits seamlessly
-- jumps to the adjacent tmux / wezterm / kitty pane instead of dead-ending.
-- The original native <C-w>h/j/k/l mappings live in core/keymaps.lua and have
-- been removed there to avoid double-binding.

local ok, splits = pcall(require, 'smart-splits')
if not ok then
  vim.notify('smart-splits.nvim not installed yet.', vim.log.levels.WARN)
  return
end

splits.setup({
  -- Auto-detect the multiplexer; supports tmux / wezterm / kitty out of the box.
  -- When run outside any multiplexer this gracefully degrades to plain Nvim splits.
  default_amount = 3,
  at_edge = 'wrap',                 -- wrap to the opposite split when already at edge
  cursor_follows_swapped_bufs = true,
  ignored_buftypes = { 'nofile', 'quickfix', 'prompt' },
  ignored_filetypes = { 'snacks_picker_list', 'aerial', 'trouble' },
})

local map = vim.keymap.set

-- Window navigation (replaces the native <C-w>h/j/k/l previously in core/keymaps.lua).
map('n', '<C-h>', function() splits.move_cursor_left()  end, { desc = 'Window left (multiplexer aware)'  })
map('n', '<C-j>', function() splits.move_cursor_down()  end, { desc = 'Window down (multiplexer aware)'  })
map('n', '<C-k>', function() splits.move_cursor_up()    end, { desc = 'Window up (multiplexer aware)'    })
map('n', '<C-l>', function() splits.move_cursor_right() end, { desc = 'Window right (multiplexer aware)' })

-- Resize splits with <M-h/j/k/l>; works even across multiplexer panes.
map('n', '<M-h>', function() splits.resize_left()  end, { desc = 'Resize split left'  })
map('n', '<M-j>', function() splits.resize_down()  end, { desc = 'Resize split down'  })
map('n', '<M-k>', function() splits.resize_up()    end, { desc = 'Resize split up'    })
map('n', '<M-l>', function() splits.resize_right() end, { desc = 'Resize split right' })

-- Swap windows (handy after creating a split in the wrong direction).
map('n', '<leader><leader>h', function() splits.swap_buf_left()  end, { desc = 'Swap window left'  })
map('n', '<leader><leader>j', function() splits.swap_buf_down()  end, { desc = 'Swap window down'  })
map('n', '<leader><leader>k', function() splits.swap_buf_up()    end, { desc = 'Swap window up'    })
map('n', '<leader><leader>l', function() splits.swap_buf_right() end, { desc = 'Swap window right' })
