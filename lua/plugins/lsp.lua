-- LSP module: enables servers configured under lsp/<server>.lua,
-- sets up diagnostics UI, and attaches buffer-local keymaps on LspAttach.

-- Diagnostics UI.
vim.diagnostic.config({
  virtual_text = {
    source = 'if_many',
    spacing = 2,
    prefix = '●',
  },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = 'E',
      [vim.diagnostic.severity.WARN]  = 'W',
      [vim.diagnostic.severity.INFO]  = 'I',
      [vim.diagnostic.severity.HINT]  = 'H',
    },
  },
  severity_sort = true,
  update_in_insert = false,
  underline = true,
  float = {
    border = 'rounded',
    source = 'if_many',
    header = '',
    prefix = '',
  },
})

-- Hover / signature help windows with rounded borders.
vim.lsp.config('*', {
  capabilities = (function()
    local caps = vim.lsp.protocol.make_client_capabilities()
    local ok_blink, blink = pcall(require, 'blink.cmp')
    if ok_blink then
      caps = blink.get_lsp_capabilities(caps)
    end
    return caps
  end)(),
})

-- Enable servers. Their per-server config lives under <config>/lsp/<name>.lua.
vim.lsp.enable({ 'clangd', 'rust_analyzer' })

-- Buffer-local keymaps when an LSP attaches.
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('user_lsp_attach', { clear = true }),
  callback = function(args)
    local bufnr = args.buf
    local function map(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = 'LSP: ' .. desc })
    end

    map('n', 'gd', vim.lsp.buf.definition, 'Goto definition')
    map('n', 'gD', vim.lsp.buf.declaration, 'Goto declaration')
    map('n', 'gr', vim.lsp.buf.references, 'List references')
    map('n', 'gi', vim.lsp.buf.implementation, 'Goto implementation')
    map('n', 'gy', vim.lsp.buf.type_definition, 'Goto type definition')
    map('n', 'K', vim.lsp.buf.hover, 'Hover')
    -- Insert keeps <C-k>; normal uses <leader>ck so smart-splits keeps <C-k>.
    map('i', '<C-k>', vim.lsp.buf.signature_help, 'Signature help')
    map('n', '<leader>ck', vim.lsp.buf.signature_help, 'Signature help')
    map('n', '<leader>rn', vim.lsp.buf.rename, 'Rename symbol')
    map({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, 'Code action')
    map('n', '<leader>cs', vim.lsp.buf.document_symbol, 'Document symbols')
    map('n', '<leader>cw', vim.lsp.buf.workspace_symbol, 'Workspace symbols')
    map('n', '<leader>ci', function() vim.lsp.buf.incoming_calls() end, 'Incoming calls')
    map('n', '<leader>co', function() vim.lsp.buf.outgoing_calls() end, 'Outgoing calls')

    -- Toggle inlay hints (rust-analyzer / clangd).
    if vim.lsp.inlay_hint and vim.lsp.inlay_hint.enable then
      map('n', '<leader>ch', function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }), { bufnr = bufnr })
      end, 'Toggle inlay hints')
    end
  end,
})
