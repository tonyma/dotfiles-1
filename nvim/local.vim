" Load settings for each location.
augroup vimrc-local
  autocmd!
  autocmd BufNewFile,BufReadPost * call s:vimrc_local(expand('<afile>:p:h'))
augroup END

function! s:vimrc_local(loc)
  let l:files = findfile('.vimrc.local', escape(a:loc, ' ') . ';', -1)
  for l:i in reverse(filter(l:files, 'filereadable(v:val)'))
    source `=l:i`
  endfor
endfunction

