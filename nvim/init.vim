" Setup encodings
set encoding=utf-8
scriptencoding utf-8

let s:config_home = stdpath("config") " ${xdg-CONFIG-home}/nvim
let s:data_home = stdpath("data")   " ${xdg-DATA-home}/nvim
let s:cache_home = stdpath("cache")   " ${xdg-CACHE-home}/nvim

" XDG Directories
" Setup XDG Home directory paths. {{{
let $XDG_CONFIG_HOME = substitute(s:config_home, '/nvim$', '', '')
let g:xdg_config_home = $XDG_CONFIG_HOME

let $XDG_DATA_HOME = substitute(s:data_home, '/nvim$', '', '')
let g:xdg_data_home = $XDG_DATA_HOME

let $XDG_CACHE_HOME = substitute(s:cache_home, '/nvim$', '', '')
let g:xdg_cache_home = $XDG_CACHE_HOME

" }}}


" Setup Environment Variables {{{
" ZSHとVIM両方に効かせる環境変数はここで設定する
" ZSHだけでいい場合は.zshenvで設定すればよい

" 基本環境設定:
let $LANG='ja_JP.UTF-8'
let $ARCHFLAGS='-arch x86_64'
let $EDITOR='nvim'
let $COLORTERM='xterm-256color'
let $TERM='xterm-256color'

" Path環境変数の設定:

let $PATH=
      \ $HOME . '/.local/bin:'  .
      \ $HOME . '/.local/sbin:' .
      \ '/usr/local/bin:'       .
      \ '/usr/local/sbin:'      .
      \ $PATH .
      \ ':/bin' .
      \ ':/usr/bin' .
      \ ':/sbin' .
      \ ':/usr/sbin'

" dotfiles自体
let $DOTFILES=$HOME . '/.config'
let $DOTS=$DOTFILES

" Zsh:
let $ZDOTDIR=$HOME . '/.config/zsh'

" Go:
let $GO111MODULE='on'
let $GOPATH=$HOME . '/go'
let $PATH=$GOENV_ROOT . '/bin:' . $PATH
let $PATH=$GOENV_ROOT . '/shims:' . $PATH
let $PATH=$PATH . ':/usr/local/go/bin:' . $HOME . '/go/bin'

" Go AWS Library
let $AWS_SDK_LOAD_CONFIG=1

" Generator-go-project:
let $GO_PROJECT_ROOT=$HOME . '/Projects'

" Python: (support sqlite3 and mysql library (used by mypy, etc...))
let $LDFLAGS="-L/usr/local/opt/zlib/lib -L/usr/local/opt/sqlite/lib"
let $CPPFLAGS="-I/usr/local/opt/zlib/include -I/usr/local/opt/sqlite/include"
let $LIBRARY_PATH=$LIBRARY_PATH . ':/usr/local/opt/openssl/lib/'

" Ruby:
let $PATH=$HOME . '/.rbenv/bin:' . $HOME . '/.rbenv/shims:' . $PATH

" Python:
if has("mac")
  let $PYTHON_CONFIGURE_OPTS='--enable-framework'
  let $PIP_REQUIRE_VIRTUALENV='true'
endif
let $PYENV_DEFAULT_PACKAGES=$XDG_CONFIG_HOME . '/pyenv/default-packages'
let $PYENV_ROOT=$HOME . '/.pyenv'
let $PATH=$PYENV_ROOT . '/bin:' . $PYENV_ROOT . '/shims:' . $PATH

" Node:
let $PATH=$HOME . '/.nodenv/shims:' . $HOME . '/.nodenv/bin:' . './node_modules/.bin:' . $PATH

" GNU commands:
let $PATH='/usr/local/opt/gzip/bin:' . $PATH
let $PATH='/usr/local/opt/openssl/bin:' . $PATH

" Yarn:
let $PATH=$PATH . ':' . $HOME . '/.yarn/bin'

" Perl:
let $PATH=$PATH . ':' . $HOME . '/perl5/bin'

" Git:
let $PATH=$PATH . ':' . '/usr/local/share/git-core/contrib/diff-highlight'

" Rg:
let $RIPGREP_CONFIG_PATH=$DOTFILES . '/ripgrep/config'

" Gigamoji:
let $GIGAMOJI_BG=':space:'

" GnuPG:
let $GNUPGHOME=$XDG_CONFIG_HOME . '/gnupg'

" Docker:
"
if has('osx')
  let $DOCKER_CONFIG=$XDG_CONFIG_HOME . '/docker-osx'
  let $MACHINE_STORAGE_PATH=$XDG_DATA_HOME . '/docker-machine-osx'
elseif has('linux')
  let $DOCKER_CONFIG=$XDG_CONFIG_HOME . '/docker-linux'
  let $MACHINE_STORAGE_PATH=$XDG_DATA_HOME . '/docker-machine-linux'
endif

function! s:uniquify_paths()
  let l:list = split($PATH, ':')
  let l:dict = {}
  let l:uniq = []
  for l:path in l:list
    if has_key(l:dict, l:path)
      continue
    endif
    let l:dict[l:path] = v:true
    let l:uniq = add(l:uniq, l:path)
  endfor
  let $PATH=join(l:uniq, ':')
endfunction
call s:uniquify_paths()
" }}}

packadd popup.nvim
packadd plenary.nvim

packadd! telescope.nvim " {{{
nnoremap <leader>ff <cmd>lua require('telescope.builtin').find_files()<cr>
nnoremap <leader>fg <cmd>lua require('telescope.builtin').live_grep()<cr>
nnoremap <leader>fb <cmd>lua require('telescope.builtin').buffers()<cr>
nnoremap <leader>fh <cmd>lua require('telescope.builtin').help_tags()<cr>
lua <<EOF
-- Built-in actions
local transform_mod = require('telescope.actions.mt').transform_mod

local actions = require('telescope.actions')
-- Global remapping
------------------------------
require('telescope').setup{
  defaults = {
    set_env = { ['COLORTERM'] = 'truecolor' },
    mappings = {
      i = {
        ["<c-x>"] = false,
        ["<C-i>"] = actions.goto_file_selection_split,
        ["<CR>"] = actions.goto_file_selection_edit + actions.center,
      },
      n = {
        ["<esc>"] = actions.close,
      },
    },
  }
}
EOF
" }}}

packadd momiji " {{{
syntax enable
set termguicolors
colorscheme momiji
" }}}

packadd galaxyline.nvim " {{{
packadd nvim-web-devicons
lua <<EOF
local colors = require('galaxyline.colors')
require('galaxyline').section.left[1]= {
  FileSize = {
    provider = 'FileSize',
    condition = function()
      if vim.fn.empty(vim.fn.expand('%:t')) ~= 1 then
        return true
      end
      return false
      end,
    icon = '   ',
    highlight = {'MomijiGreen',colors.purple},
    separator = '',
    separator_highlight = {colors.purple,colors.darkblue},
  }
}
EOF
" }}}
