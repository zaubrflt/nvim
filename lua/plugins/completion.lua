-- blink.cmp - completion engine.
-- Uses LSP + path + buffer + snippet sources, with the prebuilt Rust
-- fuzzy matcher binary (downloaded automatically by the plugin on tag releases).

local ok, blink = pcall(require, 'blink.cmp')
if not ok then
  vim.notify('blink.cmp not installed yet.', vim.log.levels.WARN)
  return
end

blink.setup({
  keymap = { preset = 'default' },

  appearance = {
    nerd_font_variant = 'mono',
  },

  completion = {
    list = {
      selection = { preselect = false, auto_insert = true },
    },
    menu = {
      border = 'rounded',
      draw = { treesitter = { 'lsp' } },
    },
    documentation = {
      auto_show = true,
      auto_show_delay_ms = 200,
      window = { border = 'rounded' },
    },
    accept = { auto_brackets = { enabled = true } },
    ghost_text = { enabled = false },
  },

  signature = {
    enabled = true,
    window = { border = 'rounded' },
  },

  sources = {
    default = { 'lsp', 'path', 'snippets', 'buffer' },
  },

  snippets = { preset = 'default' },

  -- Prefer the prebuilt Rust binary; fall back to the Lua matcher with a
  -- one-time warning when it isn't available (e.g. unsupported platform).
  fuzzy = { implementation = 'prefer_rust_with_warning' },
})
