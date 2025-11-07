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
M.ensure_installed = GetConfiguredLSPs();

-- FetchLspConfigs(M.ensure_installed)

for index, lsp_name in ipairs(M.ensure_installed) do
    vim.lsp.config(lsp_name, require('lsp.' .. lsp_name))
    vim.lsp.enable(lsp_name)
end

return M
