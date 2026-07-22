-- which-key.nvim - LazyVim-style keymap discovery popup.
-- Press <leader> (or any registered prefix) and pause briefly: a popup lists
-- the available continuations using the `desc =` text already attached to
-- every keymap in this config.

local ok, wk = pcall(require, 'which-key')
if not ok then
  vim.notify('which-key.nvim not installed yet.', vim.log.levels.WARN)
  return
end

wk.setup({
  preset = 'modern',
  win = { border = 'rounded' },
  -- Default activation delay (~200ms) is intentionally kept; lowering it makes
  -- normal-mode prefixes like `g` feel jumpy.
  icons = {
    mappings = false, -- avoid relying on a Nerd Font being installed
  },
})

-- Group labels for the leader prefixes used across the config.
-- Individual keymaps inherit their `desc` from where they are defined
-- (lua/core/keymaps.lua, lua/plugins/*.lua); we only declare the headers here.
wk.add({
  { '<leader>b',  group = 'Buffer'                },
  { '<leader>c',  group = 'Code/Diagnostics'      },
  { '<leader>d',  group = 'Debug'                 },
  { '<leader>f',  group = 'File/Find/Format'      },
  { '<leader>fg', group = 'Find: git'             }, -- nested under <leader>f
  { '<leader>g',  group = 'Git'                   },
  { '<leader>l',  group = 'Pack'                  }, -- vim.pack (LazyVim <leader>l letter)
  { '<leader>r',  group = 'Refactor'              },
  { '<leader>x',  group = 'Trouble'               },
  { '<leader>S',  group = 'Session'               },
  { '<leader>t',  group = 'Terminal'              },
  { '<leader>u',  group = 'UI'                    },
  -- Note: mini.surround registers `gs` as a group automatically; do NOT add
  -- it here too or which-key will warn about duplicate mappings.
})
