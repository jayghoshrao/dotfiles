local FetchLspConfigs = require('cfg.utils').FetchLspConfigs
local GetConfiguredLSPs = require('cfg.utils').GetConfiguredLSPs
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

--  TODO: List files in lua/lsp/ and populate this
-- M.ensure_installed = {'lua_ls', 'clangd'} -- can be used to ensure_installed in mason-lspconfig
M.ensure_installed = GetConfiguredLSPs();

FetchLspConfigs(M.ensure_installed)

vim.lsp.config('clangd', require('lsp.clangd'))
vim.lsp.enable(M.ensure_installed)

return M
