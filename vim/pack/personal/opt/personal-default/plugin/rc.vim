" Vim Debug {{{
" set verbose=20
" set verbosefile=$HOME/.local/share/vim/verbose
" }}}

" Setup encodings {{{
set encoding=utf-8
scriptencoding utf-8
" }}}

" Setup XDG_HOME {{{
if ($XDG_CONFIG_HOME ==# '')
  let $XDG_CONFIG_HOME=$HOME.'/.config'
endif
if $XDG_CONFIG_HOME =~ '/$'
  let $XDG_CONFIG_HOME = strpart($XDG_CONFIG_HOME, 0, strlen($XDG_CONFIG_HOME)-1)
endif
if ($XDG_CACHE_HOME ==# '')
  let $XDG_CACHE_HOME=$HOME.'/.cache'
endif

set undodir=$XDG_CACHE_HOME/vim/undo
set directory=$XDG_CACHE_HOME/vim/swap
set backupdir=$XDG_CACHE_HOME/vim/backup
set viminfo+='1000,n$XDG_CACHE_HOME/vim/viminfo
set runtimepath=$XDG_CONFIG_HOME/vim,$VIMRUNTIME,$XDG_CONFIG_HOME/vim/after
" }}}

" Setup Environment Variables {{{
" ZSHとVIM両方に効かせる環境変数はここで設定する
" ZSHだけでいい場合は.zshenvで設定すればよい

" 基本環境設定:
let $LANG='ja_JP.UTF-8'
let $ARCHFLAGS='-arch x86_64'
let $EDITOR='vim'
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
let $DOTFILES=$HOME.'/.config'
let $DOTS=$DOTFILES

" Zsh:
let $ZDOTDIR=$HOME.'/.config/zsh'

" Go:
let $GOENV_ROOT=$HOME.'/.goenv'
let $GO111MODULE='on'
let $GOPATH=$HOME.'/go'
let $PATH=$GOENV_ROOT.'/bin:'.$PATH
let $PATH=$GOENV_ROOT.'/shims:'.$PATH
let $PATH=$HOME.'/.goenv/bin:'.$PATH
let $PATH=$PATH.':/usr/local/go/bin:'.$HOME.'/go/bin'

" Go AWS Library
let $AWS_SDK_LOAD_CONFIG=1

" Generator-go-project:
let $GO_PROJECT_ROOT=$HOME.'/Projects'

" Python: (support sqlite3 and mysql library (used by mypy, etc...))
let $LDFLAGS="-L/usr/local/opt/zlib/lib -L/usr/local/opt/sqlite/lib"
let $CPPFLAGS="-I/usr/local/opt/zlib/include -I/usr/local/opt/sqlite/include"
let $LIBRARY_PATH=$LIBRARY_PATH.':/usr/local/opt/openssl/lib/'

" Ruby:
let $PATH=$HOME.'/.rbenv/bin:'.$HOME.'/.rbenv/shims:'.$PATH

" Python:
if has("mac")
  let $PYTHON_CONFIGURE_OPTS='--enable-framework'
  let $PIP_REQUIRE_VIRTUALENV='true'
endif
let $PYENV_DEFAULT_PACKAGES=$XDG_CONFIG_HOME.'/pyenv/default-packages'
let $PYENV_ROOT=$HOME.'/.pyenv'
let $PATH=$PYENV_ROOT.'/bin:'.$PYENV_ROOT.'/shims:'.$PATH

" Node:
let $PATH=$HOME.'/.nodenv/shims:'.$HOME.'/.nodenv/bin:'.'./node_modules/.bin:'.$PATH

" GNU commands:
let $PATH='/usr/local/opt/gzip/bin:'.$PATH
let $PATH='/usr/local/opt/openssl/bin:'.$PATH

" FZF (https://github.com/junegunn/fzf):
let $FZF_DEFAULT_OPTS='--inline-info --no-mouse --extended --ansi --no-sort'
let $FZF_DEFAULT_COMMAND='rg --files --hidden --follow --maxdepth 10 --glob "!.git/*" --glob "!*.egg-info/*" --glob "!*/__pycache__/*" --glob "!.mypy_cache/*"'
let $PATH=$PATH.':'.$HOME.'/.fzf/bin'

" Scala:
let $SCALA_HOME='/usr/local/bin/scala'
let $PATH=$PATH.':'.$SCALA_HOME.'/bin'

" Yarn:
let $PATH=$PATH.':'.$HOME.'/.yarn/bin'

" Perl:
let $PATH=$PATH.':'.$HOME.'/perl5/bin'

" Git:
let $PATH=$PATH.':'.'/usr/local/share/git-core/contrib/diff-highlight'

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

silent! ru ./secret.vim

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

" Setup XDG Home directory paths. {{{
let g:xdg_config_home=$XDG_CONFIG_HOME
if g:xdg_config_home ==# ''
  let g:xdg_config_home = $HOME.'/.config'
endif

let g:xdg_data_home=$XDG_DATA_HOME
if g:xdg_data_home ==# ''
  let g:xdg_data_home = $HOME.'/.local/share'
endif

let s:cachedir=$XDG_CACHE_HOME
if s:cachedir ==# ''
  let s:cachedir = $HOME.'/.cache'
endif

let &directory = s:cachedir.'/vim/swap'
if !isdirectory(&directory)
  call mkdir(&directory, 'p')
endif
let &backupdir = s:cachedir.'/vim/backup'
if !isdirectory(&backupdir)
  call mkdir(&backupdir, 'p')
endif
" }}}

unlet! skip_defaults_vim
source $VIMRUNTIME/defaults.vim

" Configure Plugins {{{
" vim-plug global settings
let g:plug_window = 'topleft new'
" Auto install {{{
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
" }}}

" Begin with mkdir {{{
let s:plug = {}
let s:plug['before'] = {}
let s:plug['after'] = {}
function! s:plug.begin()
  let g:plug_dir = g:xdg_data_home . '/vim-plug'
  let $VIM_PLUG_DIR=g:plug_dir
  if !isdirectory(g:plug_dir)
    call mkdir(g:plug_dir, 'p')
  endif
  call plug#begin(g:plug_dir)
endfunction

function! s:plug.end()
  for l:name in keys(s:plug.before)
    call s:plug.before[l:name]()
  endfor
  call plug#end()
  for l:name in keys(s:plug.after)
    call s:plug.after[l:name]()
  endfor
endfunction
" }}}

call s:plug.begin()
  " If you need Vim help for vim-plug itself (e.g. :help plug-options), register vim-plug as a plugin.
  Plug 'junegunn/vim-plug'

  Plug 'kyoh86/momiji', {'rtp': 'vim', 'dir': $GO_PROJECT_ROOT.'/github.com/kyoh86/momiji'}

  " {{{ junegunn/fzf
  let g:fzf_layout = { 'down': '20%' }

  Plug 'junegunn/fzf', { 'dir': $HOME.'/.fzf', 'do': { -> fzf#install() } }
  Plug 'junegunn/fzf.vim'
  Plug 'pbogut/fzf-mru.vim'

  function! s:plug.after.junegunn__fzf__vim()
    let g:fzf_command_prefix = 'Fzf'
    nnoremap <Leader>f  :<C-u>FzfFiles<CR>
    nnoremap <Leader>c  :<C-u>FzfCommands<CR>
    nnoremap <Leader>w  :<C-u>FzfWindows<CR>
    nnoremap <Leader>bb :<C-u>FzfBuffers<CR>
    nnoremap <Leader>r  :<C-u>FZFMru<CR>
    nnoremap <Leader>:  :<C-u>FzfHistory :<CR> 
    nnoremap <Leader>/  :<C-u>FzfHistory /<CR>

    function! s:format_buffer(b)
      let l:name = bufname(a:b)
      let l:name = empty(l:name) ? '[No Name]' : fnamemodify(l:name, ":p:~:.")
      let l:flag = a:b == bufnr('')  ? '%' :
              \ (a:b == bufnr('#') ? '#' : ' ')
      let l:modified = getbufvar(a:b, '&modified') ? ' [+]' : ''
      let l:readonly = getbufvar(a:b, '&modifiable') ? '' : ' [RO]'
      let l:extra = join(filter([l:modified, l:readonly], '!empty(v:val)'), '')
      return substitute(printf("[%s] %s\t%s\t%s", a:b, l:flag, l:name, l:extra), '^\s*\|\s*$', '', 'g')
    endfunction

    function! s:wipeout_buffers()
      let l:preview_window = get(g:, 'fzf_preview_window', &columns >= 120 ? 'right': '')
      let l:options = [
      \   '-m',
      \   '--tiebreak=index',
      \   '-d', '\t',
      \   '--prompt', 'Delete> '
      \ ]
      if len(l:preview_window)
        let l:options = extend(l:options, get(fzf#vim#with_preview(
              \   {"placeholder": "{2}"},
              \   l:preview_window
              \ ), 'options', []))
      endif

      return fzf#run(fzf#wrap({
      \ 'source':  map(
      \   filter(
      \     range(1, bufnr('$')),
      \     {_, nr -> buflisted(nr) && !getbufvar(nr, "&modified")}
      \   ),
      \   {_, nr -> s:format_buffer(nr)}
      \ ),
      \ 'sink*': {
      \   lines -> execute('bwipeout ' . join(map(lines, {
      \     _, line -> substitute(split(line)[0], '^\[\|\]$', '', 'g')
      \   })), 'silent!')
      \ },
      \ 'options': l:options,
      \}))
    endfunction
    command! FzfDeleteBuffers call s:wipeout_buffers()
    nnoremap <silent> <Leader>bw :<C-u>FzfDeleteBuffers<CR>
  endfunction
  " }}}

  " {{{ vim-lsp
  Plug 'prabirshrestha/vim-lsp'

  function! s:plug.before.prabirshrestha__vim__lsp()
    let g:lsp_diagnostics_echo_cursor = v:true " enable echo under cursor when in normal mode
    let g:lsp_diagnostics_float_cursor = v:true " enable hover under cursor when in normal mode
    let g:lsp_work_done_progress_enabled = v:true
    augroup lsp_install
      au!
      " call s:on_lsp_buffer_enabled only for languages that has the server registered.
      autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
    augroup END
  endfunction

  function! s:on_lsp_buffer_enabled() abort
    setlocal omnifunc=lsp#complete
    setlocal signcolumn=yes
    setlocal tagfunc=lsp#tagfunc

    nmap <silent> <Leader>ld <Plug>(lsp-definition)
    nmap <silent> <Leader>ldf <Plug>(lsp-definition)
    nmap <silent> <Leader>ldc <Plug>(lsp-declaration)
    nmap <silent> <Leader>ldt <Plug>(lsp-type-definition)

    nmap <silent> <Leader>lh <Plug>(lsp-hover)
    nmap <silent> <Leader>ln <Plug>(lsp-next-error)
    nmap <silent> <Leader>lp <Plug>(lsp-previous-error)
    nmap <silent> <Leader>lf <Plug>(lsp-document-format)
    nmap <silent> <Leader>la <Plug>(lsp-code-action)
    nmap <silent> <Leader>ll <Plug>(lsp-document-diagnostics)
    nmap <silent> <Leader>ls <Plug>(lsp-status)
    nmap <silent> <Leader>li <Plug>(lsp-implementation)
    nmap <silent> <Leader>lr <Plug>(lsp-references)
    nmap <silent> <Leader>le <Plug>(lsp-rename)
    " nmap <Leader> <Plug>(lsp-document-symbol)
    " nmap <Leader> <Plug>(lsp-workspace-symbol)
  endfunction

  Plug 'mattn/vim-lsp-settings'
  function! s:plug.before.vim__lsp__settings()
    let g:lsp_settings = {
          \   'pyls': {
          \     'workspace_config': {'pyls': {
          \       'configurationSources': ['flake8'],
          \       'plugins': {
          \         'black': {'enabled': v:true},
          \         'pycodestyle': {'enabled': v:false},
          \         'pyls_mypy': {'enabled': v:true, 'live_mode': v:false},
          \       }
          \     }}
          \   },
          \   'efm-langserver': {
          \     'disabled': v:false
          \   },
          \   'gopls': {
          \     'initialization_options': {
          \       'usePlaceholders': v:true,
          \     },
          \   },
          \   'vim-language-server': {
          \     'workspace_config': {
          \       "iskeyword": "vim iskeyword option",
          \       "diagnostic": {
          \         "enable": v:true
          \       }
          \     }
          \   }
          \ }
  endfunction
  " }}}

  " {{{ snippet completion
  Plug 'prabirshrestha/asyncomplete.vim'
  function! s:plug.after.asyncomplete__vim()
    let g:asyncomplete_auto_popup = 0

    " :help ins-completion と :help i_CTRL-X でその他のCTRL-X配下の入力一覧を確認できる
    inoremap <silent><expr> <C-x><C-s> asyncomplete#force_refresh()

    let g:asyncomplete_auto_completeopt = 0
  endfunction

  Plug 'hrsh7th/vim-vsnip'
  Plug 'hrsh7th/vim-vsnip-integ'

  function! s:plug.before.vim__vsnip()
    let g:vsnip_integ_debug = v:true
    let g:vsnip_snippet_dir = $XDG_CONFIG_HOME . '/vim/vsnip'
  endfunction

  function! s:plug.after.vim__vsnip()
    " Expand
    imap <expr> <C-j>   vsnip#expandable()  ? '<Plug>(vsnip-expand)'         : '<C-j>'
    smap <expr> <C-j>   vsnip#expandable()  ? '<Plug>(vsnip-expand)'         : '<C-j>'

    " Expand or jump
    imap <expr> <C-l>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'
    smap <expr> <C-l>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'

    " Jump forward or backward
    imap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<Tab>'
    smap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<Tab>'
    imap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'
    smap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'
  endfunction

  Plug 'golang/vscode-go'
  " }}}

  " {{{ lightline
  Plug 'itchyny/lightline.vim'
  function! s:plug.after.itchyny__lightline__vim() "
    set laststatus=2  " statuslineは常に表示
    set noshowmode  " lightlineで表示するので、vim標準のモード表示は隠す
    let g:lightline = {
      \   'colorscheme': 'momiji',
      \   'separator': {
      \     'left': "",
      \     'right': ""
      \   },
      \   'subseparator': {
      \     'left': "\UFFE8",
      \     'right': "\UFFE8"
      \   },
      \   'active': {
      \     'left': [
      \       ['mode', 'paste'],
      \       ['pwd', 'relativepath', 'readonly', 'modified', 'terminalinfo']
      \     ],
      \     'right': [
      \       ['linter_ok', 'linter_errors', 'linter_warnings'],
      \       ['gitstatus']
      \     ]
      \   },
      \   'inactive': {
      \     'left': [
      \       ['mode', 'paste'],
      \       ['pwd', 'relativepath', 'readonly', 'modified', 'terminalinfo']
      \     ],
      \     'right': []
      \   },
      \   'mode_map': {
      \     'n': "\UFFB32", 'i': "\UFFAE6", 'R': "\UFF954", 'v': 'VIS', 'V': 'VLNE', "\<C-v>": 'VBLK',
      \     'c': 'COMM', 's': 'SLCT', 'S': 'SLNE', "\<C-s>": 'SBLK', 't': "\UF120"
      \   },
      \   'component_expand': {
      \     'linter_ok': 'LightlineLspOK',
      \     'linter_warnings': 'LightlineLspWarnings',
      \     'linter_errors': 'LightlineLspErrors',
      \     'gitstatus': 'LightlineGitStatus'
      \   },
      \   'component_type': {
      \     'linter_warnings': 'warning',
      \     'linter_errors': 'error',
      \     'gitstatus': 'warning',
      \   },
      \   'component_function': {
      \     'pwd': 'LightlinePwd',
      \     'relativepath': 'LightlineRelativePath',
      \     'readonly': 'LightlineReadonly', 
      \     'modified': 'LightlineModified',
      \     'terminalinfo': 'LightlineTerminalInfo',
      \   },
      \ }
    augroup LightLineUpdate
      autocmd!
      autocmd DirChanged * call lightline#update()
    augroup END
    function! LightlinePwd() abort
      return fnamemodify(getcwd(), ':t')
    endfunction
    function! LightlineModified() abort
      return &buftype ==# 'terminal' ? '' : &modified ? '+' : &modifiable ? '' : '-'
    endfunction
    function! LightlineTerminalInfo() abort
      if &buftype !=# 'terminal'
        return ''
      endif
      let l:ttl=term_gettitle('%')
      let l:rel=fnamemodify(l:ttl, ':p:.')
      if l:rel ==# ''
        let l:rel='.'
      elseif l:rel[0] !=# '/'
        let l:rel='./'.l:rel
      endif
      return bufnr('%').':'.l:rel
    endfunction
    function! LightlineRelativePath() abort
      if &buftype ==# 'terminal'
        return ''
      elseif &buftype ==# 'quickfix' && get(w:, 'quickfix_title', '') !=# ''
        return bufnr('%') . ': (qf)' . w:quickfix_title
      else
        if expand('%') ==# ''
          let l:name = '[No Name]'
        else
          let l:max = winwidth(0) - 80
          let l:name = expand('%:t')
          if len(l:name) < l:max
            let l:name = expand('%:.')
            if l:name ==# ''
              let l:name = '.'
            elseif l:name[0] !=# '/'
              let l:name='./'.l:name
            endif

            if len(l:name) > l:max
              let l:name = '…' . l:name[-l:max :]
            endif
          endif
        endif
        return  bufnr('%') . ':' . l:name
      endif
    endfunction
    function! LightlineReadonly() abort
      return &buftype ==# 'terminal' ? '' : &readonly ? "\ue0a2" : ''
    endfunction
    function! LightlineGitStatus()
      let l:brch = ''
      let l:warn = ''
      let l:location = getcwd()
      if &buftype ==# 'terminal'
        let l:location = term_gettitle('%')
      endif
      let l:stat = s:getGitStatus(l:location)
      let l:commit = trim(s:statPart(l:stat, 'ahead', " \UFF55D") . s:statPart(l:stat, 'behind', " \UFF545") . get(l:stat, 'sync', ""))
      let l:merge = s:statPart(l:stat, 'unmerged', 'Unmerged:')
      let l:stage = trim(s:statPart(l:stat, 'staged', " \UFF631") . s:statPart(l:stat, 'unstaged', " \UFF915") . s:statPart(l:stat, 'untracked', " \UFFC89"))
      let l:warn = [ l:commit, l:merge, l:stage ]
      let l:brch = trim(s:statPart(l:stat, 'local-branch', "\UE0A0"))
      return [[], l:warn, [ l:brch ]]
    endfunction
    function! s:statPart(stat, key, pre)
      if !has_key(a:stat, a:key) || a:stat[a:key] ==# ''
        return ''
      endif
      return a:pre . a:stat[a:key]
    endfunction
    function! s:getGitStatus(path)
      let l:info = {}
      " TODO: see
      " https://git-scm.com/docs/git-status#_porcelain_format_version_2 and
      " use porcelain v2
      let l:res = system("git -C '" . a:path . "' status --porcelain --branch --untracked-files --ahead-behind --renames")
      if l:res[0:6] ==# 'fatal: '
        return l:info
      endif
      for l:file in split(l:res, "\n")
        if l:file[0:1] ==# '##'
          " ブランチ名を取得する
          let l:words = split(l:file, '\.\.\.\|[ \[\],]')[1:]
          if len(l:words) == 1
            let l:info['local-branch'] = l:words[0] . '?'
            let l:info['sync'] = "\uf12a"
          else
            let [l:info['local-branch'], l:info['remote-branch']; l:remain] = l:words
            let l:key = ''
            for l:_ in l:remain
              if l:key !=# ''
                let l:info[l:key] = l:_
                let l:key = ''
              else
                let l:key = l:_
              endif
            endfor
          endif
        elseif l:file[0] ==# 'U' || l:file[1] ==# 'U' || l:file[0:1] ==# 'AA' || l:file[0:1] ==# 'DD'
          call s:inc(l:info, 'unmerged')
        elseif l:file[0:1] ==# '??'
          call s:inc(l:info, 'untracked')
        else
          if l:file[0] !=# ' '
            call s:inc(l:info, 'staged')
          endif
          if l:file[1] !=# ' '
            call s:inc(l:info, 'unstaged')
          endif
        endif
      endfor
      return l:info
    endfunction
    function! s:inc(info, key)
      let a:info[a:key] = get(a:info, a:key, 0) + 1
    endfunction
    function! LightlineLspOK() abort
      if &buftype ==# 'terminal'
        return ''
      endif
      let l:counts = lsp#get_buffer_diagnostics_counts()    " *vim-lsp-get_buffer_diagnostics_counts*
      if l:counts['error'] == 0 && l:counts['warning'] == 0
        return 'OK'
      endif
      return ''
    endfunction
    function! LightlineLspWarnings() abort
      if &buftype ==# 'terminal'
        return ''
      endif
      let l:counts = lsp#get_buffer_diagnostics_counts()    " *vim-lsp-get_buffer_diagnostics_counts*
      if l:counts['warning'] == 0
        return ''
      endif
      return 'W:' . l:counts['warning']
    endfunction
    function! LightlineLspErrors() abort
      if &buftype ==# 'terminal'
        return ''
      endif
      let l:counts = lsp#get_buffer_diagnostics_counts()    " *vim-lsp-get_buffer_diagnostics_counts*
      if l:counts['error'] == 0
        return ''
      endif
      return 'E:' . l:counts['error']
    endfunction
  endfunction
  " }}}

  Plug 'plasticboy/vim-markdown', {'for': 'markdown'}
  function! s:plug.after.plasticboy__vim__markdown()
    let g:vim_markdown_folding_disabled = 1
    let g:vim_markdown_fenced_languages = ['c++=cpp', 'viml=vim', 'bash=sh', 'ini=dosini', 'uml=plantuml']
    let g:vim_markdown_math = 1
    let g:vim_markdown_frontmatter = 1
    let g:vim_markdown_toml_frontmatter = 1
    let g:vim_markdown_json_frontmatter = 1
    let g:vim_markdown_conceal = 0
    let g:tex_conceal = ''
  endfunction

  Plug 'jremmen/vim-ripgrep', {'on': ['Rg', 'RgRoot']}
  function! s:plug.after.jremmen__vim__ripgrep()
    let g:rg_command = 'rg --vimgrep'
  endfunction

  Plug 'lambdalisue/vim-pyenv', {'for': 'python'}
  Plug 'jmcantrell/vim-virtualenv', {'for': 'python'}
  function! s:plug.after.jmcantrell__vim__virtualenv()
    function! s:jedi_auto_force_py_version() abort
      let g:jedi#force_py_version = pyenv#python#get_internal_major_version()
    endfunction
    augroup vim-pyenv-custom-augroup
      autocmd! *
      autocmd User vim-pyenv-activate-post   call s:jedi_auto_force_py_version()
      autocmd User vim-pyenv-deactivate-post call s:jedi_auto_force_py_version()
    augroup END
  endfunction
  Plug 'aklt/plantuml-syntax', {'for': 'plantuml'}
  function! s:plug.after.aklt__plantuml__syntax()
    augroup PlantUMLCmd
      autocmd FileType plantuml command! OpenUml :!open -a "Google Chrome" %
    augroup END
  endfunction
  Plug 'elzr/vim-json', {'for': 'json'}
  function! s:plug.after.elzr__vim__json()
    let g:vim_json_syntax_conceal = 0
  endfunction
  Plug 'qpkorr/vim-bufkill'
  function! s:plug.after.qpkorr__vim__bufkill()
    let g:BufKillCreateMappings = 0
  endfunction
  Plug 'thinca/vim-quickrun', {'on': 'QuickRun'}
  function! s:plug.after.thinca__vim__quickrun()
    let g:quickrun_config = {
        \ '_': {
        \   'runner': 'terminal'
        \   }
        \ }
  endfunction
  Plug 'osyo-manga/vim-operator-jump_side'
  function! s:plug.after.osyo__manga__vim__operator__jump_side()
    " textobj の先頭へ移動する
    nmap <Leader>h <Plug>(operator-jump-head)
    " textobj の末尾へ移動する
    nmap <Leader>t <Plug>(operator-jump-tail)
  endfunction
  Plug 'simeji/winresizer'
  function! s:plug.before.osyo__manga__vim__operator__jump_side()
    let g:winresizer_start_key = '<C-W><C-E>'
  endfunction
  Plug 'machakann/vim-sandwich'  " Edit surrounders (like brackets, parentheses and quotes)
  function! s:plug.after.machakann__vim__sandwich()
    nnoremap s <Nop>   " ignore s instead of the cl
    xnoremap s <Nop>   " ignore s instead of the cl
    silent! nmap <unique><silent> sc <Plug>(operator-sandwich-replace)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-query-a)
    silent! nmap <unique><silent> scb <Plug>(operator-sandwich-replace)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-auto-a)
  endfunction

  Plug 'justinmk/vim-dirvish'
  Plug 'lambdalisue/readablefold.vim'
  Plug 'tyru/empty-prompt.vim'
  function! s:plug.before.tyru__empty__prompt__vim()
    let g:empty_prompt#pattern = '^\$ \+$'
  endfunction
  function! s:empty_prompt_mappings() abort
    call empty_prompt#map(#{lhs: ';', rhs: "<C-w>:"})
    " call empty_prompt#map(#{lhs: '<Esc>', rhs: "<C-w>N"})

    " tnoremap <C-x> <C-w>:normal \
    tnoremap <expr> <C-x> empty_prompt#is_empty() ? "<C-w>:normal \\" : "<C-x>"
  endfunction
  autocmd VimEnter * ++once call s:empty_prompt_mappings()
  nnoremap ; :

  " My Plugins {{{
  " {{{ kyoh86/vim-gogh
  Plug 'kyoh86/vim-gogh', {'dir': $GO_PROJECT_ROOT.'/github.com/kyoh86/vim-gogh'}
  function! s:plug.after.kyoh86__vim__gogh()
    nmap <Leader>ge <Plug>(gogh-edit-project)
    nmap <Leader>gp <Plug>(gogh-switch-project)
    nmap <Leader>gg <Plug>(gogh-get-repository)
    call gogh#ui#fzf#use()
  endfunction
  " }}}
  "
  Plug 'kyoh86/vim-beedle', {'on': 'Bdelete', 'dir': $GO_PROJECT_ROOT.'/github.com/kyoh86/vim-beedle'}
  Plug 'kyoh86/vim-wipeout', {'on': 'Wipeout', 'dir': $GO_PROJECT_ROOT.'/github.com/kyoh86/vim-wipeout'}
  Plug 'kyoh86/vim-editerm', {'dir': $GO_PROJECT_ROOT.'/github.com/kyoh86/vim-editerm'}
  " }}}

  if executable('direnv')
    Plug 'direnv/direnv.vim'
  endif

  Plug 'po3rin/vim-gofmtmd'
  Plug 'AndrewRadev/linediff.vim'
  Plug 'Glench/Vim-Jinja2-Syntax', {'for': 'jinja'}
  Plug 'bps/vim-textobj-python'
  Plug 'briancollins/vim-jst', {'for': 'jst'}
  Plug 'cespare/vim-toml', {'for': 'toml'}
  Plug 'dhruvasagar/vim-table-mode'
  Plug 'airblade/vim-gitgutter'
  Plug 'iberianpig/tig-explorer.vim'
  Plug 'kana/vim-operator-user'
  Plug 'kana/vim-textobj-entire'
  Plug 'kana/vim-textobj-user'
  Plug 'previm/previm'
  Plug 'leafgarland/typescript-vim', { 'for': 'typescript' }
  Plug 'machakann/vim-swap'
  function! s:plug.after.machakann__vim__swap()
    omap i, <Plug>(swap-textobject-i)
    xmap i, <Plug>(swap-textobject-i)
    omap a, <Plug>(swap-textobject-a)
    xmap a, <Plug>(swap-textobject-a)
  endfunction
  Plug 'pangloss/vim-javascript', {'for': 'javascript'}
  Plug 'posva/vim-vue'
  Plug 'robertbasic/vim-hugo-helper'
  Plug 'ryanoasis/vim-devicons'
  Plug 'sgur/vim-textobj-parameter'
  Plug 'stefandtw/quickfix-reflector.vim'
  Plug 'tell-k/vim-autoflake', {'for': 'python'}
  Plug 'tpope/vim-dispatch'
  Plug 'tyru/capture.vim', {'on': 'Capture'}  " Show Ex command output in a buffer
  Plug 'tyru/open-browser-github.vim'
  Plug 'tyru/open-browser.vim'
  Plug 'vim-jp/vim-vimlparser'
  Plug 'vim-jp/vimdoc-ja'
  Plug 'vim-jp/vital.vim', {'on': 'Vitalize'}
  Plug 'vim-scripts/sudo.vim'
  Plug 'z0mbix/vim-shfmt'
  Plug 'kana/vim-operator-replace'
  function!s:plug.after.kana__vim__operator__replace()
    map _  <Plug>(operator-replace)
  endfunction
  Plug 'lambdalisue/vim-backslash'
  Plug 'kana/vim-textobj-line'
  Plug 'nikvdp/ejs-syntax'
  function!s:plug.after.nikvdp__ejs__syntax()
    autocmd BufNewFile,BufRead *.ejs set filetype=ejs
    autocmd BufNewFile,BufRead *._ejs set filetype=ejs
  endfunction
  Plug 'kkiyama117/zenn-vim'
  function!s:plug.after.kkiyama117__zenn__vim()
    let g:zenn#article#edit_new_cmd = 'new'

    " npm install zenn-cli@latest
    command! -nargs=0 ZennUpdate call zenn#update()

    " Run npx zenn preview
    " call "|:ZennPreview| or |:ZennPreview {port}|
    command! -nargs=* ZennPreview call zenn#preview(<f-args>)

    " Stop zenn preview process 
    command! -nargs=0 ZennStopPreview call zenn#stop_preview()

    " Create zenn new article
    command! -nargs=* ZennNewArticle call zenn#new_article(<f-args>)

    " Create zenn new book
    command! -nargs=* ZennNewBook call zenn#new_book(<f-args>)
  endfunction
  Plug 'osyo-manga/vim-brightest'
  function!s:plug.after.osyo__manga__vim__brightest()
    " ハイライトするグループ名を設定します
    " アンダーラインで表示する
    let g:brightest#highlight = {
    \   "group" : "BrightestUnderline"
    \}
  endfunction
  Plug 'vim-jp/autofmt'
  set formatexpr=autofmt#japanese#formatexpr()  " kaoriya版では設定済み
  let autofmt_allow_over_tw=1                   " 全角文字がぶら下がりで1カラムはみ出すのを許可
  set formatoptions+=mB     " または mM
  set smartindent
