-- Nordic.nvim colorscheme. Set as the default theme.

local ok, nordic = pcall(require, 'nordic')
if not ok then
  vim.notify('nordic.nvim not installed yet; falling back to default colorscheme.', vim.log.levels.WARN)
  return
end

nordic.setup({
  -- Punctuation / operators in cyan to make them pop in dense C++/Rust source,
  -- a calmer Visual selection (blue0 bg / white0 fg, no bold), and a mid-gray
  -- WinSeparator so vertical splits stay readable without bright_border.
  on_highlight = function(highlights, palette)
    local strong = palette.cyan.base or palette.cyan.bright

    highlights.Delimiter              = { fg = strong }
    highlights.Operator               = { fg = strong }
    highlights['@punctuation']        = { fg = strong }
    highlights['@punctuation.delimiter'] = { fg = strong }
    highlights['@punctuation.bracket']   = { fg = strong }
    highlights['@punctuation.special']   = { fg = strong }
    highlights.Visual = {
      bg = palette.blue0,
      fg = palette.white0,
      bold = false,
    }
    highlights.WinSeparator = { fg = palette.gray4 }
    highlights.VertSplit = { fg = palette.gray4 }
  end,

  bold_keywords = false,
  italic_comments = false,
  transparent = {
    bg = false,
    float = false,
  },
  bright_border = false,
  reduced_blue = true,
  swap_backgrounds = false,
  cursorline = {
    bold = false,
    bold_number = true,
    theme = 'dark',
    blend = 0.85,
  },
  noice = {
    style = 'classic',
  },
  leap = {
    dim_backdrop = false,
  },
  ts_context = {
    dark_background = true,
  },
})

vim.cmd.colorscheme('nordic')
