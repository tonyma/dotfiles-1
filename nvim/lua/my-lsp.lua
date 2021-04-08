local custom_lsp_attach = function(_, bufnr) -- function(client, bufnr)
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
  vim.cmd[[autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()]]
end

local function merge_config(base, ext)
  local table = {}
  -- copy base
  for key, value in next, base do
    table[key] = value
  end

  if not ext then
    return table
  end

  for key, value in next, ext do
    old = table[key]
    if type(old) == 'table' and type(value) == 'table' then
      table[key] = merge_config(old, value)
    else
      table[key] = value
    end
  end

  return table
end

local additional_config = {
  typescript = {
    settings = {
      typescript = {
        importModuleSpecifier = 'relative'
      }
    }
  },
  lua = {
    settings = {
      Lua = {
        completion = {
          keywordSnippet = "Disable",
        },
        diagnostics = {
          globals = {"vim", "use"},
          disable = {"lowercase-global"}
        },
        runtime = {
          version = "LuaJIT",
          path = vim.split(package.path, ";"),
        },
        workspace = {
          library = {
            [vim.fn.expand("$VIMRUNTIME/lua")] = true,
            [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
          },
        },
      },
    },
  }
}

local function setup_servers()
  require'lspinstall'.setup()
  local servers = require'lspinstall'.installed_servers()
  for _, server in pairs(servers) do
    local config = merge_config({ on_attach = custom_lsp_attach }, additional_config[server])
    require("lspconfig")[server].setup(config)
  end
end

setup_servers()

-- Automatically reload after `:LspInstall <server>` so we don't have to restart neovim
require'lspinstall'.post_install_hook = function ()
  setup_servers() -- reload installed servers
  vim.cmd("bufdo e") -- this triggers the FileType autocmd that starts the server
end
