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

-- ─────────────────────────────────────────────────────────────────────────────
-- nvim-treesitter-textobjects (main branch tracks nvim-treesitter `main`).
-- Provides @function.inner / @class.outer / @parameter.inner etc., which we
-- then bind manually since the new API is opt-in per keymap.
-- ─────────────────────────────────────────────────────────────────────────────
do
  local ok_to, to = pcall(require, 'nvim-treesitter-textobjects')
  if ok_to then
    -- Preferred way to set up on the new main-branch API.
    if to.setup then
      to.setup({ select = { lookahead = true } })
    end
  end

  -- Keymaps below resolve at runtime; if textobjects isn't loaded yet they
  -- still work, just without the TS-aware fall-through.
  local map = vim.keymap.set
  local function select(capture)
    return function()
      local ok_sel, sel = pcall(require, 'nvim-treesitter-textobjects.select')
      if ok_sel and sel.select_textobject then
        sel.select_textobject(capture, 'textobjects')
      end
    end
  end
  -- Function / class objects (i = inner, a = around).
  map({ 'x', 'o' }, 'af', select('@function.outer'),  { desc = 'TS: a function' })
  map({ 'x', 'o' }, 'if', select('@function.inner'),  { desc = 'TS: inner function' })
  map({ 'x', 'o' }, 'ac', select('@class.outer'),     { desc = 'TS: a class' })
  map({ 'x', 'o' }, 'ic', select('@class.inner'),     { desc = 'TS: inner class' })
  map({ 'x', 'o' }, 'aa', select('@parameter.outer'), { desc = 'TS: a parameter' })
  map({ 'x', 'o' }, 'ia', select('@parameter.inner'), { desc = 'TS: inner parameter' })

  -- Move between textobjects (TS-aware ]m / [m).
  local function move(direction, capture)
    return function()
      local ok_mv, mv = pcall(require, 'nvim-treesitter-textobjects.move')
      if ok_mv then
        if direction == 'next_start'  then mv.goto_next_start(capture, 'textobjects')
        elseif direction == 'next_end'    then mv.goto_next_end(capture, 'textobjects')
        elseif direction == 'prev_start' then mv.goto_previous_start(capture, 'textobjects')
        elseif direction == 'prev_end'   then mv.goto_previous_end(capture, 'textobjects')
        end
      end
    end
  end
  map({ 'n', 'x', 'o' }, ']m', move('next_start',  '@function.outer'), { desc = 'TS: next function start' })
  map({ 'n', 'x', 'o' }, ']M', move('next_end',    '@function.outer'), { desc = 'TS: next function end' })
  map({ 'n', 'x', 'o' }, '[m', move('prev_start',  '@function.outer'), { desc = 'TS: prev function start' })
  map({ 'n', 'x', 'o' }, '[M', move('prev_end',    '@function.outer'), { desc = 'TS: prev function end' })
end

-- ─────────────────────────────────────────────────────────────────────────────
-- treesitter-context - sticky header showing the function / class / loop
-- the cursor is currently inside, useful for long C++ bodies.
-- ─────────────────────────────────────────────────────────────────────────────
do
  local ok_ctx, ctx = pcall(require, 'treesitter-context')
  if ok_ctx then
    ctx.setup({
      enable = true,
      max_lines = 4,
      min_window_height = 20,
      line_numbers = true,
      multiline_threshold = 1,
      trim_scope = 'outer',
      mode = 'cursor',
      separator = nil,
      zindex = 20,
    })
    vim.keymap.set('n', '[c', function() ctx.go_to_context(vim.v.count1) end,
      { desc = 'Jump to outer treesitter context' })
  end
end
