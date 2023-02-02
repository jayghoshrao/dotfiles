require'lspconfig'.pyright.setup{
  on_attach = require('cfg.plugins.lsp').on_attach,
  capabilities = require('cfg.plugins.lsp').capabilities,
}

