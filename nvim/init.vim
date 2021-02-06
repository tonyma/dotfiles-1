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

let g:fern#disable_default_mappings = 1
lua require('plugins')
autocmd BufWritePost plugins.lua PackerCompile

runtime! etc/my-fern-mode.vim
runtime! etc/my-fern.vim
" FileTypes:
" - markdown
" - plantuml
" - json
" - vuejs
" - python (pyenv, virtualenv, bps/vim-textobj-python)
" - Glench/Vim-Jinja2-Syntax
" - briancollins/vim-jst
" - cespare/vim-toml
" - leafgarland/typescript-vim
" - pangloss/vim-javascript
" - tell-k/vim-autoflake
" - nikvdp/ejs-syntax
"
" MyPackages:
" - packadd personal-ft
" - packadd personal-ft-diff
" - packadd personal-ft-help
" - packadd my-git-edit

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

nnoremap Q <Nop>
nnoremap gQ <Nop>
" }}}

" Set terminal {{{
augroup neovim_terminal
  autocmd!
  " Enter Terminal-mode (insert) automatically
  autocmd TermOpen * startinsert

  " Disables number lines on terminal buffers
  autocmd TermOpen * setlocal nonumber norelativenumber

  " ターミナルで
  "   * <C-\><C-n> による job <- -> normal モードの往復を可能にする
  "   * q によるmacro記録を禁止する
  " TODO: autocmd! TerminalOpen *
  " TODO:     \ nnoremap <buffer> <C-\><C-n> i|
  " TODO:     \ nnoremap <buffer> q <Nop>
augroup END

nnoremap <silent> tt :<C-u>terminal<CR>
nnoremap <silent> tx :<C-u>sp <Bar> terminal<CR>
nnoremap <silent> tv :<C-u>vsp <Bar> terminal<CR>

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
language messages en_US.UTF-8
" }}}

" TODO: Original Functions {{{
" " ConfigEdit {{{
" def s:edit_config(bang: string, mods: string)
"   if exists('g:fzf#vim#buffers')
"     fzf#vim#files(g:xdg_config_home)
"   else
"     var cmd: string
"     if mods == ''
"       cmd = 'edit' .. bang
"     else
"       cmd = mods .. ' split'
"     endif
"     execute cmd .. ' ' .. $MYVIMRC
"   endif
" enddef
" command! -bang -nargs=0 ConfigEdit call s:edit_config('<bang>', '<mods>')
" nnoremap <Leader><Leader>c :<C-u>ConfigEdit<CR>
" " }}}
" 
" " PlugEdit {{{
" def s:edit_plug(dir: string, bang: string, mods: string)
"   if exists('g:fzf#vim#buffers')
"     fzf#vim#files(dir)
"   else
"     var cmd: string
"     if mods == ''
"       cmd = 'edit' .. bang
"     else
"       cmd = mods .. ' split'
"     endif
"     execute cmd .. ' ' .. dir
"   endif
" enddef
" command! -bang -nargs=0 PlugEdit call s:edit_plug(g:plug_dir, '<bang>', '<mods>')
" nnoremap <Leader><Leader>p :<C-u>PlugEdit<CR>
" " }}}
" 
" " PlugAdd {{{
" def s:plug_add(name: string)
"   var cur_file = expand('%:p')
"   if cur_file != $MYVIMRC
"     execute ':edit ' .. escape($MYVIMRC, ' ')
"   endif
"   if expand('%:p') != $MYVIMRC
"     return
"   endif
"   if &readonly == v:true
"     if cur_file != $MYVIMRC
"       execute ':bw'
"     endif
"     return
"   endif
"   execute ':%s/\n\(\n*call s:plug\.end()\)$/\r  Plug ' .. "'" .. escape(name, '/') .. "'" .. '\r\1/'
"   execute ':w'
"   if cur_file != $MYVIMRC
"     execute ':bw'
"   endif
"   source $MYVIMRC
" enddef
" command! -nargs=1 PlugAdd call s:plug_add('<args>')
" " }}}
" 
" " Update All {{{
" def s:update_all()
"   execute 'terminal ' .. &shell .. ' -c "source ' .. $ZDOTDIR .. '/.zshrc && update"'
" enddef
" command! UpdateAll call s:update_all()
" " }}}
" 
" " Manage TODOs {{{
" def s:grep_todo()
"   grep! 'TODO\\|UNDONE\\|HACK\\|FIXME'
" enddef
" command! Todo call s:grep_todo()
" command! ToDo call s:grep_todo()
" command! TODO call s:grep_todo()
" " }}}
" 
" " Function: Switch Branch {{{
" def s:git_switch(line: string)
"   var branch = get(split(line), 1, '')
"   execute '!git switch ' .. branch
"   lightline#update()
" enddef
" 
" command! SwitchBranch call fzf#run(fzf#wrap({
"     \ 'source': "git-branches --color !current",
"     \ 'sink': function('<SID>git_switch'),
"     \ }))
" nnoremap <Leader>gb :<C-u>SwitchBranch<CR>
" " }}}
" 
" " Function: Cleanup Branch {{{
" command! CleanupBranch !git-branches cleanup
" " }}}
" 
" " Function: Quote current filename and content {{{
" nmap Y <Plug>(quotem-copy)
" vmap Y <Plug>(quotem-copy)
" }}}
" }}}
" vim: foldmethod=marker
