return {
  {
    "AlexvZyl/nordic.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("nordic").setup({
        on_highlight = function(highlights, palette)
          local strong = palette.cyan.base or palette.cyan.bright

          highlights.Delimiter = { fg = strong }
          highlights.Operator = { fg = strong }
          highlights["@punctuation"] = { fg = strong }
          highlights["@punctuation.delimiter"] = { fg = strong }
          highlights["@punctuation.bracket"] = { fg = strong }
          highlights["@punctuation.special"] = { fg = strong }
          highlights.Visual = {
            bg = palette.blue0,
            fg = palette.white0,
            bold = false,
          }
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
          theme = "dark",
          blend = 0.85,
        },
        noice = {
          style = "classic",
        },
        leap = {
          dim_backdrop = false,
        },
        ts_context = {
          dark_background = true,
        },
      })
    end,
  },
}
