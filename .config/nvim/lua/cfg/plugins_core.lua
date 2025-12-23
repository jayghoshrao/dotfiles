local map = require('cfg.utils').map

return {
    -- Terminal --------------------------------------------------------------------

    -- {
    --     "akinsho/toggleterm.nvim", version = '*',
    --     config = function()
    --         require("toggleterm").setup({
    --             open_mapping=[[<C-q>]],
    --             direction = 'float',
    --         })
    --     end
    -- },

    {
        "akinsho/toggleterm.nvim",
        version = "*",
        config = function()
            local toggleterm = require("toggleterm")

            toggleterm.setup({
                direction = "float",
                open_mapping=[[<C-q>]],
            })

            -- Helper function to toggle terminal N
            local Terminal = require("toggleterm.terminal").Terminal
            local terms = {}

            -- Create a terminal and toggle it
            local function toggle_term(n)
                if not terms[n] then
                    terms[n] = Terminal:new({ count = n, direction = "float" })
                end
                terms[n]:toggle()
            end

            -- Map <C-1> ... <C-9> to toggle terminals 1–9
            for i = 1, 9 do
                vim.keymap.set({ "n", "t" }, "<leader>" .. i , function()
                    toggle_term(i)
                end, { noremap = true, silent = true, desc = "ToggleTerm " .. i })
            end
        end,
    },

    -- Navigation ------------------------------------------------------------------

    'tpope/vim-unimpaired', -- mainly for ]f, [f
    {
        'alexghergh/nvim-tmux-navigation',
        config = function()
            require('nvim-tmux-navigation').setup {
                disable_when_zoomed = true,
                keybindings = {
                    left = "<C-h>",
                    down = "<C-j>",
                    up = "<C-k>",
                    right = "<C-l>",
                    last_active = "<C-\\>",
                }
            }
        end
    },

    -- Buffer navigation
    {
        "cbochs/grapple.nvim",
        dependencies = { { "nvim-tree/nvim-web-devicons", lazy = true } },
        opts = {
            scope = "git", -- also try out "git_branch"
        },
        event = { "BufReadPost", "BufNewFile" },
        cmd = "Grapple",
        keys = {
            { ";m", "<cmd>Grapple toggle<cr>", desc = "Grapple toggle tag" },
            -- { ";;", "<cmd>Grapple toggle_tags<cr>", desc = "Grapple open tags window" },
            { ";w", "<cmd>Grapple toggle_tags<cr>", desc = "Grapple open tags window" },

            { ";1", "<cmd>Grapple select index=1<cr>", desc = "Select first tag" },
            { ";2", "<cmd>Grapple select index=2<cr>", desc = "Select second tag" },
            { ";3", "<cmd>Grapple select index=3<cr>", desc = "Select third tag" },
            { ";4", "<cmd>Grapple select index=4<cr>", desc = "Select fourth tag" },

            -- { "<Tab>", "<cmd>Grapple cycle_tags next<cr>", desc = "Go to next tag" },
            -- { "<S-Tab>", "<cmd>Grapple cycle_tags prev<cr>", desc = "Go to previous tag" },

        },
    },

    -- Git -------------------------------------------------------------------------
    'tpope/vim-fugitive',
    {
        "sindrets/diffview.nvim",
        cmd = {"DiffviewMergeBase", "DiffviewLast", "DiffviewOpen", "DiffviewFileHistory" },
        config = function()
            vim.api.nvim_create_user_command("DiffviewMergeBase", function(opts)
                local base_branch = opts.args ~= "" and opts.args or "origin/develop"
                local merge_base = vim.fn.systemlist("git merge-base HEAD " .. base_branch)[1]
                if not merge_base or merge_base == "" then
                    print("Could not determine merge-base with " .. base_branch)
                    return
                end
                vim.cmd("DiffviewOpen " .. merge_base .. "..HEAD")
            end, {
                    nargs = "?",
                    -- complete = function(ArgLead, CmdLine, CursorPos) -- List all local + remote branches for completion
                    --     return branch_completion(ArgLead)
                    -- end,
                })

            vim.api.nvim_create_user_command("DiffviewLast", function(opts)
                local n = opts.args ~= "" and tonumber(opts.args) or 1
                vim.cmd("DiffviewOpen HEAD~" .. n .. "..HEAD")
            end, { nargs = "?" })
        end
    },
    {
        'kdheepak/lazygit.nvim',
        keys = { '<leader>gg' },
        config = function()
            map('n', '<leader>gg', [[<cmd>LazyGit<cr>]])
            vim.g.lazygit_floating_window_scaling_factor = 1.0 -- scaling factor for floating window
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
        keys ={'<space>l'},
        config = function()
            local treesj = require('treesj')
            treesj.setup({ use_default_keymaps = false })
            map('n', '<space>l', treesj.toggle)
        end
    },
    {
        'windwp/nvim-autopairs',
        config = function() require 'cfg.plugins.autopairs' end,
    },

    -- Mason, LSP, DAP -------------------------------------------------------------

    -- NOTE: install and initialize before nvim-lspconfig
    { 'williamboman/mason.nvim', opts = {}, cmd="Mason" },

    { 'williamboman/mason-lspconfig.nvim', opts={
        ensure_installed = require('cfg.lsp').ensure_installed,
        cmd="Mason"
    }},

    { "jay-babu/mason-nvim-dap.nvim", opts = {}, cmd="Mason"},

    'neovim/nvim-lspconfig', -- Built-in LSP configurations
    'onsails/lspkind-nvim',
    -- { 'ray-x/lsp_signature.nvim', config = true },

    -- {
    --     'mfussenegger/nvim-dap',
    --     config = function()
    --         require'cfg.plugins.dap'
    --     end,
    --     -- lunajson for a custom launch function. See dap.lua
    --     -- rocks = 'lunajson'
    -- },

    -- {
    --     'mfussenegger/nvim-dap-python',
    --     ft = "python",
    --     dependencies = {
    --         "mfussenegger/nvim-dap",
    --     },
    --     enabled = function()
    --         local ok, registry = pcall(require, "mason-registry")
    --         return ok and registry.is_installed("debugpy")
    --     end,
    --     opts = {}
    -- },

    -- { 'theHamsta/nvim-dap-virtual-text', opts = {}},

    -- {
    --     "rcarriga/nvim-dap-ui",
    --     dependencies = {
    --         "mfussenegger/nvim-dap",
    --         "nvim-neotest/nvim-nio"
    --     },
    --     config = function()
    --         local dap = require("dap")
    --         local dapui = require("dapui")
    --         dapui.setup()
    --         map('n', '<space>dd', ':lua require"dapui".toggle()<CR>')
    --
    --         dap.listeners.after.event_initialized["dapui_config"] = function()
    --             dapui.open()
    --         end
    --         dap.listeners.before.event_terminated["dapui_config"] = function()
    --             dapui.close()
    --         end
    --         dap.listeners.before.event_exited["dapui_config"] = function()
    --             dapui.close()
    --         end
    --     end
    -- },

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

    'nvim-treesitter/nvim-treesitter-context',
    'nvim-treesitter/nvim-treesitter-refactor',

    -- Completion ------------------------------------------------------------------

    {
        'hrsh7th/nvim-cmp',
        event="VeryLazy",
        config = function()
            require 'cfg.plugins.cmp'
        end,
        dependencies = {
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-path',
            'hrsh7th/cmp-cmdline',
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

    {
        'nvim-mini/mini.pick',
        config = function()
            -- map('n', '<space>o', ':Pick files<CR>')
            -- map('n', '<space>p', ':Pick git_files<CR>')
            require('mini.pick').setup()
            -- map('n', '<space>f', ':Pick live_grep<CR>')
        end
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
            {
                "nvim-telescope/telescope-frecency.nvim",
                -- install the latest stable version
                version = "*",
                config = function()
                    require("telescope").load_extension "frecency"
                end,
            },
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
        "mikavilpas/yazi.nvim",
        version = "*", -- use the latest stable version
        event = "VeryLazy",
        dependencies = {
            { "nvim-lua/plenary.nvim", lazy = true },
        },
        keys = {
            {
                "<leader>f",
                mode = { "n", "v" },
                "<cmd>Yazi<cr>",
                desc = "Open yazi at the current file",
            },
            {
                "<leader>cw",
                "<cmd>Yazi cwd<cr>",
                desc = "Open the file manager in nvim's working directory",
            },
            {
                "<c-up>",
                "<cmd>Yazi toggle<cr>",
                desc = "Resume the last yazi session",
            },
        },
        opts = {
            -- if you want to open yazi instead of netrw, see below for more info
            open_for_directories = false,
            keymaps = {
                show_help = "<f1>",
            },
        },
        -- 👇 if you use `open_for_directories=true`, this is recommended
        init = function()
            -- mark netrw as loaded so it's not loaded at all.
            -- More details: https://github.com/mikavilpas/yazi.nvim/issues/802
            vim.g.loaded_netrwPlugin = 1
        end,
    },

    {
        'stevearc/oil.nvim',
        config = function()
            require'oil'.setup {
                default_file_explorer = false,
                skip_confirm_for_simple_edits = false,
                keymaps = {
                    ['<C-h>'] = false,
                    ['<C-l>'] = false,
                    ['<C-p>'] = false,
                    ['<C-q>'] = 'actions.add_to_qflist',
                },
                win_options = {
                    -- Use the default status column with spacing after the line number
                    statuscolumn = '',
                },
                view_options = {
                    show_hidden = true,
                    is_always_hidden = function(name)
                        return (name == '..')
                    end,
                },
            }

            vim.keymap.set('n', '-', '<cmd>Oil<cr>')
        end
    },


    -- {
    --     "nvim-tree/nvim-tree.lua",
    --     version = "*",
    --     lazy = false,
    --     dependencies = {
    --         "nvim-tree/nvim-web-devicons",
    --     },
    --     config = function()
    --         require('cfg.plugins.tree')
    --     end,
    -- },



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


    -- Eye candy -------------------------------------------------------------------
    {
        "catppuccin/nvim", name = "catppuccin", priority = 1000,
        config = function()
            vim.cmd.colorscheme 'catppuccin-mocha'
        end
    },

    -- Utility ---------------------------------------------------------------------
    {
        'nvim-lualine/lualine.nvim',
        dependencies = {'nvim-tree/nvim-web-devicons', opt = true},
        config = function()
            require 'cfg.plugins.lualine'
        end
    },

    {"folke/zen-mode.nvim", config = function() require 'cfg.plugins.zen-mode' end, cmd = {"ZenMode"}},
    {"folke/twilight.nvim", opts = {}, cmd = {"ZenMode"}},

    {
        'szw/vim-maximizer',
        config = function()
            map('n', '<space>m', '<cmd>MaximizerToggle<cr>')
        end
    },
    { "m-demare/hlargs.nvim", opts=true },


    { "j-hui/fidget.nvim", event = "LspAttach", opts = {} },
    { "folke/which-key.nvim", config = true },
    { 'lambdalisue/suda.vim' },
    {
        'derekwyatt/vim-fswitch',
        ft = { "c", "cpp", "h", "hpp"},
        config = function()
            map('n', 'gh', ':FSHere<cr>')
        end
    },

    {
        'stevearc/quicker.nvim',
        config = function()
            vim.keymap.set("n", "<space>q", function() require("quicker").toggle() end, { desc = "Toggle quickfix" })
            vim.keymap.set("n", "<space>w", function() require("quicker").toggle({ loclist = true }) end, { desc = "Toggle loclist" })
            require("quicker").setup({
                keys = {
                    {
                        ">",
                        function()
                            require("quicker").expand({ before = 2, after = 2, add_to_existing = true })
                        end,
                        desc = "Expand quickfix context",
                    },
                    {
                        "<",
                        function()
                            require("quicker").collapse()
                        end,
                        desc = "Collapse quickfix context",
                    },
                },
            })
        end
    },

    -- Obsidian
    {
        "epwalsh/obsidian.nvim",
        version = "*",  -- recommended, use latest release instead of latest commit
        lazy = true,
        -- ft = "markdown",
        -- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
        event = {
            "BufReadPre " .. vim.fn.expand("$NOTES_DIR") .. "/*.md",
            "BufNewFile " .. vim.fn.expand("$NOTES_DIR") .. "/*.md",
        },
        dependencies = { "nvim-lua/plenary.nvim", },
        opts = {
            workspaces = {
                {
                    name = "Notes",
                    path = "~/Documents/Notes",
                },
            },
            ui = {
                -- use markdown.nvim instead for these
                checkboxes = {},
                bullets = {},
                external_link_icon = {},
            },
        },
    },

    -- Future ----------------------------------------------------------------------
    -- { 'jayghoshter/tasktags.vim', ft={'markdown', 'pandoc', 'vimwiki', 'tex'}},

    {
        'MeanderingProgrammer/render-markdown.nvim',
        ft = {"markdown", "Avante"},
        opts = {
            file_types = { "markdown", "Avante" },
        },
    },

    -- {
    --     "karb94/neoscroll.nvim",
    --     opts = {
    --         duration_multiplier=1,
    --         easing = 'quadratic'
    --     },
    -- }

    {
        "y3owk1n/undo-glow.nvim",
		enabled = vim.g.is_linux,
        event = { "VeryLazy" },
        ---@type UndoGlow.Config
        opts = {
            animation = {
                enabled = true,
                duration = 300,
                animtion_type = "zoom",
                window_scoped = true,
            },
            highlights = {
                undo = {
                    hl_color = { bg = "#693232" }, -- Dark muted red
                },
                redo = {
                    hl_color = { bg = "#2F4640" }, -- Dark muted green
                },
                yank = {
                    hl_color = { bg = "#7A683A" }, -- Dark muted yellow
                },
                paste = {
                    hl_color = { bg = "#325B5B" }, -- Dark muted cyan
                },
                search = {
                    hl_color = { bg = "#5C475C" }, -- Dark muted purple
                },
                comment = {
                    hl_color = { bg = "#7A5A3D" }, -- Dark muted orange
                },
                cursor = {
                    hl_color = { bg = "#793D54" }, -- Dark muted pink
                },
            },
            priority = 2048 * 3,
        },
        keys = {
            {
                "u",
                function()
                    require("undo-glow").undo()
                end,
                mode = "n",
                desc = "Undo with highlight",
                noremap = true,
            },
            {
                "U",
                function()
                    require("undo-glow").redo()
                end,
                mode = "n",
                desc = "Redo with highlight",
                noremap = true,
            },
            {
                "p",
                function()
                    require("undo-glow").paste_below()
                end,
                mode = "n",
                desc = "Paste below with highlight",
                noremap = true,
            },
            {
                "P",
                function()
                    require("undo-glow").paste_above()
                end,
                mode = "n",
                desc = "Paste above with highlight",
                noremap = true,
            },
            {
                "n",
                function()
                    require("undo-glow").search_next({
                        animation = {
                            animation_type = "strobe",
                        },
                    })
                end,
                mode = "n",
                desc = "Search next with highlight",
                noremap = true,
            },
            {
                "N",
                function()
                    require("undo-glow").search_prev({
                        animation = {
                            animation_type = "strobe",
                        },
                    })
                end,
                mode = "n",
                desc = "Search prev with highlight",
                noremap = true,
            },
            {
                "*",
                function()
                    require("undo-glow").search_star({
                        animation = {
                            animation_type = "strobe",
                        },
                    })
                end,
                mode = "n",
                desc = "Search star with highlight",
                noremap = true,
            },
            {
                "#",
                function()
                    require("undo-glow").search_hash({
                        animation = {
                            animation_type = "strobe",
                        },
                    })
                end,
                mode = "n",
                desc = "Search hash with highlight",
                noremap = true,
            },
            {
                "gc",
                function()
                    -- This is an implementation to preserve the cursor position
                    local pos = vim.fn.getpos(".")
                    vim.schedule(function()
                        vim.fn.setpos(".", pos)
                    end)
                    return require("undo-glow").comment()
                end,
                mode = { "n", "x" },
                desc = "Toggle comment with highlight",
                expr = true,
                noremap = true,
            },
            {
                "gc",
                function()
                    require("undo-glow").comment_textobject()
                end,
                mode = "o",
                desc = "Comment textobject with highlight",
                noremap = true,
            },
            {
                "gcc",
                function()
                    return require("undo-glow").comment_line()
                end,
                mode = "n",
                desc = "Toggle comment line with highlight",
                expr = true,
                noremap = true,
            },
        },
        init = function()
            vim.api.nvim_create_autocmd("TextYankPost", {
                desc = "Highlight when yanking (copying) text",
                callback = function()
                    require("undo-glow").yank()
                end,
            })

            -- This will handle highlights when focus gained, including switching panes in tmux
            vim.api.nvim_create_autocmd("FocusGained", {
                desc = "Highlight when focus gained",
                callback = function()
                    ---@type UndoGlow.CommandOpts
                    local opts = {
                        animation = {
                            animation_type = "slide",
                        },
                    }

                    opts = require("undo-glow.utils").merge_command_opts("UgCursor", opts)
                    local pos = require("undo-glow.utils").get_current_cursor_row()

                    require("undo-glow").highlight_region(vim.tbl_extend("force", opts, {
                        s_row = pos.s_row,
                        s_col = pos.s_col,
                        e_row = pos.e_row,
                        e_col = pos.e_col,
                        force_edge = opts.force_edge == nil and true or opts.force_edge,
                    }))
                end,
            })

            vim.api.nvim_create_autocmd("CmdLineLeave", {
                pattern = { "/", "?" },
                desc = "Highlight when search cmdline leave",
                callback = function()
                    require("undo-glow").search_cmd({
                        animation = {
                            animation_type = "fade",
                        },
                    })
                end,
            })
        end,
    },

    -- { 'code-biscuits/nvim-biscuits' , opts={}},
    -- Blink.cmp reference: https://github.com/WizardStark/dotfiles/blob/main/home/.config/nvim/lua/config/editor/blink_cmp.lua

    -- https://github.com/danielfalk/smart-open.nvim
    -- https://github.com/dmtrKovalenko/fff.nvim

    -- snacks.scroll / neoscroll / mini.animate / smear-cursor.nvim
    -- https://github.com/meznaric/key-analyzer.nvim

    -- "stevearc/conform.nvim",
    -- "mfussenegger/nvim-lint",

    -- 'tpope/vim-obsession',
    -- https://github.com/rmagatti/auto-session -- interesting, but based on cwd and not git/smart root?

    -- https://github.com/hat0uma/csvview.nvim
    -- https://github.com/MeanderingProgrammer/render-markdown.nvim
    -- iamcco/markdown-preview?
    -- https://github.com/cenk1cenk2/jq.nvim
    -- https://github.com/neolooong/whichpy.nvim -- py bin selector? and exec?
    -- https://github.com/aliqyan-21/runTA.nvim -- code exec
    -- https://github.com/mawkler/refjump.nvim
    -- https://github.com/debugloop/layers.nvim -- keymapping layers, potentially good for debugging?
    -- https://github.com/joshzcold/python.nvim
    -- https://github.com/mrjones2014/smart-splits.nvim
    -- https://github.com/kevinhwang91/nvim-hlslens

}
