-- local Path = require 'plenary.path'
local M = {}

function M.map(modes, lhs, rhs, opts)
  opts = opts or {}
  opts.noremap = opts.noremap == nil and true or opts.noremap
  if type(modes) == 'string' then
    modes = { modes }
  end
  for _, mode in ipairs(modes) do
    if type(rhs) == 'string' then
      vim.api.nvim_set_keymap(mode, lhs, rhs, opts)
    else
      opts.callback = rhs
      vim.api.nvim_set_keymap(mode, lhs, '', opts)
    end
  end
end

function M.buf_map(buffer, modes, lhs, rhs, opts)
  opts = opts or {}
  opts.noremap = opts.noremap == nil and true or opts.noremap
  if type(modes) == 'string' then
    modes = { modes }
  end
  for _, mode in ipairs(modes) do
    if type(rhs) == 'string' then
      vim.api.nvim_buf_set_keymap(buffer, mode, lhs, rhs, opts)
    else
      opts.callback = rhs
      vim.api.nvim_buf_set_keymap(buffer, mode, lhs, '', opts)
    end
  end
end

function M.create_augroups(definitions)
    for group_name, definition in pairs(definitions) do
        vim.cmd('augroup ' .. group_name)
        vim.cmd 'autocmd!'
        for _, def in ipairs(definition) do
            local command = table.concat(vim.tbl_flatten { 'autocmd', def }, ' ')
            vim.cmd(command)
        end
        vim.cmd 'augroup END'
    end
end

function M.termcode(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

-- Bust the cache of all required Lua files.
-- After running this, each require() would re-run the file.
local function unload_all_modules()
  -- Lua patterns for the modules to unload
  local unload_modules = {
    '^cfg.',
  }

  for k, _ in pairs(package.loaded) do
    for _, v in ipairs(unload_modules) do
      if k:match(v) then
        package.loaded[k] = nil
        break
      end
    end
  end
end

function M.reload()
  -- Stop LSP
  vim.cmd.LspStop()

  -- Unload all already loaded modules
  unload_all_modules()

  -- Source init.lua
  vim.cmd.luafile '$MYVIMRC'
end

-- Restart Vim without having to close and run again
function M.restart()
  -- Reload config
  M.reload()

  -- Manually run VimEnter autocmd to emulate a new run of Vim
  vim.cmd.doautocmd 'VimEnter'
end

function M.toggle_quickfix()
    for _, win in pairs(vim.fn.getwininfo()) do
        if win.quickfix == 1 then
            vim.cmd('cclose')
            return
        end
    end
    vim.cmd('copen')
end

function M.toggle_loclist()
    for _, win in pairs(vim.fn.getwininfo()) do
        if win.loclist == 1 then
            vim.cmd('lclose')
            return
        end
    end
    vim.cmd('lopen')
end

-- Useful function for debugging
-- Print the given items
function _G.P(...)
  local objects = vim.tbl_map(vim.inspect, { ... })
  print(unpack(objects))
end

function M.cd_root()
    local path=vim.fn.getcwd()
    local root_markers = { '.git', '.tasks', 'compile_commands.json', 'requirements.txt', 'setup.py'}

    while true do
        for _,  marker in ipairs(root_markers) do
            local marker_path = path .. '/' .. marker
            if vim.fn.isdirectory(marker_path) == 1 or vim.fn.filereadable(marker_path) == 1 then
                vim.cmd('cd ' .. path)
                print('Changed directory to: ' .. path)
                return
            end
        end

        local parent_path = vim.fn.fnamemodify(path, ':h')
        if parent_path == path then
            print('Project root not found.')
            return
        end

        path = parent_path
    end
end

-- Open init.lua and change working directory to its location
function M.editrc()
    local init_lua_path = vim.fn.stdpath('config') .. '/init.lua'

    -- Check if init.lua exists
    if vim.fn.filereadable(init_lua_path) == 1 then
        vim.cmd('silent! edit ' .. init_lua_path) -- Open init.lua
        local init_lua_dir = vim.fn.fnamemodify(init_lua_path, ':h')
        vim.cmd('cd ' .. init_lua_dir) -- Change working directory to init.lua's location
    else
        print('init.lua not found.')
    end
end

return M
