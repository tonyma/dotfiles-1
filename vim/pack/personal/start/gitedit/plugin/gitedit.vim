command! GitEdit call gitedit#select_commit()
nnoremap <silent> <Plug>(git-edit) :<C-u>GitEdit<CR>
