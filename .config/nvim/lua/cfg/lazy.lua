
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)


function TableConcat(...)
  local result = {}
  for _, t in ipairs({...}) do
    if type(t) == "table" then
      for i = 1, #t do
        result[#result + 1] = t[i]
      end
    end
  end
  return result
end

local opts = {
    defaults = {
        lazy = false,
    }
}

local core = require('cfg.plugins_core')
local extras = require('cfg.plugins_extras')

local ok, locals = pcall(require, 'cfg.plugins_local')
if not ok then
    locals = {}
end

local plugins = TableConcat(core, extras, locals)

return require('lazy').setup(plugins, opts)
