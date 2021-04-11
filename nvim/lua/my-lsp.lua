local custom_lsp_attach = function(client, bufnr) -- function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end

  buf_set_keymap('n', '<leader>lh', '<cmd>lua vim.lsp.buf.hover()<CR>', {noremap = true})
  buf_set_keymap('n', '<leader>ld', '<cmd>lua vim.lsp.buf.definition()<CR>', {noremap = true})
  buf_set_keymap('n', '<leader>lr', '<cmd>lua vim.lsp.buf.rename()<CR>', {noremap = true})
  buf_set_keymap('n', '<leader>ln', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', {noremap = true})
  buf_set_keymap('n', '<leader>lp', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', {noremap = true})
  -- ... and other keymappings for LSP

  -- Use LSP as the handler for omnifunc.
  --    See `:help omnifunc` and `:help ins-completion` for more information.
  vim.bo[bufnr].omnifunc = 'v:lua.vim.lsp.omnifunc'

  -- Set some keybinds conditional on server capabilities
  if client.resolved_capabilities.document_formatting then
    buf_set_keymap("n", "<leader>lf", "<cmd>lua vim.lsp.buf.formatting()<CR>", {noremap = true})
  end
  if client.resolved_capabilities.document_range_formatting then
    buf_set_keymap("v", "<leader>lf", "<cmd>lua vim.lsp.buf.range_formatting()<CR>", {noremap = true})
  end

  if vim.bo[bufnr].filetype ~= 'lua' and client.resolved_capabilities.document_formatting then
    vim.api.nvim_exec([[
      augroup lsp_auto_format
        autocmd! * <buffer>
        autocmd BufWritePre <buffer> * lua vim.lsp.buf.formatting_sync(nil, 1000)
      augroup END
    ]], false)
  end

  -- Set autocommands conditional on server_capabilities
  if client.resolved_capabilities.document_highlight then
    vim.api.nvim_exec([[
      highlight LspReferenceRead cterm=bold ctermbg=red guibg=LightYellow
      highlight LspReferenceText cterm=bold ctermbg=red guibg=LightYellow
      highlight LspReferenceWrite cterm=bold ctermbg=red guibg=LightYellow
      augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END
    ]], false)
  end
  vim.api.nvim_buf_set_var(bufnr, 'lsp_autoformat', true)
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
    local old = table[key]
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
        diagnostics = {
          globals = {'vim', 'use'},
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
        -- Do not send telemetry data containing a randomized but unique identifier
        telemetry = {
          enable = false,
        },
      },
    },
  }
}

local function setup_servers()
  require'lspinstall'.setup()
  local servers = require'lspinstall'.installed_servers()
  for _, server in ipairs(servers) do
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
