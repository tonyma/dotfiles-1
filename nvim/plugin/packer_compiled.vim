" Automatically generated packer.nvim plugin loader code

if !has('nvim-0.5')
  echohl WarningMsg
  echom "Invalid Neovim version for packer.nvim!"
  echohl None
  finish
endif

packadd packer.nvim

try

lua << END
local package_path_str = "/home/kyoh86/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?.lua;/home/kyoh86/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?/init.lua;/home/kyoh86/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?.lua;/home/kyoh86/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?/init.lua"
local install_cpath_pattern = "/home/kyoh86/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/lua/5.1/?.so"
if not string.find(package.path, package_path_str, 1, true) then
  package.path = package.path .. ';' .. package_path_str
end

if not string.find(package.cpath, install_cpath_pattern, 1, true) then
  package.cpath = package.cpath .. ';' .. install_cpath_pattern
end

local function try_loadstring(s, component, name)
  local success, err = pcall(loadstring(s))
  if not success then
    print('Error running ' .. component .. ' for ' .. name)
    error(err)
  end
end

_G.packer_plugins = {
  ["completion-nvim"] = {
    config = { "\27LJ\2\nÔ\2\0\0\6\0\16\0!6\0\0\0009\0\1\0009\0\2\0'\2\3\0'\3\4\0B\0\3\0016\0\0\0009\0\1\0009\0\5\0'\2\6\0'\3\a\0'\4\b\0005\5\t\0B\0\5\0016\0\0\0009\0\1\0009\0\n\0'\2\v\0'\3\f\0B\0\3\0016\0\0\0009\0\1\0009\0\n\0'\2\r\0006\3\0\0009\3\1\0039\3\14\3'\5\r\0B\3\2\2'\4\15\0&\3\4\3B\0\3\1K\0\1\0\6c\20nvim_get_option\14shortmess\30menuone,noinsert,noselect\16completeopt\20nvim_set_option\1\0\1\vsilent\2\31<Plug>(completion_trigger)\n<C-p>\6i\20nvim_set_keymap\14vim-vsnip\30completion_enable_snippet\17nvim_set_var\bapi\bvim\0" },
    loaded = false,
    path = "/home/kyoh86/.local/share/nvim/site/pack/packer/opt/completion-nvim"
  },
  ["edita.vim"] = {
    loaded = true,
    path = "/home/kyoh86/.local/share/nvim/site/pack/packer/start/edita.vim"
  },
  ["galaxyline.nvim"] = {
    config = { "\27LJ\2\n-\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\18my-galaxyline\frequire\0" },
    loaded = true,
    path = "/home/kyoh86/.local/share/nvim/site/pack/packer/start/galaxyline.nvim"
  },
  ["gitsigns.nvim"] = {
    config = { "\27LJ\2\n6\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\rgitsigns\frequire\0" },
    loaded = true,
    path = "/home/kyoh86/.local/share/nvim/site/pack/packer/start/gitsigns.nvim"
  },
  momiji = {
    loaded = true,
    path = "/home/kyoh86/.local/share/nvim/site/pack/packer/start/momiji"
  },
  ["nvim-lspconfig"] = {
    config = { "\27LJ\2\n&\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\vmy-lsp\frequire\0" },
    loaded = true,
    path = "/home/kyoh86/.local/share/nvim/site/pack/packer/start/nvim-lspconfig"
  },
  ["nvim-web-devicons"] = {
    loaded = false,
    path = "/home/kyoh86/.local/share/nvim/site/pack/packer/opt/nvim-web-devicons"
  },
  ["packer.nvim"] = {
    loaded = false,
    path = "/home/kyoh86/.local/share/nvim/site/pack/packer/opt/packer.nvim"
  },
  ["plenary.nvim"] = {
    loaded = true,
    path = "/home/kyoh86/.local/share/nvim/site/pack/packer/start/plenary.nvim"
  },
  ["popup.nvim"] = {
    loaded = true,
    path = "/home/kyoh86/.local/share/nvim/site/pack/packer/start/popup.nvim"
  },
  ["readablefold.vim"] = {
    loaded = true,
    path = "/home/kyoh86/.local/share/nvim/site/pack/packer/start/readablefold.vim"
  },
  ["telescope-gogh.nvim"] = {
    config = { "\27LJ\2\n«\2\0\0\6\0\16\0\0256\0\0\0009\0\1\0009\0\2\0'\2\3\0'\3\4\0'\4\5\0005\5\6\0B\0\5\0016\0\a\0'\2\b\0B\0\2\0029\0\t\0005\2\r\0005\3\v\0005\4\n\0=\4\f\3=\3\14\2B\0\2\0016\0\a\0'\2\b\0B\0\2\0029\0\15\0'\2\f\0B\0\2\1K\0\1\0\19load_extension\15extensions\1\0\0\tgogh\1\0\0\1\0\1\17shorten_path\1\nsetup\14telescope\frequire\1\0\2\fnoremap\2\vsilent\2=<CMD>lua require(\"telescope\").extensions.gogh.list()<CR>\15<Leader>fp\6n\20nvim_set_keymap\bapi\bvim\0" },
    loaded = true,
    path = "/home/kyoh86/.local/share/nvim/site/pack/packer/start/telescope-gogh.nvim"
  },
  ["telescope.nvim"] = {
    config = { "\27LJ\2\n,\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\17my-telescope\frequire\0" },
    loaded = true,
    path = "/home/kyoh86/.local/share/nvim/site/pack/packer/start/telescope.nvim"
  },
  ["vim-brightest"] = {
    config = { "\27LJ\2\nh\0\0\4\0\5\0\a6\0\0\0009\0\1\0009\0\2\0'\2\3\0005\3\4\0B\0\3\1K\0\1\0\1\0\1\ngroup\23BrightestUnderline\24brightest#highlight\17nvim_set_var\bapi\bvim\0" },
    loaded = true,
    path = "/home/kyoh86/.local/share/nvim/site/pack/packer/start/vim-brightest"
  },
  ["vim-bufkill"] = {
    loaded = false,
    path = "/home/kyoh86/.local/share/nvim/site/pack/packer/opt/vim-bufkill"
  },
  ["vim-devicons"] = {
    loaded = true,
    path = "/home/kyoh86/.local/share/nvim/site/pack/packer/start/vim-devicons"
  },
  ["vim-operator-replace"] = {
    loaded = true,
    path = "/home/kyoh86/.local/share/nvim/site/pack/packer/start/vim-operator-replace"
  },
  ["vim-operator-user"] = {
    loaded = true,
    path = "/home/kyoh86/.local/share/nvim/site/pack/packer/start/vim-operator-user"
  },
  ["vim-quickrun"] = {
    config = { "\27LJ\2\nh\0\0\5\0\a\0\t6\0\0\0009\0\1\0009\0\2\0'\2\3\0005\3\5\0005\4\4\0=\4\6\3B\0\3\1K\0\1\0\6_\1\0\0\1\0\1\vrunner\rterminal\20quickrun_config\17nvim_set_var\bapi\bvim\0" },
    loaded = true,
    path = "/home/kyoh86/.local/share/nvim/site/pack/packer/start/vim-quickrun"
  },
  ["vim-ripgrep"] = {
    commands = { "Rg" },
    loaded = false,
    path = "/home/kyoh86/.local/share/nvim/site/pack/packer/opt/vim-ripgrep"
  },
  ["vim-sandwich"] = {
    config = { "\27LJ\2\nð\3\0\0\6\0\14\0!6\0\0\0009\0\1\0009\0\2\0'\2\3\0'\3\4\0'\4\5\0005\5\6\0B\0\5\0016\0\0\0009\0\1\0009\0\2\0'\2\a\0'\3\4\0'\4\5\0005\5\b\0B\0\5\0016\0\0\0009\0\1\0009\0\2\0'\2\3\0'\3\t\0'\4\5\0005\5\n\0B\0\5\0016\0\0\0009\0\v\0'\2\f\0B\0\2\0016\0\0\0009\0\v\0'\2\r\0B\0\2\1K\0\1\0Ž\1silent! nmap <unique><silent> scb <Plug>(operator-sandwich-replace)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-auto-a)Ž\1silent! nmap <unique><silent> sc <Plug>(operator-sandwich-replace)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-query-a)\bcmd\1\0\1\fnoremap\2\asc\1\0\1\fnoremap\2\6x\1\0\1\fnoremap\2\n<Nop>\6s\6n\20nvim_set_keymap\bapi\bvim\0" },
    loaded = true,
    path = "/home/kyoh86/.local/share/nvim/site/pack/packer/start/vim-sandwich"
  },
  ["vim-swap"] = {
    config = { "\27LJ\2\ná\1\0\0\6\0\t\0!6\0\0\0009\0\1\0009\0\2\0'\2\3\0'\3\4\0'\4\5\0004\5\0\0B\0\5\0016\0\0\0009\0\1\0009\0\2\0'\2\6\0'\3\4\0'\4\5\0004\5\0\0B\0\5\0016\0\0\0009\0\1\0009\0\2\0'\2\3\0'\3\a\0'\4\b\0004\5\0\0B\0\5\0016\0\0\0009\0\1\0009\0\2\0'\2\6\0'\3\a\0'\4\b\0004\5\0\0B\0\5\1K\0\1\0\30<Plug>(swap-textobject-a)\aa,\6x\30<Plug>(swap-textobject-i)\ai,\6o\20nvim_set_keymap\bapi\bvim\0" },
    loaded = true,
    path = "/home/kyoh86/.local/share/nvim/site/pack/packer/start/vim-swap"
  },
  ["vim-test"] = {
    config = { "\27LJ\2\n“\1\0\0\4\0\a\0\r6\0\0\0009\0\1\0009\0\2\0'\2\3\0'\3\4\0B\0\3\0016\0\0\0009\0\1\0009\0\2\0'\2\5\0'\3\6\0B\0\3\1K\0\1\0\14aboveleft#test#vimterminal#term_position\16vimterminal\18test#strategy\17nvim_set_var\bapi\bvim\0" },
    loaded = true,
    path = "/home/kyoh86/.local/share/nvim/site/pack/packer/start/vim-test"
  },
  ["vim-textobj-entire"] = {
    loaded = true,
    path = "/home/kyoh86/.local/share/nvim/site/pack/packer/start/vim-textobj-entire"
  },
  ["vim-textobj-line"] = {
    loaded = true,
    path = "/home/kyoh86/.local/share/nvim/site/pack/packer/start/vim-textobj-line"
  },
  ["vim-textobj-parameter"] = {
    loaded = true,
    path = "/home/kyoh86/.local/share/nvim/site/pack/packer/start/vim-textobj-parameter"
  },
  ["vim-textobj-user"] = {
    loaded = true,
    path = "/home/kyoh86/.local/share/nvim/site/pack/packer/start/vim-textobj-user"
  },
  ["vim-vsnip"] = {
    config = { "\27LJ\2\né\4\0\0\3\0\b\0\0256\0\0\0009\0\1\0'\2\2\0B\0\2\0016\0\0\0009\0\1\0'\2\3\0B\0\2\0016\0\0\0009\0\1\0'\2\4\0B\0\2\0016\0\0\0009\0\1\0'\2\5\0B\0\2\0016\0\0\0009\0\1\0'\2\6\0B\0\2\0016\0\0\0009\0\1\0'\2\a\0B\0\2\1K\0\1\0Ysmap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'Yimap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'Wsmap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<Tab>'Wimap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<Tab>'Wsmap <expr> <C-j>   vsnip#expandable()  ? '<Plug>(vsnip-expand)'         : '<C-j>'Wimap <expr> <C-j>   vsnip#expandable()  ? '<Plug>(vsnip-expand)'         : '<C-j>'\bcmd\bvim\0" },
    loaded = true,
    path = "/home/kyoh86/.local/share/nvim/site/pack/packer/start/vim-vsnip"
  },
  ["vim-vsnip-integ"] = {
    loaded = true,
    path = "/home/kyoh86/.local/share/nvim/site/pack/packer/start/vim-vsnip-integ"
  },
  winresizer = {
    loaded = false,
    path = "/home/kyoh86/.local/share/nvim/site/pack/packer/opt/winresizer"
  }
}

