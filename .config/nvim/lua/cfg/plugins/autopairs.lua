local autopairs = require 'nvim-autopairs'

local map = require('cfg.utils').map

function _G.confirm()
  return autopairs.check_break_line_char()
end

autopairs.setup {
  check_ts = true,
  enable_moveright = true,
}

map('i', '<cr>', [[v:lua.confirm()]], { expr = true, noremap = true })
