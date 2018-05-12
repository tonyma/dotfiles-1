" Delete search highlight
nnoremap <silent> <ESC><ESC> :nohl<CR><ESC>

" FZFs
nnoremap <C-x><C-f> :Files<CR>
nnoremap <C-x><C-w> :Windows<CR>
nnoremap <C-x><C-b> :Buffers<CR>
nnoremap <C-x><C-i> :History<CR>
nnoremap <C-x><C-_> :Rg 

" Git
nnoremap <C-x><C-g><C-s> :Gstatus<CR>
" SwitchBranch
nnoremap <C-x><C-g><C-b> :call SwitchBranch()<CR>

" go
augroup GoDefCmd
  autocmd FileType go nmap <buffer> <leader>g <Plug>(go-def)
augroup END

" ALE
nmap <C-x><C-l><C-n> <Plug>(ale_next)
nmap <C-x><C-l><C-p> <Plug>(ale_previous)

" Quickfix
nnoremap <buffer> <C-x><C-q> :copen<CR>

nnoremap Q <Nop>

nnoremap <C-x> <Nop>
