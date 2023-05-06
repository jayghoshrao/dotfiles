
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

function TableConcat(t1,t2)
   for i=1,#t2 do
      t1[#t1+1] = t2[i]
   end
   return t1
end

local opts = {
    defaults = {
        lazy = false,
    }
}

local core = require('cfg.plugins_core')
local extras = require('cfg.plugins_extras')
plugins = TableConcat(core, extras)

return require('lazy').setup(plugins, opts)
