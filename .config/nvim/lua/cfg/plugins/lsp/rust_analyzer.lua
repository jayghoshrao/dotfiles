require'lspconfig'.rust_analyzer.setup{
    on_attach = require('cfg.plugins.lsp').on_attach,
    capabilities = require('cfg.plugins.lsp').capabilities,
    settings = {
        ["rust-analyzer"] = {
            imports = {
                granularity = {
                    group = "module",
                },
                prefix = "self",
            },
            cargo = {
                buildScripts = {
                    enable = true,
                },
            },
            procMacro = {
                enable = true
            },
        }
    }
}
