if exists("b:did_ftplugin")
  finish
endif
let b:did_ftplugin = 1

setlocal formatoptions-=t
setlocal comments=s1:/*,mb:*,ex:*/,://
setlocal commentstring=//\ %s
setlocal foldmethod=syntax
setlocal noexpandtab

augroup personal-ft-go-augroup
  autocmd!
  autocmd BufEnter *.go command! -buffer -bang GoOpenTest call go#open#toggle_test('%:p', '<mods>', '<bang>')
augroup END

call go#init#scaffold()
