local cmd = vim.cmd

cmd [[iab <expr> dtsf strftime("%c")]]
cmd [[iab <expr> dts strftime("%Y-%m-%d %H:%M")]]
-- nnoremap <F5> "=strftime("%Y-%m-%d %H:%M")<CR>
-- inoremap <F5> <C-R>=strftime("%Y-%m-%d %H:%M")<CR>
