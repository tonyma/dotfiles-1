def! quotem#copy(firstline: number, lastline: number, ...modifiers: list<string>): void
  var label = expand(join(['%'] + modifiers, ':'))
  setreg('+', join([label] + quotem#quote(firstline, lastline), "\n"))
enddef

def! quotem#quote(firstline: number, lastline: number): list<string>
  return ["```" .. &filetype] + getline(firstline, lastline) + ["```"]
enddef
