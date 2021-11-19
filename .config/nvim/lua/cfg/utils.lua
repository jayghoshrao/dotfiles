local cmd = vim.cmd
local opt = vim.opt

local M = {}

function M.map(modes, lhs, rhs, opts)
    opts = opts or {}
    -- noremap is on by default
    opts.noremap = opts.noremap == nil and true or opts.noremap
    if type(modes) == 'string' then
        modes = { modes }
    end
    for _, mode in ipairs(modes) do
        vim.api.nvim_set_keymap(mode, lhs, rhs, opts)
    end
end

function M.bufmap(modes, lhs, rhs, opts)
    opts = opts or {}
    -- noremap is on by default
    opts.noremap = opts.noremap == nil and true or opts.noremap
    if type(modes) == 'string' then
        modes = { modes }
    end
    for _, mode in ipairs(modes) do
        vim.api.nvim_buf_set_keymap(0, mode, lhs, rhs, opts)
    end
end

function M.create_augroups(definitions)
    for group_name, definition in pairs(definitions) do
        cmd('augroup ' .. group_name)
        cmd 'autocmd!'
        for _, def in ipairs(definition) do
            local command = table.concat(vim.tbl_flatten { 'autocmd', def }, ' ')
            cmd(command)
        end
        cmd 'augroup END'
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

-- function M.sourceconf()
-- end

function M.reload()
    -- Stop LSP
    cmd 'LspStop'

    -- require('plenary.reload').reload_module('cfg', true)

    -- Unload all already loaded modules
    unload_all_modules()

    -- Source init.lua
    cmd 'luafile $MYVIMRC'
end

-- Restart Vim without having to close and run again
function M.restart()
    -- Reload config
    M.reload()

    -- Manually run VimEnter autocmd to emulate a new run of Vim
    cmd 'doautocmd VimEnter'
end

-- Execute `PackerUpdate` every day automatically so that we are always up to
-- date!
-- I run `PackerUpdate` manually anyways, so it makes sense to run it
-- automatically.
--
-- The last saved date is saved into `XDG_CACHE_HOME/.plugins_updated_at`.
function M.update_plugins_every_day()
    local plugin_updated_at_filename = vim.env.HOME .. '/.config/.plugins_updated_at'
    local file = io.open(plugin_updated_at_filename)
    if not file then
        vim.fn.writefile({}, plugin_updated_at_filename)
        file:close()
    end

    local today = os.date '%Y-%m-%d'

    file = io.open(plugin_updated_at_filename)
    local contents = file:read '*a'
    if contents ~= today then
        vim.fn.execute 'PackerUpdate'

        file = io.open(plugin_updated_at_filename, 'w')
        file:write(today)
    end

    file:close()
end

-- Useful function for debugging
-- Print the given items
function _G.dump(...)
    local objects = vim.tbl_map(vim.inspect, { ... })
    print(unpack(objects))
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

-- Create non existent directories when vim passed a filepath
function M.MkNonExDir(file, buf)
    -- only do it for normal buffers (not terminals etc)
    buftype = vim.fn.getbufvar(buf, '&buftype') 
    -- also only do it for local files, not scp:// etc
    if buftype == '' and not string.find(file, '^[a-zA-Z]+:') then
        dir = vim.fn.fnamemodify(file, ':h')
        isdir = vim.fn.isdirectory(dir)
        if vim.fn.isdirectory(dir)==0 then
            vim.fn.mkdir(dir, 'p')
        end
    end
end

-- See https://github.com/aitjcize/cppman
function M.CppMan()
    opt.iskeyword:append{':'}
    current_word = vim.fn.expand("<cword>")
    opt.iskeyword:remove{':'}
    cmd('Man ' .. current_word)
end

return M
