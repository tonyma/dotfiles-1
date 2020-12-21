command! -range QuotemCopy :call quotem#copy(<line1>, <line2>)
nnoremap <silent> <Plug>(quotem-copy) :<C-u>     QuotemCopy<CR>
vnoremap <silent> <Plug>(quotem-copy) :<C-u>'<,'>QuotemCopy<CR>

command! -range QuotemCopyName :call quotem#copy(<line1>, <line2>, 't')
nnoremap <silent> <Plug>(quotem-copy-name) :<C-u>     QuotemCopyName<CR>
vnoremap <silent> <Plug>(quotem-copy-name) :<C-u>'<,'>QuotemCopyName<CR>

command! -range QuotemCopyFull :call quotem#copy(<line1>, <line2>, 'p')
nnoremap <silent> <Plug>(quotem-copy-full) :<C-u>     QuotemCopyFull<CR>
vnoremap <silent> <Plug>(quotem-copy-full) :<C-u>'<,'>QuotemCopyFull<CR>
