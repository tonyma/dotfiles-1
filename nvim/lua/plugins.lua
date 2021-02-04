vim.cmd[[packadd packer.nvim]]

require('packer').startup(function()
  use { 'wbthomason/packer.nvim', opt = true }

  use { 'kyoh86/momiji' }

  use {
    'lewis6991/gitsigns.nvim',
    requires = {
      'nvim-lua/plenary.nvim'
    },
    config = function()
      require('gitsigns').setup()
    end
  }

  use {
    'nvim-telescope/telescope.nvim',
    requires = {{'nvim-lua/popup.nvim'}, {'nvim-lua/plenary.nvim'}},
    config = function() require('my-telescope') end,
  }

  use {
    '~/Projects/github.com/kyoh86/telescope-gogh.nvim',
    requires = {
      'telescope.nvim'
    },
    config = function()
      vim.api.nvim_set_keymap('n', '<Leader>fp', '<CMD>lua require("telescope").extensions.gogh.list()<CR>',  { noremap = true, silent = true })

      require('telescope').setup{
        extensions = {
          gogh = {
            shorten_path = false,
            keys = {
              cd   = 'default',
              open = '<c-e>',
              lcd  = nil,
              tcd  = nil,
            }
          }
        }
      }
      require('telescope').load_extension('gogh')
    end
  }

  use {
    'glepnir/galaxyline.nvim',
    branch = 'main',
    config = function() require'my-galaxyline' end,
    requires = {
      {'kyazdani42/nvim-web-devicons', opt = true},
      {'kyoh86/momiji'}
    }
  }

  use {
    'neovim/nvim-lspconfig',
    requires = {{
      'nvim-lua/completion-nvim',
      setup = function()
        vim.api.nvim_set_var('completion_enable_auto_popup', 0)
      end,
      config = function()
        vim.api.nvim_set_var('completion_enable_snippet', 'vim-vsnip')
        --  map <C-p> to manually trigger completion
        vim.api.nvim_set_keymap('i', '<C-p>', '<Plug>(completion_trigger)', {silent = true})
        vim.api.nvim_set_option('completeopt', 'menuone,noinsert,noselect')
        vim.api.nvim_set_option('shortmess', vim.api.nvim_get_option('shortmess') .. 'c')
      end,
    }, {
      'hrsh7th/vim-vsnip',
      config = function()
        -- Expand
        vim.cmd[[imap <expr> <C-j>   vsnip#expandable()  ? '<Plug>(vsnip-expand)'         : '<C-j>']]
        vim.cmd[[smap <expr> <C-j>   vsnip#expandable()  ? '<Plug>(vsnip-expand)'         : '<C-j>']]

        -- Jump forward or backward
        vim.cmd[[imap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<Tab>']]
        vim.cmd[[smap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<Tab>']]
        vim.cmd[[imap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>']]
        vim.cmd[[smap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>']]
      end,
      requires = {'golang/vscode-go'},
    }, {
      'hrsh7th/vim-vsnip-integ'
    }},
    config = function() require 'my-lsp' end,
  }

  use { 'jremmen/vim-ripgrep', cmd = 'Rg' }

  use {
    'kana/vim-textobj-line',
    requires = {'kana/vim-textobj-user', opt = true}
  }

  use {
    'kana/vim-textobj-entire',
    requires = {'kana/vim-textobj-user', opt = true}
  }

  use {
    'sgur/vim-textobj-parameter',
    requires = {'kana/vim-textobj-user', opt = true}
  }

  use {
    'kana/vim-operator-replace',
    requires = {'kana/vim-operator-user', opt = true}
  }

  use {
    disable = true,
    'osyo-manga/vim-operator-jump_side',
    requires = {'kana/vim-operator-user', opt = true},
    config = function()
      -- textobj の先頭へ移動する
      vim.api.nvim_set_keymap('n', '<Leader>h', '<Plug>(operator-jump-head)', {})
      -- textobj の末尾へ移動する
      vim.api.nvim_set_keymap('n', '<Leader>t', '<Plug>(operator-jump-tail)', {})
    end,
  }

  use {
    'machakann/vim-sandwich',
    config = function()
      -- ignore s instead of the cl
      vim.api.nvim_set_keymap('n', 's', '<Nop>', { noremap = true })
      vim.api.nvim_set_keymap('x', 's', '<Nop>', { noremap = true })

      --NOTE: silent! は vim.cmd じゃないと呼べないっぽい
      vim.cmd[[silent! nmap <unique><silent> sc <Plug>(operator-sandwich-replace)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-query-a)]]
      vim.cmd[[silent! nmap <unique><silent> scb <Plug>(operator-sandwich-replace)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-auto-a)]]
    end,
  }

  use {
    'thinca/vim-quickrun',
    config = function()
      vim.api.nvim_set_var('quickrun_config', { _ = { runner = 'terminal' } })
    end,
  }

  use {
    'machakann/vim-swap',
    config = function()
      vim.api.nvim_set_keymap('o', 'i,', '<Plug>(swap-textobject-i)', {})
      vim.api.nvim_set_keymap('x', 'i,', '<Plug>(swap-textobject-i)', {})
      vim.api.nvim_set_keymap('o', 'a,', '<Plug>(swap-textobject-a)', {})
      vim.api.nvim_set_keymap('x', 'a,', '<Plug>(swap-textobject-a)', {})
    end,
  }

  use { 'lambdalisue/readablefold.vim' }

  use {
    'vim-test/vim-test',
    config = function()
      vim.api.nvim_set_var('test#strategy', 'vimterminal')
      vim.api.nvim_set_var('test#vimterminal#term_position', 'aboveleft')
    end,
  }
  
  use {
    'qpkorr/vim-bufkill',
    setup = function()
      vim.api.nvim_set_var('BufKillCreateMappings', 0)
    end,
  }

  use {
    'osyo-manga/vim-brightest',
    config = function()
      vim.api.nvim_set_var('brightest#highlight', { group = "BrightestUnderline" })
    end,
  }

  use {
    'kevinhwang91/nvim-hlslens',
    config = function()

      vim.api.nvim_set_keymap('n', 'n', [[<Cmd>execute('normal! ' . v:count1 . 'n')<CR> <Cmd>lua require('hlslens').start()<CR>]], { silent = true, noremap = true })
      -- vim.api.nvim_set_keymap('n', 'N', [[<Cmd>execute('normal! ' . v:count1 . 'N')<CR> <Cmd>lua require('hlslens').start()<CR>]], { silent = true, noremap = true })
      vim.api.nvim_set_keymap('n', '*', [[*<Cmd>lua require('hlslens').start()<CR>]], { noremap = true })
      vim.api.nvim_set_keymap('n', '#', [[#<Cmd>lua require('hlslens').start()<CR>]], { noremap = true })
      vim.api.nvim_set_keymap('n', 'g*', [[g*<Cmd>lua require('hlslens').start()<CR>]], { noremap = true })
      vim.api.nvim_set_keymap('n', 'g#', [[g#<Cmd>lua require('hlslens').start()<CR>]], { noremap = true })
    end,
  }

  use {
    'simeji/winresizer',
    setup = function()
      vim.api.nvim_set_var('winresizer_start_key', '<C-w><C-e>')
    end,
  }

  use { 'lambdalisue/edita.vim' }

  use {
    'lambdalisue/fern.vim',
    -- config is in init.vim
    requires = {
      { 'lambdalisue/fern-git-status.vim' }        ,
      { 'lambdalisue/fern-hijack.vim' }            ,
      { 'lambdalisue/fern-renderer-nerdfont.vim' } ,
    }
  }

end)
