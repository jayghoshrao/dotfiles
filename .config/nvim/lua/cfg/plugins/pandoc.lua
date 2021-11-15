local create_augroups = require('cfg.utils').create_augroups

local bufmap = require('cfg.utils').bufmap

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
  -- vim.api.nvim_buf_set_keymap( 0, 'x', 'J', [[:<C-u>lua 
    -- require'lir.mark.actions'.toggle_mark('v')<CR>]], { noremap = true, 
    -- silent = true })
  -- vim.api.nvim_buf_set_keymap( 0, 'n', '-', [[:<C-u>lua require'lir.actions'.up()<CR>]], { noremap = true, silent = true })
  bufmap('n', '<leader>z', [[:!nohup zathura '%<.pdf' > /dev/null 2>&1 & disown<CR><CR>]], {silent = true})
  bufmap('n', '<leader>c', [[:!pdflatex '%' <CR>]], {silent = true})
  bufmap('n', '<leader>t', [[:!tectonic '%' <CR>]], {silent = true})
end

function _G.MarkdownSettings()
  bufmap('n', '<leader>t', [[:!nohup typora '%' > /dev/null 2>&1 & disown<CR><CR>]], {silent = true})
  bufmap('n', '<leader>c', [[:AsyncRun pandoc -t pdf --filter=mermaid-filter -o '%<.pdf' '%'<CR>]])
  bufmap('n', '<leader>b', [[:AsyncRun pandoc -t beamer --filter=mermaid-filter -o '%<.pdf' '%'<CR>]])
  bufmap('n', '<leader>z', [[:!nohup zathura '%<.pdf' > /dev/null 2>&1 & disown<CR><CR>]], {silent = true})
end

M = {}

-- TODO: Make these toggleable

function M.AutoPandoc()
    vim.g.autopandoc_active = 1
    create_augroups {
        AutoPandoc = {
            { 'BufWritePost', '<buffer>', [[AsyncRun pandoc -t pdf --filter=mermaid-filter -o '%<.pdf' '%']]}
        }
    }
end

function M.AutoPDFLatex()
    vim.g.autopdflatex_active = 1
    create_augroups {
        AutoPDFLatex = {
            { 'BufWritePost', '<buffer>', [[AsyncRun pdflatex '%']]}
        }
    }
end

-- FIXME: Sometimes switching between tex/md files messes this up
create_augroups {
  TexPandoc = {
    { 'Filetype', 'tex', ':lua TexSettings()' },
  },
  MDPandoc = {
    { 'Filetype', 'markdown', ':lua MarkdownSettings()' },
  },
}

vim.cmd [[command! AutoPandoc lua require'cfg.plugins.pandoc'.AutoPandoc()]]
vim.cmd [[command! AutoPDFLatex lua require'cfg.plugins.pandoc'.AutoPDFLatex()]]


return M

