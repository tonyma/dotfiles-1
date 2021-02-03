lspconfig = require "lspconfig"
lspconfig.gopls.setup {
  on_attach = require'completion'.on_attach,
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

lspconfig.pyls.setup{
  on_attach=require'completion'.on_attach
}

vim.cmd[[autocmd Filetype python,go setlocal omnifunc=v:lua.vim.lsp.omnifunc]]
