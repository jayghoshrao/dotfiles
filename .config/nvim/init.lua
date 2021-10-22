local g = vim.g

local map = require('cfg.utils').map

-- Map space to leader
-- map('n', '<space>', '<nop>')
-- map('v', '<space>', '<nop>')
g.mapleader = ','
g.maplocalleader = '\\'

-- My custom configurations
require 'cfg.settings'
require 'cfg.commands'
require 'cfg.autocmds'
require 'cfg.plugins'
require 'cfg.mappings'
-- require 'cfg.abbreviations'
-- require 'cfg.plugins.web_devicons' -- Set up icons before statusline
-- require 'cfg.statusline'
-- require 'cfg.tabline'
-- require 'cfg.file_info'
-- require 'cfg.terminal'
require 'cfg.folding'
