-- ~/.config/nvim/lua/plugins/nordic.lua
return {
  {
    "AlexvZyl/nordic.nvim",
    lazy = false,       -- 保证主题在启动时加载
    priority = 1000,    -- 主题应比其他插件更早加载
    config = function()
      require("nordic").setup({
        -- ---------- 调色板回调 ----------
        on_palette = function(palette)
        end,
        after_palette = function(palette)
        end,

        -- ---------- 重点：增强符号颜色 ----------
        on_highlight = function(highlights, palette)
          -- 手动增强符号颜色：分号、逗号、冒号、括号、运算符等
          -- local strong = palette.white0 or "#ECEFF4"
          local strong = palette.cyan.base or palette.cyan.bright

          -- 如果想稍微柔和一点，也可以用：
          -- local strong = palette.snowfall or palette.gray2

          -- Neovim syntax groups
          highlights.Delimiter = { fg = strong }      -- , ; : ( ) { }
          highlights.Operator = { fg = strong }       -- + - * / = < >

          -- Treesitter groups
          highlights["@punctuation"] = { fg = strong }
          highlights["@punctuation.delimiter"] = { fg = strong }
          highlights["@punctuation.bracket"] = { fg = strong }
          highlights["@punctuation.special"] = { fg = strong }
        end,

        -- ---------- 基本样式 ----------
        bold_keywords = false,
        italic_comments = false,

        -- ---------- 背景透明 ----------
        transparent = {
          bg = false,
          float = false,
        },

        bright_border = false,
        reduced_blue = true,
        swap_backgrounds = false,

        -- ---------- 光标行 ----------
        cursorline = {
          bold = false,
          bold_number = true,
          theme = "dark",
          blend = 0.85,
        },

        -- ---------- 插件风格 ----------
        noice = {
          style = "classic",   -- "flat" 可选
        },

        telescope = {
          style = "flat",      -- 更现代的外观
        },

        leap = {
          dim_backdrop = false,
        },

        ts_context = {
          dark_background = true,
        },
      })

      -- 加载主题
      vim.cmd([[colorscheme nordic]])
    end,
  },
}