call s:plug.end()
" }}}

" Configure packages {{{
packadd go-imports
let g:goimports = v:true
let g:goimports_simplify = v:true
packadd go-coverage

packadd my-copy-buffer-name
packadd my-git-edit
packadd my-popup-info
packadd my-quote
packadd personal-ft
packadd personal-ft-diff
packadd personal-ft-go
packadd personal-ft-help
" }}}

" Functions {{{

" ConfigEdit {{{
def s:edit_config(bang: string, mods: string)
  if exists('g:fzf#vim#buffers')
    fzf#vim#files(g:xdg_config_home)
  else
    var cmd: string
    if mods == ''
      cmd = 'edit' .. bang
    else
      cmd = mods .. ' split'
    endif
    execute cmd .. ' ' .. $MYVIMRC
  endif
enddef
command! -bang -nargs=0 ConfigEdit call s:edit_config('<bang>', '<mods>')
nnoremap <Leader><Leader>c :<C-u>ConfigEdit<CR>
" }}}

" PlugEdit {{{
def s:edit_plug(dir: string, bang: string, mods: string)
  if exists('g:fzf#vim#buffers')
    fzf#vim#files(dir)
  else
    var cmd: string
    if mods == ''
      cmd = 'edit' .. bang
    else
      cmd = mods .. ' split'
    endif
    execute cmd .. ' ' .. dir
  endif
