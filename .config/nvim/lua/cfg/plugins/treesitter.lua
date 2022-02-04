require('nvim-treesitter.install').compilers = { 'gcc' }
require('nvim-treesitter.configs').setup {
  highlight = {
    enable = true,
    use_languagetree = true,
    additional_vim_regex_highlighting = true,
  },
  indent = {
    enable = true,
    disable = {"python"}
  },
  playground = {
    enable = false,
    disable = {},
    updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
    persist_queries = false, -- Whether the query persists across vim sessions
  },
  autopairs = {
    enable = true,
  },
  context_commentstring = {
    enable = true,
  },
  incremental_selection = {
      enable = true,
      keymaps = {
          init_selection = "gnn",
          node_incremental = "grn",
          scope_incremental = "grc",
          node_decremental = "grm",
          },
  },
  ensure_installed = {
    'json',
    'python',
    'html',
    'lua',
    'yaml',
    'css',
    'bash',
    'c',
    'cpp',
    'toml',
    'cmake',
    'comment',
    'dockerfile',
    'fortran',
    'json5',
    'latex',
    'llvm',
    'rust',
    'vim',
    'bibtex',
    'http',
    'markdown'
  },
}
