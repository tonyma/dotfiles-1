let g:plug_dir = expand('<sfile>:p:h:h' . 'plug')
call plug#begin(g:plug_dir)
  Plug 'prabirshrestha/vim-lsp'

  function! s:on_lsp_buffer_enabled() abort
    setlocal omnifunc=lsp#complete
  endfunction

  augroup lsp_install
    autocmd!
    " call s:on_lsp_buffer_enabled only for languages that has the server registered.
    autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
  augroup END

  Plug 'mattn/vim-lsp-settings'

  " Expand
  imap <expr> <C-j>   vsnip#expandable()  ? '<Plug>(vsnip-expand)'         : '<C-j>'
  smap <expr> <C-j>   vsnip#expandable()  ? '<Plug>(vsnip-expand)'         : '<C-j>'

  Plug 'hrsh7th/vim-vsnip'
  Plug 'hrsh7th/vim-vsnip-integ'

  Plug 'golang/vscode-go'
call plug#end()