enddef
command! -bang -nargs=0 PlugEdit call s:edit_plug(g:plug_dir, '<bang>', '<mods>')
nnoremap <Leader><Leader>p :<C-u>PlugEdit<CR>
" }}}

" PlugAdd {{{
def s:plug_add(name: string)
  var cur_file = expand('%:p')
  if cur_file != $MYVIMRC
    execute ':edit ' .. escape($MYVIMRC, ' ')
  endif
  if expand('%:p') != $MYVIMRC
    return
  endif
  if &readonly == v:true
    if cur_file != $MYVIMRC
      execute ':bw'
    endif
    return
  endif
  execute ':%s/\n\(\n*call s:plug\.end()\)$/\r  Plug ' .. "'" .. escape(name, '/') .. "'" .. '\r\1/'
  execute ':w'
  if cur_file != $MYVIMRC
    execute ':bw'
  endif
  source $MYVIMRC
enddef
command! -nargs=1 PlugAdd call s:plug_add('<args>')
" }}}

" Update All {{{
def s:update_all()
  execute 'terminal ' .. &shell .. ' -c "source ' .. $ZDOTDIR .. '/.zshrc && update"'
enddef
command! UpdateAll call s:update_all()
" }}}

" Manage TODOs {{{
def s:grep_todo()
  grep! 'TODO\\|UNDONE\\|HACK\\|FIXME'
