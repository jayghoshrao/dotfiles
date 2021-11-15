local map = require('cfg.utils').map

-- vim.g.vsnip_snippet_dir = '~/.config/nvim/vsnip'
-- vim.g.vsnip_filetypes = {
--   typescript = { 'javascript' },
--   typescriptreact = { 'javascript', 'typescript' },
--   vue = { 'javascript', 'typescript' },
-- }


-- Expand
map('i', '<C-a>', [[vsnip#expandable()  ? '<Plug>(vsnip-expand)' : '<C-a>']], {expr = true, noremap = false})
map('s', '<C-a>', [[vsnip#expandable()  ? '<Plug>(vsnip-expand)' : '<C-a>']], {expr = true, noremap = false})

-- Expand or jump
map('i', '<c-n>', [[vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-n>']], {expr = true, noremap = false})
map('s', '<c-n>', [[vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-n>']], {expr = true, noremap = false})

-- Jump forward or backward
map('i', '<Tab>', [[vsnip#jumpable(1)  ? '<Plug>(vsnip-jump-next)' : '<Tab>']], {expr = true, noremap = false})
map('s', '<Tab>', [[vsnip#jumpable(1)  ? '<Plug>(vsnip-jump-next)' : '<Tab>']], {expr = true, noremap = false})
map('i', '<S-Tab>', [[vsnip#jumpable(1)  ? '<Plug>(vsnip-jump-prev)' : '<S-Tab>']], {expr = true, noremap = false})
map('s', '<S-Tab>', [[vsnip#jumpable(1)  ? '<Plug>(vsnip-jump-prev)' : '<S-Tab>']], {expr = true, noremap = false})

-- -- Select or cut text to use as $TM_SELECTED_TEXT in the next snippet.
-- -- See https://github.com/hrsh7th/vim-vsnip/pull/50
-- nmap        s   <Plug>(vsnip-select-text)
-- xmap        s   <Plug>(vsnip-select-text)
-- nmap        S   <Plug>(vsnip-cut-text)
-- xmap        S   <Plug>(vsnip-cut-text)

--------
-- Expand or jump
-- map('i', '<tab>', [[vsnip#available(1) ? '<Plug>(vsnip-expand-or-jump)' : '<tab>']], { expr = true, noremap = false })
-- map('s', '<tab>', [[vsnip#available(1) ? '<Plug>(vsnip-expand-or-jump)' : '<tab>']], { expr = true, noremap = false })

-- map('i', '<s-tab>', [[vsnip#jumpable(-1) ? '<Plug>(vsnip-jump-prev)' : '<s-tab>']], { expr = true, noremap = false })
-- map('s', '<s-tab>', [[vsnip#jumpable(-1) ? '<Plug>(vsnip-jump-prev)' : '<s-tab>']], { expr = true, noremap = false })
