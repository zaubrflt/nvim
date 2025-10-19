-- 自动根据 .clang-format 设置缩进宽度与 Tab 规则
-- 支持 BasedOnStyle 推断默认 IndentWidth
-- 默认：4 空格；若发现 .clang-format，则解析其中的配置

local M = {}

function M.setup()
  vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
    callback = function()
      local clang_file = vim.fn.findfile(".clang-format", ".;")
      if clang_file == "" then
        -- 没有 .clang-format
        vim.bo.shiftwidth = 4
        vim.bo.tabstop = 4
        vim.bo.softtabstop = 4
        vim.bo.expandtab = true
        return
      end

      local lines = vim.fn.readfile(clang_file)
      local indent_width = nil
      local use_tab = nil
      local base_style = nil

      for _, line in ipairs(lines) do
        local width = line:match("^%s*IndentWidth:%s*(%d+)")
        if width then
          indent_width = tonumber(width)
        end

        local tab_policy = line:match("^%s*UseTab:%s*(%S+)")
        if tab_policy then
          use_tab = tab_policy
        end

        local base = line:match("^%s*BasedOnStyle:%s*(%S+)")
        if base then
          base_style = base
        end
      end

      -- 如果没写 IndentWidth，则根据 BasedOnStyle 推断
      if not indent_width and base_style then
        local defaults = {
          LLVM = 2,
          Google = 2,
          Chromium = 4,
          Mozilla = 2,
          WebKit = 4,
          Microsoft = 4,
          GNU = 2,
        }
        indent_width = defaults[base_style] or 4
      end

      -- 应用结果
      indent_width = indent_width or 4
      vim.bo.shiftwidth = indent_width
      vim.bo.tabstop = indent_width
      vim.bo.softtabstop = indent_width

      if use_tab then
        local lower = use_tab:lower()
        if lower == "always" then
          vim.bo.expandtab = false
        elseif lower == "never" or lower == "false" then
          vim.bo.expandtab = true
        end
      else
        vim.bo.expandtab = true
      end
    end,
  })
end

return M

