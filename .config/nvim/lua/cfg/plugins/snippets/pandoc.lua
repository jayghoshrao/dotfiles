
-- Add this to your snippets file or within the 'init.lua' (for Neovim with LuaSnip)

local ls = require("luasnip")
local s = ls.s
local fmt = require('luasnip.extras.fmt').fmt
local i = ls.insert_node
local f = ls.function_node

ls.add_snippets('markdown', {

    s(
        ':::',
        fmt([[
:::: {{.columns}}
::: {{.column width="50%"}}
\begin{{figure}}
\centering
\includegraphics[height=0.8\textheight]{{{}}}
\caption{{{}}}
\end{{figure}}
:::
::: {{.column width="50%"}}
{}
:::
::::

]], {
                ls.insert_node(1), -- First placeholder for column width
                ls.insert_node(2), -- Second placeholder for column width
                ls.insert_node(3), -- Second placeholder for column width
            })
    ),

    s('fig', fmt( [[
\begin{{figure}}
\centering
\includegraphics[{}]{{ {} }}
\caption{{{}}}
\end{{figure}}
]], 
        {i(1), i(2), i(3)}
    )),


})


