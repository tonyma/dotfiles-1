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
local momiji_colors = {
  black          = vim.api.nvim_get_var('momiji_color_black'),
  red            = vim.api.nvim_get_var('momiji_color_red'),
  green          = vim.api.nvim_get_var('momiji_color_green'),
  yellow         = vim.api.nvim_get_var('momiji_color_yellow'),
  blue           = vim.api.nvim_get_var('momiji_color_blue'),
  magenta        = vim.api.nvim_get_var('momiji_color_magenta'),
  cyan           = vim.api.nvim_get_var('momiji_color_cyan'),
  white          = vim.api.nvim_get_var('momiji_color_white'),
  bright_black   = vim.api.nvim_get_var('momiji_color_bright_black'),
  bright_red     = vim.api.nvim_get_var('momiji_color_bright_red'),
  bright_green   = vim.api.nvim_get_var('momiji_color_bright_green'),
  bright_yellow  = vim.api.nvim_get_var('momiji_color_bright_yellow'),
  bright_blue    = vim.api.nvim_get_var('momiji_color_bright_blue'),
  bright_magenta = vim.api.nvim_get_var('momiji_color_bright_magenta'),
  bright_cyan    = vim.api.nvim_get_var('momiji_color_bright_cyan'),
  bright_white   = vim.api.nvim_get_var('momiji_color_bright_white'),
  hard_black     = vim.api.nvim_get_var('momiji_color_hard_black'),
  grayscale1     = vim.api.nvim_get_var('momiji_color_grayscale1'),
  grayscale2     = vim.api.nvim_get_var('momiji_color_grayscale2'),
  grayscale3     = vim.api.nvim_get_var('momiji_color_grayscale3'),
  grayscale4     = vim.api.nvim_get_var('momiji_color_grayscale4'),
  grayscale5     = vim.api.nvim_get_var('momiji_color_grayscale5'),
}
local gl = require('galaxyline')
local gls = gl.section

gls.left[1] = {
  ViMode = {
    provider = function()
      -- auto change color according the vim mode
      local mode_color = {
        n      = momiji_colors.green,
        i      = momiji_colors.blue,
        v      = momiji_colors.yellow,
        [''] = momiji_colors.yellow,
        V      = momiji_colors.yellow,
        c      = momiji_colors.red,
        no     = momiji_colors.green,
        s      = momiji_colors.orange,
        S      = momiji_colors.orange,
        [''] = momiji_colors.orange,
        ic     = momiji_colors.yellow,
        R      = momiji_colors.violet,
        Rv     = momiji_colors.violet,
        cv     = momiji_colors.red,
        ce     = momiji_colors.red,
        r      = momiji_colors.cyan,
        rm     = momiji_colors.cyan,
        ['r?'] = momiji_colors.cyan,
        ['!']  = momiji_colors.red,
        t      = momiji_colors.red,
      }
      vim.api.nvim_command('hi GalaxyViMode guifg='..mode_color[vim.fn.mode()])
      return '  '
    end,
    highlight = {momiji_colors.red,momiji_colors.white,'bold'},
  },
}
gls.left[2]= {
  FileSize = {
    provider = 'FileSize',
    condition = function()
      if vim.fn.empty(vim.fn.expand('%:t')) ~= 1 then
        return true
      end
      return false
      end,
    icon = '   ',
    highlight = 'MomijiGreen',
    separator = '',
    separator_highlight = 'MomijiGreen',
  }
}
EOF
" }}}
