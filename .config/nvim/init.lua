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
require 'cfg.mappings'
require 'cfg.plugins'

vim.cmd.colorscheme 'catppuccin-mocha'

-- set colorscheme via autocmd hooks
-- cmd[[doautocmd User PlugLoaded]]
require 'cfg.autocmds'
require 'cfg.folding'
require 'cfg.abbreviations'

-- require 'cfg.plugins.web_devicons' -- Set up icons before statusline
-- require 'cfg.statusline'
-- require 'cfg.tabline'
-- require 'cfg.file_info'
-- require 'cfg.terminal'

-- -- REFERENCES:
-- https://github.com/JoosepAlviste/dotfiles/tree/master/config/nvim
