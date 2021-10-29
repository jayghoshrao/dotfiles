local vim = vim
local fn = vim.fn
local cmd = vim.cmd

-- Check out https://github.com/gillescastel/latex-snippets
-- https://github.com/rhysd/clever-f.vim
-- https://github.com/bkad/CamelCaseMotion or 
-- https://github.com/chaoren/vim-wordmotion
-- Plug 'voldikss/vim-floaterm'
-- https://github.com/junegunn/vim-peekaboo
-- https://github.com/stefandtw/quickfix-reflector.vim
-- Vimspector + Telescope
-- https://github.com/gelguy/wilder.nvim
-- https://github.com/ngscheurich/iris.nvim
-- https://github.com/d0c-s4vage/lookatme
-- https://github.com/b3nj5m1n/kommentary
-- https://github.com/alpertuna/vim-header
-- https://github.com/garbas/vim-snipmate
-- https://github.com/onsails/diaglist.nvim
-- https://github.com/ahmedkhalf/project.nvim
-- https://github.com/ibhagwan/fzf-lua
-- https://github.com/rmagatti/goto-preview
-- https://github.com/ggandor/lightspeed.nvim " vim-sneak successor
-- https://github.com/ray-x/lsp_signature.nvim
-- https://github.com/lewis6991/gitsigns.nvim
-- https://github.com/ThePrimeagen/git-worktree.nvim


-- Automatically install packer.nvim
local install_path = fn.stdpath 'data' .. '/site/pack/packer/opt/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
    cmd('!git clone https://github.com/wbthomason/packer.nvim ' .. install_path)
end

cmd [[packadd packer.nvim]]
--- startup and add configure plugins
-- packer.startup(function()
return require('packer').startup(function(use)
    local use = use

    -- personal
    use 'jayghoshter/tasktags.vim'

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


    -- Debugger: Woah!
    if vim.fn.has('python3') == 1 then
        use 'puremourning/vimspector'
    end

    --" Plug 'https://github.com/mfussenegger/nvim-dap'
    use 'szw/vim-maximizer'

    -- Tpope's plugins are de-facto standard
    use 'tpope/vim-surround'                                     
    use 'tpope/vim-unimpaired'                                   
    use 'tpope/vim-repeat'                                      
    use 'tpope/vim-obsession'                                   

    use {
        'tpope/vim-fugitive',
        cmd = { 'Git', 'G', 'Gstatus', 'Gblame', 'Gpush', 'Gpull', 'Gvdiffsplit', },
    }

    -- GitHub: Better pull requests and issues.
    use 'pwntester/octo.nvim'
    use 'kyazdani42/nvim-web-devicons'
    use {
        'lewis6991/gitsigns.nvim', -- Git status signs in the gutter
        config = function()
            require 'cfg.plugins.gitsigns'
        end,
    }

    -- Language- and Filetype-specific:
    use 'lervag/vimtex'
    use 'mboughaba/i3config.vim'           
    use {
        'vim-pandoc/vim-pandoc',
        config = function()
            require 'cfg.plugins.pandoc'
        end
    }

    -- General:
    use 'lambdalisue/suda.vim'
    use 'skywind3000/asyncrun.vim'
    use 'tommcdo/vim-lion'                                       

    -- Vim object extensions
    -- 1. Indent object
    use 'michaeljsmith/vim-indent-object'
    --  2. [n]ext, [,], and user dI' to delete inner without space
    use 'wellle/targets.vim'               
    -- use 'vim-scripts/argtextobj.vim'

    -- Explore and Pick!
    use {
        "luukvbaal/nnn.nvim",
        config = function() 
            require("nnn").setup({
                explorer = {
                    cmd = "nnn -eo",       -- command overrride (-F1 flag is implied, -a flag is invalid!)
                    width = 24,        -- width of the vertical split
                    session = "",      -- or global/local/shared
                    tabs = true,       -- seperate explorer buffer per tab
                },
                picker = {
                    cmd = "nnn -eo",       -- command override (-p flag is implied)
                    style = {
                        width = 0.8,     -- width in percentage of the viewport
                        height = 0.8,    -- height in percentage of the viewport
                        xoffset = 0.5,   -- xoffset in percentage
                        yoffset = 0.5,   -- yoffset in percentage
                        border = "solid",
                    },
                    session = "",      -- or global/local/shared
                },
                replace_netrw = "picker", -- or explorer/picker
                mappings = {
                    { "<C-t>", "tabedit" },         -- open file(s) in tab
                    { "<C-s>", "split" },           -- open file(s) in split
                    { "<C-v>", "vsplit" },          -- open file(s) in vertical split
                    -- { "<C-y>", copy_to_clipboard }, -- copy file(s) to clipboard
                    -- { "<C-w>", cd_to_path },        -- cd to file directory
                },       
                -- windownav = "<C-w>l" -- window movement mapping to navigate out of nnn
            }) 
            local map = require('cfg.utils').map
            map('n', '<leader>e', ':NnnExplorer %:p:h<cr>')
            map('n', '<leader>f', ':NnnPicker<cr>')
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

end)
