command! CopyBufferName call copy_buffer_name#copy()
command! CopyBufferFullName call copy_buffer_name#copy('p')

nnoremap <silent> <Leader>%y :<C-u>CopyBufferName<CR>
nnoremap <silent> <Leader>%Y :<C-u>CopyBufferFullName<CR>
