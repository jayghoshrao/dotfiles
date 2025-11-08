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

-- NOTE: Use FetchLspConfigs() to install lsp configs to lua/lsp

-- List files in lua/lsp/ and populate ensure_installed 
M.ensure_installed = GetConfiguredLSPs();

for index, lsp_name in ipairs(M.ensure_installed) do
    vim.lsp.config(lsp_name, require('lsp.' .. lsp_name))
    vim.lsp.enable(lsp_name)
end

return M
