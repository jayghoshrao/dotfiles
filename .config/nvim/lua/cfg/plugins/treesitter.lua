-- require('nvim-treesitter.install').compilers = { 'gcc' }
require('nvim-treesitter.configs').setup {
  highlight = {
    enable = true,
    use_languagetree = true,
    additional_vim_regex_highlighting = false,
  },
  indent = {
    enable = true,
  },
  playground = {
    enable = false,
    disable = {},
    updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
    persist_queries = false, -- Whether the query persists across vim sessions
  },
  autotag={
      enable=true,
  },
  autopairs = {
    enable = true,
  },
  context_commentstring = {
    enable = true,
    enable_autocmd = false,
  },
  matchup = {
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
    'bash',
    'bibtex',
    'c',
    'cmake',
    'comment',
    'cpp',
    'css',
    'dockerfile',
    'fortran',
    'html',
    'http',
    'json',
    'json5',
    'latex',
    'llvm',
    'lua',
    'markdown',
    'markdown_inline',
    'nix',
    'python',
    'rust',
    'toml',
    'vim',
    'yaml',
  },
}
