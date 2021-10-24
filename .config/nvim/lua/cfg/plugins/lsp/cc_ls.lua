local root_pattern = require'lspconfig'.util.root_pattern

-- require'lspconfig'.ccls.setup{}

require'lspconfig'.ccls.setup{
    root_dir = root_pattern(".ccls", ".ccls-root", "compile_commands.json", "compile_flags.txt", ".git") or dirname,
}
   -- capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
