-- lua/plugins/gruvbox-material.lua
return {
  {
    "sainnhe/gruvbox-material",
    priority = 1000, -- 确保比其他主题优先加载
    lazy = false,
    config = function()
      -- 设置主题选项（要在 colorscheme 前执行）
      vim.g.gruvbox_material_background = "soft"  -- soft, medium, hard
      vim.g.gruvbox_material_foreground = "mix"     -- mix: 更柔和
      vim.g.gruvbox_material_enable_italic = 1
      vim.g.gruvbox_material_enable_bold = 1
      vim.g.gruvbox_material_ui_contrast = "low"
      vim.g.gruvbox_material_transparent_background = 0

      -- 开启真彩色（推荐）
      vim.opt.termguicolors = true

      -- vim.cmd.colorscheme("gruvbox-material")

    end,
  },
}

