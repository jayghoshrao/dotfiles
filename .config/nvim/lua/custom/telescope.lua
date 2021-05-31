-- Fallback to find_files if not in git dir
local M = {}

M.project_files = function()
  local opts = {} -- define here if you want to define something
  local ok = pcall(require'telescope.builtin'.git_files, opts)
  if not ok then require'telescope.builtin'.find_files(opts) end
end

local finders = require('telescope.finders')
M.git_dirty=function()
require('telescope.builtin').find_files({
    prompt_title = "Git Dirty >",
    finder = finders.new_oneshot_job({'git', 'ls-files', '-m', '-o', '--exclude-standard'}),
})
end

-- local previewers = require('telescope.previewers')
-- local pickers = require('telescope.pickers')
-- local sorters = require('telescope.sorters')

-- pickers.new {
-- results_title = 'Resources',
-- -- Run an external command and show the results in the finder window
-- sorter = sorters.get_fuzzy_file(),
-- previewer = previewers.new_termopen_previewer {
--  -- Execute another command using the highlighted entry
--  get_command = function(entry)
--    return {'terraform', 'state', 'list', entry.value}
--  end
-- },
-- }:find()

return M
