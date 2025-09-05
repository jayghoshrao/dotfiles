--                          ███
--                         ▒▒▒
--  ████████   █████ █████ ████  █████████████
-- ▒▒███▒▒███ ▒▒███ ▒▒███ ▒▒███ ▒▒███▒▒███▒▒███
--  ▒███ ▒███  ▒███  ▒███  ▒███  ▒███ ▒███ ▒███
--  ▒███ ▒███  ▒▒███ ███   ▒███  ▒███ ▒███ ▒███
--  ████ █████  ▒▒█████    █████ █████▒███ █████
-- ▒▒▒▒ ▒▒▒▒▒    ▒▒▒▒▒    ▒▒▒▒▒ ▒▒▒▒▒ ▒▒▒ ▒▒▒▒▒


vim.g.mapleader = ','
vim.g.maplocalleader = '\\'

require 'cfg.settings'
require 'cfg.commands'
require 'cfg.mappings'
require 'cfg.autocmds'
require 'cfg.folding'
require 'cfg.abbreviations'
require 'cfg.lsp'
require 'cfg.lazy' -- Loads cfg.plugins_core cfg.plugins_extras
