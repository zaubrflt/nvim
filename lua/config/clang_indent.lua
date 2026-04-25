-- 自动根据 .clang-format 设置 C/C++ 缩进宽度与 Tab 规则

local M = {}

local cache = {}

local style_defaults = {
  llvm = 2,
  google = 2,
  chromium = 4,
  mozilla = 2,
  webkit = 4,
  microsoft = 4,
  gnu = 2,
}

local default_config = {
  indent_width = 4,
  expandtab = true,
}

local function clean_value(value)
  value = value:gsub("%s+#.*$", "")
  value = vim.trim(value)

  local first = value:sub(1, 1)
  local last = value:sub(-1)
  if (first == '"' and last == '"') or (first == "'" and last == "'") then
    value = value:sub(2, -2)
  end

  return value
end

local function parse_value(line, key)
  local value = line:match("^%s*" .. key .. ":%s*(.-)%s*$")
  return value and clean_value(value) or nil
end

local function parse_lines(lines)
  local indent_width
  local use_tab
  local base_style

  for _, line in ipairs(lines) do
    local width = parse_value(line, "IndentWidth")
    if width then
      indent_width = tonumber(width)
    end

    use_tab = parse_value(line, "UseTab") or use_tab
    base_style = parse_value(line, "BasedOnStyle") or base_style
  end

  if not indent_width and base_style then
    indent_width = style_defaults[base_style:lower()]
  end

  local expandtab = default_config.expandtab
  if use_tab then
    local lower = use_tab:lower()
    if lower == "always" or lower == "forindentation" or lower == "forcontinuationandindentation" then
      expandtab = false
    elseif lower == "never" or lower == "false" or lower == "alignwithspaces" then
      expandtab = true
    end
  end

  return {
    indent_width = indent_width or default_config.indent_width,
    expandtab = expandtab,
  }
end

local function get_clang_config(clang_file)
  if clang_file == "" then
    return default_config
  end

  clang_file = vim.fn.fnamemodify(clang_file, ":p")
  local stat = (vim.uv or vim.loop).fs_stat(clang_file)
  local mtime = stat and stat.mtime and stat.mtime.sec or 0
  local cached = cache[clang_file]

  if cached and cached.mtime == mtime then
    return cached.config
  end

  local ok, lines = pcall(vim.fn.readfile, clang_file)
  if not ok then
    return default_config
  end

  local config = parse_lines(lines)
  cache[clang_file] = {
    mtime = mtime,
    config = config,
  }

  return config
end

local function find_clang_file(bufnr)
  local name = vim.api.nvim_buf_get_name(bufnr)
  if name == "" then
    return vim.fn.findfile(".clang-format", ".;")
  end

  return vim.fn.findfile(".clang-format", vim.fn.fnamemodify(name, ":p:h") .. ";")
end

local function apply_to_buffer(bufnr)
  local clang_file = find_clang_file(bufnr)
  local config = get_clang_config(clang_file)
  local buffer = vim.bo[bufnr]

  buffer.shiftwidth = config.indent_width
  buffer.tabstop = config.indent_width
  buffer.softtabstop = config.indent_width
  buffer.expandtab = config.expandtab
end

function M.setup()
  local group = vim.api.nvim_create_augroup("clang_indent_settings", { clear = true })

  vim.api.nvim_create_autocmd("FileType", {
    group = group,
    pattern = { "c", "cpp" },
    callback = function(args)
      apply_to_buffer(args.buf)
    end,
  })

  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(bufnr) then
      local filetype = vim.bo[bufnr].filetype
      if filetype == "c" or filetype == "cpp" then
        apply_to_buffer(bufnr)
      end
    end
  end
end

return M

