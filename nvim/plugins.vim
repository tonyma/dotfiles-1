let s:dir = g:xdg_data_home . "/vim-plug"
if !isdirectory(s:dir)
  call mkdir(s:dir, 'p')
endif

call plug#begin(s:dir)
  Plug 'thinca/vim-splash'
  let g:splash#path = $XDG_CONFIG_HOME . '/nvim/splash.txt'
  Plug 'roosta/vim-srcery'
  Plug 'tyru/capture.vim'  " Show Ex command output in a buffer
  Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
  Plug 'junegunn/fzf.vim'
  set rtp+=/usr/local/opt/fzf

  Plug 'kana/vim-textobj-user'
  Plug 'kana/vim-textobj-entire'
  Plug 'Chiel92/vim-autoformat'
  Plug 'itchyny/lightline.vim'
  let g:lightline = {
    \   'colorscheme': 'jellybeans',
    \   'active': {
    \     'left': [
    \       [ 'mode', 'paste' ],
    \       [ 'gitbranch', 'readonly', 'filename', 'modified' ],
    \     ],
    \   },
    \   'component': {
    \     'filename': '%n:%f'
    \   },
    \   'component_function': {
    \     'gitbranch': 'fugitive#head',
    \   },
    \ }
  set laststatus=2  " statuslineは常に表示
  set noshowmode  " lightlineで表示するので、vim標準のモード表示は隠す

  Plug 'tpope/vim-dispatch'
  Plug 'romainl/vim-qf'
  let g:qf_auto_quit = 0  " disable `quit Vim if the last window is a location/quickfix window`
  Plug 'Valloric/YouCompleteMe'
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
  let g:ale_sign_column_always = 1
  " Set this. Airline will handle the rest.
  let b:ale_linters = {
  \   'javascript': ['eslint'],
  \   'go': ["gometalinter --config=" . $XDG_CONFIG_HOME . "/gometalinter/config.json"],
  \}
  " show ALE error messages in lightline
  function! s:ale_string(mode)
    if !exists('g:ale_buffer_info')
      return ''
    endif

    let l:buffer = bufnr('%')
    let [l:error_count, l:warning_count] = ale#statusline#Count(l:buffer)
    let [l:error_format, l:warning_format, l:no_errors] = g:ale_statusline_format

    if a:mode == 0 " Error
      return l:error_count ? printf(l:error_format, l:error_count) : ''
    elseif a:mode == 1 " Warning
      return l:warning_count ? printf(l:warning_format, l:warning_count) : ''
    endif

    return l:error_count == 0 && l:warning_count == 0 ? l:no_errors : ''
  endfunction
  augroup LightLineOnALE
    autocmd!
    autocmd User ALELint call lightline#update()
  augroup END

  Plug 'simeji/winresizer'
  Plug 'thinca/vim-qfreplace'
  Plug 'jremmen/vim-ripgrep'

  " Language supports
  Plug 'cespare/vim-toml', {'for': 'toml'}

  Plug 'fatih/vim-go'
  let g:syntastic_go_checkers = ['go', 'golint', 'govet']
  let g:go_metalinter_command = "--config=" . $XDG_CONFIG_HOME . "/gometalinter/config.json"
  let g:go_fmt_command = "goimports"
  let g:go_highlight_string_spellcheck = 0
  let g:go_highlight_format_strings = 0

  Plug 'Glench/Vim-Jinja2-Syntax'
  Plug 'nsf/gocode', { 'rtp': 'vim', 'do': '~/.vim/plugged/gocode/vim/symlink.sh' }
  Plug 'davidhalter/jedi-vim', {'for': 'python'}
  let g:jedi#completions_enabled = 0 " YouCompleteMeに任せる
  let g:jedi#show_call_signatures=0

  Plug 'pangloss/vim-javascript'
  Plug 'ryym/vim-riot' " riot.js
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
