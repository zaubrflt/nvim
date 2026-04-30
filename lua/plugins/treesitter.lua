-- nvim-treesitter (main branch) - parser management for Neovim 0.12+.
-- Highlight / fold / indent are enabled manually via a FileType autocmd, since
-- the main branch no longer auto-enables them.

local ok, ts = pcall(require, 'nvim-treesitter')
if not ok then
  vim.notify('nvim-treesitter not installed yet.', vim.log.levels.WARN)
  return
end

ts.setup({
  install_dir = vim.fs.joinpath(vim.fn.stdpath('data'), 'site'),
})

local ensure_installed = {
  'c', 'cpp', 'rust', 'lua', 'luadoc', 'vim', 'vimdoc',
  'bash', 'json', 'jsonc', 'yaml', 'toml', 'markdown', 'markdown_inline',
  'query', 'regex', 'diff', 'gitcommit', 'git_rebase',
}

-- Parsers are NOT installed at startup. Each install clones into a temp dir
-- and renames into place, which races with antivirus / Defender on Windows
-- and intermittently fails with EPERM. Users invoke `:TsEnsure` once after
-- first launch (and after editing the list above), and `:TsUpdate` when
-- they want fresher parsers.
local function installed_parsers()
  local found = {}
  local parser_dir = vim.fs.joinpath(vim.fn.stdpath('data'), 'site', 'parser')
  if vim.fn.isdirectory(parser_dir) == 0 then return found end
  for name in vim.fs.dir(parser_dir) do
    local lang = name:match('^(.+)%.so$') or name:match('^(.+)%.dll$')
    if lang then found[lang] = true end
  end
  return found
end

vim.api.nvim_create_user_command('TsEnsure', function()
  local have = installed_parsers()
  local missing = {}
  for _, lang in ipairs(ensure_installed) do
    if not have[lang] then table.insert(missing, lang) end
  end
  if #missing == 0 then
    vim.notify('TsEnsure: all parsers already installed.', vim.log.levels.INFO)
    return
  end
  vim.notify('TsEnsure: installing ' .. table.concat(missing, ', '), vim.log.levels.INFO)
  ts.install(missing)
end, { desc = 'Install missing nvim-treesitter parsers from ensure_installed' })

vim.api.nvim_create_user_command('TsUpdate', function()
  if ts.update then
    ts.update(ensure_installed)
  else
    ts.install(ensure_installed)
  end
end, { desc = 'Update nvim-treesitter parsers in ensure_installed' })

local ts_filetypes = {
  c = 'c', cpp = 'cpp', rust = 'rust', lua = 'lua', vim = 'vim', help = 'vimdoc',
  bash = 'bash', sh = 'bash', json = 'json', jsonc = 'jsonc', yaml = 'yaml',
  toml = 'toml', markdown = 'markdown', query = 'query',
}

local pattern = {}
for ft, _ in pairs(ts_filetypes) do
  table.insert(pattern, ft)
end

vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('user_treesitter', { clear = true }),
  pattern = pattern,
  callback = function(args)
    local lang = ts_filetypes[vim.bo[args.buf].filetype]
    if not lang then return end

    -- Highlighting (will silently fail if parser is not yet installed).
    pcall(vim.treesitter.start, args.buf, lang)

    -- Folding via treesitter.
    vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'

    -- Indentation: opt-in per filetype via the new main-branch helper.
    local ok_ts, ts_mod = pcall(require, 'nvim-treesitter')
    if ok_ts and ts_mod.indentexpr then
      vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end
  end,
})
