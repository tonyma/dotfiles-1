if &buftype ==# 'help'
  finish
endif

" in editing

set colorcolumn=80
highlight  link  helpIgnore     PreProc
highlight  link  helpBar        PreProc
highlight  link  helpStar       PreProc
highlight  link  helpBacktick   PreProc
if has('conceal')
  set conceallevel=0
endif