-- Setup for: winresizer
try_loadstring("\27LJ\2\nX\0\0\4\0\5\0\a6\0\0\0009\0\1\0009\0\2\0'\2\3\0'\3\4\0B\0\3\1K\0\1\0\15<C-w><C-e>\25winresizer_start_key\17nvim_set_var\bapi\bvim\0", "setup", "winresizer")
vim.cmd [[packadd winresizer]]
-- Setup for: vim-bufkill
try_loadstring("\27LJ\2\nN\0\0\4\0\4\0\a6\0\0\0009\0\1\0009\0\2\0'\2\3\0)\3\0\0B\0\3\1K\0\1\0\26BufKillCreateMappings\17nvim_set_var\bapi\bvim\0", "setup", "vim-bufkill")
vim.cmd [[packadd vim-bufkill]]
-- Setup for: completion-nvim
try_loadstring("\27LJ\2\nU\0\0\4\0\4\0\a6\0\0\0009\0\1\0009\0\2\0'\2\3\0)\3\0\0B\0\3\1K\0\1\0!completion_enable_auto_popup\17nvim_set_var\bapi\bvim\0", "setup", "completion-nvim")
vim.cmd [[packadd completion-nvim]]
-- Config for: telescope.nvim
try_loadstring("\27LJ\2\n,\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\17my-telescope\frequire\0", "config", "telescope.nvim")
-- Config for: nvim-lspconfig
try_loadstring("\27LJ\2\n&\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\vmy-lsp\frequire\0", "config", "nvim-lspconfig")
-- Config for: completion-nvim
try_loadstring("\27LJ\2\nÔ\2\0\0\6\0\16\0!6\0\0\0009\0\1\0009\0\2\0'\2\3\0'\3\4\0B\0\3\0016\0\0\0009\0\1\0009\0\5\0'\2\6\0'\3\a\0'\4\b\0005\5\t\0B\0\5\0016\0\0\0009\0\1\0009\0\n\0'\2\v\0'\3\f\0B\0\3\0016\0\0\0009\0\1\0009\0\n\0'\2\r\0006\3\0\0009\3\1\0039\3\14\3'\5\r\0B\3\2\2'\4\15\0&\3\4\3B\0\3\1K\0\1\0\6c\20nvim_get_option\14shortmess\30menuone,noinsert,noselect\16completeopt\20nvim_set_option\1\0\1\vsilent\2\31<Plug>(completion_trigger)\n<C-p>\6i\20nvim_set_keymap\14vim-vsnip\30completion_enable_snippet\17nvim_set_var\bapi\bvim\0", "config", "completion-nvim")
-- Config for: vim-quickrun
try_loadstring("\27LJ\2\nh\0\0\5\0\a\0\t6\0\0\0009\0\1\0009\0\2\0'\2\3\0005\3\5\0005\4\4\0=\4\6\3B\0\3\1K\0\1\0\6_\1\0\0\1\0\1\vrunner\rterminal\20quickrun_config\17nvim_set_var\bapi\bvim\0", "config", "vim-quickrun")
-- Config for: vim-swap
try_loadstring("\27LJ\2\ná\1\0\0\6\0\t\0!6\0\0\0009\0\1\0009\0\2\0'\2\3\0'\3\4\0'\4\5\0004\5\0\0B\0\5\0016\0\0\0009\0\1\0009\0\2\0'\2\6\0'\3\4\0'\4\5\0004\5\0\0B\0\5\0016\0\0\0009\0\1\0009\0\2\0'\2\3\0'\3\a\0'\4\b\0004\5\0\0B\0\5\0016\0\0\0009\0\1\0009\0\2\0'\2\6\0'\3\a\0'\4\b\0004\5\0\0B\0\5\1K\0\1\0\30<Plug>(swap-textobject-a)\aa,\6x\30<Plug>(swap-textobject-i)\ai,\6o\20nvim_set_keymap\bapi\bvim\0", "config", "vim-swap")
-- Config for: vim-sandwich
try_loadstring("\27LJ\2\nð\3\0\0\6\0\14\0!6\0\0\0009\0\1\0009\0\2\0'\2\3\0'\3\4\0'\4\5\0005\5\6\0B\0\5\0016\0\0\0009\0\1\0009\0\2\0'\2\a\0'\3\4\0'\4\5\0005\5\b\0B\0\5\0016\0\0\0009\0\1\0009\0\2\0'\2\3\0'\3\t\0'\4\5\0005\5\n\0B\0\5\0016\0\0\0009\0\v\0'\2\f\0B\0\2\0016\0\0\0009\0\v\0'\2\r\0B\0\2\1K\0\1\0Ž\1silent! nmap <unique><silent> scb <Plug>(operator-sandwich-replace)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-auto-a)Ž\1silent! nmap <unique><silent> sc <Plug>(operator-sandwich-replace)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-query-a)\bcmd\1\0\1\fnoremap\2\asc\1\0\1\fnoremap\2\6x\1\0\1\fnoremap\2\n<Nop>\6s\6n\20nvim_set_keymap\bapi\bvim\0", "config", "vim-sandwich")
-- Config for: galaxyline.nvim
try_loadstring("\27LJ\2\n-\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\18my-galaxyline\frequire\0", "config", "galaxyline.nvim")
-- Config for: vim-vsnip
try_loadstring("\27LJ\2\né\4\0\0\3\0\b\0\0256\0\0\0009\0\1\0'\2\2\0B\0\2\0016\0\0\0009\0\1\0'\2\3\0B\0\2\0016\0\0\0009\0\1\0'\2\4\0B\0\2\0016\0\0\0009\0\1\0'\2\5\0B\0\2\0016\0\0\0009\0\1\0'\2\6\0B\0\2\0016\0\0\0009\0\1\0'\2\a\0B\0\2\1K\0\1\0Ysmap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'Yimap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'Wsmap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<Tab>'Wimap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<Tab>'Wsmap <expr> <C-j>   vsnip#expandable()  ? '<Plug>(vsnip-expand)'         : '<C-j>'Wimap <expr> <C-j>   vsnip#expandable()  ? '<Plug>(vsnip-expand)'         : '<C-j>'\bcmd\bvim\0", "config", "vim-vsnip")
-- Config for: gitsigns.nvim
try_loadstring("\27LJ\2\n6\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\rgitsigns\frequire\0", "config", "gitsigns.nvim")
-- Config for: vim-brightest
try_loadstring("\27LJ\2\nh\0\0\4\0\5\0\a6\0\0\0009\0\1\0009\0\2\0'\2\3\0005\3\4\0B\0\3\1K\0\1\0\1\0\1\ngroup\23BrightestUnderline\24brightest#highlight\17nvim_set_var\bapi\bvim\0", "config", "vim-brightest")
-- Config for: vim-test
try_loadstring("\27LJ\2\n“\1\0\0\4\0\a\0\r6\0\0\0009\0\1\0009\0\2\0'\2\3\0'\3\4\0B\0\3\0016\0\0\0009\0\1\0009\0\2\0'\2\5\0'\3\6\0B\0\3\1K\0\1\0\14aboveleft#test#vimterminal#term_position\16vimterminal\18test#strategy\17nvim_set_var\bapi\bvim\0", "config", "vim-test")
-- Config for: telescope-gogh.nvim
try_loadstring("\27LJ\2\n«\2\0\0\6\0\16\0\0256\0\0\0009\0\1\0009\0\2\0'\2\3\0'\3\4\0'\4\5\0005\5\6\0B\0\5\0016\0\a\0'\2\b\0B\0\2\0029\0\t\0005\2\r\0005\3\v\0005\4\n\0=\4\f\3=\3\14\2B\0\2\0016\0\a\0'\2\b\0B\0\2\0029\0\15\0'\2\f\0B\0\2\1K\0\1\0\19load_extension\15extensions\1\0\0\tgogh\1\0\0\1\0\1\17shorten_path\1\nsetup\14telescope\frequire\1\0\2\fnoremap\2\vsilent\2=<CMD>lua require(\"telescope\").extensions.gogh.list()<CR>\15<Leader>fp\6n\20nvim_set_keymap\bapi\bvim\0", "config", "telescope-gogh.nvim")

-- Command lazy-loads
vim.cmd [[command! -nargs=* -range -bang -complete=file Rg lua require("packer.load")({'vim-ripgrep'}, { cmd = "Rg", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]]

END

catch
  echohl ErrorMsg
  echom "Error in packer_compiled: " .. v:exception
  echom "Please check your config for correctness"
  echohl None
endtry
