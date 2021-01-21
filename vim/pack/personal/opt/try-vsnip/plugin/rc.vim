let g:plug_dir = expand('<sfile>:p:h:h' . 'plug')
call plug#begin(g:plug_dir)
  Plug 'prabirshrestha/vim-lsp'

  function! s:on_lsp_buffer_enabled() abort
    setlocal omnifunc=lsp#complete
    setlocal signcolumn=yes
    setlocal tagfunc=lsp#tagfunc

    nmap <Leader>ld <Plug>(lsp-definition)
    nmap <Leader>ldf <Plug>(lsp-definition)
    nmap <Leader>ldc <Plug>(lsp-declaration)
    nmap <Leader>ldt <Plug>(lsp-type-definition)

    nmap <Leader>lh <Plug>(lsp-hover)
    nmap <Leader>ln <Plug>(lsp-next-error)
    nmap <Leader>lp <Plug>(lsp-previous-error)
    nmap <Leader>lf <Plug>(lsp-document-format)
    nmap <Leader>la <Plug>(lsp-code-action)
    nmap <Leader>ll <Plug>(lsp-document-diagnostics)
    nmap <Leader>ls <Plug>(lsp-status)
    nmap <Leader>li <Plug>(lsp-implementation)
    nmap <Leader>lr <Plug>(lsp-references)
    nmap <Leader>le <Plug>(lsp-rename)
  endfunction

  augroup lsp_install
    autocmd!
    " call s:on_lsp_buffer_enabled only for languages that has the server registered.
    autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
  augroup END

  let g:lsp_settings={}
  Plug 'mattn/vim-lsp-settings'

  Plug 'hrsh7th/vim-vsnip'
  Plug 'hrsh7th/vim-vsnip-integ'

  Plug 'golang/vscode-go'

call plug#end()
