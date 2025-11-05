local fn = vim.fn
local opt = vim.opt
local cmd = vim.cmd

vim.api.nvim_create_autocmd({"FileType"}, {
  pattern = "lua",
  callback = function()
    vim.opt_local.foldlevel = 0
    -- vim.opt_local.foldlevelstart = 0
  end,
})

-- Custom foldexpr that folds with both treesitter and {{{ markers
function _G.custom_foldexpr(lnum)
  local line = vim.fn.getline(lnum)
  
  -- Check for marker fold {{{ or }}}
  -- Use the foldmarker option for exact marker strings if you prefer; here hardcoded
  if line:find("{{{") then
    return ">"  -- start fold
  elseif line:find("}}}") then
    return "<"  -- end fold
  end

  -- Fall back to Treesitter folding expression
  local ts_fold = vim.treesitter.foldexpr(lnum)  -- call treesitter foldexpr
  return ts_fold
end


function _G.foldtext()
  local indent_level = fn.indent(vim.v.foldstart)
  local indent = fn['repeat'](' ', indent_level)
  local first = fn.substitute(fn.getline(vim.v.foldstart), '\\v\\s*', '', '')
  local second = fn.substitute(fn.getline(vim.v.foldstart+1), '\\v\\s*', '', '')

  local preview = first
  if first == "{" then
    preview = first .. second
  end

  return indent .. preview .. '...' .. fn.getline(vim.v.foldend):gsub('^%s*', '')
end

opt.foldmethod = 'expr'
-- opt.foldexpr = 'nvim_treesitter#foldexpr()'
opt.foldexpr = 'v:lua.custom_foldexpr(v:lnum)'
opt.foldtext = 'v:lua.foldtext()'
opt.foldlevelstart = 99
-- opt.foldlevelstart = 2


-- Better fold colors
-- autocmd ColorScheme nord highlight Folded ctermbg=0 ctermfg=12 guibg=#3B4252 guifg=#b5b5b5
-- cmd[[highlight Folded ctermbg=0 ctermfg=12 guibg=#3B4252 guifg=#b5b5b5]]
-- cmd[[highlight Conceal guifg=#81A1C1 guibg=#2E3440]]

-- Edit: I've got it. For whatever reason the color settings aren't respected 
-- when using a colorscheme until after "VimEnter". I used an autocommand to 
-- get around this. 
cmd[[au VimEnter * highlight Folded ctermbg=0 ctermfg=12 guibg=#3B4252 guifg=#b5b5b5]]
cmd[[au VimEnter * highlight Conceal guifg=#81A1C1 guibg=#2E3440]]
-- cmd[[au VimEnter * highlight NnnFloatBorder ctermbg=0 ctermfg=12 guibg=#3B4252 guifg=#b5b5b5]]

local M = {}
--------------------------------------------------------------------------------

local function normal(cmdStr) vim.cmd.normal { cmdStr, bang = true } end

-- `h` closes folds when at the beginning of a line.
function M.h()
	local count = vim.v.count1 -- saved as `normal` affects it
	for _ = 1, count, 1 do
		local col = vim.api.nvim_win_get_cursor(0)[2]
		local textBeforeCursor = vim.api.nvim_get_current_line():sub(1, col)
		local onIndentOrFirstNonBlank = textBeforeCursor:match("^%s*$")
		local firstChar = col == 0
		if onIndentOrFirstNonBlank or firstChar then
			local wasFolded = pcall(normal, "zc")
			if not wasFolded then normal("h") end
		else
			normal("h")
		end
	end
end

-- `l` on a folded line opens the fold.
function M.l()
	local count = vim.v.count1 -- saved as `normal` affects it
	for _ = 1, count, 1 do
		local isOnFold = vim.fn.foldclosed(".") > -1
		local action = isOnFold and "zo" or "l"
		pcall(normal, action)
	end
end

-- `$` on a folded line opens the fold recursively.
function M.dollar()
	local isOnFold = vim.fn.foldclosed(".") > -1
	local action = isOnFold and "zO" or "$"
	pcall(normal, action)
end

vim.keymap.set("n", "h", function() M.h() end, { desc = "Origami h" })
vim.keymap.set("n", "l", function() M.l() end, { desc = "Origami l" })
vim.keymap.set("n", "L", function() M.dollar() end, { desc = "Origami $" })

--------------------------------------------------------------------------------
return M
