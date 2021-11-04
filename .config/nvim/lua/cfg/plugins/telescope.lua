local actions = require 'telescope.actions'
local finders = require('telescope.finders')

local map = require('cfg.utils').map

map('n', '<space>o', [[<cmd>lua require'telescope.builtin'.find_files()<cr>]])
map('n', '<space>p', [[<cmd>lua require'telescope.builtin'.git_files()<cr>]])
map('n', '<space>f', [[<cmd>lua require'telescope.builtin'.live_grep()<cr>]])

map('n', '<space>l', [[<cmd>lua require'telescope.builtin'.buffers()<cr>]])
map('n', '<space>h', [[<cmd>lua require'telescope.builtin'.help_tags()<cr>]])
map('n', '<space>e', [[<cmd>lua require'telescope.builtin'.current_buffer_fuzzy_find()<cr>]])
map('n', '<space>m', [[<cmd>lua require'telescope.builtin'.marks()<cr>]])
map('n', '<space>;', [[<cmd>lua require'telescope.builtin'.command_history()<cr>]])
map('n', '<space>/', [[<cmd>lua require'telescope.builtin'.search_history()<cr>]])
map('n', '<space>b', [[<cmd>lua require'telescope.builtin'.builtin()<cr>]])
map('n', '<space>s', [[<cmd>lua require'telescope.builtin'.lsp_workspace_symbols()<cr>]])

local opts = { noremap = true, silent = true }

map('n', 'gr', [[<cmd>lua require'telescope.builtin'.lsp_references()<cr>]], opts)
map('n', '<space>gs', [[<cmd>lua require'telescope.builtin'.git_status()<cr>]], opts)

-- map('n', '<leader>fr', [[<cmd>lua require'telescope.builtin'.oldfiles()<cr>]])
-- map('n', '', [[<cmd>lua require'telescope.builtin'.quickfix()<cr>]])

-- map('n', '<leader>fx', [[<cmd>lua require'telescope.builtin'.git_status()<cr>]])
map('n', '<space>gc', [[<cmd>lua require'telescope.builtin'.git_commits()<cr>]])
map('n', '<space>gi', [[<cmd>lua require'telescope'.extensions.gh.issues()<cr>]])
map('n', '<space>gp', [[<cmd>lua require'telescope'.extensions.gh.pull_request()<cr>]])
map('n', '<space>gg', [[<cmd>lua require'telescope'.extensions.gh.gist()<cr>]])
map('n', '<space>gr', [[<cmd>lua require'telescope'.extensions.gh.run()<cr>]])

require('telescope').setup {
  defaults = {
    prompt_prefix = ' ❯ ',
    selection_caret = '❯ ',
    mappings = {
      i = {
        ['<esc>'] = actions.close,

        ['<C-q>'] = actions.send_to_qflist,

        ['<c-j>'] = actions.move_selection_next,
        ['<c-k>'] = actions.move_selection_previous,

        ['<s-up>'] = actions.cycle_history_prev,
        ['<s-down>'] = actions.cycle_history_next,
      },
    },
  },
  extensions = {
    fzf = {
      fuzzy = true,
      override_generic_sorter = true,
      override_file_sorter = true,
      case_mode = 'smart_case',
    },
    -- fzy_native = {
    --     override_generic_sorter = false,
    --     override_file_sorter = true,
    -- },
  },
  pickers = {
    oldfiles = {
      sort_lastused = true,
      cwd_only = true,
    },
    find_files = {
      hidden = true,
    },
    live_grep = {
      path_display = { 'shorten' },
    },
  },
}

require('telescope').load_extension 'fzf'
-- require('telescope').load_extension('fzy_native')
require('telescope').load_extension('gh')

local M = {}

M.project_files = function()
  local opts = {} -- define here if you want to define something
  local ok = pcall(require'telescope.builtin'.git_files, opts)
  if not ok then require'telescope.builtin'.find_files(opts) end
end

M.git_dirty=function()
require('telescope.builtin').find_files({
    prompt_title = "Git Dirty >",
    finder = finders.new_oneshot_job({'git', 'ls-files', '-m', '-o', '--exclude-standard'}),
})
end

return M
