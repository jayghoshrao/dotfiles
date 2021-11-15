local map = require('cfg.utils').map

vim.cmd[[let g:nnn#action = {'<c-v>': 'vsplit', '<c-t>': 'tab split', '<c-x>': 'split'}]]

vim.g['nnn#replace_netrw'] = 1

vim.g['nnn#command'] = 'nnn -eo'
vim.g['nnn#set_default_mappings'] = 1
map('n', '<leader>f', ':NnnPicker %:p:h<CR>')
map('n', '<leader>e', ':NnnExplorer %:p:h<CR>')

-- Or pass a dictionary with window size
-- vim.g[ 'nnn#layout' ] = { left = '~40%' } -- or right, up, down

vim.g[ 'nnn#layout' ]  = { window =  { width = 0.9, height = 0.6, highlight = 'Debug' } }
vim.g[ 'nnn#explorer_layout' ] = { left = '~30%' } -- or right, up, down

vim.g[ 'nnn#session' ] = 'local'
