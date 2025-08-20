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

function M.find_root()
    local path = vim.fn.getcwd()
    local root_markers = { '.git', '.tasks', 'compile_commands.json', 'requirements.txt', 'setup.py' }

    while true do
        for _, marker in ipairs(root_markers) do
            local marker_path = path .. '/' .. marker
            if vim.fn.isdirectory(marker_path) == 1 or vim.fn.filereadable(marker_path) == 1 then
                return path
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

function M.cd_root()
    local root = M.find_root()
    vim.cmd('cd ' .. root)
    print("Changed dir to root: " .. root)
end


-- Open init.lua and change working directory to its location
function M.editrc()
    local init_lua_path = vim.fn.stdpath('config') .. '/init.lua'

    -- Check if init.lua exists
    if vim.fn.filereadable(init_lua_path) == 1 then
        vim.cmd('silent! edit ' .. init_lua_path) -- Open init.lua
        local init_lua_dir = vim.fn.fnamemodify(init_lua_path, ':h')
        vim.cmd('cd ' .. init_lua_dir)            -- Change working directory to init.lua's location
    else
        print('init.lua not found.')
    end
end

function M.LlamaRun(prompt_tag, opts)
    if opts.replace then
        vim.cmd('normal! vipd')
        vim.cmd('Gen ' .. prompt_tag)
    elseif opts.yank then
        vim.cmd('normal! vipy')
        vim.cmd('Gen ' .. prompt_tag)
    elseif opts.visual then
        local prompts = require("gen.prompts")
        require('gen').exec(vim.tbl_deep_extend("force", { mode = 'v' }, prompts[prompt_tag]))
    end
end

-- Downloads config files into $CONFIG_DIR/lua/ from the official neovim/nvim-lspconfig repo
function M.FetchLspConfigs(lsp_names)
    local config_dir = vim.fn.stdpath("config") .. "/lsp"
    if vim.fn.isdirectory(config_dir) == 0 then
        vim.fn.mkdir(config_dir, "p")
    end

    -- for lsp_name in string.gmatch(lsp_names, "%S+") do
    for _,lsp_name in ipairs(lsp_names) do
        local output_file = config_dir .. "/" .. lsp_name .. ".lua"

        if vim.fn.filereadable(output_file) == 0 then
            local url = string.format(
                "https://raw.githubusercontent.com/neovim/nvim-lspconfig/refs/heads/master/lsp/%s.lua",
                lsp_name
            )

            local cmd = { "curl", "-fsSLo", output_file, "--create-dirs", url }
            local result = vim.fn.system(cmd)

            if vim.v.shell_error ~= 0 then
                vim.notify("Download failed for " .. lsp_name .. ": " .. result, vim.log.levels.ERROR)
            else
                vim.notify("Downloaded LSP config for " .. lsp_name .. " → " .. output_file)
            end
        end
    end
end

-- -- Create command :DownloadLspConfig <lsp-name>
-- vim.api.nvim_create_user_command("FetchLspConfigs", function(opts)
--     M.FetchLspConfigs(opts.args)
-- end, { nargs = '+' })

vim.api.nvim_create_user_command("FetchLspConfigs", function(opts)
    -- Split the input string into a table of LSP names
    local lsp_names = {}
    for lsp_name in string.gmatch(opts.args, "%S+") do
        table.insert(lsp_names, lsp_name)
    end
    
    -- Call the function with the table of LSP names
    M.FetchLspConfigs(lsp_names)
end, { nargs = 1 })  -- Allow one argument 

return M
