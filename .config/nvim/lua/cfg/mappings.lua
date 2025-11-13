local map = require('cfg.utils').map

local silent = { silent = true }

-- Better pane movements
map('n', '<c-h>', '<c-w>h')
map('n', '<c-j>', '<c-w>j')
map('n', '<c-k>', '<c-w>k')
map('n', '<c-l>', '<c-w>l')

-- Yank from the cursor to the end of the line, like C and D
map('n', 'Y', 'y$')

-- Ex-mode is weird and not useful so it seems better to repeat the last macro
map('n', 'Q', '@@')

-- Navigate merge conflict markers
map('n', ']n', [[:call search('^\(@@ .* @@\|[<=>|]\{7}[<=>|]\@!\)', 'W')<cr>]], { silent = true })
map('n', '[n', [[:call search('^\(@@ .* @@\|[<=>|]\{7}[<=>|]\@!\)', 'bW')<cr>]], { silent = true })

-- Navigate loclist
map('n', ']l', ':lnext<cr>', { silent = true })
map('n', '[l', ':lprev<cr>', { silent = true })

-- Quit the buffer
map('n', '<leader>q', ':quit<cr>', silent)

-- NOTE: Quit Vim without saving
map('n', '<leader>x', ':q!<cr>', silent)

-- -- Quit Vim without closing windows (useful for keeping a session)
-- map('n', '<leader>x', ':quitall<cr>', silent)

-- Save
map('n', '<leader>w', ':silent w!<cr>', silent)
map('n', '<c-s>', ':w!<cr>', silent)
map('i', '<c-s>', '<esc>:w!<cr>', silent)

-- Move to the start of the line
map('c', '<c-a>', '<home>')

-- Visual shifting does not exit Visual mode
map('v', '<', '<gv')
map('v', '>', '>gv')

-- Around line: with leading and trailing whitespace
map('v', 'al', ':<c-u>silent! normal! 0v$<cr>', { silent = true })
map('o', 'al', ':normal val<cr>', { noremap = false, silent = true })

-- Inner line: without leading or trailing whitespace
map('v', 'il', ':<c-u>silent! normal! ^vg_<cr>', { silent = true })
map('o', 'il', ':normal vil<cr>', { noremap = false, silent = true })

-- Whole file, jump back with <c-o>
map('v', 'ae', [[:<c-u>silent! normal! m'gg0VG$<cr>]], { silent = true })
map('o', 'ae', ':normal Vae<cr>', { noremap = false, silent = true })

-- Personal
map({'n', 'v'},'j', 'gj')
map({'n', 'v'},'k', 'gk')

map({'n', 'v'}, 'J', '<c-d>')
map({'n', 'v'}, 'K', '<c-u>')
map({'n', 'v'}, 'H', 'g^')
map({'n', 'v'}, 'L', 'g$')

-- undo
map('n', 'U', '<c-r>')

-- typohacks
-- TODO: Make this filetype specific to c/c++
-- map('i', ';;', '<esc>A;<esc>')
-- map('i', ':;', '::')


map('n', '<Left>', ':vertical resize +5<CR>')
map('n', '<Right>', ':vertical resize -5<CR>')

-- directory commands
map('n', '<leader>d', ':lcd %:p:h<cr>')     -- change working dir to that of current file
map('n', '<leader>ld', ':pwd<cr>')          -- print current dir
map('n', '<leader>lcd', ':lcd ~/')          -- prompt for changing working dir

-- find and cd into root directory
map('n', '<leader>r', ":lua require('cfg.utils').cd_root()<CR>")


-- Strip trailing whitespace
-- map('n', '<F2>', ':%s/\s*$//e<CR>')

map('n', '<space><space>', '<c-^>')
map('n', '<BS><BS>', '<c-^>')

map('n', '<space>x', ':bdelete!<CR>' )

-- tabs
map( 'n', 'tn', ':tabnew<Space>' )
map( 'n', 'td', ':tabclose<Space>' )
map( 'n', 'tk', ':tabnext<CR>' )
map( 'n', 'tj', ':tabprev<CR>' )
map( 'n', 'th', ':tabfirst<CR>' )
map( 'n', 'tl', ':tablast<CR>' )

-- Handled by quicker.nvim
-- map('n', '<space>q', [[<cmd>lua require('cfg.utils').toggle_quickfix()<cr>]])
-- map('n', '<space>w', [[<cmd>lua require('cfg.utils').toggle_loclist()<cr>]])

map('n', '<leader>,', ':MaximizerToggle<cr>', {silent = true})

map('n', '<leader>..', ':Reload')
map('n', '<leader>.e', ':e $MYVIMRC<cr>', silent)

-- Thanks Primeagen
-- n /zz = center/zv = open folds
map('n', 'n', 'nzzzv')
map('n', 'N', 'Nzzzv')

map('n', '<leader>jl', '<s-j>') -- standard
-- map('n', '<leader>jl', 'mz<s-j>`z') -- not repeatable

-- -- focus scrolling
-- Disabled since neoscroll seems to override it anyway
-- map("n", "<C-d>", "<C-d>zz")
-- map("n", "<C-u>", "<C-u>zz")

-- Undo break points: punctuation breaks undo into fragments
map('i', ',', ',<c-g>u')
map('i', '.', '.<c-g>u')
map('i', '!', '!<c-g>u')
map('i', '?', '?<c-g>u')

-- Move text without ruining registers
map('n', '<a-j>', ':m .+1<CR>==')
map('n', '<a-k>', ':m .-2<CR>==')
map('i', '<a-j>', '<esc>:m .+1<CR>==i')
map('i', '<a-k>', '<esc>:m .-2<CR>==i')
map('v', '<a-j>', ":m '>+1<CR>gv=gv" )
map('v', '<a-k>', ":m '<-2<CR>gv=gv" )

-- -- Quick German mappings
-- map('i', '<a-s>', 'ß')
-- map('i', '<a-a>', 'ä')
-- map('i', '<a-o>', 'ö')
-- map('i', '<a-u>', 'ü')
-- map('i', '<a-s-a>', 'Ä')
-- map('i', '<a-s-o>', 'Ö')
-- map('i', '<a-s-u>', 'Ü')
