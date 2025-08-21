local FetchLspConfigs = require('cfg.utils').FetchLspConfigs
local M = {}

vim.diagnostic.config({
  signs = {
    text = {
      [ vim.diagnostic.severity.ERROR ] = '🚩',
      [ vim.diagnostic.severity.WARN ] = '❗',
      [ vim.diagnostic.severity.HINT ] = '🪧',
      [ vim.diagnostic.severity.INFO ] = '❕',
    },
  },
  virtual_text = {current_line = true},
})

M.ensure_installed = {'lua_ls', 'clangd', 'basedpyright', 'ruff', 'texlab'} -- can be used to ensure_installed in mason-lspconfig

FetchLspConfigs(M.ensure_installed)
vim.lsp.enable(M.ensure_installed)

return M
