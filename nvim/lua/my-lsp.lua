lspconfig = require "lspconfig"

local custom_lsp_attach = function(client)
  -- See `:help nvim_buf_set_keymap()` for more information
  vim.api.nvim_buf_set_keymap(0, 'n', '<leader>lh', '<cmd>lua vim.lsp.buf.hover()<CR>', {noremap = true})
  vim.api.nvim_buf_set_keymap(0, 'n', '<leader>ld', '<cmd>lua vim.lsp.buf.definition()<CR>', {noremap = true})
  -- ... and other keymappings for LSP

  -- Use LSP as the handler for omnifunc.
  --    See `:help omnifunc` and `:help ins-completion` for more information.
  vim.bo.omnifunc = 'v:lua.vim.lsp.omnifunc'

  -- For plugins with an `on_attach` callback, call them here. For example:
  require('completion').on_attach()
end


lspconfig.gopls.setup {
  on_attach = custom_lsp_attach,
  cmd = {"gopls", "serve"},
  settings = {
    gopls = {
      analyses = {
        unusedparams = true,
      },
      staticcheck = true,
    },
  },
}

lspconfig.tsserver.setup{
  on_attach = custom_lsp_attach,
}
lspconfig.angularls.setup{
  on_attach = custom_lsp_attach,
}

lspconfig.pyls.setup{
  on_attach = custom_lsp_attach,
}