enddef
command! Todo call s:grep_todo()
command! ToDo call s:grep_todo()
command! TODO call s:grep_todo()
" }}}

" Function: Switch Branch {{{
def s:git_switch(line: string)
  var branch = get(split(line), 1, '')
  execute '!git switch ' .. branch
  lightline#update()
enddef

command! SwitchBranch call fzf#run(fzf#wrap(#{
    \ source: "git-branches --color !current",
    \ sink: function('<SID>git_switch'),
    \ }))
nnoremap <Leader>gb :<C-u>SwitchBranch<CR>
" }}}

" Function: Cleanup Branch {{{
command! CleanupBranch !git-branches cleanup
" }}}

" Function: Quote current filename and content {{{
nmap Y <Plug>(quotem-copy)
vmap Y <Plug>(quotem-copy)
" }}}

" }}}

" Command aliases & map {{{
command! Ghf OpenGithubFile
nmap <Leader>gd <Plug>(git-edit)
nmap <Leader>ic <Plug>(pinfo-show-cursor)
nmap <Leader>ib <Plug>(pinfo-show-buffer)
nmap <Leader>ih <Plug>(pinfo-show-highlight)
" }}}

" Settings {{{
" Stop All Default Plugins {{{
let g:loaded_gzip              = 1
let g:loaded_tar               = 1
let g:loaded_tarPlugin         = 1
let g:loaded_zip               = 1
let g:loaded_zipPlugin         = 1
let g:loaded_rrhelper          = 1
let g:loaded_2html_plugin      = 1
let g:loaded_vimball           = 1
let g:loaded_vimballPlugin     = 1
let g:loaded_getscript         = 1
let g:loaded_getscriptPlugin   = 1
" }}}

