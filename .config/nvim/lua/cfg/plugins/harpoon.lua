local map = require'cfg.utils'.map

require("harpoon").setup({
    global_settings = {
        save_on_toggle = false,
        save_on_change = true,
        enter_on_sendcmd = false,
    },
})

map('n', '<space>a', [[<cmd>lua require("harpoon.mark").add_file()<CR>]])
map('n', '<C-e>', [[<cmd>lua require("harpoon.ui").toggle_quick_menu()<CR>]])
map('n', '<leader>tc', [[<cmd>lua require("harpoon.cmd-ui").toggle_quick_menu()<CR>]])

map('n', '<space>1', [[<cmd>lua require("harpoon.ui").nav_file(1)<CR>]])
map('n', '<space>2', [[<cmd>lua require("harpoon.ui").nav_file(2)<CR>]])
-- map('n', '<C-n>', [[<cmd>lua require("harpoon.ui").nav_file(3)<CR>]])
-- map('n', '<C-s>', [[<cmd>lua require("harpoon.ui").nav_file(4)<CR>]])

map('n', '<leader>tu', [[<cmd>lua require("harpoon.term").gotoTerminal(1)<CR>]])
map('n', '<leader>te', [[<cmd>lua require("harpoon.term").gotoTerminal(2)<CR>]])

map('n', '<leader>cu', [[<cmd>lua require("harpoon.term").sendCommand(1, 1)<CR>]])
map('n', '<leader>ce', [[<cmd>lua require("harpoon.term").sendCommand(1, 2)<CR>]])
