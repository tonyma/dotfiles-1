" Setup encodings
set encoding=utf-8
scriptencoding utf-8

" Setup XDG Home directory paths. {{{
  let s:config_home = stdpath("config") " ${xdg-CONFIG-home}/nvim
  let s:data_home = stdpath("data")   " ${xdg-DATA-home}/nvim
  let s:cache_home = stdpath("cache")   " ${xdg-CACHE-home}/nvim

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

lua <<EOL
local execute = vim.api.nvim_command
local fn = vim.fn

local install_path = fn.stdpath('data')..'/site/pack/packer/opt/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
  execute('!git clone https://github.com/wbthomason/packer.nvim '..install_path)
  execute 'packadd packer.nvim'
end
EOL

lua require('plugins')
autocmd BufWritePost plugins.lua PackerCompile

" TODO: FileTypes:
" - python (pyenv, virtualenv, bps/vim-textobj-python, tell-k/vim-autoflake)

" Colors {{{
  syntax enable
  colorscheme momiji
" }}}

" Indents {{{
  set tabstop=2
  set autoindent
  set shiftwidth=2
  set expandtab
  set smarttab
  set nowrap
" }}}

" Displays {{{
  set number       " Show the line number
  set emoji        " Show emoji characters
  set conceallevel=0
" }}}

" Show invisibles {{{
  set list
  set listchars=tab:»\ ,trail:∙,eol:↵,extends:»,precedes:«,nbsp:∙
" }}}

" Setup Keymaps (for regular functions) {{{
  " Delete search highlight
  nnoremap <C-l> :<C-u>nohlsearch<CR><C-l>

  " Quickfix
  nnoremap <Leader>q :<C-u>copen<CR><ESC>

  " Luafile
  augroup my-lua-file
    autocmd!
    autocmd FileType lua nnoremap <buffer> <leader>r <cmd>w<bar>luafile %<cr>
  augroup END

  " Vimfile
  augroup my-vim-file
    autocmd!
    autocmd FileType vim nnoremap <buffer> <leader>r <cmd>w<bar>so %<cr>
  augroup END

  nnoremap Q <Nop>
  nnoremap gQ <Nop>
" }}}

