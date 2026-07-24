-- Runtime UI toggles via Snacks.toggle (LazyVim-style).
-- Format-on-save still starts disabled; see lua/plugins/format.lua.

local ok = pcall(require, 'snacks')
if not ok then
  vim.notify('snacks.nvim not installed yet; UI toggles unavailable.', vim.log.levels.WARN)
  return
end

-- Keep existing letter bindings where this repo already had them.
Snacks.toggle.option('relativenumber', { name = 'Relative Number' }):map('<leader>ur')
Snacks.toggle.option('wrap', { name = 'Wrap' }):map('<leader>uw')
Snacks.toggle.option('spell', { name = 'Spelling' }):map('<leader>us')
Snacks.toggle.diagnostics():map('<leader>ud')
Snacks.toggle.inlay_hints():map('<leader>uh')
Snacks.toggle.scroll():map('<leader>uS')

-- Custom format-on-save toggle; must stay default-off at startup.
Snacks.toggle({
  name = 'Format on Save',
  get = function()
    return vim.g.user_format_on_save == true
  end,
  set = function(state)
    vim.g.user_format_on_save = state
  end,
}):map('<leader>uf')

-- Extra LazyVim-style toggles (new keys; all have desc via Snacks.toggle).
Snacks.toggle.line_number():map('<leader>ul')
Snacks.toggle.option('conceallevel', {
  off = 0,
  on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2,
  name = 'Conceal Level',
}):map('<leader>uc')
Snacks.toggle.treesitter():map('<leader>uT')
Snacks.toggle.indent():map('<leader>ug')
Snacks.toggle.dim():map('<leader>uD')
Snacks.toggle.option('background', { off = 'light', on = 'dark', name = 'Dark Background' }):map(
  '<leader>ub'
)

-- Zen / zoom (phase D).
Snacks.toggle.zen():map('<leader>uz')
Snacks.toggle.zoom():map('<leader>uZ')

-- Profiler (phase D; Debug group).
Snacks.toggle.profiler():map('<leader>dpp')
Snacks.toggle.profiler_highlights():map('<leader>dph')
