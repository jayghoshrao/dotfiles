-- Utility commands for reloading the configuration and restarting LSP
vim.cmd [[command! Restart lua require'cfg.utils'.restart()]]
vim.cmd [[command! Reload lua require'cfg.utils'.reload()]]