" Colors {{{
syntax enable
set termguicolors
set background=dark
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
set number
" }}}

" Show invisibles {{{
set list
set listchars=tab:»\ ,trail:∙,eol:↵,extends:»,precedes:«,nbsp:∙
" }}}

" Change cursor shape in different modes {{{
let &t_SI = "\<Esc>]50;CursorShape=1\x7"
let &t_SR = "\<Esc>]50;CursorShape=2\x7"
let &t_EI = "\<Esc>]50;CursorShape=0\x7"

" }}}

" Completion {{{
set wildmenu
set wildmode=longest:full,full
set completeopt=menuone,noinsert,popuphidden
set completepopup=border:on,align:item
" }}}

" Other misc settings {{{
set clipboard=unnamedplus,unnamed
set shortmess-=S
set shortmess+=I
set hidden              " able to edit without saving
set fixendofline        " <EOL> at the end of file will be restored if missing
set showcmd             " 
set textwidth=120         " never limit length of each line
set ambiwidth=double
set foldmethod=marker
set backspace=2
set cursorline   " Highlight cursor line
set showtabline=1
set hlsearch
set history=1000
set incsearch
set t_RV=
set scrolloff=3 " Show least &scrolloff lines before/after cursor
set sidescrolloff=3
set formatoptions+=j " Delete comment character when joining commented lines
set helplang=ja,en
highlight Pmenu ctermfg=159 ctermbg=17
language messages en_US.UTF-8
let g:html_indent_autotags='html,body,head,tbody,theadk' " seealso :help ft-html-indent
" }}}

