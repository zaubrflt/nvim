
return {
  -- add colorscheme
  { "sainnhe/gruvbox-material" },
  { "AlexvZyl/nordic.nvim" },
  { "rebelot/kanagawa.nvim" },
  { "EdenEast/nightfox.nvim" },

  -- Configure LazyVim to load gruvbox
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "nordic",
    },
  },
}
