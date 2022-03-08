require'lspconfig'.fortls.setup{
  on_attach = require('cfg.plugins.lsp').on_attach,
  capabilities = require('cfg.plugins.lsp').capabilities,
  cmd = { "fortls", "--enable_code_actions", "--hover_signature", "--variable_hover", "--lowercase_intrinsics"}
}
