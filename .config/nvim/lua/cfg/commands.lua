-- Utility commands for reloading the configuration and restarting LSP
vim.cmd [[command! -bar Restart lua require'cfg.utils'.restart()]]
vim.cmd [[command! -bar Reload lua require'cfg.utils'.reload()]]

-- gbd helpers
vim.cmd [[ command! Xg :let @+ = 'b ' . expand('%:p') . ':' . line('.') ]]
