-- Lightweight editing helpers. Three small plugins in one file because each
-- has trivial setup and shares the "passive ergonomics" theme.
-- Indent guides / scope come from snacks.indent + snacks.scope.

-- mini.pairs - auto-insert closing brackets, quotes, etc.
do
  local ok, pairs_mod = pcall(require, 'mini.pairs')
  if ok then
    pairs_mod.setup({
      modes = { insert = true, command = false, terminal = false },
      -- Skip auto-pair when the next char is alphanumeric, avoids "(|x" → "(|x)"
      -- inserting a stray closing paren next to existing identifiers.
      skip_next = [=[[%w%%%'%[%"%.%`%$]]=],
      skip_ts   = { 'string' },
      skip_unbalanced = true,
      markdown = true,
    })
  else
    vim.notify('mini.pairs not installed yet.', vim.log.levels.WARN)
  end
end

-- mini.surround - add / delete / replace surroundings.
-- We pick the LazyVim-style `gs*` prefix instead of mini's default `s*` so that
-- the original `s` (substitute) keeps working and flash.nvim can claim `s/S`
-- for jumping.
do
  local ok, surround = pcall(require, 'mini.surround')
  if ok then
    surround.setup({
      mappings = {
        add            = 'gsa',  -- normal & visual: gsa{motion}{char}
        delete         = 'gsd',
        find           = 'gsf',
        find_left      = 'gsF',
        highlight      = 'gsh',
        replace        = 'gsr',
        update_n_lines = 'gsn',
        suffix_last    = 'l',
        suffix_next    = 'n',
      },
      n_lines = 200,
      search_method = 'cover_or_next',
    })
    -- mini.surround registers `gs` as a group itself; no extra <nop> needed.
  else
    vim.notify('mini.surround not installed yet.', vim.log.levels.WARN)
  end
end

-- guess-indent.nvim - per-buffer detection of indent width / expandtab.
-- Runs on BufReadPost; doesn't override global vim.opt.
do
  local ok, guess = pcall(require, 'guess-indent')
  if ok then
    guess.setup({
      auto_cmd = true,
      override_editorconfig = false,
      filetype_exclude = {
        'netrw', 'tutor', 'snacks_picker_list', 'aerial', 'help',
        'dapui_scopes', 'dapui_breakpoints', 'dapui_stacks', 'dapui_watches',
      },
      buftype_exclude = { 'help', 'nofile', 'terminal', 'prompt' },
    })
  else
    vim.notify('guess-indent.nvim not installed yet.', vim.log.levels.WARN)
  end
end

-- mini.ai - extended text objects (vaf = around function, vac = around class,
-- …). Indent scope textobjects `ii`/`ai` and jumps `[i`/`]i` come from
-- snacks.scope (enabled in plugins/snacks.lua).
do
  local ok, ai = pcall(require, 'mini.ai')
  if ok then
    ai.setup({
      n_lines = 500,
      custom_textobjects = {
        -- Brace-matching is already covered by `i{` / `a{` natively; here we
        -- only register a handful of conveniences that mini.ai authors recommend.
        o = ai.gen_spec.treesitter({
          a = { '@block.outer',     '@conditional.outer', '@loop.outer' },
          i = { '@block.inner',     '@conditional.inner', '@loop.inner' },
        }),
        f = ai.gen_spec.treesitter({ a = '@function.outer',  i = '@function.inner'  }),
        c = ai.gen_spec.treesitter({ a = '@class.outer',     i = '@class.inner'     }),
        t = { '<([%p%w]-)%f[^<%w][^<>]->.-</%1>', '^<.->().*()</[^/]->$' },  -- HTML-ish tags
      },
    })
  else
    vim.notify('mini.ai not installed yet.', vim.log.levels.WARN)
  end
end
