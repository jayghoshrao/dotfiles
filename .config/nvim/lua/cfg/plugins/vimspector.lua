local map = require('cfg.utils').map
local silent = { silent = true }


map('n', '<space>dd', '<cmd>call vimspector#Launch()<cr>')
map('n', '<space>de', '<cmd>call vimspector#Reset()<cr>')
map('n', '<space>dc', '<cmd>call vimspector#Continue()<cr>')

-- debug navigation
map('n', '<space>dl', '<plug>VimspectorStepInto', {noremap = false})
map('n', '<space>dj', '<plug>VimspectorStepOver', {noremap = false})
map('n', '<space>dk', '<plug>VimspectorStepOut', {noremap = false})
map('n', '<space>dr', '<plug>VimspectorRestart', {noremap = false})

-- debug [h]ere
map('n', '<space>dh', '<plug>VimspectorRunToCursor', {noremap = false})

-- debug breakpoints
map('n', '<space>db', '<plug>VimspectorToggleBreakpoint', {noremap = false})
map('n', '<space>dB', '<cmd>call vimspector#ClearBreakpoints()<cr>')
map('n', '<space>dcb', '<plug>VimspectorToggleConditionalBreakpoint', {noremap = false})

map('n', '<space>di', '<plug>VimspectorBalloonEval', {noremap = false})

-- debug navigation SHORT
map('n', '<space>j', '<plug>VimspectorStepOver', {noremap = false})
map('n', '<space>k', '<plug>VimspectorStepOut', {noremap = false})
map('n', '<space>l', '<plug>VimspectorStepInto', {noremap = false})
map('n', '<space>r', '<plug>VimspectorRestart', {noremap = false})
map('n', '<space>c', '<cmd>call vimspector#Continue()<cr>')

map('n', '<space>da', [[<cmd>lua require('cfg.plugins.vimspector').AddToWatch()<cr>]])

M={}

function M.AddToWatch()
    vim.cmd [[
        let word = expand("<cexpr>")
        call vimspector#AddWatch(word) ]]
end

return M
