-- TODO: Look into lsp-zero. Integrates all LSP config and uses mason

-- -- WORKFLOW:
-- https://github.com/ThePrimeagen/git-worktree.nvim
-- https://github.com/chipsenkbeil/distant.nvim -- remote edits
-- https://github.com/ahmedkhalf/project.nvim

-- -- MANUALS:
-- https://github.com/sunaku/vim-dasht
-- https://github.com/rhysd/devdocs.vim

-- -- MISC:
-- use 'LnL7/vim-nix' -- probably not required, but potentially useful
-- https://github.com/ofirgall/open.nvim

-- C++ dev
-- https://github.com/p00f/clangd_extensions.nvim
-- https://github.com/Civitasv/cmake-tools.nvim

-- Folds
-- https://github.com/chrisgrieser/nvim-origami

local map = require('cfg.utils').map

return {

    { 'LnL7/vim-nix', ft = 'nix' },
    { 'mboughaba/i3config.vim', ft = 'i3config'},
    'ggandor/lightspeed.nvim',
    'duane9/nvim-rg',

    {
        'onsails/diaglist.nvim',
        config = function()
            require("diaglist").init({
                debug = false,
                debounce_ms = 150,
            })

            vim.api.nvim_create_user_command('DiagBuf', function()
                require('diaglist').open_buffer_diagnostics()
            end, {})

            vim.api.nvim_create_user_command('DiagAll', function()
                require('diaglist').open_all_diagnostics()
            end, {})

        end
    },

    { 'norcalli/nvim-colorizer.lua', config = true, cmd={'ColorizerToggle'} },

    -- {
    --   'editorconfig/editorconfig-vim', -- Project-specific settings
    --   config = function()
    --     vim.g.EditorConfig_preserve_formatoptions = 1
    --   end,
    -- }

    -- { 'vim-pandoc/vim-pandoc', ft = { 'markdown', 'tex', 'pandoc' } },
    -- { 'vim-pandoc/vim-pandoc-syntax', ft = {'markdown', 'pandoc'} },

    {
        'lervag/vimtex',
        enabled = vim.g.is_linux,
        ft = { 'markdown', 'tex' },
    },


    {
        "stevearc/aerial.nvim",
        config = function()
            require('aerial').setup({
                -- optionally use on_attach to set keymaps when aerial has attached to a buffer
                on_attach = function(bufnr)
                    -- Jump forwards/backwards with '{' and '}'
                    vim.keymap.set('n', '{', '<cmd>AerialPrev<CR>', {buffer = bufnr})
                    vim.keymap.set('n', '}', '<cmd>AerialNext<CR>', {buffer = bufnr})
                end,
                nav = {
                    keymaps = {
                        ["q"] = "actions.close",
                    }
                }

            })
            -- You probably also want to set a keymap to toggle aerial
            vim.keymap.set('n', '<space>a', '<cmd>AerialNavToggle<CR>')
        end
    },
    -- TODO { 'nvim-focus/focus.nvim', version = false , config=true},

    {
        "nvim-zh/colorful-winsep.nvim",
        enabled = vim.g.is_linux,
        config = true,
        event = { "WinNew" },
    },


    -- {
    --   "klen/nvim-config-local",
    --   config = function()
    --     require('config-local').setup ({
    --       -- Config file patterns to load (lua supported)
    --       config_files = { ".nvim.lua", ".nvimrc", ".exrc" },
    --
    --       -- Where the plugin keeps files data
    --       hashfile = vim.fn.stdpath("data") .. "/config-local",
    --
    --       autocommands_create = true, -- Create autocommands (VimEnter, DirectoryChanged)
    --       commands_create = true,     -- Create commands (ConfigLocalSource, ConfigLocalEdit, ConfigLocalTrust, ConfigLocalIgnore)
    --       silent = false,             -- Disable plugin messages (Config loaded/ignored)
    --       lookup_parents = true,     -- Lookup config files in parent directories
    --     })
    --   end
    -- },

    -- "stefandtw/quickfix-reflector.vim",

    {
        "linux-cultist/venv-selector.nvim",
        dependencies = {
            "neovim/nvim-lspconfig",
            "mfussenegger/nvim-dap", "mfussenegger/nvim-dap-python", --optional
            { "nvim-telescope/telescope.nvim", branch = "0.1.x", dependencies = { "nvim-lua/plenary.nvim" } },
        },
        ft = "python",
        config = true,
        keys = {
            { ",v", "<cmd>VenvSelect<cr>" },
        },
    },

    {
        "zbirenbaum/copilot.lua",
        dependencies = { "copilotlsp-nvim/copilot-lsp" },
        config = true,
        enabled = vim.g.is_win,
    },

    -- {
    --     "yetone/avante.nvim",
    --     enabled = vim.g.is_win,
    --     -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
    --     -- ⚠️ must add this setting! ! !
    --     build = vim.fn.has("win32") ~= 0
    --         and "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false"
    --         or "make",
    --     event = "VeryLazy",
    --     version = false, -- Never set this value to "*"! Never!
    --     ---@module 'avante'
    --     ---@type avante.Config
    --     opts = {
    --         instructions_file = ".github/copilot-instructions.md",
    --         provider = "copilot",
    --     },
    --     windows = {
    --         ask = {
    --             floating = true,
    --         },
    --     },
    --     dependencies = {
    --         "nvim-lua/plenary.nvim",
    --         "MunifTanjim/nui.nvim",
    --         --- The below dependencies are optional,
    --         -- "nvim-mini/mini.pick", -- for file_selector provider mini.pick
    --         "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
    --         "hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
    --         -- "ibhagwan/fzf-lua", -- for file_selector provider fzf
    --         "stevearc/dressing.nvim", -- for input provider dressing
    --         -- "folke/snacks.nvim", -- for input provider snacks
    --         "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
    --         "zbirenbaum/copilot.lua", -- for providers='copilot'
    --         {
    --             -- support for image pasting
    --             "HakonHarnes/img-clip.nvim",
    --             event = "VeryLazy",
    --             opts = {
    --                 -- recommended settings
    --                 default = {
    --                     embed_image_as_base64 = false,
    --                     prompt_for_file_name = false,
    --                     drag_and_drop = {
    --                         insert_mode = true,
    --                     },
    --                     -- required for Windows users
    --                     use_absolute_path = true,
    --                 },
    --             },
    --         },
    --         -- -- Configured elsewhere
    --         -- 'MeanderingProgrammer/render-markdown.nvim',
    --     },
    -- }

    {
        "olimorris/codecompanion.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
        },
        cmd = {
            'CodeCompanion',
            'CodeCompanionCmd',
            'CodeCompanionChat',
            'CodeCompanionActions',
        },
        opts = {
            strategies = {
                chat = { adapter = "copilot"},
                -- inline = {adapter = "copilot"},
                agent = {adapter = "copilot"},
            },
            -- NOTE: The log_level is in `opts.opts`
            opts = {
                log_level = "DEBUG", -- or "TRACE"
            },
        },
    },

}