" Setup Keymaps (for regular functions) {{{
" Delete search highlight
nnoremap <ESC><ESC> :<C-u>nohl<CR><ESC>

" Quickfix
nnoremap <Leader>q :<C-u>copen<CR><ESC>

nnoremap Q <Nop>
nnoremap gQ <Nop>
augroup TermMap
  " ターミナルで
  "   * <C-\><C-n> による job <- -> normal モードの往復を可能にする
  "   * q によるmacro記録を禁止する
  autocmd! TerminalOpen *
      \ nnoremap <buffer> <C-\><C-n> i|
      \ nnoremap <buffer> q <Nop>
augroup END

nnoremap <silent> tt :<C-u>terminal++curwin ++noclose <CR>
nnoremap <silent> tx :<C-u>terminal++noclose         <CR>
nnoremap <silent> tv :<C-u>vertical terminal++noclose<CR>

" }}}

" Function: Update Terminal Window Title {{{
function! Tapi_UpdateStatus(bufnum, arglist)
  if len(a:arglist) == 1
    call lightline#update()
  endif
endfunction
" }}}
" Function: Delete Terminal Buffer {{{
" ++nocloseで開くので、exitしたらそのままbuffer deleteしたい。
" zshrcの方で function :bd() としてこいつを呼び出してexitするコマンド :bd を定義済
function! Tapi_DeleteTerminalBuffer(bufnum, arglist)
  autocmd! SafeState <buffer> ++once bdelete
