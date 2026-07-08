-- nvim-treesitter — MAIN branch API (the ground-up rewrite).
--
-- On `main`, require('nvim-treesitter').setup{} no longer takes highlight /
-- indent / ensure_installed / textobjects / etc. Those modules are gone:
--   * highlighting is started per-buffer with vim.treesitter.start()
--   * parsers are installed with require('nvim-treesitter').install{...}
--   * indent is a plain 'indentexpr' provided by the plugin
--   * textobjects moved to the `main` branch of nvim-treesitter-textobjects
-- See ../plugins_core.lua for the plugin spec (branch = 'main' + textobjects).

-- Parsers to compile (needs the tree-sitter CLI + a C compiler on PATH).
-- No-ops for already-built parsers; safe to run on every startup.
require('nvim-treesitter').install({
    'bash', 'bibtex', 'c', 'cmake', 'comment', 'cpp', 'css', 'dockerfile',
    'fortran', 'html', 'http', 'json', 'json5', 'llvm', 'lua', 'markdown',
    'markdown_inline', 'nix', 'python', 'rust', 'toml', 'vim', 'yaml',
})

-- Filetypes that should get treesitter highlighting + indent. Deliberately
-- EXCLUDES markdown / tex / latex / pandoc / vimwiki (the old config's
-- highlight.disable list) so those keep their regex/plugin highlighting.
local TS_FILETYPES = {
    'bash', 'sh', 'bibtex', 'c', 'cmake', 'cpp', 'css', 'dockerfile',
    'fortran', 'html', 'http', 'json', 'json5', 'lua', 'nix', 'python',
    'rust', 'toml', 'vim', 'yaml',
}

vim.api.nvim_create_autocmd('FileType', {
    pattern = TS_FILETYPES,
    callback = function(ev)
        -- Highlighting. pcall so a missing/uncompiled parser can't error the buffer open.
        pcall(vim.treesitter.start)
        -- Treesitter-based indent (was indent = { enable = true }).
        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        -- Incremental selection: gnn / grn / grc / grm (standalone; see below).
        require('cfg.plugins.ts_incremental').attach(ev.buf)
    end,
})

-- Textobjects (main branch of nvim-treesitter-textobjects). setup() only takes
-- behaviour options now; the keymaps below are the replacement for the old
-- `textobjects = { select/move/swap = { keymaps = {...} } }` block.
local ok_to = pcall(require, 'nvim-treesitter-textobjects')
if ok_to then
    require('nvim-treesitter-textobjects').setup({
        select = { lookahead = true },   -- jump forward to the textobj, like targets.vim
        move   = { set_jumps = true },   -- record moves in the jumplist
    })

    local select = require('nvim-treesitter-textobjects.select').select_textobject
    local move   = require('nvim-treesitter-textobjects.move')
    local swap   = require('nvim-treesitter-textobjects.swap')

    -- select
    local sel = {
        aa = '@parameter.outer', ia = '@parameter.inner',
        af = '@function.outer',  ['if'] = '@function.inner',
        ac = '@class.outer',     ic = '@class.inner',
    }
    for lhs, cap in pairs(sel) do
        vim.keymap.set({ 'x', 'o' }, lhs, function() select(cap, 'textobjects') end,
            { desc = 'TS select ' .. cap })
    end

    -- move
    local mv = {
        { { 'n', 'x', 'o' }, ']m', function() move.goto_next_start('@function.outer', 'textobjects') end },
        { { 'n', 'x', 'o' }, ']]', function() move.goto_next_start('@class.outer', 'textobjects') end },
        { { 'n', 'x', 'o' }, ']M', function() move.goto_next_end('@function.outer', 'textobjects') end },
        { { 'n', 'x', 'o' }, '][', function() move.goto_next_end('@class.outer', 'textobjects') end },
        { { 'n', 'x', 'o' }, '[m', function() move.goto_previous_start('@function.outer', 'textobjects') end },
        { { 'n', 'x', 'o' }, '[[', function() move.goto_previous_start('@class.outer', 'textobjects') end },
        { { 'n', 'x', 'o' }, '[M', function() move.goto_previous_end('@function.outer', 'textobjects') end },
        { { 'n', 'x', 'o' }, '[]', function() move.goto_previous_end('@class.outer', 'textobjects') end },
    }
    for _, m in ipairs(mv) do
        vim.keymap.set(m[1], m[2], m[3], { desc = 'TS move ' .. m[2] })
    end

    -- swap
    vim.keymap.set('n', '<leader>a', function() swap.swap_next('@parameter.inner') end,
        { desc = 'TS swap next param' })
    vim.keymap.set('n', '<leader>A', function() swap.swap_previous('@parameter.inner') end,
        { desc = 'TS swap prev param' })
end

-- NOTE: `incremental_selection` (gnn/grn/grc/grm) is restored via the
-- standalone cfg.plugins.ts_incremental module (attached in the autocmd above),
-- since nvim-treesitter's `main` branch dropped it upstream. `refactor`,
-- `matchup`, and `autotag` from the old config were provided by plugins not
-- installed here, so they are simply gone.
