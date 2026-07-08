-- Standalone incremental selection for nvim-treesitter's `main` branch, which
-- dropped the old `incremental_selection` module. Replicates:
--   init_selection      -> select the node under the cursor
--   node_incremental    -> grow to the parent node
--   node_decremental    -> shrink to the previous selection
--   scope_incremental   -> grow to the enclosing local scope (locals.scm)
-- Keymaps are wired buffer-locally from the FileType autocmd in treesitter.lua.

local M = {}

M.selections = {}  -- bufnr -> stack of TSNode (top = current selection)

local ESC = vim.api.nvim_replace_termcodes('<Esc>', true, false, true)

local function ranges_equal(a, b)
    local a1, a2, a3, a4 = a:range()
    local b1, b2, b3, b4 = b:range()
    return a1 == b1 and a2 == b2 and a3 == b3 and a4 == b4
end

-- does `outer` fully contain `inner`'s range?
local function contains(outer, inner)
    local osr, osc, oer, oec = outer:range()
    local isr, isc, ier, iec = inner:range()
    local start_ok = osr < isr or (osr == isr and osc <= isc)
    local end_ok   = oer > ier or (oer == ier and oec >= iec)
    return start_ok and end_ok
end

-- treesitter range (0-indexed, end-exclusive) -> vim range (1-indexed, inclusive)
local function to_vim_range(buf, srow, scol, erow, ecol)
    srow, scol, erow = srow + 1, scol + 1, erow + 1
    if ecol == 0 then
        erow = erow - 1
        local line = vim.api.nvim_buf_get_lines(buf, erow - 1, erow, false)[1] or ''
        ecol = math.max(#line, 1)
    end
    return srow, scol, erow, ecol
end

local function select_node(buf, node)
    if vim.fn.mode():find('[vV\22]') then
        vim.cmd('normal! ' .. ESC)
    end
    local sr, sc, er, ec = to_vim_range(buf, node:range())
    vim.fn.setpos('.', { buf, sr, sc, 0 })
    vim.cmd('normal! v')
    vim.fn.setpos('.', { buf, er, ec, 0 })
end

function M.init_selection()
    local buf = vim.api.nvim_get_current_buf()
    local node = vim.treesitter.get_node()
    if not node then return end
    M.selections[buf] = { node }
    select_node(buf, node)
end

function M.node_incremental()
    local buf = vim.api.nvim_get_current_buf()
    local stack = M.selections[buf]
    if not stack or #stack == 0 then return M.init_selection() end
    local cur = stack[#stack]
    local parent = cur:parent()
    while parent and ranges_equal(parent, cur) do
        parent = parent:parent()
    end
    if parent then
        stack[#stack + 1] = parent
        select_node(buf, parent)
    else
        select_node(buf, cur)
    end
end

function M.node_decremental()
    local buf = vim.api.nvim_get_current_buf()
    local stack = M.selections[buf]
    if not stack or #stack == 0 then return end
    if #stack > 1 then stack[#stack] = nil end
    select_node(buf, stack[#stack])
end

function M.scope_incremental()
    local buf = vim.api.nvim_get_current_buf()
    local stack = M.selections[buf]
    if not stack or #stack == 0 then return M.init_selection() end
    local cur = stack[#stack]

    local ok, parser = pcall(vim.treesitter.get_parser, buf)
    if not ok or not parser then return M.node_incremental() end
    local query = vim.treesitter.query.get(parser:lang(), 'locals')
    if not query then return M.node_incremental() end

    local root = parser:parse()[1]:root()
    local best  -- smallest scope that strictly contains the current selection
    for id, node in query:iter_captures(root, buf, 0, -1) do
        local name = query.captures[id]
        if (name == 'local.scope' or name == 'scope')
            and contains(node, cur) and not ranges_equal(node, cur)
            and (not best or contains(best, node)) then
            best = node
        end
    end

    if best then
        stack[#stack + 1] = best
        select_node(buf, best)
    else
        M.node_incremental()
    end
end

-- Set the buffer-local keymaps (matches the old master-branch defaults).
function M.attach(buf)
    local opts = { buffer = buf, silent = true }
    vim.keymap.set('n', 'gnn', M.init_selection,
        vim.tbl_extend('force', opts, { desc = 'TS init selection' }))
    vim.keymap.set('x', 'grn', M.node_incremental,
        vim.tbl_extend('force', opts, { desc = 'TS grow node' }))
    vim.keymap.set('x', 'grc', M.scope_incremental,
        vim.tbl_extend('force', opts, { desc = 'TS grow scope' }))
    vim.keymap.set('x', 'grm', M.node_decremental,
        vim.tbl_extend('force', opts, { desc = 'TS shrink node' }))
end

return M
