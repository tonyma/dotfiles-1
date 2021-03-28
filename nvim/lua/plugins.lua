vim.cmd[[packadd packer.nvim]]

require('packer').startup(function()
  use { 'wbthomason/packer.nvim', opt = true }

  -- Visuals                 ==================================================

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
    'glepnir/galaxyline.nvim',
    branch = 'main',
    config = function() require'my-galaxyline' end,
    requires = {
      {'kyazdani42/nvim-web-devicons'},
      {'lewis6991/gitsigns.nvim'},
      {'kyoh86/momiji'}
    },
  }

  use {
    'kyoh86/gitstat.nvim',
    config = function()

      vim.g['gitstat#parts'] = 'branch,ahead,behind,sync,unmerged,staged,unstaged,untracked'
      vim.g['gitstat#blend'] = 10
      vim.cmd('highlight! GitStatWindow    guibg=' .. vim.g.momiji_colors.green  .. ' guifg=' .. vim.g.momiji_colors.black)
      vim.cmd('highlight! GitStatBranch    guibg=' .. vim.g.momiji_colors.green  .. ' guifg=' .. vim.g.momiji_colors.black)
      vim.cmd('highlight! GitStatRemote    guibg=' .. vim.g.momiji_colors.green  .. ' guifg=' .. vim.g.momiji_colors.black)
      vim.cmd('highlight! GitStatAhead     guibg=' .. vim.g.momiji_colors.yellow .. ' guifg=' .. vim.g.momiji_colors.black)
      vim.cmd('highlight! GitStatBehind    guibg=' .. vim.g.momiji_colors.yellow .. ' guifg=' .. vim.g.momiji_colors.black)
      vim.cmd('highlight! GitStatSync      guibg=' .. vim.g.momiji_colors.yellow .. ' guifg=' .. vim.g.momiji_colors.black)
      vim.cmd('highlight! GitStatUnmerged  guibg=' .. vim.g.momiji_colors.yellow .. ' guifg=' .. vim.g.momiji_colors.black)
      vim.cmd('highlight! GitStatStaged    guibg=' .. vim.g.momiji_colors.yellow .. ' guifg=' .. vim.g.momiji_colors.black)
      vim.cmd('highlight! GitStatUnstaged  guibg=' .. vim.g.momiji_colors.yellow .. ' guifg=' .. vim.g.momiji_colors.black)
      vim.cmd('highlight! GitStatUntracked guibg=' .. vim.g.momiji_colors.yellow .. ' guifg=' .. vim.g.momiji_colors.black)
      require 'gitstat'.show()
    end
  }

  use { 'lambdalisue/readablefold.vim' }

  use {
    'osyo-manga/vim-brightest',
    config = function()
      vim.api.nvim_set_var('brightest#highlight', { group = "BrightestUnderline" })
    end,
  }

  use {
    'kyoh86/vim-cinfo',
    config = function()
      vim.api.nvim_set_keymap('n', '<leader>ic', '<plug>(cinfo-show-cursor)', {})
      vim.api.nvim_set_keymap('n', '<leader>ib', '<plug>(cinfo-show-buffer)', {})
      vim.api.nvim_set_keymap('n', '<leader>ih', '<plug>(cinfo-show-highlight)', {})
    end,
  }

  -- Fuzzy finder            ==================================================

  use {
    'nvim-telescope/telescope.nvim',
    requires = {{'nvim-lua/popup.nvim'}, {'nvim-lua/plenary.nvim'}},
    config = function() require('my-telescope') end,
  }

  use {
    'nvim-telescope/telescope-github.nvim',
    requires = {
      'nvim-telescope/telescope.nvim'
    },
    config = function()
      vim.api.nvim_set_keymap('n', '<leader>fgi', '<cmd>lua require("telescope").extensions.gh.issues()<cr>',  { noremap = true, silent = true })
      vim.api.nvim_set_keymap('n', '<leader>fgp', '<cmd>lua require("telescope").extensions.gh.pull_request()<cr>',  { noremap = true, silent = true })
    end
  }

  use {
    'kyoh86/telescope-gogh.nvim',
    requires = {
      'nvim-telescope/telescope.nvim'
    },
    config = function()
      vim.api.nvim_set_keymap('n', '<leader>fp', '<cmd>lua require("telescope").extensions.gogh.list()<cr>',  { noremap = true, silent = true })

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
    "nvim-telescope/telescope-frecency.nvim",
    requires = {
      'tami5/sql.nvim',
    },
    config = function()
      require"telescope".load_extension("frecency")
      vim.api.nvim_set_keymap('n', '<leader>fm', "<cmd>lua require('telescope').extensions.frecency.frecency()<cr>", {noremap = true, silent = true})
    end
  }

  -- LSP                     ==================================================

  use {
    {'kabouzeid/nvim-lspinstall'},
    {
      'neovim/nvim-lspconfig',
      config = function() require 'my-lsp' end,
    }
  }

  -- Snippet                 ==================================================

  use {
    'nvim-lua/completion-nvim',
    setup = function()
      vim.api.nvim_set_var('completion_enable_auto_popup', 0)
    end,
    config = function()
      vim.api.nvim_set_var('completion_enable_snippet', 'vim-vsnip')
      --  map <c-p> to manually trigger completion
      vim.api.nvim_set_keymap('i', '<c-x><c-s>', '<plug>(completion_trigger)', {})
      vim.api.nvim_set_option('completeopt', 'menuone,noinsert')
      vim.api.nvim_set_option('shortmess', vim.api.nvim_get_option('shortmess') .. 'c')
    end,
  }
  use {
    'hrsh7th/vim-vsnip',
    config = function()
      -- Expand
      vim.cmd[[imap <expr> <c-j>   vsnip#expandable()  ? '<plug>(vsnip-expand)'         : '<c-j>']]
      vim.cmd[[smap <expr> <c-j>   vsnip#expandable()  ? '<plug>(vsnip-expand)'         : '<c-j>']]

      -- Jump forward or backward
      vim.cmd[[imap <expr> <tab>   vsnip#jumpable(1)   ? '<plug>(vsnip-jump-next)'      : '<tab>']]
      vim.cmd[[smap <expr> <tab>   vsnip#jumpable(1)   ? '<plug>(vsnip-jump-next)'      : '<tab>']]
      vim.cmd[[imap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<plug>(vsnip-jump-prev)'      : '<S-Tab>']]
      vim.cmd[[smap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<plug>(vsnip-jump-prev)'      : '<S-Tab>']]
    end,
    requires = {
      'golang/vscode-go',
      opt = true,
      ft = {'go'},
    },
  }

  -- Text handlers           ==================================================

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
    'whatyouhide/vim-textobj-xmlattr',
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
      vim.api.nvim_set_keymap('n', '<leader>h', '<plug>(operator-jump-head)', {})
      -- textobj の末尾へ移動する
      vim.api.nvim_set_keymap('n', '<leader>t', '<plug>(operator-jump-tail)', {})
    end,
  }

  use {
    'machakann/vim-sandwich',
    config = function()
      -- ignore s instead of the cl
      vim.api.nvim_set_keymap('n', 's', '<nop>', { noremap = true })
      vim.api.nvim_set_keymap('x', 's', '<nop>', { noremap = true })

      --NOTE: silent! は vim.cmd じゃないと呼べないっぽい
      vim.cmd[[silent! nmap <unique><silent> sc <plug>(operator-sandwich-replace)<plug>(operator-sandwich-release-count)<plug>(textobj-sandwich-query-a)]]
      vim.cmd[[silent! nmap <unique><silent> scb <plug>(operator-sandwich-replace)<plug>(operator-sandwich-release-count)<plug>(textobj-sandwich-auto-a)]]
    end,
  }

  use {
    'machakann/vim-swap',
    config = function()
      vim.api.nvim_set_keymap('o', 'i,', '<plug>(swap-textobject-i)', {})
      vim.api.nvim_set_keymap('x', 'i,', '<plug>(swap-textobject-i)', {})
      vim.api.nvim_set_keymap('o', 'a,', '<plug>(swap-textobject-a)', {})
      vim.api.nvim_set_keymap('x', 'a,', '<plug>(swap-textobject-a)', {})
    end,
  }

  use { 'amadeus/vim-convert-color-to' }

  -- Integrations            ==================================================

  use { 'jremmen/vim-ripgrep', cmd = 'Rg' }
  use {
    'gabrielpoca/replacer.nvim',
    config = function()
      vim.api.nvim_set_keymap('n', '<leader>h', '<cmd>lua require("replacer").run()<cr>', { nowait = true, noremap = true, silent = true })
    end,
  }
  -- use { 'stefandtw/quickfix-reflector.vim' }

  use {
    'thinca/vim-quickrun',
    setup = function()
      vim.g.quickrun_no_default_key_mappings = 1
    end,
    config = function()
      vim.api.nvim_set_keymap('n', '<leader>r', '<plug>QuickRun -mode n<cr>', { silent = true, noremap = true })
      vim.api.nvim_set_keymap('v', '<leader>r', '<plug>QuickRun -mode v<cr>', { silent = true, noremap = true })
    end,
  }

  use {
    'vim-test/vim-test',
    config = function()
      vim.api.nvim_set_var('test#strategy', 'vimterminal')
      vim.api.nvim_set_var('test#vimterminal#term_position', 'aboveleft')
    end,
  }

  use {
    'kyoh86/vim-quotem',
    config = function()
      vim.api.nvim_set_keymap('v', '<leader>yb', '<plug>(quotem-named)', {})
      vim.api.nvim_set_keymap('v', '<leader>Yb', '<plug>(quotem-fullnamed)', {})
      vim.api.nvim_set_keymap('n', '<leader>yb', '<plug>(operator-quotem-named)', {})
      vim.api.nvim_set_keymap('n', '<leader>Yb', '<plug>(operator-quotem-fullnamed)', {})
    end,
  }

  use {
    'kyoh86/vim-copy-buffer-name',
    config = function()
      vim.api.nvim_set_keymap('n', '<leader>y%', '<plug>(copy-buffer-name)', {})
      vim.api.nvim_set_keymap('n', '<leader>Y%', '<plug>(copy-buffer-full-name)', {})
    end,
  }

  use { 'iberianpig/tig-explorer.vim' }

  use { 'kkiyama117/zenn-vim' }

  use {
    'tyru/open-browser-github.vim',
    requires = { 'tyru/open-browser.vim' }
  }

  -- Manipulate vim          ==================================================

  use {
    'qpkorr/vim-bufkill',
    setup = function()
      vim.api.nvim_set_var('BufKillCreateMappings', 0)
    end,
  }

  use {
    'lambdalisue/edita.vim',
    config = function()
      vim.g['edita#opener'] = 'new'
    end,
  }
  use { 'tyru/empty-prompt.vim' }

  use {
    'lambdalisue/fern.vim',
    -- config is in init.vim
    requires = {
      { 'lambdalisue/fern-git-status.vim' }        ,
      { 'lambdalisue/fern-hijack.vim' }            ,
      { 'lambdalisue/fern-renderer-nerdfont.vim' } ,
    },
    setup = function()
      vim.api.nvim_set_var('fern#disable_default_mappings', 1)
    end,
    config = function()
      vim.cmd[[
        runtime! etc/my-fern-mode.vim
        runtime! etc/my-fern.vim
      ]]
    end,
  }

  use { 'tyru/capture.vim' }

  use {
    'Asheq/close-buffers.vim',
    config = function()
      vim.api.nvim_set_keymap('n', '<C-q>', '<cmd>Bdelete menu<cr>', {noremap = true, silent = true})
    end
  }

  use {
    'tkmpypy/chowcho.nvim',
    config = function()
      require('chowcho').setup {
        text_color = '#FFFFFF',
        bg_color = '#555555',
        active_border_color = '#0A8BFF',
        border_style = 'default' -- 'default', 'rounded',
      }
      vim.api.nvim_set_keymap('n', '<leader>wf', '<cmd>lua require("chowcho").run()<cr>', {noremap = true})
    end,
  }

  use {
    'kyoh86/curtain.nvim',
    config = function()
      vim.api.nvim_set_keymap('n', '<leader>wr', '<plug>(curtain-start)', {})
    end,
  }

  use { 'bfredl/nvim-miniyank',
    config = function()
      vim.api.nvim_set_keymap('', 'p', '<plug>(miniyank-autoput)', {})
      vim.api.nvim_set_keymap('', 'P', '<plug>(miniyank-autoPut)', {})
    end,
  }

  -- Languages               ==================================================

  -- - go
  use {
    {'kyoh86/vim-go-filetype'},
    {'kyoh86/vim-go-scaffold'},
    {'kyoh86/vim-go-testfile'},
    {'kyoh86/vim-go-coverage'},
    {'mattn/vim-goimports'},
  }

  -- - markdown
  use {
    'iamcco/markdown-preview.nvim',
    run = 'cd app && yarn install',
    ft = 'markdown',
  }
  use { 'dhruvasagar/vim-table-mode', ft = 'markdown' }

  -- - others
  use { 'z0mbix/vim-shfmt', ft = {'sh', 'bash', 'zsh'} }
  use { 'lambdalisue/vim-backslash', ft = 'vim' }
  use { 'glench/vim-jinja2-syntax' }
  use { 'briancollins/vim-jst' }
  use { 'nikvdp/ejs-syntax' }
  use { 'cespare/vim-toml' }
  use { 'leafgarland/typescript-vim' }
  use {
    'prettier/vim-prettier',
    run = 'yarn install'
  }
  use { 'pangloss/vim-javascript' }

  use { 'vim-jp/autofmt', ft = 'help' }

  -- Plugin Development      ==================================================

  use { 'prabirshrestha/async.vim', cmd = 'AsyncEmbed' }
  use { 'lambdalisue/vital-Whisky' }
  use { 'vim-jp/vital.vim' }
  use {
    'thinca/vim-themis',
    config = function()
      local path = packer_plugins['vim-themis'].path
      vim.env.PATH = vim.env.PATH .. ':' .. path .. '/bin'
    end,
  }

end)
