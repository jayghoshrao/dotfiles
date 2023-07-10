-- TODO: Look into lsp-zero. Integrates all LSP config and uses mason

-- -- WORKFLOW:
-- https://github.com/ThePrimeagen/git-worktree.nvim
-- https://github.com/stefandtw/quickfix-reflector.vim
-- https://github.com/chipsenkbeil/distant.nvim -- remote edits
-- https://github.com/ahmedkhalf/project.nvim

-- -- MANUALS:
-- https://github.com/sunaku/vim-dasht
-- https://github.com/rhysd/devdocs.vim

-- -- UTILITY:
-- https://github.com/b3nj5m1n/kommentary
-- https://github.com/gelguy/wilder.nvim -- wildmenu addon. Might not need it with nvim-cmp

-- -- MISC:
-- https://github.com/ibhagwan/fzf-lua -- Telescope alternative
-- https://github.com/d0c-s4vage/lookatme  -- presentation!
-- https://github.com/ngscheurich/iris.nvim -- color helper
-- use 'LnL7/vim-nix' -- probably not required, but potentially useful
-- https://github.com/junegunn/vim-peekaboo -- See register context

return {

    'ggandor/lightspeed.nvim',
    'duane9/nvim-rg',

    {
        'onsails/diaglist.nvim',
        config = function()
            require("diaglist").init({
                debug = false,
                debounce_ms = 150,
            })

            vim.cmd [[ command! DiagBuf lua require('diaglist').open_all_diagnostics() ]]
            vim.cmd [[ command! DiagAll lua require('diaglist').open_buffer_diagnostics() ]]

        end
    },

    {
        'norcalli/nvim-colorizer.lua',
        config = function()
            require'colorizer'.setup()
        end
    },

    -- {
    --   'editorconfig/editorconfig-vim', -- Project-specific settings
    --   config = function()
    --     vim.g.EditorConfig_preserve_formatoptions = 1
    --   end,
    -- }

    -- {
    --     'vim-pandoc/vim-pandoc',
    --     config = function()
    --         require 'cfg.plugins.pandoc'
    --     end,
    --     ft = {
    --         'markdown',
    --         'vimwiki',
    --         'tex'
    --     }
    -- },

    {
        'vimwiki/vimwiki',
        config = function()
            require 'cfg.plugins.vimwiki'
        end,
        ft = {'markdown', 'vimwiki', 'pandoc'}
    },

    -- -- NOTE: doesn't work everywhere since vimwiki
    -- -- is only used for certain filetypes
    -- {
    --     'ElPiloto/telescope-vimwiki.nvim',
    --     config = function()
    --         require('telescope').load_extension('vw')
    --         local map = require('cfg.utils').map
    --         map('n', '<space>n', ':Telescope vw<cr>')
    --     end
    -- },

    {
        'lervag/vimtex',
        ft = {
            'vimwiki',
            'markdown',
            'tex'
        }
    },

    'mboughaba/i3config.vim',

    -- doesn't work on windows?
    'm-pilia/vim-ccls',

    -- -- Unsure if I need this
    -- use {
    --     "cuducos/yaml.nvim",
    --     ft = {"yaml"}, -- optional
    --     dependencies = {
    --         "nvim-treesitter/nvim-treesitter",
    --         "nvim-telescope/telescope.nvim" -- optional
    --     },
    --     -- config = function ()
    --     --     require("yaml_nvim").init()
    --     -- end,
    -- }

    -- -- WARNING: Very slow
    -- { 'ray-x/lsp_signature.nvim', config=function() require'lsp_signature'.setup() end }

    -- Probably never going to use it
    {
        'goerz/jupytext.vim',
        dependencies = {
            'hkupty/iron.nvim',
            'kana/vim-textobj-user',
            'kana/vim-textobj-line',
            'GCBallesteros/vim-textobj-hydrogen',
        },
        config = function()
            -- vim.g.jupytext_filetype_map = {md = 'vimwiki'}
            vim.g.jupytext_fmt = 'py'
            vim.g.jupytext_style = 'hydrogen'
            -- " Send cell to IronRepl and move to next cell.
            -- " Depends on the text object defined in vim-textobj-hydrogen
            -- " You first need to be connected to IronRepl
            -- vim.api.nvim_buf_set_keymap(0, {'n'}, ']x', 'ctrih/^# %%<CR><CR>', {} )
            require 'cfg.plugins.iron'
        end
    },
    -- vim.g.jupytext_filetype_map = {md = 'vimwiki'}

    {'kevinhwang91/nvim-bqf', ft = 'qf'},

    -- optional
    {
        'junegunn/fzf', 
        build = function()
            vim.fn['fzf#install']()
        end
    },

    {
        'Wansmer/treesj',
        dependencies = { 'nvim-treesitter/nvim-treesitter' },
        config = function()
            require('treesj').setup({
                use_default_keymaps = false,
            })
        end,
    },

    {
        "nvim-tree/nvim-tree.lua",
        version = "*",
        lazy = false,
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
        config = function()
            require('cfg.plugins.tree')
        end,
    }

}
