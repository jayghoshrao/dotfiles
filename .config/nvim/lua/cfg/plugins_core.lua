return {


    'tpope/vim-surround',
    'tpope/vim-unimpaired',
    'tpope/vim-repeat',
    'tpope/vim-obsession',
    'tpope/vim-fugitive',
    'lambdalisue/suda.vim',
    'tommcdo/vim-lion',

    -- Vim object extensions
    -- 1. Indent object
    'michaeljsmith/vim-indent-object',
    --  2. [n]ext, [,], and user dI' to delete inner without space
    'wellle/targets.vim',
    -- use 'vim-scripts/argtextobj.vim'

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

    -- NOTE: install and initialize before nvim-lspconfig
    {
        'williamboman/mason.nvim',
        -- 'williamboman/mason-lspconfig.nvim',
        -- "jayp0521/mason-nvim-dap.nvim",
        config = function()
            require 'cfg.plugins.mason'
        end,
    },

    {
        'neovim/nvim-lspconfig', -- Built-in LSP configurations
        config = function()
            require 'cfg.plugins.lsp'
            require 'cfg.plugins.lsp.cc_ls'
            require 'cfg.plugins.lsp.docker_ls'
            require 'cfg.plugins.lsp.fortls'
            require 'cfg.plugins.lsp.rust_analyzer'
            require 'cfg.plugins.lsp.json_ls'
            -- require 'cfg.plugins.lsp.sumneko_lua'
            require 'cfg.plugins.lsp.rnix'
            require 'cfg.plugins.lsp.pyright'
            -- require 'cfg.plugins.lsp.pylsp'
            -- require 'cfg.plugins.lsp.ruff_lsp'
            require 'cfg.plugins.lsp.texlab'
            require 'cfg.plugins.lsp.yaml_ls'
        end,
        dependencies = {
            -- {
            --     'jose-elias-alvarez/null-ls.nvim',
            --     config = function()
            --         require 'cfg.plugins.lsp.null_ls'
            --     end,
            -- },
            {
                'onsails/lspkind-nvim'
            }
        },
    },

    {
        'nvim-treesitter/nvim-treesitter',
        -- build = ':TSUpdate',
        config = function()
            require 'cfg.plugins.treesitter'
        end,
        dependencies = {
            -- 'nvim-treesitter/playground',
            {
              'numToStr/Comment.nvim',
              dependencies = {
                    -- Dynamically set commentstring based on cursor location in file
                    'JoosepAlviste/nvim-ts-context-commentstring',
                },
              config = function()
                require('Comment').setup({
                  pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
                })
              end,
            },
        },
    },

    {
        'mfussenegger/nvim-dap',
        config = function()
            require'cfg.plugins.dap'
        end,
        -- lunajson for a custom launch function. See dap.lua
        -- rocks = 'lunajson'
    },

    {
        'theHamsta/nvim-dap-virtual-text',
        config = function()
            require("nvim-dap-virtual-text").setup({
                enabled = true,                     -- enable this plugin (the default)
                enabled_commands = true,            -- create commands DapVirtualTextEnable, DapVirtualTextDisable, DapVirtualTextToggle, (DapVirtualTextForceRefresh for refreshing when debug adapter did not notify its termination)
                highlight_changed_variables = true, -- highlight changed values with NvimDapVirtualTextChanged, else always NvimDapVirtualText
                highlight_new_as_changed = false,   -- highlight new variables in the same way as changed variables (if highlight_changed_variables)
                show_stop_reason = true,            -- show stop reason when stopped for exceptions
                commented = false,                  -- prefix virtual text with comment string
                -- experimental features:
                virt_text_pos = 'eol',              -- position of virtual text, see `:h nvim_buf_set_extmark()`
                all_frames = false,                 -- show virtual text for all stack frames not only current. Only works for debugpy on my machine.
                virt_lines = false,                 -- show virtual lines instead of virtual text (will flicker!)
                virt_text_win_col = nil             -- position the virtual text at a fixed window column (starting from the first text column) ,
            })
        end
    },

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
            -- 'petertriho/cmp-git',
            {
                'L3MON4D3/LuaSnip',
                config = function()
                    require 'cfg.plugins.luasnip'
                end,
                dependencies = 'https://github.com/rafamadriz/friendly-snippets'
            }
        },
    },

    {
        'nvim-telescope/telescope.nvim',
        config = function()
            require 'cfg.plugins.telescope'
        end,
        dependencies = {
            'nvim-lua/plenary.nvim', -- Useful Lua utilities
            'nvim-lua/popup.nvim',
            'nvim-telescope/telescope-github.nvim',
            -- FZY sorter for Telescope
            -- 'nvim-telescope/telescope-fzy-native.nvim'
            -- TODO: FZF sorter for Telescope
            -- { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' },
            {
                'nvim-telescope/telescope-fzf-native.nvim', 
                build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build' 
            }
        },
    },

    {
        'lewis6991/gitsigns.nvim', -- Git status signs in the gutter
        config = function()
            require 'cfg.plugins.gitsigns'
        end,
    },

    {
        'mcchrish/nnn.vim',
        config = function()
            require'cfg.plugins.nnn'
        end
    },

    {
        'lukas-reineke/indent-blankline.nvim',
        config = function()
            require("indent_blankline").setup {
                show_end_of_line = true,
                space_char_blankline = " ",
                use_treesitter = false, -- testing
                char_list = {"▏"}
            }
        end
    },

    {
        'windwp/nvim-autopairs',
        config = function()
            require 'cfg.plugins.autopairs'
        end,
    },

    {
        'nvim-lualine/lualine.nvim',
        dependencies = {'kyazdani42/nvim-web-devicons', opt = true},
        config = function()
            require 'cfg.plugins.lualine'
        end
    },

    {
        'andersevenrud/nordic.nvim',
        config = function()
            -- The table used in this example contains the default settings.
            -- Modify or remove these to your liking:
            require('nordic').colorscheme({
                -- Underline style used for spelling
                -- Options: 'none', 'underline', 'undercurl'
                underline_option = 'undercurl',
                -- Italics for certain keywords such as constructors,
                -- functions,
                -- labels and namespaces
                italic = true,
                -- Italic styled comments
                italic_comments = true,
                -- Minimal mode: different choice of colors for Tabs and
                -- StatusLine
                minimal_mode = false
            })

            -- require('cfg.utils').create_augroups {
            --   nord = {
            --         { 'User', 'PlugLoaded', [[++nested colorscheme nordic]] },
            --     }
            -- }
        end
    },

    { 'jayghoshter/tasktags.vim', ft={'markdown', 'pandoc', 'vimwiki'}},

    {
        'skywind3000/asynctasks.vim',
        dependencies = {
            {
                'skywind3000/asyncrun.vim',
                config = function()
                    require 'cfg.plugins.async'
                end
            }
        },
    },

    {
        'GustavoKatel/telescope-asynctasks.nvim',
        config = function()
            local map = require('cfg.utils').map
            map('n', '<leader>tt', [[<cmd>lua require('telescope').extensions.asynctasks.all()<cr>]])
        end
    },


    {
        'derekwyatt/vim-fswitch',
        config = function() 
            require('cfg.utils').map('n', 'gh', ':FSHere<cr>')
        end
    },

    {
        'kdheepak/lazygit.nvim',
        config = function()
            local map = require('cfg.utils').map
            map('n', '<leader>gg', [[<cmd>LazyGit<cr>]])
        end
    },

    {
        "folke/which-key.nvim",
        config = function()
            require("which-key").setup()
        end
    },

    {
        "akinsho/toggleterm.nvim", version = '*', 
        config = function()
            require("toggleterm").setup({
                open_mapping=[[<C-q>]],
                direction = 'float',
            })
        end
    },

    {
        'ThePrimeagen/harpoon',
        config = function()
            require'cfg.plugins.harpoon'
        end
    },

    {
        "folke/zen-mode.nvim",
        config = function()
            require 'cfg.plugins.zen-mode'
        end
    },

    {
        "folke/twilight.nvim",
        config = function()
            require("twilight").setup {}
        end
    },


    --" Plug 'https://github.com/mfussenegger/nvim-dap'
    {
        'szw/vim-maximizer',
        config = function()
            local map = require 'cfg.utils'.map
            map('n', '<space>m', '<cmd>MaximizerToggle<cr>')
        end
    }

}