" Set terminal {{{
  augroup neovim_terminal
    autocmd!
    " Disables number lines on terminal buffers
    autocmd TermOpen * setlocal nonumber norelativenumber
  augroup END

  " <C-w>で使えるウィンドウの管理系をマップする
  tnoremap <C-W>n       <C-\><C-n><C-W>n
  tnoremap <C-W><C-N>   <C-\><C-n><C-W><C-N>
  tnoremap <C-W>ge      <C-\><C-n><C-W>ge
  tnoremap <C-W>q       <C-\><C-n><C-W>q
  tnoremap <C-W><C-Q>   <C-\><C-n><C-W><C-Q>
  tnoremap <C-W>c       <C-\><C-n><C-W>c
  tnoremap <C-W>o       <C-\><C-n><C-W>o
  tnoremap <C-W><C-O>   <C-\><C-n><C-W><C-O>
  tnoremap <C-W><Down>  <C-\><C-n><C-W><Down>
  tnoremap <C-W><C-J>   <C-\><C-n><C-W><C-J>
  tnoremap <C-W>j       <C-\><C-n><C-W>j
  tnoremap <C-W><Up>    <C-\><C-n><C-W><Up>
  tnoremap <C-W><C-K>   <C-\><C-n><C-W><C-K>
  tnoremap <C-W>k       <C-\><C-n><C-W>k
  tnoremap <C-W><Left>  <C-\><C-n><C-W><Left>
  tnoremap <C-W><C-H>   <C-\><C-n><C-W><C-H>
  tnoremap <C-W><BS>    <C-\><C-n><C-W><BS>
  tnoremap <C-W>h       <C-\><C-n><C-W>h
  tnoremap <C-W><Right> <C-\><C-n><C-W><Right>
  tnoremap <C-W><C-L>   <C-\><C-n><C-W><C-L>
  tnoremap <C-W>l       <C-\><C-n><C-W>l
  tnoremap <C-W>w       <C-\><C-n><C-W>w
  tnoremap <C-W><C-W>   <C-\><C-n><C-W><C-W>
  tnoremap <C-W>W       <C-\><C-n><C-W>W
  tnoremap <C-W>t       <C-\><C-n><C-W>t
  tnoremap <C-W><C-T>   <C-\><C-n><C-W><C-T>
  tnoremap <C-W>b       <C-\><C-n><C-W>b
  tnoremap <C-W><C-B>   <C-\><C-n><C-W><C-B>
  tnoremap <C-W>p       <C-\><C-n><C-W>p
  tnoremap <C-W><C-P>   <C-\><C-n><C-W><C-P>
  tnoremap <C-W>P       <C-\><C-n><C-W>P
  tnoremap <C-W>r       <C-\><C-n><C-W>r
  tnoremap <C-W><C-R>   <C-\><C-n><C-W><C-R>
  tnoremap <C-W>R       <C-\><C-n><C-W>R
  tnoremap <C-W>x       <C-\><C-n><C-W>x
  tnoremap <C-W><C-X>   <C-\><C-n><C-W><C-X>
  tnoremap <C-W>K       <C-\><C-n><C-W>K
  tnoremap <C-W>J       <C-\><C-n><C-W>J
  tnoremap <C-W>H       <C-\><C-n><C-W>H
  tnoremap <C-W>L       <C-\><C-n><C-W>L
  tnoremap <C-W>T       <C-\><C-n><C-W>T
  tnoremap <C-W>=       <C-\><C-n><C-W>=
  tnoremap <C-W>-       <C-\><C-n><C-W>-
  tnoremap <C-W>+       <C-\><C-n><C-W>+
  tnoremap <C-W><C-_>   <C-\><C-n><C-W><C-_>
  tnoremap <C-W>_       <C-\><C-n><C-W>_
  tnoremap <C-W><lt>    <C-\><C-n><C-W><lt>
  tnoremap <C-W>>       <C-\><C-n><C-W>>
  " tnoremap <C-W>\|      <C-\><C-n><C-W>\|
  tnoremap <C-W>]       <C-\><C-n><C-W>]
  tnoremap <C-W><C-]>   <C-\><C-n><C-W><C-]>
  tnoremap <C-W>g]      <C-\><C-n><C-W>g]
  tnoremap <C-W>g<C-]>  <C-\><C-n><C-W>g<C-]>
  tnoremap <C-W>f       <C-\><C-n><C-W>f
  tnoremap <C-W><C-F>   <C-\><C-n><C-W><C-F>
  tnoremap <C-W>F       <C-\><C-n><C-W>F
  tnoremap <C-W>gf      <C-\><C-n><C-W>gf
  tnoremap <C-W>gF      <C-\><C-n><C-W>gF
  tnoremap <C-W>gt      <C-\><C-n><C-W>gt
  tnoremap <C-W>gT      <C-\><C-n><C-W>gT
  tnoremap <C-W>z       <C-\><C-n><C-W>z
  tnoremap <C-W><C-Z>   <C-\><C-n><C-W><C-Z>
  tnoremap <C-W>}       <C-\><C-n><C-W>}
  tnoremap <C-W>g}      <C-\><C-n><C-W>g}

  function! s:termopen_volatile() abort
    " 終了時にバッファを消すterminalを開く
    call termopen($SHELL, {'on_exit': function('<SID>close_success_term')})
    " 最初から挿入モード
    startinsert
  endfunction
  function! s:close_success_term(job_id, code, event) dict
    call feedkeys("\<CR>")
  endfun

  function! s:split_termopen_volatile(size, mods) abort
    " 指定方向に画面分割
    execute a:mods .. ' ' .. 'new'
    call s:termopen_volatile()
    " 指定方向にresize
    let l:size = v:count
    if l:size == 0
      let l:size = a:size
    end
    if l:size != 0
      execute a:mods .. ' resize ' . l:size
    end
  endfun

  " Terminal: terminalを開く
  "   - 新しいWindowで:   :NewTerminal
  "   - 指定のWindowSize: :30NewTerminal
  "   - 指定の位置:       :vertical NewTerminal  /  :botright 15NewTerminal
  command! Terminal :call s:termopen_volatile()
  command! -count NewTerminal :call s:split_termopen_volatile(<count>, <q-mods>)

  " ターミナルをさっと開く
  "   サイズ指定付き: 80tx 15tv
  nnoremap <silent> tt <Cmd>Terminal<CR>
  nnoremap <silent> tx <Cmd>NewTerminal<CR>
  nnoremap <silent> tv <Cmd>vertical NewTerminal<CR>

  set termguicolors
  let $NVIM_TERMINAL = 1
