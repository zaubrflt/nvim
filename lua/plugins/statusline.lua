-- lualine.nvim - statusline.
-- Reads the active colorscheme automatically so it inherits nordic.

local ok, lualine = pcall(require, 'lualine')
if not ok then
  vim.notify('lualine.nvim not installed yet.', vim.log.levels.WARN)
  return
end

-- Show only the short DAP status when a session is active. nvim-dap exposes
-- a tiny status helper that reports stack frame info; this avoids an extra
-- dependency on lualine's nvim-dap-status component.
local function dap_status()
  local ok_dap, dap = pcall(require, 'dap')
  if not ok_dap then return '' end
  local s = dap.status and dap.status() or ''
  return s ~= '' and ('  ' .. s) or ''
end

-- Compact list of attached LSP servers; keeps the right side from getting
-- repetitive when several clients (clangd + null-ls-style helpers) attach.
local function lsp_clients()
  local clients = vim.lsp.get_clients({ bufnr = 0 })
  if #clients == 0 then return '' end
  local names = {}
  for _, c in ipairs(clients) do table.insert(names, c.name) end
  return ' ' .. table.concat(names, ',')
end

-- Resolve a theme that exists. nordic.nvim ships with a 'nordic' lualine theme
-- (registered as `lualine.themes.nordic`); fall back to 'auto' if it isn't on
-- runtimepath yet (e.g. first launch before plugins finished cloning).
local function resolve_theme()
  local ok_theme = pcall(require, 'lualine.themes.nordic')
  return ok_theme and 'nordic' or 'auto'
end

lualine.setup({
  options = {
    theme = resolve_theme(),
    component_separators = { left = '│', right = '│' },
    section_separators   = { left = '',  right = ''  },
    globalstatus = true,                        -- matches opt.laststatus = 3
    disabled_filetypes = {
      statusline = { 'NvimTree', 'aerial', 'dap-repl', 'dapui_scopes',
                     'dapui_breakpoints', 'dapui_stacks', 'dapui_watches',
                     'dapui_console' },
    },
  },
  sections = {
    lualine_a = { 'mode' },
    lualine_b = { 'branch', { 'diff', symbols = { added = '+', modified = '~', removed = '-' } } },
    lualine_c = {
      { 'filename', path = 1, symbols = { modified = ' ●', readonly = ' ', unnamed = '[No Name]' } },
      { 'diagnostics',
        sources = { 'nvim_diagnostic' },
        symbols = { error = 'E', warn = 'W', info = 'I', hint = 'H' },
      },
      { dap_status },
    },
    lualine_x = { lsp_clients, 'encoding', 'fileformat', 'filetype' },
    lualine_y = { 'progress' },
    lualine_z = { 'location' },
  },
  extensions = { 'nvim-tree', 'aerial', 'fzf', 'lazy', 'quickfix', 'man' },
})
