local create_augroups = require('cfg.utils').create_augroups
local g = vim.g
local cmd = vim.cmd

M = {}

function M.AsyncRunQuickFixToggle() 
    print("status: " .. g.asyncrun_status)
    if g.asyncrun_status == 'failure' then
        cmd [[call asyncrun#quickfix_toggle(10,1)]]
        os.execute("mpv ~/local/share/sounds/8bit-error.mp3 &> /dev/null")
    else
        cmd [[call asyncrun#quickfix_toggle(10,0)]]
        os.execute("mpv ~/local/share/sounds/correct.mp3 &> /dev/null")
    end
end

vim.api.nvim_create_user_command("Make", "wa | AsyncRun -silent -program=make", { desc = "AsyncRun make" })

create_augroups {
    AsyncStopToggle = {
        { 'User', 'AsyncRunStop', [[:lua require'cfg.plugins.async'.AsyncRunQuickFixToggle()]]}
    }
}

g.asyncrun_open = 0
g.asyncrun_bell = 1
g.asyncrun_trim = 1

return M
