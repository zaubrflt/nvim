-- vim.pack management keymaps (LazyVim <leader>l + Astro-style subcommands).
-- <leader>p is clipboard paste; use <leader>l for Pack instead.

local map = vim.keymap.set

local function pack_ready()
  if vim.pack and vim.pack.add then
    return true
  end
  vim.notify('vim.pack is unavailable (need Neovim >= 0.12)', vim.log.levels.ERROR)
  return false
end

--- @return { name: string, active: boolean, path: string, rev: string }[]
local function plugin_items()
  local items = {}
  for _, info in ipairs(vim.pack.get()) do
    items[#items + 1] = {
      name = info.spec.name,
      active = info.active,
      path = info.path,
      rev = info.rev or '',
    }
  end
  table.sort(items, function(a, b)
    return a.name < b.name
  end)
  return items
end

--- @param prompt string
--- @param on_choice fun(item: { name: string, active: boolean, path: string, rev: string })
local function select_plugin(prompt, on_choice)
  local items = plugin_items()
  if #items == 0 then
    vim.notify('No vim.pack plugins found', vim.log.levels.WARN)
    return
  end

  vim.ui.select(items, {
    prompt = prompt,
    format_item = function(item)
      local mark = item.active and '*' or ' '
      local rev = item.rev ~= '' and item.rev:sub(1, 7) or '?'
      return string.format('%s %s  %s', mark, item.name, rev)
    end,
  }, function(item)
    if item then
      on_choice(item)
    end
  end)
end

map('n', '<leader>lu', function()
  if not pack_ready() then
    return
  end
  vim.pack.update()
end, { desc = 'Pack: update all' })

map('n', '<leader>lU', function()
  if not pack_ready() then
    return
  end
  select_plugin('Update plugin', function(item)
    vim.pack.update({ item.name })
  end)
end, { desc = 'Pack: update one' })

map('n', '<leader>lb', function()
  if not pack_ready() then
    return
  end
  vim.pack.update(nil, { offline = true })
end, { desc = 'Pack: browse installed' })

map('n', '<leader>lh', '<cmd>checkhealth vim.pack<cr>', { desc = 'Pack: checkhealth' })

map('n', '<leader>ll', function()
  local path = vim.fs.joinpath(vim.fn.stdpath('log'), 'nvim-pack.log')
  vim.cmd.edit(path)
end, { desc = 'Pack: open log' })

map('n', '<leader>lr', function()
  if not pack_ready() then
    return
  end
  select_plugin('Reinstall plugin (delete + restart)', function(item)
    vim.pack.del({ item.name }, { force = true })
    vim.notify(
      string.format("Removed '%s'. Run :restart to reinstall from lockfile.", item.name),
      vim.log.levels.INFO
    )
  end)
end, { desc = 'Pack: reinstall one' })

map('n', '<leader>lx', function()
  if not pack_ready() then
    return
  end
  select_plugin('Delete plugin from disk', function(item)
    local ok, err = pcall(vim.pack.del, { item.name }, { force = item.active })
    if not ok then
      vim.notify(tostring(err), vim.log.levels.ERROR)
      return
    end
    vim.notify(
      string.format(
        "Removed '%s' from disk. Remove its vim.pack.add() entry or it will reinstall on restart.",
        item.name
      ),
      vim.log.levels.INFO
    )
  end)
end, { desc = 'Pack: delete from disk' })
