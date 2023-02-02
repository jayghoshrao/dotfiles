require('lspconfig').ruff_lsp.setup {
  on_attach = require('cfg.plugins.lsp').on_attach,
  capabilities = require('cfg.plugins.lsp').capabilities,
  settings = {
    ruff_lsp = {
      -- Any extra CLI arguments for `ruff` go here.
      args = {},
    }
  }
}
