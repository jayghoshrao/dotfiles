local cmp = require'cmp'
local lspkind = require('lspkind')
local luasnip = require("luasnip")
local sidekick = require("sidekick") 

local has_words_before = function()
  unpack = unpack or table.unpack
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end


cmp.setup {

    -- To invert selection order and box position near bottom of the screen. 
    view = {                                                        
        entries = {name = 'custom', selection_order = 'near_cursor' } 
    },                                                           

    snippet = {
        expand = function(args)
            -- vim.fn['vsnip#anonymous'](args.body)
            require'luasnip'.lsp_expand(args.body)
        end,
    },

    mapping = {

        -- ['<Tab>'] = cmp.mapping(cmp.mapping.select_next_item(), { 'i', 's' }),
        -- ['<S-Tab>'] = cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'}),
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
        ["<Tab>"] = cmp.mapping(function(fallback)
            if not sidekick.nes_jump_or_apply() then
                if luasnip.expand_or_jumpable() then
                    luasnip.expand_or_jump()
                elseif cmp.visible() then
                    cmp.select_next_item()
                elseif has_words_before() then
                    cmp.complete()
                else
                    fallback()
                end
            end
        end, { "i", "s" }),

        ["<S-Tab>"] = cmp.mapping(function(fallback)
            if luasnip.jumpable(-1) then
                luasnip.jump(-1)
            elseif cmp.visible() then
                cmp.select_prev_item()
            else
                fallback()
            end
        end, { "i", "s" }),

        ['<C-p>'] = cmp.mapping.select_prev_item(),
        ['<C-n>'] = cmp.mapping.select_next_item(),
        -- ['<C-Space>'] = cmp.mapping.complete(),
        -- ['<C-e>'] = cmp.mapping.close(),
        -- ['<C-y>'] = cmp.mapping.confirm {
        ['<C-y>'] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Insert,
            select = true,
        },
        ["<C-d>"] = cmp.mapping.scroll_docs(-4),
        ["<C-u>"] = cmp.mapping.scroll_docs(4),
    },

    sources = {
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
        { name = 'path' },
        { name = 'buffer'},
    },

    window = {
        documentation = {
            winhighlight = 'NormalFloat:CmpDocumentation',
        }
    },

    experimental = {
        ghost_text = true,
    },

    formatting = {
        format = lspkind.cmp_format({with_text = false, maxwidth = 50})
    },

    -- formatting = {
    --     fields = { 'kind', 'abbr', 'menu' },
    --     format = function(_, vim_item)
    --         local kind = string.format('%s %s', icons[vim_item.kind], vim_item.kind)
    --
    --         -- Move the icon to be on the left side
    --         local strings = vim.split(kind, '%s', { trimempty = true })
    --         vim_item.kind = ' ' .. strings[1] .. ' '
    --
    --         if vim_item.menu and #vim_item.menu > 25 then
    --             local first_slash = string.find(vim_item.menu, '/')
    --             local last_slash = string.find(vim_item.menu, '/[^/]*$')
    --
    --             vim_item.menu = string.sub(vim_item.menu, 1, first_slash) .. '…' .. string.sub(vim_item.menu, last_slash)
    --         end
    --
    --         return vim_item
    --     end,
    -- },

    sorting = {
        comparators = {
            cmp.config.compare.offset,
            cmp.config.compare.exact,
            cmp.config.compare.score,
            require "cmp-under-comparator".under,
            cmp.config.compare.kind,
            cmp.config.compare.sort_text,
            cmp.config.compare.length,
            cmp.config.compare.order,
        },
    }

}

-- require('cmp_git').setup()

-- -- For some reason, setting the highlights right away after loading the plugin
-- -- does not work (cmp default highlights are used). A workaround is to load the
-- -- highlights after everything has initialized
-- vim.defer_fn(function()
--     require '.plugins.cmp_highlights'
-- end, 0)

-- -- Set configuration for specific filetype.
-- cmp.setup.filetype('gitcommit', {
--     sources = cmp.config.sources({
--         { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
--     }, {
--         { name = 'buffer' },
--     })
-- })

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
        { name = 'buffer' }
    }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
        { name = 'path' }
    }, {
        { name = 'cmdline' }
    })
})
