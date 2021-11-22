local vim = vim
local fn = vim.fn
local cmd = vim.cmd

-- TODO: Check
-- https://github.com/onsails/diaglist.nvim
-- https://github.com/nvim-telescope/telescope-vimspector.nvim
-- https://github.com/junegunn/vim-peekaboo
-- https://github.com/rhysd/clever-f.vim
-- https://github.com/ggandor/lightspeed.nvim -- vim-sneak successor
-- https://github.com/ray-x/lsp_signature.nvim
-- https://github.com/ThePrimeagen/git-worktree.nvim
-- https://github.com/stefandtw/quickfix-reflector.vim

-- https://github.com/b3nj5m1n/kommentary
-- https://github.com/alpertuna/vim-header
-- https://github.com/ahmedkhalf/project.nvim
-- https://github.com/gelguy/wilder.nvim

-- https://github.com/ibhagwan/fzf-lua
-- https://github.com/d0c-s4vage/lookatme  -- presentation!
-- https://github.com/ngscheurich/iris.nvim


-- -- Automatically install packer.nvim
local install_path = fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
    cmd('!git clone https://github.com/wbthomason/packer.nvim ' .. install_path)
end

-- cmd [[packadd packer.nvim]]

--- startup and add configure plugins
-- packer.startup(function()
return require('packer').startup(function(use)
    local use = use

    use 'wbthomason/packer.nvim'

    -- personal
    use { 'jayghoshter/tasktags.vim', ft={'markdown', 'pandoc', 'vimwiki'}}

    -- Advanced highlighting
    use {
        'nvim-treesitter/nvim-treesitter',
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

    -- LSP Config and Completion
    use {
        'neovim/nvim-lspconfig', -- Built-in LSP configurations
        config = function()
            require 'cfg.plugins.lsp'
            require 'cfg.plugins.lsp.cc_ls'
            require 'cfg.plugins.lsp.docker_ls'
            require 'cfg.plugins.lsp.fortls'
            require 'cfg.plugins.lsp.init'
            require 'cfg.plugins.lsp.json_ls'
            -- require 'cfg.plugins.lsp.lua_ls'
            -- require 'cfg.plugins.lsp.lua_types'
            require 'cfg.plugins.lsp.null_ls'
            require 'cfg.plugins.lsp.pyright'
            require 'cfg.plugins.lsp.texlab'
            require 'cfg.plugins.lsp.yaml_ls'
        end,
        requires = {
            {
                'hrsh7th/vim-vsnip', -- Snippets
                config = function()
                    require 'cfg.plugins.vsnip'
                end,
                requires = 'https://github.com/rafamadriz/friendly-snippets'
            },
            {
                'hrsh7th/nvim-cmp',
                requires = {
                    'hrsh7th/cmp-nvim-lsp',
                    'hrsh7th/cmp-buffer',
                    'hrsh7th/cmp-path',
                    'hrsh7th/cmp-vsnip',
                },
                config = function()
                    require 'cfg.plugins.cmp'
                end,
            },
            {
                'jose-elias-alvarez/null-ls.nvim',
                config = function()
                    require 'cfg.plugins.lsp.null_ls'
                end,
            },
            {
                'onsails/lspkind-nvim'
            }
        },
    }
    use 'm-pilia/vim-ccls'

    -- Telescope: It's dope
    use {
        -- Fuzzy finder
        'nvim-telescope/telescope.nvim',
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
                pre_hook = function()
                    return require('ts_context_commentstring.internal').calculate_commentstring()
                end,
            }
        end,
    }

    -- Colorschemes
    -- use 'shaunsingh/nord.nvim'

    use {
        'maaslalani/nordbuddy',
        config = function()
            -- The table used in this example contains the default settings.
            -- Modify or remove these to your liking:
            require('nordbuddy').colorscheme({
                -- Underline style used for spelling
                -- Options: 'none', 'underline', 'undercurl'
                underline_option = 'none',
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

    -- -- Debugger: Woah!
    -- if vim.fn.has('python3') == 1 then
    --     use {
    --         'puremourning/vimspector',
    --         config = function()
    --             require 'cfg.plugins.vimspector'
    --         end
    --     }
    -- end
    --
    use {'mfussenegger/nvim-dap',
        config = function()
            require'cfg.plugins.dap'
        end
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
                sidebar = {
                    -- You can change the order of elements in the sidebar
                    elements = {
                        -- Provide as ID strings or tables with "id" and "size" keys
                        {
                            id = "scopes",
                            size = 0.25, -- Can be float or integer > 1
                        },
                        { id = "breakpoints", size = 0.25 },
                        { id = "stacks", size = 0.25 },
                        { id = "watches", size = 00.25 },
                    },
                    size = 40,
                    position = "left", -- Can be "left", "right", "top", "bottom"
                },
                tray = {
                    elements = { "repl" },
                    size = 10,
                    position = "bottom", -- Can be "left", "right", "top", "bottom"
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
            require("zen-mode").setup {
                window = {
                    backdrop = 1, -- shade the backdrop of the Zen window. Set to 1 to keep the same as Normal
                    -- height and width can be:
                    -- * an absolute number of cells when > 1
                    -- * a percentage of the width / height of the editor when <= 1
                    -- * a function that returns the width or the height
                    width = 120, -- width of the Zen window
                    height = 1, -- height of the Zen window
                    -- by default, no options are changed for the Zen window
                    -- uncomment any of the options below, or add other vim.wo options you want to apply
                    options = {
                        -- signcolumn = "no", -- disable signcolumn
                        number = false, -- disable number column
                        -- relativenumber = false, -- disable relative numbers
                        -- cursorline = false, -- disable cursorline
                        -- cursorcolumn = false, -- disable cursor column
                        -- foldcolumn = "0", -- disable fold column
                        -- list = false, -- disable whitespace characters
                    },
                },
                plugins = {
                    -- disable some global vim options (vim.o...)
                    -- comment the lines to not apply the options
                    options = {
                        enabled = true,
                        ruler = false, -- disables the ruler text in the cmd line area
                        showcmd = false, -- disables the command in the last line of the screen
                    },
                    twilight = { enabled = true }, -- enable to start Twilight when zen mode opens
                    gitsigns = { enabled = false }, -- disables git signs
                    tmux = { enabled = false }, -- disables the tmux statusline
                    -- this will change the font size on kitty when in zen mode
                    -- to make this work, you need to set the following kitty options:
                    -- - allow_remote_control socket-only
                    -- - listen_on unix:/tmp/kitty
                    kitty = {
                        enabled = false,
                        font = "+4", -- font size increment
                    },
                },
                -- callback where you can add custom code when the Zen window opens
                on_open = function(win)
                end,
                -- callback where you can add custom code when the Zen window closes
                on_close = function()
                end,
            }
            local map = require('cfg.utils').map
            map('n', '<leader>g', ':ZenMode<cr>')
        end
    }

    use {
        "folke/twilight.nvim",
        config = function()
            require("twilight").setup {
                -- your configuration comes here
                -- or leave it empty to use the default settings
                -- refer to the configuration section below
            }
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
            require'lualine'.setup {
                options = {
                    icons_enabled = true,
                    theme = 'nord',
                    component_separators = { left = '', right = ''},
                    section_separators = { left = '', right = ''},
                    disabled_filetypes = {},
                    always_divide_middle = true,
                },
                sections = {
                    lualine_a = {'mode'},
                    lualine_b = {'branch', 'diff',
                        {'diagnostics', sources={'nvim_lsp', 'coc'}}},
                    lualine_c = {'g:asyncrun_status', 'filename'},
                    lualine_x = {'encoding', 'fileformat', 'filetype'},
                    lualine_y = {'progress'},
                    lualine_z = {'location'}
                },
                inactive_sections = {
                    lualine_a = {},
                    lualine_b = {},
                    lualine_c = {'filename'},
                    lualine_x = {'location'},
                    lualine_y = {},
                    lualine_z = {}
                },
                tabline = {
                    lualine_a = {
                        {
                            'buffers',
                            buffers_color = {
                                -- active = 'StatusLine',
                                inactive = 'StatusLineNC',
                            },
                        }
                    },
                    lualine_b = {},
                    lualine_c = {},
                    lualine_x = {},
                    lualine_y = {},
                    lualine_z = {
                        {
                            'tabs',
                            tabs_color = {
                                -- active = 'StatusLine',
                                inactive = 'StatusLineNC',
                            }
                        }
                    }
                },
                extensions = {}
            }
        end
    }

    use_rocks 'lunajson'

end)
