-- Central plugin registry using Neovim 0.12's built-in vim.pack manager.
-- Each plugin's setup lives in its own module under lua/plugins/.

if not vim.pack or not vim.pack.add then
  vim.notify(
    'vim.pack is not available. This config requires Neovim 0.12 or newer.',
    vim.log.levels.ERROR
  )
  return
end

vim.pack.add({
  -- Colorscheme.
  { src = 'https://github.com/AlexvZyl/nordic.nvim' },

  -- Syntax highlighting (main branch is required for Neovim 0.12).
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter', version = 'main' },

  -- Completion engine. Pin to 1.x for stable prebuilt fuzzy matcher binaries.
  { src = 'https://github.com/saghen/blink.cmp', version = vim.version.range('^1.0.0') },

  -- Snippet library: VSCode-format snippets for many languages. blink.cmp's
  -- built-in snippets source has `friendly_snippets = true` by default, so this
  -- is automatically picked up after the plugin is registered.
  { src = 'https://github.com/rafamadriz/friendly-snippets' },

  -- Formatter runner.
  { src = 'https://github.com/stevearc/conform.nvim' },

  -- Debug Adapter Protocol stack.
  { src = 'https://github.com/mfussenegger/nvim-dap' },
  { src = 'https://github.com/nvim-neotest/nvim-nio' },
  { src = 'https://github.com/rcarriga/nvim-dap-ui' },
  { src = 'https://github.com/theHamsta/nvim-dap-virtual-text' },

  -- Git integration.
  { src = 'https://github.com/lewis6991/gitsigns.nvim' },
  { src = 'https://github.com/kdheepak/lazygit.nvim' },

  -- File explorer + icons.
  { src = 'https://github.com/nvim-tree/nvim-web-devicons' },
  { src = 'https://github.com/nvim-tree/nvim-tree.lua' },

  -- Fuzzy finder (uses the system `fzf` binary as backend).
  { src = 'https://github.com/ibhagwan/fzf-lua' },

  -- Statusline.
  { src = 'https://github.com/nvim-lualine/lualine.nvim' },

  -- Editing helpers from echasnovski/mini.nvim (each plugin is its own repo).
  { src = 'https://github.com/echasnovski/mini.pairs' },
  { src = 'https://github.com/echasnovski/mini.surround' },

  -- Auto-detect indentation per buffer without overriding global vim.opt.
  { src = 'https://github.com/NMAC427/guess-indent.nvim' },

  -- Treesitter-aware jump motions.
  { src = 'https://github.com/folke/flash.nvim' },

  -- Code outline / symbol sidebar.
  { src = 'https://github.com/stevearc/aerial.nvim' },

  -- Treesitter add-ons. Both are compatible with nvim-treesitter `main`:
  -- treesitter-textobjects ships a `main` branch tracking the new API,
  -- treesitter-context only depends on vim.treesitter (no nvim-treesitter dep).
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter-textobjects', version = 'main' },
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter-context' },

  -- Diagnostics / LSP references / quickfix UI.
  { src = 'https://github.com/folke/trouble.nvim' },

  -- Editing add-ons in the mini.* family (one repo each).
  { src = 'https://github.com/echasnovski/mini.ai' },
  { src = 'https://github.com/echasnovski/mini.indentscope' },

  -- Multiplexer-aware split navigation (tmux/wezterm/kitty).
  { src = 'https://github.com/mrjones2014/smart-splits.nvim' },

  -- TODO/FIXME highlighter and search.
  { src = 'https://github.com/folke/todo-comments.nvim' },

  -- Session management (named + branch-scoped).
  { src = 'https://github.com/stevearc/resession.nvim' },

  -- Buffer tabline (visualises <S-h>/<S-l> / <leader>bd).
  { src = 'https://github.com/akinsho/bufferline.nvim' },

  -- Floating / split terminals managed from inside Neovim.
  { src = 'https://github.com/akinsho/toggleterm.nvim' },

  -- Keymap discoverability popup (LazyVim-style <leader> menu).
  { src = 'https://github.com/folke/which-key.nvim', version = vim.version.range('^3.0.0') },
})

-- Order matters: colorscheme first, then features.
require('plugins.colorscheme')
require('plugins.treesitter')
require('plugins.completion')
require('plugins.lsp')
require('plugins.format')
require('plugins.dap')
require('plugins.git')
require('plugins.lazygit')
require('plugins.filetree')
require('plugins.picker')
require('plugins.statusline')
require('plugins.editing')
require('plugins.motion')
require('plugins.outline')
require('plugins.trouble')
require('plugins.splits')
require('plugins.todo')
require('plugins.session')
require('plugins.bufferline')
require('plugins.terminal')
require('plugins.whichkey')
