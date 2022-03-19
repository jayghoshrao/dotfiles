-- People to follow for neovim plugin development:
--    - Junegunn Choi
--    - TJ DeVries
--    - Folke
--    - The Primeagen
--
--  [NOTE]: Hub for neovim plugins: https://neovimcraft.com

-- Moving to LUA: https://cj.rs/blog/my-setup/nvim-0-5/
-- TODO: Look at vim.defer_fn()

local g = vim.g
local cmd = vim.cmd

-- Map space to leader
-- map('n', '<space>', '<nop>')
-- map('v', '<space>', '<nop>')

g.mapleader = ','
g.maplocalleader = '\\'

-- My custom configurations
require 'cfg.settings'
require 'cfg.commands'
require 'cfg.autocmds'
require 'cfg.mappings'
require 'cfg.plugins'

-- set colorscheme via autocmd hooks
cmd[[doautocmd User PlugLoaded]]

require 'cfg.folding'
require 'cfg.abbreviations'

-- require 'cfg.plugins.web_devicons' -- Set up icons before statusline
-- require 'cfg.statusline'
-- require 'cfg.tabline'
-- require 'cfg.file_info'
-- require 'cfg.terminal'