" }}}

" Auto-off IME {{{
  if executable('ibus')
    " IM OFF command
    command! ImeOff silent !ibus engine 'xkb:us::eng'

    " When in insert mode
    augroup InsertHook
        autocmd!
        autocmd InsertLeave * ImeOff
    augroup END
  elseif executable('fcitx-remote')
    " IM OFF command
    command! ImeOff silent !fcitx-remote -c

    " When in insert mode
    augroup InsertHook
        autocmd!
        autocmd InsertLeave * ImeOff
    augroup END
  endif
" }}}

" Command-line-mode mappings {{{
  cnoremap <C-A> <Home>
  cnoremap <C-F> <Right>
  cnoremap <C-B> <Left>
  cnoremap <C-D> <Del>
  cnoremap <C-H> <BS>
  "
  " Go back command histories with prefix in the command
  cnoremap <C-P> <Up>
  cnoremap <C-N> <Down>

  " enter command-line-window
  set cedit=\<C-Y>
" }}}

" Other misc settings {{{
  set clipboard=unnamedplus,unnamed
  set hidden              " able to edit without saving
  set fixendofline        " <EOL> at the end of file will be restored if missing
  set showcmd             " 
  set textwidth=100         " never limit length of each line
  set ambiwidth=single
  set foldmethod=manual
  set backspace=2
  set cursorline   " Highlight cursor line
  set showtabline=1
  set hlsearch
  set history=1000
  set incsearch
  set scrolloff=3 " Show least &scrolloff lines before/after cursor
  set sidescrolloff=3
  set formatoptions+=j " Delete comment character when joining commented lines
  set helplang=ja,en
  set grepprg=rg\ --vimgrep\ --no-heading
  set grepformat=%f:%l:%c:%m,%f:%l:%m
  language messages en_US.UTF-8
" }}}

" Original Functions {{{
  " Manage TODOs {{{
    function s:grep_todo()
      silent! grep! -i 'TODO\|UNDONE\|HACK\|FIXME' | copen
    endfunction
    command! Todo call s:grep_todo()
    command! ToDo call s:grep_todo()
    command! TODO call s:grep_todo()
  " }}}

  " Show Keymaps {{{
    command! Nmaps lua require('keymaps').show_keymaps('n')
    command! Imaps lua require('keymaps').show_keymaps('i')
    command! Vmaps lua require('keymaps').show_keymaps('v')
    command! Omaps lua require('keymaps').show_keymaps('o')
    command! Tmaps lua require('keymaps').show_keymaps('t')
  " }}}

  " Update All {{{
    function! s:update_all()
      execute 'terminal ' .. &shell .. ' -c "source ' .. $ZDOTDIR .. '/.zshrc && update"'
      startinsert
    endfunction
    command! UpdateAll call s:update_all()
  " }}}

" }}}

" vim: foldmethod=marker
