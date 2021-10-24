-- https://github.com/rcjsuen/dockerfile-language-server-nodejs
require('lspconfig').dockerls.setup {
  on_attach = require('cfg.plugins.lsp').on_attach,
  capabilities = require('cfg.plugins.lsp').capabilities,
  flags = {
    debounce_text_changes = 150,
  },
}
