local g = vim.g

g.mapleader = ','
g.maplocalleader = '\\'

-- My custom configurations
require 'cfg.settings'
require 'cfg.commands'
require 'cfg.mappings'
require 'cfg.plugins'

-- set colorscheme via autocmd hooks
-- cmd[[doautocmd User PlugLoaded]]
require 'cfg.autocmds'
require 'cfg.folding'
require 'cfg.abbreviations'

-- -- REFERENCES:
-- https://github.com/JoosepAlviste/dotfiles/tree/master/config/nvim
