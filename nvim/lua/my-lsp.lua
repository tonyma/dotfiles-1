-- =========== snippet
local nvim_lsp = require("lspconfig")
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
  properties = {
    "documentation",
    "detail",
    "additionalTextEdits"
  }
}

-- =========== attach

local custom_lsp_attach = function(client, bufnr) -- function(client, bufnr)
  local function buf_set_keymap(...)
    vim.api.nvim_buf_set_keymap(bufnr, ...)
  end

  local opts = {noremap = true, silent = true}
  -- show / edit actions
  buf_set_keymap("n", "<leader>lh", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
  buf_set_keymap("n", "<leader>lD", "<cmd>vim.lsp.buf.declaration()<CR>", opts)
  buf_set_keymap("n", "<leader>ld", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
  buf_set_keymap("n", "<leader>li", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
  buf_set_keymap("n", "<leader>lr", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
  buf_set_keymap("n", "]l", "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>", opts)
  buf_set_keymap("n", "[l", "<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>", opts)
  buf_set_keymap("n", "<leader>ls", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
  buf_set_keymap("n", "<leader>la", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
  buf_set_keymap("v", "<leader>la", "<cmd>lua vim.lsp.buf.range_code_action()<CR>", opts)

  -- listup actions
  buf_set_keymap("n", "<leader>llr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
  buf_set_keymap("n", "<leader>lls", "<cmd>lua vim.lsp.buf.document_symbol()<CR>", opts)
  buf_set_keymap("n", "<leader>llS", "<cmd>lua vim.lsp.buf.workspace_symbol()<CR>", opts)
  buf_set_keymap("n", "<leader>llc", "<cmd>lua vim.lsp.buf.incoming_calls()<CR>", opts)
  buf_set_keymap("n", "<leader>llC", "<cmd>lua vim.lsp.buf.outgoing_calls()<CR>", opts)
  buf_set_keymap("n", "<leader>lld", "<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>", opts)

  -- Set some keybinds conditional on server capabilities
  client.resolved_capabilities.document_formatting = false
  -- if client.resolved_capabilities.document_formatting then
  --   print("enable formatter")
  --   buf_set_keymap("n", "<leader>lf", "<cmd>lua vim.lsp.buf.formatting()<CR>", {noremap = true})
  --   vim.api.nvim_exec(
  --     [[
  --       augroup lsp_auto_format
  --       autocmd! * <buffer>

  --       autocmd BufWritePre *.go,*.rs,*.py lua vim.lsp.buf.formatting_sync(nil, 1000)
  --       augroup END
  --     ]],
  --     false
  --   )
  -- end
  if client.resolved_capabilities.document_range_formatting then
    buf_set_keymap("v", "<leader>lf", "<cmd>lua vim.lsp.buf.range_formatting()<CR>", {noremap = true})
  end

  -- Set autocommands conditional on server_capabilities
  if client.resolved_capabilities.document_highlight then
    vim.api.nvim_exec(
      [[
      highlight LspReferenceRead cterm=underline,bold gui=underline,bold
      highlight LspReferenceText cterm=underline gui=underline
      highlight LspReferenceWrite cterm=reverse gui=reverse
      augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END
    ]],
      false
    )
  end
  vim.api.nvim_buf_set_var(bufnr, "lsp_autoformat", true)
  vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"
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
    if type(old) == "table" and type(value) == "table" then
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
        importModuleSpecifier = "relative"
      }
    }
  },
  efm = {
    init_options = {documentFormatting = true},
    settings = {
      rootMarkers = {".git/"},
      languages = {}
    }
  },
  go = {
    init_options = {
      usePlaceholders = true,
      semanticTokens = true,
      staticcheck = true,
      experimentalPostfixCompletions = true,
      --hoverKind = 'Structured',
      analyses = {
        nilness = true,
        shadow = true,
        unusedparams = true,
        unusedwrite = true,
        fieldalignment = true
      },
      codelenses = {
        gc_details = true,
        tidy = true
      }
    }
  },
  lua = {
    settings = {
      Lua = {
        diagnostics = {
          globals = {"vim", "use"},
          disable = {"lowercase-global"}
        },
        runtime = {
          version = "LuaJIT",
          path = vim.split(package.path, ";")
        },
        workspace = {
          library = {
            [vim.fn.expand("$VIMRUNTIME/lua")] = true,
            [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true
          }
        },
        -- Do not send telemetry data containing a randomized but unique identifier
        telemetry = {
          enable = false
        }
      }
    }
  }
}

local lspinstall = require("lspinstall")

local function setup_servers()
  lspinstall.setup()
  local servers = lspinstall.installed_servers()
  for _, server in pairs(servers) do
    local config =
      merge_config(
      {
        on_attach = custom_lsp_attach,
        capabilities = capabilities
      },
      additional_config[server]
    )
    nvim_lsp[server].setup(config)
  end
end

setup_servers()

-- Automatically reload after `:LspInstall <server>` so we don't have to restart neovim
lspinstall.post_install_hook = function()
  setup_servers() -- reload installed servers
  vim.cmd("bufdo e") -- this triggers the FileType autocmd that starts the server
end

vim.cmd [[ command! -nargs=0 LspUpdateAll lua require('my-lsp-update').update() ]]
