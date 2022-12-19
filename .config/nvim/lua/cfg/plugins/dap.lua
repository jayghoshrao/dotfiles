local dap = require('dap')
local map = require('cfg.utils').map

-- autocomplete in REPL
require('cfg.utils').create_augroups {
    dap_launch = {
        { 'FileType', 'dap-repl', [[lua require('dap.ext.autocompl').attach()]] },
    }
}

-- UI mods 
dap.defaults.fallback.terminal_win_cmd = '80vsplit new'
vim.fn.sign_define('DapBreakpoint', {text='🟥', texthl='', linehl='', numhl=''})
vim.fn.sign_define('DapBreakpointCondition', {text='🟪', texthl='', linehl='', numhl=''})
vim.fn.sign_define('DapBreakpointRejected', {text='🟦', texthl='', linehl='', numhl=''})
vim.fn.sign_define('DapStopped', {text='⭐️', texthl='', linehl='', numhl=''})

-- keymaps
map('n', '<space>db', ':lua require"dap".toggle_breakpoint()<CR>')
map('n', '<space>dcb', ":lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>")
map('n', '<space>dL', ':lua require"dap".set_breakpoint(nil, nil, vim.fn.input("Log point message: ")<CR>')
map('n', '<space>de', ':lua require"dap".set_exception_breakpoints({"all"})<CR>')

map('n', '<space>k', ':lua require"dap".step_out()<CR>')
map('n', '<space>l', ':lua require"dap".step_into()<CR>')
map('n', '<space>j', ':lua require"dap".step_over()<CR>')
map('n', '<space>c', ':lua require"dap".continue()<CR>')
map('n', '<space>dc', ':lua require"dap".continue()<CR>')

map('n', '<space>dh', ':lua require"dap".run_to_cursor()<CR>')
map('n', '<space>dl', ':lua require"dap".run_last()<CR>')

map('n', '<space>dk', ':lua require"dap".up()<CR>')
map('n', '<space>dj', ':lua require"dap".down()<CR>')

map('n', '<space>dx', ':lua require"dap".terminate()<CR>')
map('n', '<space>d_', ':lua require"dap".clear_breakpoints()<CR>')

map('n', '<space>dr', ':lua require"dap".repl.toggle({}, "split")<CR><C-w>j')

-- map('n', '<space>di', ':lua require"dap.ui.variables".hover()<CR>')
-- map('n', '<space>di', ':lua require"dap.ui.variables".visual_hover()<CR>')
map('n', '<space>di', ':lua require"dap.ui.widgets".hover()<CR>')


map('n', '<space>d?', ':lua require"dap.ui.variables".scopes()<CR>')
map('n', '<space>d?', ':lua local widgets=require"dap.ui.widgets";widgets.centered_float(widgets.scopes)<CR>')

map('n', '<space>da', ':lua require("dap.ext.vscode").load_launchjs()<CR>')
map('n', '<space>dn', ':lua require("cfg.plugins.dap").launch()<CR>')

local mason_dap_bin = vim.fn.stdpath "data" .. "/mason/bin" 

-- DAP: CPP
dap.adapters.cppdbg = {
  type = 'executable',
  -- command = '/home/jayghoshter/DAP/extension/debugAdapters/bin/OpenDebugAD7',
  command = mason_dap_bin .. '/OpenDebugAD7',
}

dap.configurations.cpp = {
  {
    name = "Launch file",
    type = "cppdbg",
    request = "launch",
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    cwd = '${workspaceFolder}',
    stopOnEntry = true,
  },
}

-- If you want to use this for Rust and C, add something like this:

dap.configurations.c = dap.configurations.cpp
dap.configurations.rust = dap.configurations.cpp
dap.configurations.fortran = dap.configurations.cpp

-- Read and launch DAP based on config directly
M = {}
function M.launch()
    local open = io.open
    local file = open(".vscode/launch.json", "r")
    if not file then return nil end
    local jsonString = file:read "*a"
    file:close()
    local cfg = require("lunajson").decode(jsonString)
    dap.run(cfg.configurations[1])
end

return M
