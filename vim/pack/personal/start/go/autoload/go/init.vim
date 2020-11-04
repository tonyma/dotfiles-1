function! go#init#scaffold() abort
  let l:bytes = get(wordcount(), 'bytes', 0)
  if l:bytes != 0
    return
  endif

  let l:package_name = go#init#get_package_name()
  if l:package_name ==# ''
    return
  endif

  call setline(1, ['package ' . l:package_name, '', ''])
  call cursor(3, 1)
endfunction

function! go#init#get_package_name() abort
  let l:filename = expand('%:p')
  if l:filename ==# ''
    return ''
  endif

  let l:basename = fnamemodify(l:filename, ':t')
  if l:basename !~ '\.go$'
    return ''
  endif

  let l:dir = fnamemodify(l:filename, ':h')
  let l:dirname = fnamemodify(l:dir, ':t')

  " Search simbling *_test.go files and get package name from them
  if l:basename =~ '_test\.go$'
    for l:simb in glob(l:dir . '/*_test.go', v:true, v:true)
      for l:line in readfile(l:simb, v:null, get(g:, 'go_init_read_package_line_max_length', 10))
        let l:matches = matchlist(l:line, 'package \(.*\)')
        if len(l:matches) > 1
          return l:matches[1]
        endif
      endfor
    endfor
  endif

  " Search simbling *.go files (not *_test.go) and get package name from them
  let l:wildignore = &wildignore
  set wildignore=*_test.go
  let l:files = glob(l:dir . '/*.go', v:false, v:true)
  let &wildignore = l:wildignore

  for l:simb in l:files
    for l:line in readfile(l:simb, v:null, get(g:, 'go_init_read_package_line_max_length', 10))
      let l:matches = matchlist(l:line, 'package \(.*\)')
      if len(l:matches) > 1
        return l:matches[1]
      endif
    endfor
  endfor

  " If the file is the cmd/**/*.go, return 'main'
  let l:dir = fnamemodify(l:dir, ':h')
  let l:i = 0
  let l:prev = ''
  while l:i < 5 && l:dir != l:prev
    if fnamemodify(l:dir, ':t') ==# 'cmd'
      return 'main'
    endif
    let l:prev = l:dir
    let l:dir = fnamemodify(l:dir, ':h')
    let l:i = l:i + 1
  endwhile

  " Directory containing invalid charactors for package name, return 'main'
  if match(l:dirname, '[^0-9a-zA-Z_]') >= 0
    return 'main'
  endif

  return l:dirname
endfunction
