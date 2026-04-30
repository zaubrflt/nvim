-- rust-analyzer LSP configuration. Picked up by vim.lsp.enable('rust_analyzer').
-- clippy is enabled as the check command so we don't need a separate linter plugin.

return {
  cmd = { 'rust-analyzer' },
  filetypes = { 'rust' },
  root_markers = { 'Cargo.toml', 'rust-project.json', '.git' },
  settings = {
    ['rust-analyzer'] = {
      check = {
        command = 'clippy',
        extraArgs = { '--no-deps' },
      },
      cargo = {
        allFeatures = true,
        loadOutDirsFromCheck = true,
        runBuildScripts = true,
      },
      procMacro = {
        enable = true,
      },
      diagnostics = {
        enable = true,
        experimental = { enable = true },
      },
      inlayHints = {
        bindingModeHints = { enable = false },
        chainingHints = { enable = true },
        closingBraceHints = { enable = true, minLines = 25 },
        closureReturnTypeHints = { enable = 'never' },
        lifetimeElisionHints = { enable = 'never', useParameterNames = false },
        maxLength = 25,
        parameterHints = { enable = true },
        reborrowHints = { enable = 'never' },
        renderColons = true,
        typeHints = {
          enable = true,
          hideClosureInitialization = false,
          hideNamedConstructor = false,
        },
      },
    },
  },
}
