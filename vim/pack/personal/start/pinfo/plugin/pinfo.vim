command! CursorInfo call pinfo#cursor#show()
nnoremap <silent> <Plug>(pinfo-show-cursor) :<C-u>CursorInfo<CR>

command! BufferInfo call pinfo#buffer#show()
nnoremap <silent> <Plug>(pinfo-show-buffer) :<C-u>BufferInfo<CR>

command! HighlightInfo call pinfo#highlight#show()
nnoremap <silent> <Plug>(pinfo-show-highlight) :<C-u>HighlightInfo<CR>
