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
        -- TODO: 'williamboman/mason-lspconfig.nvim',
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
            -- require 'cfg.plugins.lsp.clangd'
            require 'cfg.plugins.lsp.docker_ls'
            require 'cfg.plugins.lsp.fortls'
            require 'cfg.plugins.lsp.rust_analyzer'
            require 'cfg.plugins.lsp.json_ls'
            -- require 'cfg.plugins.lsp.sumneko_lua'
            require 'cfg.plugins.lsp.lua_ls'
            require 'cfg.plugins.lsp.rnix'
            require 'cfg.plugins.lsp.pyright'
            -- require 'cfg.plugins.lsp.pylsp'
            -- require 'cfg.plugins.lsp.ruff_lsp'
            require 'cfg.plugins.lsp.texlab'
            require 'cfg.plugins.lsp.yaml_ls'
        end,
        dependencies = {
            {
                'onsails/lspkind-nvim'
            }
        },
    },

    {
        'jose-elias-alvarez/null-ls.nvim',
        ft = {"python"},
        config = function()
            require 'cfg.plugins.lsp.null_ls'
        end,
        requires = { "nvim-lua/plenary.nvim" },
    },

    -- TODO: 'https://github.com/sustech-data/wildfire.nvim'
    -- https://github.com/echasnovski/mini.nvim

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
            -- TODO: https://github.com/RRethy/nvim-treesitter-textsubjects
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

              -- config = function()
              --   require('Comment').setup({
              --     pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
              --   })
              -- end,
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
        'mfussenegger/nvim-dap-python',
        ft = "python",
        dependencies = {
            "mfussenegger/nvim-dap",
        },
        config = function()
            require('dap-python').setup()
        end
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
        "rcarriga/nvim-dap-ui",
        dependencies = {
            "mfussenegger/nvim-dap",
            "nvim-neotest/nvim-nio"
        },
        config = function()
            local dap = require("dap")
            local dapui = require("dapui")
            dapui.setup()
            local map = require('cfg.utils').map
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
                version = "v2.*",
                build = "make install_jsregexp",
                dependencies = 'https://github.com/rafamadriz/friendly-snippets',
            },
            {
                "lukas-reineke/cmp-under-comparator"
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
        main = "ibl",
        config = function()
            require("ibl").setup() 
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
        dependencies = {'nvim-tree/nvim-web-devicons', opt = true},
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

    { "catppuccin/nvim", name = "catppuccin", priority = 1000 },

    { 'jayghoshter/tasktags.vim', ft={'markdown', 'pandoc', 'vimwiki', 'tex'}},

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
    },

    {
        "j-hui/fidget.nvim",
        tag = "legacy",
        event = "LspAttach",
        opts = {
            -- options
        },
    },

    {
        'jpmcb/nvim-llama',
        config = function()
            require("nvim-llama").setup {
                model = 'llama2',
            }
        end
    },

    {
        "David-Kunz/gen.nvim",
        cmd = { "Gen" },
        config = function()
            local gen = require("gen")
            gen.setup({
                model = "llama3:8b", -- The default model to use.
                host = '0.0.0.0',
                port = 11434,
                display_mode = "float", -- The display mode. Can be "float" or "split".
                show_prompt = false, -- Shows the Prompt submitted to Ollama.
                show_model = true, -- Displays which model you are using at the beginning of your chat session.
                no_auto_close = false, -- Never closes the window automatically.
                -- init = function(options)
                --     pcall(io.popen, "ollama serve > /dev/null 2>&1 &")
                -- end,
                -- Function to initialize Ollama
                command = function(options)
                    return "curl --silent --no-buffer -X POST http://"
                        .. options.host
                        .. ":"
                        .. options.port
                        .. "/api/chat -d $body"
                end,
                -- The command for the Ollama service. You can use placeholders $prompt, $model and $body (shellescaped).
                -- This can also be a lua function returning a command string, with options as the input parameter.
                -- The executed command must return a JSON object with { response, context }
                -- (context property is optional).
                debug = false,
            })
        end,
        dependencies = {
            {
                'dj95/telescope-gen.nvim',
                config=function()
                    require('telescope').load_extension('gen')
                end
            }
        }
    },

}
