" go.vim: Utilities for working with Go files.

" Get the package path for the file in the current buffer.
fun! go#coverage#go#package() abort
  let [l:out, l:err] = go#coverage#system#run(['go', 'list', './' . expand('%:h')])
  if l:err || l:out[0] is# '_'
    if l:out[0] is# '_' || go#coverage#str#has_suffix(l:out, 'cannot import absolute path')
      let l:out = 'cannot determine module path (outside GOPATH, no go.mod)'
    endif
    call go#msg#error(l:out)
    return ''
  endif

  return l:out
endfun

" Get path to file in current buffer as package/path/file.go
fun! go#coverage#go#packagepath() abort
  return go#coverage#go#package() . '/' . expand('%:t')
endfun

let s:go_commands = ['go', 'bug', 'build', 'clean', 'doc', 'env', 'fix', 'fmt',
                   \ 'generate', 'get', 'install', 'list', 'mod', 'run', 'test',
                   \ 'tool', 'version', 'vet']

" Add g:go_coverage_build_tags to the flag_list; will be merged with existing tags
" (if any).
fun! go#coverage#go#add_build_tags(flag_list) abort
  if get(g:, 'go_coverage_build_tags', []) == []
    return a:flag_list
  endif

  if type(a:flag_list) isnot v:t_list
    call go#msg#error('add_build_tags: not a list: %s', a:flag_list)
    return a:flag_list
  endif

  let l:last_flag = 0
  for l:i in range(len(a:flag_list))
    if a:flag_list[l:i][0] is# '-' || index(s:go_commands, a:flag_list[l:i]) > -1
      let l:last_flag = l:i
    endif

    if a:flag_list[l:i] is# '-tags'
      let l:tags = uniq(split(trim(a:flag_list[l:i+1], "\"'"), ' ') + g:go_coverage_build_tags)
      return a:flag_list[:l:i]
            \ + ['"' . join(l:tags, ' ') . '"']
            \ +  a:flag_list[l:i+2:]
    endif
  endfor

  return a:flag_list[:l:last_flag]
        \ + ['-tags', '"' . join(g:go_coverage_build_tags, ' ') . '"']
        \ + a:flag_list[l:last_flag+1:]
endfun
