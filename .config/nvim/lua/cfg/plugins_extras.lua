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

    {
        "folke/sidekick.nvim",
        opts = {
            -- add any options here
            -- cli = {
            --     mux = {
            --         backend = "zellij",
            --         enabled = true,
            --     },
            -- },
            cli = {
                win = {
                    keys = {
                        prompt        = { "<c-s-p>", "prompt"    , mode = "t" , desc = "insert prompt or context" },
                    }
                }
            }
        },
        keys = {
            {
                "<Tab>",
                function()
                    -- if there is a next edit, jump to it, otherwise apply it if any
                    if not require("sidekick").nes_jump_or_apply() then
                        return "<Tab>" -- fallback to normal tab
                    end
                end,
                expr = true,
                desc = "Goto/Apply Next Edit Suggestion",
            },
            {
                "<c-.>",
                function() require("sidekick.cli").toggle() end,
                desc = "Sidekick Toggle",
                mode = { "n", "t", "i", "x" },
            },
            {
                ";;",
                function() require("sidekick.cli").toggle() end,
                desc = "Sidekick Toggle CLI",
                mode = { "n", "t" },
            },
            {
                ";as",
                function() require("sidekick.cli").select() end,
                -- Or to select only installed tools:
                -- require("sidekick.cli").select({ filter = { installed = true } })
                desc = "Select CLI",
            },
            {
                ";ad",
                function() require("sidekick.cli").close() end,
                desc = "Detach a CLI Session",
            },
            {
                ";at",
                function() require("sidekick.cli").send({ msg = "{this}" }) end,
                mode = { "x", "n" },
                desc = "Send This",
            },
            {
                ";af",
                function() require("sidekick.cli").send({ msg = "{file}" }) end,
                desc = "Send File",
            },
            {
                ";av",
                function() require("sidekick.cli").send({ msg = "{selection}" }) end,
                mode = { "x" },
                desc = "Send Visual Selection",
            },
            {
                ";ap",
                function() require("sidekick.cli").prompt() end,
                mode = { "n", "x" },
                desc = "Sidekick Select Prompt",
            },
            -- -- Example of a keybinding to open Claude directly
            -- {
            --     "<leader>ac",
            --     function() require("sidekick.cli").toggle({ name = "claude", focus = true }) end,
            --     desc = "Sidekick Toggle Claude",
            -- },
        },
    }

}