endfunction

" ++nocloseで開くので、exitしたらそのままbuffer wipeoutしたい。
" zshrcの方で function :bw() としてこいつを呼び出してexitするコマンド :bw を定義済
function! Tapi_WipeoutTerminalBuffer(bufnum, arglist)
  autocmd! SafeState <buffer> ++once bwipeout
endfunction

" }}}

" Setup terminal {{{
if executable('/usr/local/bin/zsh')
  set shell=/usr/local/bin/zsh
elseif executable('/usr/bin/zsh')
  set shell=/usr/bin/zsh
endif
"
" Shift+Space押しがち。邪魔なのでSpaceに置き換えちゃう
" https://github.com/vim-jp/issues/issues/1328
tnoremap <S-Space> <Space>

function s:term_setting()
  if &buftype ==# 'terminal'
    " 行番号を表示しない
    setlocal nonumber
    " wrapする（と、なぜかWrapしなくなる）
    setlocal nonumber nowrap
    " ノーマルモード、<Up>で一つ前のプロンプトに戻る
    nnoremap <buffer> <silent> <Up>   ?^\(\(([^)]\+) \)\=\$ .\+\)\@=<CR>
    " ノーマルモード、<Down>で一つ後のプロンプトに戻る
    nnoremap <buffer> <silent> <Down> /^\(\(([^)]\+) \)\=\$ .\+\)\@=<CR>
  endif
