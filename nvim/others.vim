" Colors {{{
syntax enable
set termguicolors
set background=dark
set hlsearch
colorscheme momiji
" }}}

" Indents {{{
set tabstop=2
set autoindent
set shiftwidth=2
set expandtab
set nowrap
" }}}

" Displays {{{
set number       " Show the line number
set emo          " Show emoji characters
set conceallevel=0
" }}}

" Show invisibles {{{
set list
set listchars=tab:»\ ,trail:∙,eol:↵,extends:»,precedes:«,nbsp:∙
" }}}

" Change cursor shape in different modes {{{
if exists('$TMUX')
  let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
  let &t_SR = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=2\x7\<Esc>\\"
  let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
else
  let &t_SI = "\<Esc>]50;CursorShape=1\x7"
  let &t_SR = "\<Esc>]50;CursorShape=2\x7"
  let &t_EI = "\<Esc>]50;CursorShape=0\x7"
endif

let $NVIM_TUI_ENABLE_CURSOR_SHAPE=1
set guicursor=n-v-c:block-Cursor/lCursor-blinkon0,i-ci:ver25-Cursor/lCursor,r-cr:hor20-Cursor/lCursor
" }}}

" Completion {{{
set wildmode=longest:full,full
set completeopt=menu,menuone
let g:pymode_rope_complete_on_dot = 0
" }}}

" Other misc settings {{{
set clipboard+=unnamedplus,unnamed
set fixendofline
set showcmd
set ambiwidth=double
set foldmethod=marker
set backspace=2  
set cursorline   " Highlight cursor line
highlight Pmenu ctermfg=159 ctermbg=17
" }}}

" Function: Load Configurations {{{
let g:config_home = $HOME . '/.vim'
function! Config(bang)
  execute 'edit'.a:bang g:config_home
endfunction
command! -bang -nargs=0 Config :call Config('<bang>')

if !exists("*ConfigReload")
  function! ConfigReload()
    " reload vimrc
    execute 'source $MYVIMRC'
  endfunction
endif
command! -nargs=0 ConfigReload :call ConfigReload()
command! -nargs=0 Reload :call ConfigReload()
" }}}

" Function: Switch branch {{{
function! SwitchBranch()
  let l:source = "git-branches --color --exclude-current"
  echo l:source
  let l:selected = fzf#run({'source': l:source, 'options': ['--border']})
  let l:selected = get(split(get(l:selected, 0, '')), 1, '')
  if l:selected !=# ''
    " change branch
    call system("git checkout ".l:selected)
  endif
endfunction
" }}}
