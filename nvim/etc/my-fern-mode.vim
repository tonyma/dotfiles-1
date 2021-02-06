function! s:init_fern()
  nmap <nowait> <buffer> !       <Plug>(fern-action-hidden:toggle)
  nmap <nowait> <buffer> /       <Plug>(fern-action-include)
  nmap <nowait> <buffer> <C-r>   <Plug>(fern-action-reload:cursor)
  nmap <nowait> <buffer> <C-S-r> <Plug>(fern-action-reload:all)
  nmap <nowait> <buffer> >       <Plug>(fern-action-expand:in)
  nmap <nowait> <buffer> <       <Plug>(fern-action-collapse)
  nmap <nowait> <buffer> -       <Plug>(fern-action-leave)
  nmap <nowait> <buffer> +       <Plug>(fern-action-enter)
  nmap <nowait> <buffer> <C-x>   <Plug>(fern-action-open:above)
  nmap <nowait> <buffer> <C-v>   <Plug>(fern-action-open:left)
  nmap <nowait> <buffer> <CR>    <Plug>(fern-action-open-or-expand)
  nmap <nowait> <buffer> <C-l>   <Plug>(fern-action-redraw)
  nmap <nowait> <buffer> y       <Plug>(fern-action-yank:bufname)
  nmap <nowait> <buffer> <C-g>   <Plug>(fern-action-cd)             " hint: 'G'oto dir

  nnoremap <nowait> <buffer> <C-x>      <cmd>call <SID>fern_mode_toggle()<CR>
endfunction

function! s:fern_mode_operate()
  if &ft != 'fern'
    return
  endif
  let b:my_fern_mode = 'operate'

  nmap <nowait> <buffer> <Space>     <Plug>(fern-action-mark:toggle)
  nmap <nowait> <buffer> <C-S-Space> <Plug>(fern-action-mark:clear)
  nmap <nowait> <buffer> <ESC>       <Plug>(fern-action-cancel)<Plug>(fern-action-mark:clear)<cmd>call <SID>fern_mode_view(v:false)<CR>
  nmap <nowait> <buffer> N           <Plug>(fern-action-new-path)
  nmap <nowait> <buffer> C           <Plug>(fern-action-copy)
  nmap <nowait> <buffer> M           <Plug>(fern-action-move)
  nmap <nowait> <buffer> D           <Plug>(fern-action-remove)

  highlight link FernRootSymbol   WarningMsg
  highlight link FernRootText     WarningMsg
  highlight link FernLeafSymbol   WarningMsg
  highlight link FernBranchSymbol WarningMsg
  highlight link FernBranchText   WarningMsg

  doautocmd User MyFernModeChanged
endfunction

function! s:fern_mode_view(init)
  if &ft != 'fern'
    return
  endif
  let b:my_fern_mode = 'view'

  if !a:init
    call fern#action#call('mark:clear')
  endif

  nmap <nowait> <buffer> <Space>     <Nop>
  nmap <nowait> <buffer> <C-S-Space> <Nop>
  nmap <nowait> <buffer> <ESC>       <Plug>(fern-action-cancel)
  nmap <nowait> <buffer> N           <Nop>
  nmap <nowait> <buffer> C           <Nop>
  nmap <nowait> <buffer> M           <Nop>
  nmap <nowait> <buffer> D           <Nop>

  highlight link FernRootSymbol   Directory
  highlight link FernRootText     Directory
  highlight link FernLeafSymbol   Directory
  highlight link FernBranchSymbol Directory
  highlight link FernBranchText   Directory

  doautocmd User MyFernModeChanged
endfunction

function! s:fern_mode_toggle()
  if &ft != 'fern'
    return
  endif
  if get(b:, 'my_fern_mode', '') !=# 'operate'
    call s:fern_mode_operate()
  else
    call s:fern_mode_view(v:false)
  endif
endfunction

augroup fern-mode
  autocmd!
  autocmd FileType fern call s:init_fern()
augroup END
