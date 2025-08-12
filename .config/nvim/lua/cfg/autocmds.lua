local group = vim.api.nvim_create_augroup('Setup', {})

-- -- Highlight text after yanking
-- vim.api.nvim_create_autocmd('TextYankPost', {
--   group = group,
--   callback = function()
--     require('vim.highlight').on_yank { higroup = 'Substitute', timeout = 200 }
--   end,
-- })

-- Hide cursorline in insert mode
vim.api.nvim_create_autocmd({ 'InsertLeave', 'WinEnter' }, { command = 'set cursorline', group = group })
vim.api.nvim_create_autocmd({ 'InsertEnter', 'WinLeave' }, { command = 'set nocursorline', group = group })

-- -- Automatically close Vim if the quickfix window is the only one open
-- vim.api.nvim_create_autocmd('WinEnter', {
--   group = group,
--   callback = function()
--     if vim.fn.winnr '$' == 1 and vim.fn.win_gettype() == 'quickfix' then
--       vim.cmd.q()
--     end
--   end,
-- })

-- Automatically update changed file in Vim
-- Triger `autoread` when files changes on disk
-- https://unix.stackexchange.com/questions/149209/refresh-changed-content-of-file-opened-in-vim/383044#383044
-- https://vi.stackexchange.com/questions/13692/prevent-focusgained-autocmd-running-in-command-line-editing-mode
vim.api.nvim_create_autocmd({ 'FocusGained', 'BufEnter', 'CursorHold', 'CursorHoldI' }, {
  group = group,
  command = [[silent! if mode() != 'c' && !bufexists("[Command Line]") | checktime | endif]],
})

-- Notification after file change
-- https://vi.stackexchange.com/questions/13091/autocmd-event-for-autoread
vim.api.nvim_create_autocmd('FileChangedShellPost', {
  group = group,
  command = [[echohl WarningMsg | echo "File changed on disk. Buffer reloaded." | echohl None]],
})

vim.api.nvim_create_autocmd(
    'FileType', {
        group = group,
        pattern = "yaml",
        command = [[ setlocal ts=2 sts=2 sw=2 expandtab indentkeys-=0# indentkeys-=<:> ]],
    }
)

-- vim.api.nvim_create_autocmd(
--     'FileType', {
--         group = group,
--         pattern = "pandoc",
--         command = [[ setlocal commentstring=%%\ %s ]],
--     }
-- )

-- Automatically create parent directories before writing a file
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function()
    local dir = vim.fn.expand('<afile>:p:h')
    if vim.fn.isdirectory(dir) == 0 then
      vim.fn.mkdir(dir, 'p')
    end
  end,
})
