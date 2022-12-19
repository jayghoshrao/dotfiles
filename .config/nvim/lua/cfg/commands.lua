-- Utility commands for reloading the configuration and restarting LSP
vim.api.nvim_create_user_command('Restart', function()
  require('j.utils').restart()
end, {})
vim.api.nvim_create_user_command('Reload', function()
  require('j.utils').reload()
end, {})

-- gdb helper
vim.cmd [[ command! Xg :let @+ = 'b ' . expand('%:p') . ':' . line('.') ]]

-- CppMan
vim.cmd [[ command! CppMan lua require'cfg.utils'.CppMan() ]]

