highlight link FernMarkedLine PmenuSel

function! s:open_dir()
  if &buftype !=# ''
    echom 'is not file buffer'
    return '-'
  endif

  let l:dirname = expand('%:p:h')
  if !isdirectory(l:dirname)
    echom 'is not dir'
    return '-'
  endif
  return ':edit ' .. l:dirname .. ''
endfunction
nmap <silent> <expr> - <SID>open_dir()
