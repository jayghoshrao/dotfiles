local g = vim.g
local cmd = vim.cmd

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

-- -- REFERENCES:
-- https://github.com/JoosepAlviste/dotfiles/tree/master/config/nvim
