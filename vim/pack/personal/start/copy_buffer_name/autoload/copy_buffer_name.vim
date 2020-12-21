def! copy_buffer_name#copy(...modifiers: list<string>): void
  setreg('+', expand(join(['%'] + modifiers, ':')))
enddef
