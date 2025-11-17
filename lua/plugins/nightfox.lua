-- 文件：lua/plugins/nightfox.lua
return {
  "EdenEast/nightfox.nvim",
  lazy = false,         -- 立刻加载（颜色主题一般不 lazy）
  priority = 1000,      -- 让主题最先加载
  config = function()
    require("nightfox").setup({
      options = {
        compile_path = vim.fn.stdpath("cache") .. "/nightfox",
        compile_file_suffix = "_compiled",
        transparent = false,
        terminal_colors = true,
        dim_inactive = false,
        module_default = true,
        colorblind = {
          enable = false,
          simulate_only = false,
          severity = {
            protan = 0,
            deutan = 0,
            tritan = 0,
          },
        },
        styles = {
          comments = "NONE",
          conditionals = "NONE",
          constants = "NONE",
          functions = "NONE",
          keywords = "NONE",
          numbers = "NONE",
          operators = "NONE",
          strings = "NONE",
          types = "NONE",
          variables = "NONE",
        },
        inverse = {
          match_paren = false,
          visual = false,
          search = false,
        },
        modules = {},
      },
      palettes = {},
      specs = {},
      groups = {},
    })

    -- 加载主题
    -- vim.cmd("colorscheme nightfox")
  end,
}

