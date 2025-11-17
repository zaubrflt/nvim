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
          -- 你可以在这里自定义颜色，例如：
          -- palette.red = "#ff6b6b"
        end,
        after_palette = function(palette)
          -- 扩展色板也可以继续修改
        end,
        on_highlight = function(highlights, palette)
          -- 可以在这里覆盖 highlight 组，例如：
          -- highlights.LspInlayHint = { fg = palette.gray5 }
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

