-- lua/plugins/kanagawa.lua
return {
  {
    "rebelot/kanagawa.nvim",
    lazy = false,     -- 确保立即加载（不要延迟）
    priority = 1000,  -- 在其他插件前加载
    config = function()
      require("kanagawa").setup({
        compile = false, -- 是否预编译配色 (加快启动)
        undercurl = true,
        commentStyle = { italic = true },
        functionStyle = {},
        keywordStyle = { italic = true },
        statementStyle = { bold = true },
        typeStyle = {},
        transparent = false,   -- 是否启用透明背景
        dimInactive = false,   -- 是否让非当前窗口背景更暗
        terminalColors = true, -- 同步终端配色
        colors = {
          theme = {
            all = {
              ui = {
                bg_gutter = "none", -- 去掉行号列和边缘背景
              },
            },
          },
        },
        overrides = function(colors)
          local theme = colors.theme
          return {
            -- 这里可以定制高亮组
            NormalFloat = { bg = "none" },
            FloatBorder = { fg = theme.ui.float.fg_border, bg = "none" },
            CursorLineNr = { fg = theme.diag.warning, bold = true },
            -- Telescope 定制
            TelescopeTitle = { fg = theme.ui.special, bold = true },
            TelescopePromptNormal = { bg = theme.ui.bg_p1 },
            TelescopePromptBorder = { fg = theme.ui.bg_p1, bg = theme.ui.bg_p1 },
          }
        end,
        theme = "wave", -- 可选: "wave", "dragon", "lotus"
        background = {
          dark = "wave",
          light = "lotus",
        },
      })
    end,
  },
}
