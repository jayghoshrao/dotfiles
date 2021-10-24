local fn = vim.fn
local opt = vim.opt
local cmd = vim.cmd

function _G.foldtext()
  local indent_level = fn.indent(vim.v.foldstart)
  local indent = fn['repeat'](' ', indent_level)
  local first = fn.substitute(fn.getline(vim.v.foldstart), '\\v\\s*', '', '')

  return indent .. first .. '...' .. fn.getline(vim.v.foldend):gsub('^%s*', '')
end

opt.foldmethod = 'expr'
opt.foldexpr = 'nvim_treesitter#foldexpr()'
opt.foldtext = 'v:lua.foldtext()'
opt.foldlevelstart = 99

-- Better fold colors
-- autocmd ColorScheme nord highlight Folded ctermbg=0 ctermfg=12 guibg=#3B4252 guifg=#b5b5b5
-- cmd[[highlight Folded ctermbg=0 ctermfg=12 guibg=#3B4252 guifg=#b5b5b5]]
-- cmd[[highlight Conceal guifg=#81A1C1 guibg=#2E3440]]

-- Edit: I've got it. For whatever reason the color settings aren't respected 
-- when using a colorscheme until after "VimEnter". I used an autocommand to 
-- get around this. 
cmd[[au VimEnter * highlight Folded ctermbg=0 ctermfg=12 guibg=#3B4252 guifg=#b5b5b5]]
cmd[[au VimEnter * highlight Conceal guifg=#81A1C1 guibg=#2E3440]]
