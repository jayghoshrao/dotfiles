-- local vim = vim

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

local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

--- startup and add configure plugins
-- packer.startup(function()
return require('packer').startup(function(use)
    use 'wbthomason/packer.nvim'

    -- personal
    use { 'jayghoshter/tasktags.vim', ft={'markdown', 'pandoc', 'vimwiki'}}

    -- Advanced highlighting
    use {
        'nvim-treesitter/nvim-treesitter',
        tag='v0.8.1',
        run = ':TSUpdate',
        config = function()
            require 'cfg.plugins.treesitter'
        end,
        requires = {
            -- Dynamically set commentstring based on cursor location in file
            'JoosepAlviste/nvim-ts-context-commentstring',
            'nvim-treesitter/playground',
        },
    }

    -- install and initialize before nvim-lspconfig
    use {
        'williamboman/mason.nvim',
        -- 'williamboman/mason-lspconfig.nvim',
        -- "jayp0521/mason-nvim-dap.nvim",
        config = function()
            require 'cfg.plugins.mason'
        end,
    }

    -- LSP Config and Completion
    use {
        'neovim/nvim-lspconfig', -- Built-in LSP configurations
        config = function()
            require 'cfg.plugins.lsp'
            require 'cfg.plugins.lsp.cc_ls'
            require 'cfg.plugins.lsp.docker_ls'
            require 'cfg.plugins.lsp.fortls'
            require 'cfg.plugins.lsp.rust_analyzer'
            require 'cfg.plugins.lsp.json_ls'
            require 'cfg.plugins.lsp.sumneko_lua'
            require 'cfg.plugins.lsp.pyright'
            require 'cfg.plugins.lsp.texlab'
            require 'cfg.plugins.lsp.yaml_ls'
        end,
        requires = {
            {
                'L3MON4D3/LuaSnip',
                config = function()
                    require 'cfg.plugins.luasnip'
                end,
                requires = 'https://github.com/rafamadriz/friendly-snippets'
            },
            {
                'hrsh7th/nvim-cmp',
                config = function()
                    require 'cfg.plugins.cmp'
                end,
                requires = {
                    'hrsh7th/cmp-nvim-lsp',
                    'hrsh7th/cmp-buffer',
                    'hrsh7th/cmp-path',
                    'saadparwaiz1/cmp_luasnip',
                    -- 'petertriho/cmp-git',
                },
            },
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
    }
    use 'm-pilia/vim-ccls'

    use {
        'onsails/diaglist.nvim',
        config = function()
            require("diaglist").init({
                debug = false,
                debounce_ms = 150,
            })
        end
    }

    -- Telescope: It's dope
    use {
        -- Fuzzy finder
        'nvim-telescope/telescope.nvim', tag='0.1.0',
        config = function()
            require 'cfg.plugins.telescope'
        end,
        requires = {
            'nvim-lua/plenary.nvim', -- Useful Lua utilities
            'nvim-lua/popup.nvim',
            'nvim-telescope/telescope-github.nvim',
            -- FZY sorter for Telescope
            -- 'nvim-telescope/telescope-fzy-native.nvim'
            -- FZF sorter for Telescope
            { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' },
        },
    }



    --" Plug 'https://github.com/mfussenegger/nvim-dap'
    use {
        'szw/vim-maximizer',
        config = function()
            local map = require 'cfg.utils'.map
            map('n', '<space>m', '<cmd>MaximizerToggle<cr>')
        end

    }

    -- Tpope's plugins are de-facto standard
    use 'tpope/vim-surround'
    use 'tpope/vim-unimpaired'
    use 'tpope/vim-repeat'
    use 'tpope/vim-obsession'
    use 'tpope/vim-fugitive'


    use 'kyazdani42/nvim-web-devicons'

    use {
        'lewis6991/gitsigns.nvim', -- Git status signs in the gutter
        config = function()
            require 'cfg.plugins.gitsigns'
        end,
    }

    -- Language- and Filetype-specific:
    use {
        'lervag/vimtex',
        ft = {
            'vimwiki',
            'markdown',
            'tex'
        }
    }

    use 'mboughaba/i3config.vim'

    use {
        'vim-pandoc/vim-pandoc',
        config = function()
            require 'cfg.plugins.pandoc'
        end,
        ft = {
            'markdown',
            'vimwiki',
            'tex'
        }
    }
    require 'cfg.utils'.map('n', '<leader>vwl', '<Plug>VimwikiNextLink', {noremap=false} )
    require 'cfg.utils'.map('n', '<leader>vwh', '<Plug>VimwikiPrevLink', {noremap=false} )
    use {
        'vimwiki/vimwiki',
        config = function()
            require 'cfg.plugins.vimwiki'
        end,
        ft = {'markdown', 'vimwiki', 'pandoc'}
    }

    -- NOTE: doesn't work everywhere since vimwiki
    -- is only used for certain filetypes
    use {
        'ElPiloto/telescope-vimwiki.nvim',
        config = function()
            require('telescope').load_extension('vw')
            local map = require('cfg.utils').map
            map('n', '<space>n', ':Telescope vw<cr>')
        end
    }


    -- General:
    use 'lambdalisue/suda.vim'
    use 'tommcdo/vim-lion'

    -- Vim object extensions
    -- 1. Indent object
    use 'michaeljsmith/vim-indent-object'
    --  2. [n]ext, [,], and user dI' to delete inner without space
    use 'wellle/targets.vim'
    -- use 'vim-scripts/argtextobj.vim'

    -- Explore and Pick!
    --
    use {
        'mcchrish/nnn.vim',
        config = function()
            require'cfg.plugins.nnn'
        end

    }

    -- General Utilities
    use {
        'lukas-reineke/indent-blankline.nvim',
        config = function()
            require("indent_blankline").setup {
                show_end_of_line = true,
                space_char_blankline = " ",
                use_treesitter = true,
                char_list = {"▏"}
            }
        end
    }

    use { 'alexghergh/nvim-tmux-navigation', config = function()
        require'nvim-tmux-navigation'.setup {
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
    }

    use {
        'windwp/nvim-autopairs',
        config = function()
            require 'cfg.plugins.autopairs'
        end,
    }

    use {
      'numToStr/Comment.nvim',
      config = function()
        require('Comment').setup {
          pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
        }
      end,
    }

    -- Colorschemes
    -- use 'shaunsingh/nord.nvim'

    use {
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

            require('cfg.utils').create_augroups {
              nord = {
                    { 'User', 'PlugLoaded', [[++nested colorscheme nordic]] },
                }
            }
        end
    }

    use {
        'norcalli/nvim-colorizer.lua',
        config = function()
            require'colorizer'.setup()
        end
    }

    -- use {
    --   'editorconfig/editorconfig-vim', -- Project-specific settings
    --   config = function()
    --     vim.g.EditorConfig_preserve_formatoptions = 1
    --   end,
    -- }
    --

    -- Conditional loading of plugins helps avoid issues on some server setups
    -- GitHub: Better pull requests and issues.
    if vim.fn.executable('gh') == 1 then
        use 'pwntester/octo.nvim'
    end

    use {'mfussenegger/nvim-dap',
        config = function()
            require'cfg.plugins.dap'
        end,
        -- lunajson for a custom launch function. See dap.lua
        rocks = 'lunajson'
    }

    use {
        'rcarriga/nvim-dap-ui',
        config = function()
            require("dapui").setup({
                icons = { expanded = "▾", collapsed = "▸" },
                mappings = {
                    -- Use a table to apply multiple mappings
                    expand = { "<CR>", "<2-LeftMouse>" },
                    open = "o",
                    remove = "d",
                    edit = "e",
                    repl = "r",
                },
                layouts = {
                    {
                        elements = {
                            'scopes',
                            'breakpoints',
                            'stacks',
                            'watches',
                        },
                        size = 40,
                        position = 'left',
                    },
                    {
                        elements = {
                            'repl',
                            'console',
                        },
                        size = 10,
                        position = 'bottom',
                    },
                },
                floating = {
                    max_height = nil, -- These can be integers or a float between 0 and 1.
                    max_width = nil, -- Floats will be treated as percentage of your screen.
                    border = "single", -- Border style. Can be "single", "double" or "rounded"
                    mappings = {
                        close = { "q", "<Esc>" },
                    },
                },
                windows = { indent = 1 },
            })
            require('cfg.utils').map('n', '<space>dd', '<cmd>lua require("dapui").toggle()<cr>')
            require('cfg.utils').map('n', '<space>dD', '<cmd>lua require("dapui").close()<cr>')
        end
    }

    use {
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
    }


    use {
        'ThePrimeagen/harpoon',
        config = function()
            require'cfg.plugins.harpoon'
        end
    }

    -- Lua
    use {
        "folke/zen-mode.nvim",
        config = function()
            require 'cfg.plugins.zen-mode'
        end
    }

    use {
        "folke/twilight.nvim",
        config = function()
            require("twilight").setup {}
        end
    }

    use {
        'skywind3000/asynctasks.vim',
        requires = {
            {
                'skywind3000/asyncrun.vim',
                config = function()
                    require 'cfg.plugins.async'
                end
            }
        },
    }

    use {
        'GustavoKatel/telescope-asynctasks.nvim',
        config = function()
            local map = require('cfg.utils').map
            map('n', '<leader>tt', [[<cmd>lua require('telescope').extensions.asynctasks.all()<cr>]])
        end
    }


    use {
        'derekwyatt/vim-fswitch',
        config = [[require('cfg.utils').map('n', 'gh', ':FSHere<cr>')]]
    }

    use {
        "folke/which-key.nvim",
        config = function()
            require("which-key").setup {
            }
        end
    }

    use {
        "cuducos/yaml.nvim",
        ft = {"yaml"}, -- optional
        requires = {
            "nvim-treesitter/nvim-treesitter",
            "nvim-telescope/telescope.nvim" -- optional
        },
        -- config = function ()
        --     require("yaml_nvim").init()
        -- end,
    }

    use {
        'nvim-lualine/lualine.nvim',
        requires = {'kyazdani42/nvim-web-devicons', opt = true},
        config = function()
            require 'cfg.plugins.lualine'
        end
    }

    use 'ggandor/lightspeed.nvim'

    use 'duane9/nvim-rg'

    use {
        'kdheepak/lazygit.nvim',
        config = function()
            local map = require('cfg.utils').map
            map('n', '<leader>gg', [[<cmd>LazyGit<cr>]])
        end
    }


    use {
        'goerz/jupytext.vim',
        -- config = function()
        --     vim.g.jupytext_filetype_map = {md = 'vimwiki'}
        -- end
    }
    vim.g.jupytext_filetype_map = {md = 'vimwiki'}

    -- REPLs for nvim
    -- use {'hkupty/iron.nvim', tag = "v3.0"}

    use { 'ray-x/lsp_signature.nvim', config=function() require'lsp_signature'.setup() end }
    use 'lewis6991/impatient.nvim'

    use {"akinsho/toggleterm.nvim", tag = '*', 
        config = function()
            require("toggleterm").setup({
                open_mapping=[[<C-q>]],
                direction = 'float',
            })
        end}

    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if packer_bootstrap then
    require('packer').sync()
    end

end)

