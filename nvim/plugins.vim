let s:dir = g:xdg_data_home . "/vim-plug"
if !isdirectory(s:dir)
  call mkdir(s:dir, 'p')
endif

call plug#begin(s:dir)
  Plug 'thinca/vim-splash'
  let g:splash#path = $XDG_CONFIG_HOME . '/nvim/splash.txt'
  Plug 'roosta/vim-srcery'
  Plug 'kyoh86/momiji', { 'rtp': 'vim' }
  Plug 'tyru/capture.vim'  " Show Ex command output in a buffer
  Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
  Plug 'junegunn/fzf.vim'
  set rtp+=/usr/local/opt/fzf

  Plug 'editorconfig/editorconfig-vim'
  Plug 'kana/vim-textobj-user'
  Plug 'kana/vim-textobj-entire'
  Plug 'tpope/vim-surround'
  Plug 'Chiel92/vim-autoformat'
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
      let branch = fugitive#head()
      return branch !=# '' ? "\ue0a0 ".branch : ''
    endif
    return ''
  endfunction
  set laststatus=2  " statuslineは常に表示
  set noshowmode  " lightlineで表示するので、vim標準のモード表示は隠す

  Plug 'tpope/vim-dispatch'
  Plug 'romainl/vim-qf'
  let g:qf_auto_quit = 0  " disable `quit Vim if the last window is a location/quickfix window`
  function! BuildYCM(info)
    " info is a dictionary with 3 fields
    " - name:   name of the plugin
    " - status: 'installed', 'updated', or 'unchanged'
    " - force:  set on PlugInstall! or PlugUpdate!
    if a:info.status == 'installed' || a:info.force
      !./install.py
    endif
  endfunction

  Plug 'plasticboy/vim-markdown'
  let g:vim_markdown_folding_disabled = 1
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

  Plug 'tpope/vim-fugitive'
  Plug 'airblade/vim-gitgutter'
  Plug 'tpope/vim-rhubarb'
  Plug 'idanarye/vim-merginal'
  Plug 'w0rp/ale'  " Asynchronous Lint Engine
  let g:ale_enabled = 1
  let g:ale_sign_error = '>'
  let g:ale_sign_warning = '!'
  let g:ale_go_gometalinter_options = "--config=" . $XDG_CONFIG_HOME . "/gometalinter/config.json"
  let g:ale_linters = {
      \ 'javascript': ['eslint'],
      \ 'go': ['gometalinter', 'go build'],
      \ 'vim': ['vint']
  \ }
  let g:ale_fixers = {
      \ 'javascript': ['eslint']
  \ }
  let g:ale_fix_on_save = 1

  Plug 'maximbaz/lightline-ale'

  Plug 'simeji/winresizer'
  Plug 'thinca/vim-qfreplace'
  Plug 'kyoh86/vim-ripgrep', { 'branch': 'escape-vbars' }
  let g:rg_command = 'rg --vimgrep'
  let g:rg_escape_vbars = v:true

  " Language supports
  Plug 'cespare/vim-toml', {'for': 'toml'}
  Plug 'pangloss/vim-javascript', {'for': 'javascript'}
  Plug 'briancollins/vim-jst'
  let g:syntastic_go_checkers = ['golint', 'govet', 'go']
  Plug 'fatih/vim-go'
  let g:syntastic_go_checkers = ['golint', 'govet', 'go']
  let g:go_metalinter_command = "--config=" . $XDG_CONFIG_HOME . "/gometalinter/config.json"
  let g:go_fmt_command = "goimports"
  let g:go_highlight_functions = 1
  let g:go_highlight_string_spellcheck = 0
  let g:go_highlight_format_strings = 0

  Plug 'Glench/Vim-Jinja2-Syntax'
  Plug 'nsf/gocode', { 'rtp': 'vim', 'do': '~/.local/share/vim-plug/gocode/vim/symlink.sh' }
  Plug 'davidhalter/jedi-vim', {'for': 'python'}
  let g:jedi#completions_enabled = 0 " YouCompleteMeに任せる
  let g:jedi#show_call_signatures=0

  Plug 'aklt/plantuml-syntax'
  augroup PlantUMLCmd
    autocmd FileType plantuml command! OpenUml :!open -a "Google Chrome" %
  augroup END
  Plug 'elzr/vim-json'
  Plug 'syngan/vim-vimlint'
  Plug 'ynkdir/vim-vimlparser'
call plug#end()

let s:plug = {
      \ "plugs": get(g:, 'plugs', {})
      \ }

function! s:plug.is_installed(name)
  return has_key(self.plugs, a:name) ? isdirectory(self.plugs[a:name].dir) : 0
endfunction

function! s:plug.check_installation()
  if empty(self.plugs)
    return
  endif

  let list = []
  for [name, spec] in items(self.plugs)
    if !isdirectory(spec.dir)
      call add(list, spec.uri)
    endif
  endfor

  if len(list) > 0
    let unplugged = map(list, 'substitute(v:val, "^.*github\.com/\\(.*/.*\\)\.git$", "\\1", "g")')

    " Ask whether installing plugs like NeoBundle
    echomsg 'Not installed plugs: ' . string(unplugged)
    if confirm('Install plugs now?', "yes\nNo", 2) == 1
      PlugInstall
      echo "Pleaze restart vim"
    endif

  endif
endfunction

augroup CheckPlug
  autocmd!
  autocmd VimEnter * if !argc() | call s:plug.check_installation() | endif
augroup END
