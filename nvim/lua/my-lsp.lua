lspconfig = require "lspconfig"

local custom_lsp_attach = function(client, bufnr)
  -- See `:help nvim_buf_set_keymap()` for more information
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>lh', '<cmd>lua vim.lsp.buf.hover()<CR>', {noremap = true})
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>ld', '<cmd>lua vim.lsp.buf.definition()<CR>', {noremap = true})
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>lr', '<cmd>lua vim.lsp.buf.rename()<CR>', {noremap = true})
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>ln', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', {noremap = true})
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>lp', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', {noremap = true})
  -- ... and other keymappings for LSP

  -- Use LSP as the handler for omnifunc.
  --    See `:help omnifunc` and `:help ins-completion` for more information.
  vim.bo[bufnr].omnifunc = 'v:lua.vim.lsp.omnifunc'
  vim.cmd[[command! -buffer LspStop lua vim.lsp.stop_client(vim.lsp.get_active_clients())]]

  -- For plugins with an `on_attach` callback, call them here. For example:
  require('completion').on_attach()
end

lspconfig.angularls.setup{ on_attach = custom_lsp_attach }
lspconfig.bashls.setup{ on_attach = custom_lsp_attach }
lspconfig.cssls.setup{ on_attach = custom_lsp_attach }
-- lspconfig.denols.setup{ on_attach = custom_lsp_attach }
lspconfig.dockerls.setup{ on_attach = custom_lsp_attach }
lspconfig.efm.setup{ on_attach = custom_lsp_attach }
lspconfig.gopls.setup { on_attach = custom_lsp_attach }
lspconfig.html.setup{ on_attach = custom_lsp_attach }
lspconfig.jsonls.setup{ on_attach = custom_lsp_attach }
lspconfig.perlls.setup{ on_attach = custom_lsp_attach }
lspconfig.pyls.setup{ on_attach = custom_lsp_attach }
lspconfig.rust_analyzer.setup{ on_attach = custom_lsp_attach }
lspconfig.terraformls.setup{ on_attach = custom_lsp_attach }
lspconfig.tsserver.setup{
  on_attach = custom_lsp_attach,
  settings = {
    typescript = {
      importModuleSpecifier = 'relative'
    }
  }
}
lspconfig.vimls.setup{ on_attach = custom_lsp_attach }
lspconfig.yamlls.setup{ on_attach = custom_lsp_attach }
