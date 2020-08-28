function! gitedit#select_commit() abort
  let l:preview_window = get(g:, 'fzf_preview_window', &columns >= 120 ? 'right': '')
  let l:options = [
        \  '--prompt', 'Edit> ',
        \  '--layout', 'reverse-list',
        \  ]
  if len(l:preview_window)
    let l:options = extend(l:options, [
          \  '--preview', 'git diff-tree --no-commit-id --name-only -r {1}',
          \  ])
  endif

  call fzf#run(fzf#wrap({
  \ 'source': 'git log --oneline --decorate=short --color',
  \ 'options': l:options,
  \ 'sink': function('<SID>select_file'),
  \ }))
endfunction

function! s:select_file(line) abort
  if a:line ==# ''
    return
  endif
  let l:commit = split(a:line, ' ')[0]
  echom 'selected commit: ' . l:commit

  let l:preview_window = get(g:, 'fzf_preview_window', &columns >= 120 ? 'right': '')
  let l:options = [ '--prompt', 'Edit> ', '--select-1' ]
  if len(l:preview_window)
    let l:options = extend(l:options, get(fzf#vim#with_preview(
          \   {"placeholder": "{1}"},
          \   l:preview_window
          \ ), 'options', []))
  endif

  return fzf#run(fzf#wrap({
  \ 'source': 'git diff-tree --no-commit-id --name-only -r ' . l:commit,
  \ 'options': l:options,
  \}))
endfunction
" $ git log --oneline --decorate=short --color | fzf --layout reverse-list --ansi --preview="git diff-tree --no-commit-id --name-only -r {1}" +s -d ' ' --with-nth 2.. | awk '{print $1}' | xargs -r -n1 git diff-tree --no-commit-id --name-only -r 
