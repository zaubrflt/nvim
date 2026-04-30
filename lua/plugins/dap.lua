-- nvim-dap + dap-ui + virtual-text. C++ and Rust both run via codelldb.
--
-- Codelldb is expected on $PATH (see README). On Windows the executable is
-- usually `codelldb.cmd` (or `codelldb.exe` inside the extension's adapter dir).

local ok_dap, dap = pcall(require, 'dap')
if not ok_dap then
  vim.notify('nvim-dap not installed yet.', vim.log.levels.WARN)
  return
end

local ok_ui, dapui = pcall(require, 'dapui')
if ok_ui then
  dapui.setup({
    layouts = {
      {
        elements = {
          { id = 'scopes',      size = 0.3 },
          { id = 'breakpoints', size = 0.2 },
          { id = 'stacks',      size = 0.25 },
          { id = 'watches',     size = 0.25 },
        },
        position = 'left',
        size = 40,
      },
      {
        elements = {
          { id = 'repl',    size = 0.5 },
          { id = 'console', size = 0.5 },
        },
        position = 'bottom',
        size = 10,
      },
    },
    floating = { border = 'rounded' },
  })

  dap.listeners.before.attach['dapui_config'] = function() dapui.open() end
  dap.listeners.before.launch.dapui_config = function() dapui.open() end
  dap.listeners.before.event_terminated['dapui_config'] = function() dapui.close() end
  dap.listeners.before.event_exited['dapui_config'] = function() dapui.close() end
end

local ok_vt, dap_vt = pcall(require, 'nvim-dap-virtual-text')
if ok_vt then
  dap_vt.setup({
    enabled = true,
    enabled_commands = true,
    highlight_changed_variables = true,
    highlight_new_as_changed = false,
    show_stop_reason = true,
    commented = false,
  })
end

-- Sign characters for breakpoints / stop position.
vim.fn.sign_define('DapBreakpoint',          { text = '●', texthl = 'DiagnosticError', linehl = '', numhl = '' })
vim.fn.sign_define('DapBreakpointCondition', { text = '◆', texthl = 'DiagnosticWarn',  linehl = '', numhl = '' })
vim.fn.sign_define('DapLogPoint',            { text = '◆', texthl = 'DiagnosticInfo',  linehl = '', numhl = '' })
vim.fn.sign_define('DapStopped',             { text = '▶', texthl = 'DiagnosticOk',    linehl = 'Visual', numhl = '' })
vim.fn.sign_define('DapBreakpointRejected',  { text = '○', texthl = 'DiagnosticError', linehl = '', numhl = '' })

-- codelldb adapter (works for C, C++, Rust).
dap.adapters.codelldb = {
  type = 'server',
  port = '${port}',
  executable = {
    command = 'codelldb',
    args = { '--port', '${port}' },
    -- On Windows, set detached = false to avoid keeping a stray cmd window open.
    detached = vim.fn.has('win32') == 0,
  },
}

local function pick_executable()
  return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
end

local cpp_cfg = {
  {
    name = 'Launch executable',
    type = 'codelldb',
    request = 'launch',
    program = pick_executable,
    cwd = '${workspaceFolder}',
    stopOnEntry = false,
    args = {},
    runInTerminal = false,
  },
  {
    name = 'Attach to process',
    type = 'codelldb',
    request = 'attach',
    pid = require('dap.utils').pick_process,
    args = {},
  },
}

dap.configurations.cpp = cpp_cfg
dap.configurations.c = cpp_cfg
dap.configurations.rust = {
  {
    name = 'Launch (cargo target)',
    type = 'codelldb',
    request = 'launch',
    program = function()
      -- Try to pick from `target/debug/` for convenience.
      local default = vim.fn.getcwd() .. '/target/debug/'
      return vim.fn.input('Path to executable: ', default, 'file')
    end,
    cwd = '${workspaceFolder}',
    stopOnEntry = false,
    sourceLanguages = { 'rust' },
    args = {},
  },
  {
    name = 'Attach to process',
    type = 'codelldb',
    request = 'attach',
    pid = require('dap.utils').pick_process,
    args = {},
  },
}

local map = vim.keymap.set
map('n', '<F5>',  function() dap.continue()      end, { desc = 'DAP: Continue / Start' })
map('n', '<F10>', function() dap.step_over()     end, { desc = 'DAP: Step over' })
map('n', '<F11>', function() dap.step_into()     end, { desc = 'DAP: Step into' })
map('n', '<F12>', function() dap.step_out()      end, { desc = 'DAP: Step out' })
map('n', '<leader>db', function() dap.toggle_breakpoint() end, { desc = 'DAP: Toggle breakpoint' })
map('n', '<leader>dB', function()
  vim.ui.input({ prompt = 'Condition: ' }, function(cond)
    if cond and cond ~= '' then dap.set_breakpoint(cond) end
  end)
end, { desc = 'DAP: Conditional breakpoint' })
map('n', '<leader>dl', function()
  vim.ui.input({ prompt = 'Log message: ' }, function(msg)
    if msg and msg ~= '' then dap.set_breakpoint(nil, nil, msg) end
  end)
end, { desc = 'DAP: Log point' })
map('n', '<leader>dr', function() dap.repl.toggle() end, { desc = 'DAP: Toggle REPL' })
map('n', '<leader>dt', function() dap.terminate()  end, { desc = 'DAP: Terminate' })
map('n', '<leader>dc', function() dap.run_to_cursor() end, { desc = 'DAP: Run to cursor' })

if ok_ui then
  map('n', '<leader>du', function() dapui.toggle()    end, { desc = 'DAP: Toggle UI' })
  map({ 'n', 'v' }, '<leader>de', function() dapui.eval() end, { desc = 'DAP: Eval expression' })
end
