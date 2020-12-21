def! quotem#copy(firstline: number, lastline: number, ...modifiers: list<string>): void
  var lines: list<string>

  if &buftype ==# 'terminal'
    add(lines, "```console")
  else
    # put buffer name on the top
    add(lines, expand(join(['%'] + modifiers, ':')))
    add(lines, "```" .. &filetype)
  endif

  extend(lines, getline(firstline, lastline))
  add(lines, "```")

  setreg('+', join(lines, "\n"))
enddef
