local root_pattern = require'lspconfig'.util.root_pattern

require'lspconfig'.clangd.setup{
    root_dir = root_pattern(".clangd", "compile_commands.json", "compile_flags.txt", ".git") or dirname,
    on_attach = require('cfg.plugins.lsp').on_attach,
    capabilities = require('cfg.plugins.lsp').capabilities,
}
   -- capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
