local finders = require 'telescope.finders'
local pickers = require 'telescope.pickers'
local make_entry = require 'telescope.make_entry'
local conf = require('telescope.config').values

vim.diagnostic.config({
    signs = {
        text = {
            [ vim.diagnostic.severity.ERROR ] = '🚩',
            [ vim.diagnostic.severity.WARN ] = '❗',
            [ vim.diagnostic.severity.HINT ] = '🪧',
            [ vim.diagnostic.severity.INFO ] = '❕',
        },
    },
    virtual_text = {current_line = true},
})

-- Use FZF to find references
-- vim.lsp.handlers['textDocument/references'] = require('cfg.plugins.fzf.functions').lsp_references_handler

-- Handle formatting in a smarter way
-- If the buffer has been edited before formatting has completed, do not try to
-- apply the changes
vim.lsp.handlers['textDocument/formatting'] = function(err, result, ctx, _)
  if err ~= nil or result == nil then
    return
  end

  -- If the buffer hasn't been modified before the formatting has finished,
  -- update the buffer
  if not vim.api.nvim_buf_get_option(ctx.bufnr, 'modified') then
    local view = vim.fn.winsaveview()
    vim.lsp.util.apply_text_edits(result, ctx.bufnr)
    vim.fn.winrestview(view)
    if ctx.bufnr == vim.api.nvim_get_current_buf() or not ctx.bufnr then
      vim.api.nvim_command 'noautocmd :update'
    end
  end
end

local icons = {
  Text = '',
  Method = '',
  Function = '',
  Constructor = '',
  Variable = '',
  Class = '',
  Interface = '',
  Module = '',
  Property = '',
  Unit = '',
  Value = '',
  Enum = '',
  Keyword = '',
  Snippet = '',
  Color = '',
  File = '',
  Folder = '',
  EnumMember = '',
  Constant = '',
  Struct = '',
  Field = '',
  TypeParameter = '',
}

local kinds = vim.lsp.protocol.CompletionItemKind
for i, kind in ipairs(kinds) do
  kinds[i] = icons[kind] or kind
end


-- Enable completion triggered by <c-x><c-o>
-- local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end
-- buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

-- Construct some utilities that are needed for setting up the LSP servers

local M = {}

function M.on_attach(client, bufnr)

  local function buf_map(...)
    vim.api.nvim_buf_set_keymap(bufnr, ...)
  end

  -- Set up keymaps
  local opts = { noremap = true, silent = false }
  -- buf_map('n', '<c-]>', [[<cmd>lua require('cfg.plugins.lsp').definitions()<cr>]], opts)
  buf_map('n', '<c-]>', [[<cmd>lua vim.lsp.buf.definition()<cr>]], opts)
  buf_map('n', 'gd', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
  buf_map('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
  buf_map('n', 'gD', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)

  buf_map('n', '<space>rn', [[<cmd>lua vim.lsp.buf.rename()<CR>]], opts)
  buf_map('n', '<space>ca', [[<cmd>lua vim.lsp.buf.code_action()<cr>]], opts)

  buf_map('n', 'gk', [[<cmd>lua vim.lsp.buf.hover()<cr>]], opts)
  buf_map('n', 'gs', [[<cmd>lua vim.lsp.buf.signature_help()<cr>]], opts)
  -- buf_map('n', '<space>y', [[<cmd>lua vim.lsp.buf.signature_help()<cr>]], opts)

  -- buf_map('n', '<leader>ff', [[<cmd>lua vim.lsp.buf.format()<cr>]], opts)

end

M.capabilities = vim.lsp.protocol.make_client_capabilities()
-- Configure that we accept snippets so that the server would send us snippet
-- completion items. Snippets are not supported by default, but
-- `vim-vsnip-integ` adds support for them.
M.capabilities.textDocument.completion.completionItem.snippetSupport = true
M.capabilities.textDocument.completion.completionItem.resolveSupport = {
  properties = {
    'documentation',
    'detail',
    'additionalTextEdits',
  },
}
M.capabilities.textDocument.completion.completionItem.preselectSupport = true
M.capabilities.textDocument.completion.completionItem.insertReplaceSupport = true
M.capabilities.textDocument.completion.completionItem.labelDetailsSupport = true
M.capabilities.textDocument.completion.completionItem.deprecatedSupport = true
M.capabilities.textDocument.completion.completionItem.commitCharactersSupport = true
M.capabilities.textDocument.completion.completionItem.tagSupport = { valueSet = { 1 } }

local function list_or_jump(action, title, opts)
  opts = opts or {}

  local params = vim.lsp.util.make_position_params()
  local result, err = vim.lsp.buf_request_sync(0, action, params, opts.timeout or 10000)
  if err then
    vim.api.nvim_err_writeln('Error when executing ' .. action .. ' : ' .. err)
    return
  end
  local flattened_results = {}
  for _, server_results in pairs(result) do
    if server_results.result then
      vim.list_extend(flattened_results, server_results.result)
    end
  end


  if #flattened_results == 0 then
    -- If no LSP results, try ctags as fallback
    local current_word = vim.fn.expand("<cword>")
    local tags = vim.fn.taglist('^' .. current_word .. '$')
    
    if #tags == 0 then
        print("No LSP results or tags found for: " .. current_word)
        return
    elseif #tags == 1 then
        -- Jump to single tag
        vim.cmd('tag ' .. current_word)
    else
        -- Multiple tags found, show in telescope
        require('telescope.builtin').tags({
            default_text = current_word,
        })
    end
  elseif #flattened_results == 1 then
    vim.lsp.util.jump_to_location(flattened_results[1], 'utf-8')
  else
    local locations = vim.lsp.util.locations_to_items(flattened_results)
    pickers.new(opts, {
      prompt_title = title,
      finder = finders.new_table {
        results = locations,
        entry_maker = opts.entry_maker or make_entry.gen_from_quickfix(opts),
      },
      previewer = conf.qflist_previewer(opts),
      sorter = conf.generic_sorter(opts),
    }):find()
  end
end

function M.definitions(opts)
  return list_or_jump('textDocument/definition', 'LSP Definitions', opts)
end

return M
