function! gitedit#select_commit() abort
  let l:preview_window = get(g:, 'fzf_preview_window', &columns >= 120 ? 'right': '')
  let l:options = [
        \  '--prompt', 'Edit> ',
        \  '--layout', 'reverse-list',
        \  ]

  let s:status = gitedit#get_status('', v:false)
  let l:preview_prefix = ''
  let l:preview_suffix = ''
  let l:source = 'git log --oneline --decorate=short --color'
  for l:key in ['Staged', 'Unstaged', 'Unmerged']
    if len(s:status[l:key]) > 0
      let l:source = 'echo ' . l:key . ';' . l:source
      let l:preview_prefix = l:preview_prefix . 'if [ {1} = "' . l:key . '" ];then;'
      for l:file in s:status[l:key]
        let l:preview_prefix = l:preview_prefix . 'echo "' . l:file . '";'
      endfor
      let l:preview_prefix = l:preview_prefix . 'el'
    endif
  endfor
  if l:preview_prefix !=# ''
    let l:preview_prefix = l:preview_prefix . 'se;'
    let l:preview_suffix = ';fi'
  endif
  let l:preview = l:preview_prefix . 'git diff-tree --no-commit-id --name-only -r {1}' . l:preview_suffix
  if len(l:preview_window)
    let l:options = extend(l:options, [
          \  '--preview', l:preview,
          \  ])
  endif
  call fzf#run(fzf#wrap({
  \ 'source': l:source,
  \ 'options': l:options,
  \ 'sink': function('<SID>select_file'),
  \ }))
endfunction

function! s:select_file(line) abort
  let l:preview_window = get(g:, 'fzf_preview_window', &columns >= 120 ? 'right': '')
  let l:options = [ '--prompt', 'Edit> ', '--select-1' ]
  if len(l:preview_window)
    let l:options = extend(l:options, get(fzf#vim#with_preview(
          \   {"placeholder": "{1}"},
          \   l:preview_window
          \ ), 'options', []))
  endif
  if a:line ==# ''
    return
  elseif a:line ==# 'Unmerged' || a:line ==# 'Unstaged' || a:line ==# 'Staged'
    let l:source = ''
    for l:file in s:status[a:line]
      let l:source = l:source . 'echo "' . l:file . '";'
    endfor
  else
    let l:commit = split(a:line, ' ')[0]
    echom 'selected commit: ' . l:commit
    let l:source = 'git diff-tree --no-commit-id --name-only -r ' . l:commit
  endif
  return fzf#run(fzf#wrap({
  \ 'source': l:source,
  \ 'options': l:options,
  \}))
endfunction

function! gitedit#get_status(path, branch) abort
  let l:status = {
        \ 'Unmerged': [],
        \ 'Staged': [],
        \ 'Unstaged': [],
        \ }
  " TODO: see
  " https://git-scm.com/docs/git-status#_porcelain_format_version_2 and
  " use porcelain v2
  let l:cmd = "git"
  if a:path !=# ''
    let l:cmd = l:cmd . " -C '" . a:path . "'"
  endif
  let l:cmd = l:cmd . " status --porcelain --untracked-files --ahead-behind --renames"
  if a:branch
    let l:cmd = l:cmd . ' --branch'
  endif
  let l:res = system(l:cmd)
  if l:res[0:6] ==# 'fatal: '
    return l:status
  endif
  for l:file in split(l:res, "\n")
    if l:file[0:1] ==# '##'
      call extend(l:status, s:parse_branch_status(l:file))
    elseif l:file[0] ==# 'U' || l:file[1] ==# 'U' || l:file[0:1] ==# 'AA' || l:file[0:1] ==# 'DD'
      call add(l:status['Unmerged'], l:file[3:])
    elseif l:file[0:1] ==# '??'
      call add(l:status['Untracked'], l:file[3:])
    else
      if l:file[0] !=# ' '
        call add(l:status['Staged'], l:file[3:])
      endif
      if l:file[1] !=# ' '
        call add(l:status['Unstaged'], l:file[3:])
      endif
    endif
  endfor
  return l:status
endfunction

function s:parse_branch_status(line) abort
  " ブランチ名を取得する
  let l:status = {}
  let l:words = split(a:line, '\.\.\.\|[ \[\],]')[1:]
  if len(l:words) == 1
    let l:status['local-branch'] = l:words[0] . '?'
    let l:status['sync'] = "\uf12a"
  else
    let [l:status['local-branch'], l:status['remote-branch']; l:remain] = l:words
    let l:key = ''
    for l:_ in l:remain
      if l:key !=# ''
        let l:status[l:key] = l:_
        let l:key = ''
      else
        let l:key = l:_
      endif
    endfor
  endif
  return l:status
endfunction
