local create_augroups = require('cfg.utils').create_augroups

local map = require('cfg.utils').map

vim.g['pandoc#syntax#conceal#use'] = 1
vim.g['pandoc#syntax#style#use_definition_lists'] = 0
vim.g['pandoc#syntax#conceal#urls'] = 1
vim.g['pandoc#formatting#mode'] = "sA"
vim.g['pandoc#formatting#smart_autoformat_on_cursormoved'] = 1
vim.g['pandoc#command#use_message_buffers'] = 1
vim.g['pandoc#folding#level'] = 1
vim.g['pandoc#folding#fold_vim_markers'] = 1
vim.g['pandoc#folding#vim_markers_in_comments_only'] = 1
vim.g['pandoc#spell#enabled'] = 0
vim.g['pandoc#keyboard#use_default_mappings'] = 1
-- vim.g['pandoc#filetypes#handled'] = {"pandoc", "markdown"}

function _G.TexSettings()
  -- vim.api.nvim_buf_set_keymap( 0, 'x', 'J', [[:<C-u>lua require'lir.mark.actions'.toggle_mark('v')<CR>]], { noremap = true, silent = true })
  -- vim.api.nvim_buf_set_keymap( 0, 'n', '-', [[:<C-u>lua require'lir.actions'.up()<CR>]], { noremap = true, silent = true })
  map('n', '<leader>z', [[:!nohup zathura '%<.pdf' > /dev/null 2>&1 & disown<CR><CR>]], {silent = true})
  map('n', '<leader>c', [[:!pdflatex '%' <CR>]], {silent = true})
  map('n', '<leader>t', [[:!tectonic '%' <CR>]], {silent = true})
end

function _G.MarkdownSettings()
  map('n', '<leader>t', [[:!nohup typora '%' > /dev/null 2>&1 & disown<CR><CR>]], {silent = true})
  map('n', '<leader>c', [[:Pandoc! pdf<CR><CR>]])
  map('n', '<leader>b', [[:Pandoc! beamer<CR><CR>]])
  map('n', '<leader>z', [[:!nohup zathura '%<.pdf' > /dev/null 2>&1 & disown<CR><CR>]], {silent = true})
end

create_augroups {
  pandoc_settings = {
    { 'Filetype', 'tex', ':lua TexSettings()' },
    { 'Filetype', 'markdown', ':lua MarkdownSettings()' },
  },
}
