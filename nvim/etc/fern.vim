echomsg 'init-fern'

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

  let b:my_fern_mode = 'view'
  nnoremap <nowait> <buffer> <C-x>      <Cmd>call <SID>fern_mode_toggle()<CR>
endfunction

function! s:fern_mode_operator()
  if &ft != 'fern'
    return
  endif
  let b:my_fern_mode = 'operator'

  nmap <nowait> <buffer> <Space>     <Plug>(fern-action-mark:toggle)
  nmap <nowait> <buffer> <C-S-Space> <Plug>(fern-action-mark:clear)
  nmap <nowait> <buffer> <ESC>       <Plug>(fern-action-cancel)<Plug>(fern-action-mark:clear)<Cmd>call <SID>fern_mode_view()<CR>
  nmap <nowait> <buffer> N           <Plug>(fern-action-new-path)
  nmap <nowait> <buffer> C           <Plug>(fern-action-copy)
  nmap <nowait> <buffer> M           <Plug>(fern-action-move)
  nmap <nowait> <buffer> D           <Plug>(fern-action-remove)

  highlight link FernRootSymbol   MomijiBlue
  highlight link FernRootText     MomijiBlue
  highlight link FernLeafSymbol   MomijiBlue
  highlight link FernBranchSymbol MomijiBlue
  highlight link FernBranchText   MomijiBlue

  lua require("galaxyline").load_galaxyline()
endfunction

function! s:fern_mode_view()
  if &ft != 'fern'
    return
  endif
  let b:my_fern_mode = 'view'

  call fern#action#call('mark:clear')

  nmap <nowait> <buffer> <Space>     <Nop>
  nmap <nowait> <buffer> <C-S-Space> <Nop>
  nmap          <buffer> <ESC>       <Plug>(fern-action-cancel)
  nmap <nowait> <buffer> N           <Nop>
  nmap <nowait> <buffer> C           <Nop>
  nmap <nowait> <buffer> M           <Nop>
  nmap <nowait> <buffer> D           <Nop>

  highlight link FernRootSymbol   Directory
  highlight link FernRootText     Directory
  highlight link FernLeafSymbol   Directory
  highlight link FernBranchSymbol Directory
  highlight link FernBranchText   Directory

  lua require("galaxyline").load_galaxyline()
endfunction

function! s:fern_mode_toggle()
  if &ft != 'fern'
    return
  endif
  if get(b:, 'my_fern_mode') != 'operator'
    call s:fern_mode_operator()
  else
    call s:fern_mode_view()
  endif
endfunction

highlight link FernMarkedLine PmenuSel
augroup my-fern
  autocmd!
  autocmd FileType fern call s:init_fern()
augroup END
