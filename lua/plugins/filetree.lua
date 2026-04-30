-- nvim-tree.lua - sidebar file explorer.

local ok_icons, devicons = pcall(require, 'nvim-web-devicons')
if ok_icons then
  devicons.setup({ default = true })
end

local ok, nvim_tree = pcall(require, 'nvim-tree')
if not ok then
  vim.notify('nvim-tree.lua not installed yet.', vim.log.levels.WARN)
  return
end

-- Recommended by nvim-tree: disable netrw.
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

nvim_tree.setup({
  sort = { sorter = 'case_sensitive' },
  view = {
    width = 35,
    side = 'left',
    preserve_window_proportions = true,
  },
  renderer = {
    group_empty = true,
    highlight_git = true,
    indent_markers = { enable = true },
    icons = {
      git_placement = 'after',
      show = {
        file = ok_icons,
        folder = ok_icons,
        folder_arrow = true,
        git = true,
      },
    },
  },
  filters = {
    dotfiles = false,
    custom = { '^.git$', 'node_modules', '__pycache__', 'target' },
  },
  git = { enable = true, ignore = false, timeout = 400 },
  diagnostics = {
    enable = true,
    show_on_dirs = true,
  },
  update_focused_file = {
    enable = true,
    update_root = false,
  },
  actions = {
    open_file = {
      quit_on_open = false,
      window_picker = { enable = true },
    },
  },
})

local map = vim.keymap.set
map('n', '<leader>e',  '<cmd>NvimTreeToggle<cr>',   { desc = 'File tree: toggle' })
map('n', '<leader>fe', '<cmd>NvimTreeFindFile<cr>', { desc = 'File tree: locate current file' })
map('n', '<leader>fc', '<cmd>NvimTreeCollapse<cr>', { desc = 'File tree: collapse all' })
