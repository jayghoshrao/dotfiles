local map = require('cfg.utils').map

return {

    -- 'tpope/vim-unimpaired',
    -- 'tpope/vim-obsession',

    -- Terminal -------------------------------------------------------------------- 

    {
        "akinsho/toggleterm.nvim", version = '*', 
        config = function()
            require("toggleterm").setup({
                open_mapping=[[<C-q>]],
                direction = 'float',
            })
        end
    },

    -- Navigation ------------------------------------------------------------------

    { 'alexghergh/nvim-tmux-navigation', config = function()
        require('nvim-tmux-navigation').setup {
            disable_when_zoomed = true, -- defaults to false
            keybindings = {
                left = "<C-h>",
                down = "<C-j>",
                up = "<C-k>",
                right = "<C-l>",
                last_active = "<C-\\>",
                -- next = "<C-Space>",
            }
        }
    end
    },



    -- Git -------------------------------------------------------------------------

    'tpope/vim-fugitive',
    {
        'kdheepak/lazygit.nvim',
        config = function()
            map('n', '<leader>gg', [[<cmd>LazyGit<cr>]])
        end
    },
    {
        'lewis6991/gitsigns.nvim', -- Git status signs in the gutter
        config = function()
            require 'cfg.plugins.gitsigns'
        end,
    },


    -- Text layout and alignment --------------------------------------------------- 

    'michaeljsmith/vim-indent-object',
    'wellle/targets.vim', --  [n]ext, [,], and user dI' to delete inner without space
    'tpope/vim-surround',
    'tpope/vim-repeat',
    'tommcdo/vim-lion',
    { 'lukas-reineke/indent-blankline.nvim', main = "ibl", opts = {} },
    {
        'Wansmer/treesj',
        dependencies = { 'nvim-treesitter/nvim-treesitter' },
        config = function()
            local treesj = require('treesj')
            treesj.setup({ use_default_keymaps = false })
            map('n', '<space>l', treesj.toggle)
        end
    },
    {
        'windwp/nvim-autopairs',
        config = function()
            require 'cfg.plugins.autopairs'
        end,
    },


    -- Mason, LSP, DAP ------------------------------------------------------------- 

    -- NOTE: install and initialize before nvim-lspconfig
    { 'williamboman/mason.nvim', opts = {} },

    { 'williamboman/mason-lspconfig.nvim', opts={
        ensure_installed = require('cfg.lsp').ensure_installed,
    }},

    { "jay-babu/mason-nvim-dap.nvim", opts = {}},

    'neovim/nvim-lspconfig', -- Built-in LSP configurations
    'onsails/lspkind-nvim',
    { 'ray-x/lsp_signature.nvim', config = true },


    {
        'mfussenegger/nvim-dap',
        config = function()
            require'cfg.plugins.dap'
        end,
        -- lunajson for a custom launch function. See dap.lua
        -- rocks = 'lunajson'
    },

    {
        'mfussenegger/nvim-dap-python',
        ft = "python",
        dependencies = {
            "mfussenegger/nvim-dap",
        },
        enabled = function()
            local ok, registry = pcall(require, "mason-registry")
            return ok and registry.is_installed("debugpy")
        end,
        opts = {}
    },

    { 'theHamsta/nvim-dap-virtual-text', opts = {}},

    {
        "rcarriga/nvim-dap-ui",
        dependencies = {
            "mfussenegger/nvim-dap",
            "nvim-neotest/nvim-nio"
        },
        config = function()
            local dap = require("dap")
            local dapui = require("dapui")
            dapui.setup()
            map('n', '<space>dd', ':lua require"dapui".toggle()<CR>')

            dap.listeners.after.event_initialized["dapui_config"] = function()
                dapui.open()
            end
            dap.listeners.before.event_terminated["dapui_config"] = function()
                dapui.close()
            end
            dap.listeners.before.event_exited["dapui_config"] = function()
                dapui.close()
            end
        end
    },

    -- Treesitter ------------------------------------------------------------------ 
    {
        'nvim-treesitter/nvim-treesitter',
        -- build = ':TSUpdate',
        enabled = function()
            return vim.fn.executable('gcc')==1 or vim.fn.executable('clang')==1
        end,
        config = function()
            require 'cfg.plugins.treesitter'
        end,
        dependencies = {
            -- 'nvim-treesitter/playground',
            'nvim-treesitter/nvim-treesitter-textobjects',
            'RRethy/nvim-treesitter-textsubjects',
            {
              'numToStr/Comment.nvim',
                opts = {

                },
              dependencies = {
                    -- Dynamically set commentstring based on cursor location in file
                    { 
                        'JoosepAlviste/nvim-ts-context-commentstring',
                        config = function()
                            require('ts_context_commentstring').setup({})
                            vim.g.skip_ts_context_commentstring_module = true
                        end
                    },
                },

              config = function()
                require('Comment').setup({
                  pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
                })
              end,
            },
        },
    },

    -- Completion ------------------------------------------------------------------ 

    {
        'hrsh7th/nvim-cmp',
        config = function()
            require 'cfg.plugins.cmp'
        end,
        dependencies = {
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-path',
            -- 'saadparwaiz1/cmp_luasnip',
            {
                'L3MON4D3/LuaSnip',
                config = function()
                    require 'cfg.plugins.luasnip'
                end,
                version = "v2.*",
                build = "make install_jsregexp",
                dependencies = 'https://github.com/rafamadriz/friendly-snippets',
            },
            {
                "lukas-reineke/cmp-under-comparator" -- improved sorting in cmp for methods starting with '_'
            }
        },
    },

    -- Picker ---------------------------------------------------------------------- 

    -- { 
    --     'https://github.com/echasnovski/mini.pick',
    --     config = function()
    --         map('n', '<space>o', ':Pick files<CR>')
    --         map('n', '<space>p', ':Pick git_files<CR>')
    --         map('n', '<space>f', ':Pick live_grep<CR>')
    --     end
    -- },

    {
        'nvim-telescope/telescope.nvim',
        config = function()
            require 'cfg.plugins.telescope'
        end,
        dependencies = {
            'nvim-lua/plenary.nvim', -- Useful Lua utilities
            'nvim-lua/popup.nvim',
            'nvim-telescope/telescope-github.nvim',
        },
    },

    {
        'nvim-telescope/telescope-fzf-native.nvim', 
        enabled = function()
            return vim.fn.executable('make') == 1
        end,
        build = 'make',
        -- build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build',
        config = function()
            require('telescope').setup {
                extensions = {
                    fzf = {
                        fuzzy = true,                    -- false will only do exact matching
                        override_generic_sorter = true,  -- override the generic sorter
                        override_file_sorter = true,     -- override the file sorter
                        case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
                        -- the default case_mode is "smart_case"
                    }
                }
            }
            require('telescope').load_extension('fzf')
        end
    },

    -- File browsing and navigation ------------------------------------------------

    {
        'mcchrish/nnn.vim',
        config = function()
            require'cfg.plugins.nnn'
        end
    },

    { 'stevearc/oil.nvim', opts={
        default_file_explorer = false
    }},

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
    },

    -- { 'jayghoshter/tasktags.vim', ft={'markdown', 'pandoc', 'vimwiki', 'tex'}},


    -- Task execution -------------------------------------------------------------- 

    {
        'skywind3000/asynctasks.vim',
        dependencies = {
            {
                'skywind3000/asyncrun.vim',
                config = function()
                    require 'cfg.plugins.async'
                end
            },
            {
                'GustavoKatel/telescope-asynctasks.nvim',
                config = function()
                    map('n', '<leader>tt', [[<cmd>lua require('telescope').extensions.asynctasks.all()<cr>]])
                end
            },
        },
    },


    {
        "catppuccin/nvim", name = "catppuccin", priority = 1000,
        config = function()
            vim.cmd.colorscheme 'catppuccin-mocha'
        end
    },

    {
        'nvim-lualine/lualine.nvim',
        dependencies = {'nvim-tree/nvim-web-devicons', opt = true},
        config = function()
            require 'cfg.plugins.lualine'
        end
    },

    { "folke/zen-mode.nvim", config = function() require 'cfg.plugins.zen-mode' end },
    { "folke/twilight.nvim", opts = {} },
    {
        'szw/vim-maximizer',
        config = function()
            map('n', '<space>m', '<cmd>MaximizerToggle<cr>')
        end
    },


    -- Eye candy / utility
    { "j-hui/fidget.nvim", event = "LspAttach", opts = {} },
    { "folke/which-key.nvim", config = true },
    { "m-demare/hlargs.nvim", opts=true },
    { 'lambdalisue/suda.vim' },
    {
        'derekwyatt/vim-fswitch',
        ft = { "c", "cpp", "h", "hpp"},
        config = function()
            map('n', 'gh', ':FSHere<cr>')
        end
    },

}
