" Curtain.vim
" Resize and move windows easily like open and close a curtain.
"
" AUTHOR: kyoh86 <me@kyoh86.dev>
" LICENSE: MIT

"TODO: support changing keys
let s:keys = {
      \ 'focus left':  'h',
      \ 'focus below': 'j',
      \ 'focus above': 'k',
      \ 'focus right': 'l',
      \
      \ 'increase left':  '<left>',
      \ 'increase below': '<down>',
      \ 'increase above': '<up>',
      \ 'increase right': '<right>',
      \
      \ 'decrease left':  '<s-left>',
      \ 'decrease below': '<s-down>',
      \ 'decrease above': '<s-up>',
      \ 'decrease right': '<s-right>',
      \
      \ 'move to left':  '<leader>h',
      \ 'move to below': '<leader>j',
      \ 'move to above': '<leader>k',
      \ 'move to right': '<leader>l',
      \ }

" window informations:
"   - botline   last displayed buffer line
"   - bufnr     number of buffer in the window
"   - height    window height (excluding winbar)
"   - loclist   1 if showing a location list
"   - quickfix  1 if quickfix or location list window
"   - terminal  1 if a terminal window
"   - tabnr     tab page number
"   - topline   first displayed buffer line
"   - variables a reference to the dictionary with window-local variables
"   - width     window width
"   - winbar    1 if the window has a toolbar, 0 otherwise
"   - wincol    leftmost screen column of the window
"   - winid     window-ID
"   - winnr     window number
"   - winrow    topmost screen column of the window
let s:windows = []

function! s:key_msg(key)
  return a:key . ': ' . s:keys[a:key]
endfunction

function! s:edge_msg(edge)
  return map(['move to', 'increase', 'decrease', 'focus'], {_, v -> s:key_msg(v . ' ' . a:edge)})
endfunction

function! s:center(text, width)
  let l:padding = a:width - len(a:text)
  if l:padding > 0
    return repeat(' ', l:padding/2) . a:text
  endif
  return a:text
endfunction

function! s:set_keymap(base_win, buf)
  call nvim_set_current_win(a:base_win.winid)
  let l:left_winnr = winnr('h')
  let l:below_winnr = winnr('j')
  let l:above_winnr = winnr('k')
  let l:right_winnr = winnr('l')
  let l:cur_winnr = winnr()

  " pad lines
  for l:row in range(a:base_win.height)
    call setbufline(a:buf, l:row, ' ')
  endfor

  if l:above_winnr isnot l:cur_winnr
    call setbufline(a:buf, 1, s:center(join(s:edge_msg('above'), '; '), a:base_win.width))
    call nvim_buf_set_keymap(a:buf, 'n', s:keys['focus above'], '<cmd>call curtain#focus(' . l:above_winnr . ')<cr>', {'noremap': v:true})
  endif

  if l:left_winnr isnot l:cur_winnr
    let l:show_left = v:true && a:base_win.height >= 5
    call nvim_buf_set_keymap(a:buf, 'n', s:keys['focus left'], '<cmd>call curtain#focus(' . l:left_winnr . ')<cr>', {'noremap': v:true})
  else
    let l:show_left = v:false
  endif

  if l:right_winnr isnot l:cur_winnr
    let l:show_right = v:true && a:base_win.height >= 4 + 2
    call nvim_buf_set_keymap(a:buf, 'n', s:keys['focus right'], '<cmd>call curtain#focus(' . l:right_winnr . ')<cr>', {'noremap': v:true})
  else
    let l:show_right = v:false
  endif

  if l:show_left || l:show_right
    let l:side_msg_row = a:base_win.height/2-1
    let l:left_msg = s:edge_msg('left')
    let l:right_msg = s:edge_msg('right')
    for l:row in range(4)
      if l:show_left
        let l:left_msgline = l:left_msg[l:row]
      else
        let l:left_msgline = ''
      endif
      if l:show_right
        let l:right_msgline = l:right_msg[l:row]
      else
        let l:right_msgline = ''
      endif
      let l:space = a:base_win.width - len(l:left_msgline) - len(l:right_msgline)
      if l:space < 1
        call setbufline(a:buf, l:side_msg_row + l:row, ' ')
      else
        call setbufline(a:buf, l:side_msg_row + l:row, l:left_msgline . repeat(' ', l:space) . l:right_msgline)
      endif
    endfor
  endif

  if l:below_winnr isnot l:cur_winnr
    call setbufline(a:buf, a:base_win.height, s:center(join(s:edge_msg('below'), '; '), a:base_win.width))
    call nvim_buf_set_keymap(a:buf, 'n', s:keys['focus below'], '<cmd>call curtain#focus(' . l:below_winnr . ')<cr>', {'noremap': v:true})
  endif
endfunction

function! s:set_autocmd(buf)
  augroup curtain.nvim
    autocmd!
    execute 'autocmd WinLeave <buffer=' . a:buf . '> execute("bwipeout! ' . a:buf . '")'
    " TODO: follow resize
    " TODO: follow move
  augroup END
endfunction

function! s:set_option(buf)
  call nvim_buf_set_option(a:buf, 'readonly', v:true)
  call nvim_buf_set_option(a:buf, 'filetype', 'curtain')
  call nvim_buf_set_option(a:buf, 'buftype', 'nofile')
endfunction

function! curtain#focus(winnr)
  let l:win_index = a:winnr - 1
  let l:win = s:windows[l:win_index]
  let l:buf = nvim_create_buf(v:false, v:true)
  call s:set_keymap(l:win, l:buf)
  call s:set_autocmd(l:buf)
  call s:set_option(l:buf)

  call nvim_open_win(l:buf, v:true, {
        \ 'relative': 'win',
        \ 'win': l:win.winid,
        \ 'width': l:win.width,
        \ 'height': l:win.height,
        \ 'row': 0,
        \ 'col': 0,
        "\ 'focusable': v:false, TODO: enable this option
        \ 'style': 'minimal',
        \ })
endfunction

function! curtain#start()
  if winnr('$') == 1
    return
  endif

  let l:tabnr = tabpagenr()
  let s:windows = filter(getwininfo(), {_, item -> item.tabnr is l:tabnr})
  if len(s:windows) is 0
    return
  endif

  call curtain#focus(winnr())
endfunction

call curtain#start()
