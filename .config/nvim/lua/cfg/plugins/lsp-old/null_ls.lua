local util = require 'lspconfig.util'
local null_ls = require 'null-ls'

null_ls.setup({
    sources = {
        null_ls.builtins.formatting.black,
        null_ls.builtins.diagnostics.ruff,
        null_ls.builtins.diagnostics.mypy.with({
            extra_args = function()
                local virtual = os.getenv("VIRTUAL_ENV") or os.getenv("CONDA_PREFIX") or "/usr"
                return { "--python-executable", virtual .. "/bin/python3" }
            end,
        })
    },
})

-- require('lspconfig')['null-ls'].setup {
--   on_attach = require('cfg.plugins.lsp').on_attach,
--   root_dir = util.root_pattern('.git'),
-- }
