-- Nordic.nvim colorscheme. Set as the default theme.

local ok, nordic = pcall(require, 'nordic')
if not ok then
  vim.notify('nordic.nvim not installed yet; falling back to default colorscheme.', vim.log.levels.WARN)
  return
end

nordic.setup({
  bold_keywords = false,
  italic_comments = true,
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
  telescope = {
    style = 'flat',
  },
  leap = {
    dim_backdrop = false,
  },
  ts_context = {
    dark_background = true,
  },
})

vim.cmd.colorscheme('nordic')
