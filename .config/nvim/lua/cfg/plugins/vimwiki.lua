vim.g['vimwiki_list'] = {
    {
        path = '/home/jayghoshter/Dropbox/Notes',
        syntax = 'markdown',
        ext = '.md',
    },
}

vim.g.vimwiki_folding = 'expr'
vim.g.vimwiki_table_mappings = 0

require 'cfg.utils'.map('n', '<leader>vwl', '<Plug>VimwikiNextLink', {noremap=false} )
require 'cfg.utils'.map('n', '<leader>vwh', '<Plug>VimwikiPrevLink', {noremap=false} )
