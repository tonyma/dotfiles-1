set encoding=utf-8
scriptencoding utf-8

let s:dir = g:xdg_data_home . '/vim-plug'
if !isdirectory(s:dir)
  call mkdir(s:dir, 'p')
endif

call plug#begin(s:dir)
  " {{{ thinca/vim-splash
  Plug 'thinca/vim-splash'
  let g:splash#path = $XDG_CONFIG_HOME . '/nvim/splash.txt'
  " }}}

  Plug 'roosta/vim-srcery'
  Plug 'kyoh86/momiji', { 'rtp': 'vim' }
  Plug 'tyru/capture.vim'  " Show Ex command output in a buffer

  " {{{ junegunn/fzf
  Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' } 
  Plug 'junegunn/fzf.vim'
  set runtimepath+=/usr/local/opt/fzf
  " }}}

  Plug 'justinmk/vim-dirvish'
  Plug 'kristijanhusak/vim-dirvish-git'
  Plug 'editorconfig/editorconfig-vim'
  Plug 'kana/vim-textobj-user'
  Plug 'kana/vim-textobj-entire'
  Plug 'tpope/vim-surround'
  Plug 'Chiel92/vim-autoformat'

  " {{{ itchyny/lightline.vim
  Plug 'itchyny/lightline.vim'
  let g:lightline = {
    \   'colorscheme': 'momiji',
    \   'separator': {
    \     'left': "\ue0b0",
    \     'right': "\ue0b2"
    \   },
    \   'subseparator': {
    \     'left': "\ue0b1",
    \     'right': "\ue0b3"
    \   },
    \   'active': {
    \     'left': [
    \       [ 'mode', 'paste' ],
    \       [ 'gitbranch', 'readonly', 'filename', 'modified' ]
    \     ],
    \     'right': [
    \       [ 'linter_ok', 'linter_errors', 'linter_warnings' ],
    \       [ 'fileformat', 'fileencoding', 'filetype', 'percent', 'lineinfo' ]
    \     ]
    \   },
    \   'component': {
    \     'lineinfo': "\ue0a1%3l:%-2v",
    \     'filename': '%n:%f'
    \   },
    \   'component_expand': {
    \     'linter_ok': 'lightline#ale#ok',
    \     'linter_warnings': 'lightline#ale#warnings',
    \     'linter_errors': 'lightline#ale#errors',
    \   },
    \   'component_type': {
    \     'linter_warnings': 'warning',
    \     'linter_errors': 'error',
    \   },
    \   'component_function': {
    \     'readonly': 'LightlineReadonly',
    \     'gitbranch': 'LightlineFugitive'
    \   },
    \ }
  function! LightlineReadonly()
    return &readonly ? "\ue0a2" : ''
  endfunction
  function! LightlineFugitive()
    if exists('*fugitive#head')
      let l:branch = fugitive#head()
      return l:branch !=# '' ? "\ue0a0 ".l:branch : ''
    endif
    return ''
  endfunction
  set laststatus=2  " statuslineは常に表示
  set noshowmode  " lightlineで表示するので、vim標準のモード表示は隠す
  " }}}

  Plug 'leafgarland/typescript-vim', { 'for': 'typescript' }
  Plug 'tpope/vim-dispatch'

  " {{{ romainl/vim-qf
  Plug 'romainl/vim-qf'
  let g:qf_auto_quit = 0  " disable `quit Vim if the last window is a location/quickfix window`
  " }}}

  " {{{ plasticboy/vim-markdown
  Plug 'plasticboy/vim-markdown'
  let g:vim_markdown_folding_disabled = 1
  let g:vim_markdown_fenced_languages = ['c++=cpp', 'viml=vim', 'bash=sh', 'ini=dosini', 'uml=plantuml']
  let g:vim_markdown_math = 1
  let g:vim_markdown_frontmatter = 1
  let g:vim_markdown_toml_frontmatter = 1
  let g:vim_markdown_json_frontmatter = 1
  let g:vim_markdown_conceal = 0
  let g:tex_conceal = ''
  " }}}

  Plug 'kyoh86/vim-hugo'

  " {{{ 'Valloric/YouCompleteMe'
  function! BuildYCM(info)
    " info is a dictionary with 3 fields
    " - name:   name of the plugin
    " - status: 'installed', 'updated', or 'unchanged'
    " - force:  set on PlugInstall! or PlugUpdate!
    if a:info.status ==# 'installed' || a:info.force
      !./install.py --clang-completer --go-completer --java-completer --enable-coverage --clang-tidy
    endif
  endfunction
  Plug 'Valloric/YouCompleteMe', { 'do': function('BuildYCM') }
  let g:ycm_filetype_blacklist = {
      \ 'tagbar' : 1,
      \ 'qf' : 1,
      \ 'notes' : 1,
      \ 'markdown' : 1,
      \ 'unite' : 1,
      \ 'text' : 1,
      \ 'vimwiki' : 1,
      \ 'pandoc' : 1,
      \ 'infolog' : 1,
      \ 'mail' : 1
      \}
  let g:ycm_auto_trigger = 0
  let g:ycm_key_invoke_completion = '<C-x><C-o>'
  " }}}

  Plug 'tpope/vim-fugitive'
  Plug 'airblade/vim-gitgutter'
  Plug 'tpope/vim-rhubarb'
  Plug 'idanarye/vim-merginal'
  Plug 'tell-k/vim-autoflake'

  " {{{ w0rp/ale (Asynchronous Lint Engine)
  Plug 'w0rp/ale'  
  let g:ale_enabled = 1
  let g:ale_sign_error = '>'
  let g:ale_sign_warning = '!'
  let g:ale_go_gometalinter_options = '--config=' . $XDG_CONFIG_HOME . '/gometalinter/config.json'
  let g:ale_python_mypy_options = '--ignore-missing-imports --strict'
  let g:ale_completion_enabled = 1
  let g:ale_linters = {
      \ 'javascript': ['eslint'],
      \ 'go': ['gometalinter', 'go build'],
      \ 'vim': ['vint'],
      \ 'python': ['mypy', 'flask8', 'pylint']
  \ }
  let g:ale_fixers = {
      \ 'typescript': ['tslint'],
      \ 'javascript': ['eslint'],
      \ 'python': ['autopep8', 'yapf']
  \ }
  let g:ale_fix_on_save = 1
  " }}}

  Plug 'maximbaz/lightline-ale'

  Plug 'simeji/winresizer'

  " {{{ kyoh86/vim-qfreplace
  Plug 'kyoh86/vim-qfreplace'
  augroup Qfreplacer
    autocmd BufReadPost quickfix nnoremap <buffer> <c-x><c-r> :Qfreplace<CR>
  augroup END
  " }}}

   " {{{ kyoh86/vim-ripgrep
  Plug 'kyoh86/vim-ripgrep', { 'branch': 'escape-vbars' }
  let g:rg_command = 'rg --vimgrep'
  let g:rg_escape_vbars = v:true
  " }}}

  Plug 'cespare/vim-toml', {'for': 'toml'}
  Plug 'pangloss/vim-javascript', {'for': 'javascript'}
  Plug 'briancollins/vim-jst'

  " {{{ fatih/vim-go
  Plug 'fatih/vim-go'
  let g:go_metalinter_command = '--config=' . $XDG_CONFIG_HOME . '/gometalinter/config.json'
  let g:go_fmt_command = 'goimports'
  let g:go_highlight_functions = 1
  let g:go_highlight_string_spellcheck = 0
  let g:go_highlight_format_strings = 0
  " }}}

  Plug 'Glench/Vim-Jinja2-Syntax'
  Plug 'nsf/gocode', { 'rtp': 'vim', 'do': '~/.local/share/vim-plug/gocode/vim/symlink.sh' }

  " {{{ davidhalter/jedi-vim
  Plug 'davidhalter/jedi-vim', {'for': 'python'} 
  let g:jedi#completions_enabled = 0 " YouCompleteMeに任せる
  let g:jedi#show_call_signatures = 1
  " }}}

  " {{{ 'lambdalisue/vim-pyenv'
  Plug 'lambdalisue/vim-pyenv', {'for': 'python'}

  function! s:jedi_auto_force_py_version() abort
    let g:jedi#force_py_version = pyenv#python#get_internal_major_version()
  endfunction
  augroup vim-pyenv-custom-augroup
    autocmd! *
    autocmd User vim-pyenv-activate-post   call s:jedi_auto_force_py_version()
    autocmd User vim-pyenv-deactivate-post call s:jedi_auto_force_py_version()
  augroup END
  " }}}

  " {{{ aklt/plantuml-syntax
  Plug 'aklt/plantuml-syntax'
  augroup PlantUMLCmd
    autocmd FileType plantuml command! OpenUml :!open -a "Google Chrome" %
  augroup END
  " }}}

  Plug 'kazuph/previm', { 'branch': 'feature/add-plantuml-plugin' }
  Plug 'tyru/open-browser.vim'

  " {{{ elzr/vim-json
  Plug 'elzr/vim-json'
  let g:vim_json_syntax_conceal = 0
  " }}}

  Plug 'syngan/vim-vimlint'
  Plug 'ynkdir/vim-vimlparser'
call plug#end()

let s:plug = {
      \ 'plugs': get(g:, 'plugs', {})
      \ }

function! s:plug.is_installed(name)
  return has_key(l:self.plugs, a:name) ? isdirectory(l:self.plugs[a:name].dir) : 0
endfunction

function! s:plug.check_installation()
  if empty(l:self.plugs)
    return
  endif

  let l:list = []
  for [l:name, l:spec] in items(l:self.plugs)
    if !isdirectory(l:spec.dir)
      call add(l:list, l:spec.uri)
    endif
  endfor

  if len(l:list) > 0
    let l:unplugged = map(l:list, 'substitute(v:val, "^.*github\.com/\\(.*/.*\\)\.git$", "\\1", "g")')

    " Ask whether installing plugs like NeoBundle
    echomsg 'Not installed plugs: ' . string(l:unplugged)
    if confirm('Install plugs now?', "yes\nNo", 2) == 1
      PlugInstall
      echo 'Pleaze restart vim'
    endif

  endif
endfunction

augroup CheckPlug
  autocmd!
  autocmd VimEnter * if !argc() | call s:plug.check_installation() | endif
augroup END
