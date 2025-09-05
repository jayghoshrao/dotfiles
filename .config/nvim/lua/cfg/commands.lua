-- gdb helper
vim.cmd [[ command! Xg :let @+ = 'b ' . expand('%:p') . ':' . line('.') ]]

-- CppMan
vim.cmd [[ command! CppMan lua require'cfg.utils'.CppMan() ]]

vim.cmd [[ command! RC lua require'cfg.utils'.editrc() ]]

-- remove trailing white space
vim.api.nvim_create_user_command("Nows", "%s/\\s\\+$//e", { desc = "remove trailing whitespace" })

-- remove blank lines
vim.api.nvim_create_user_command("Nobl", "g/^\\s*$/d", { desc = "remove blank lines" })
