lspconfig = require "lspconfig"

local custom_lsp_attach = function(client)
  -- See `:help nvim_buf_set_keymap()` for more information
  vim.api.nvim_buf_set_keymap(0, 'n', '<leader>lh', '<cmd>lua vim.lsp.buf.hover()<CR>', {noremap = true})
  vim.api.nvim_buf_set_keymap(0, 'n', '<leader>ld', '<cmd>lua vim.lsp.buf.definition()<CR>', {noremap = true})
  vim.api.nvim_buf_set_keymap(0, 'n', '<leader>lr', '<cmd>lua vim.lsp.buf.rename()<CR>', {noremap = true})
  -- ... and other keymappings for LSP

  -- Use LSP as the handler for omnifunc.
  --    See `:help omnifunc` and `:help ins-completion` for more information.
  vim.bo.omnifunc = 'v:lua.vim.lsp.omnifunc'

  -- For plugins with an `on_attach` callback, call them here. For example:
  require('completion').on_attach()
end

lspconfig.angularls.setup{ on_attach = custom_lsp_attach }
lspconfig.bashls.setup{ on_attach = custom_lsp_attach }
lspconfig.cssls.setup{ on_attach = custom_lsp_attach }
lspconfig.denols.setup{ on_attach = custom_lsp_attach }
lspconfig.dockerls.setup{ on_attach = custom_lsp_attach }
lspconfig.efm.setup{ on_attach = custom_lsp_attach }
lspconfig.gopls.setup { on_attach = custom_lsp_attach }
lspconfig.html.setup{ on_attach = custom_lsp_attach }
lspconfig.jsonls.setup{ on_attach = custom_lsp_attach }
lspconfig.perlls.setup{ on_attach = custom_lsp_attach }
lspconfig.pyls.setup{ on_attach = custom_lsp_attach }
lspconfig.rust_analyzer.setup{ on_attach = custom_lsp_attach }
lspconfig.terraformls.setup{ on_attach = custom_lsp_attach }
lspconfig.tsserver.setup{ on_attach = custom_lsp_attach }
lspconfig.vimls.setup{ on_attach = custom_lsp_attach }
lspconfig.yamlls.setup{ on_attach = custom_lsp_attach }
