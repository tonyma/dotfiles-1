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

local function setup_servers()
  require'lspinstall'.setup()
  local servers = require'lspinstall'.installed_servers()
  for _, server in pairs(servers) do
    local config = { on_attach = custom_lsp_attach }
    if server == 'typescript' then
      config.settings = {
        typescript = {
          importModuleSpecifier = 'relative'
        }
      }
    end
    require("lspconfig")[server].setup(config)
  end
end

setup_servers()

-- Automatically reload after `:LspInstall <server>` so we don't have to restart neovim
require'lspinstall'.post_install_hook = function ()
  setup_servers() -- reload installed servers
  vim.cmd("bufdo e") -- this triggers the FileType autocmd that starts the server
end