endfunction

augroup TermSetting
  " ターミナルでの設定
  autocmd! TerminalWinOpen * call s:term_setting()
augroup END
" }}}

" Load settings for each location {{{
augroup vimrc-local
  autocmd!
  autocmd DirChanged global call s:vimrc_local(expand('<afile>'))
augroup END

function! s:vimrc_local(loc)
  let files = findfile('.vimrc.local', escape(a:loc, ' ') . ';', -1)
  for i in reverse(filter(files, 'filereadable(v:val)'))
    source `=i`
  endfor
endfunction
" }}}

" Default Plugins {{{
let g:is_posix = 1
let g:vim_json_conceal = 0
" }}}

" Grep {{{
" auto-open quickfix
autocmd QuickfixCmdPost make,grep,grepadd,vimgrep if len(getqflist()) != 0 | copen | endif
" use rg for grep
if executable('rg')
  set grepprg=rg\ --vimgrep\ --no-heading
  set grepformat=%f:%l:%c:%m,%f:%l:%m
endif
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

" GVim Settings {{{
set columns=200
set lines=50
set guioptions=cei
set guifont=Cica\ 9.5
set mouse=
set guicursor=n-c:block-Cursor/lCursor,v:block-vCursor,ve:ver35-Cursor,o:hor50-Cursor,i-ci:ver25-Cursor/lCursor,r-cr:hor20-Cursor/lCursor,sm:block-Cursor,a:blinkwait333-blinkoff333-blinkon333
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

" }}}
