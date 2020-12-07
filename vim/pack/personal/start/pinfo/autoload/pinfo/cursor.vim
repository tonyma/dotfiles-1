" Show cursor info in popup
def pinfo#cursor#show()
  # get cursor line text
  const text = getline('.')
  const text_before = strpart(text, 0, col('.') - 1)
  const text_after = strpart(text, col('.') - 1)
  const char = strcharpart(text_after, 0, 1)

  # get cursor position informations
  const cur_row_idx = line('.')
  const cur_row_len = strchars(text)
  const cur_col_char_idx = strchars(text_before) + 1

  # get charcode informations
  const charcode = char2nr(char)
  const charcode_utf8 = trim(execute('normal g8'))

  # get buffer size
  const buf_lines = line('$')
  const buf_counts = wordcount()

  # format output
  const output = [
    'Line: ' .. cur_row_idx .. ' of ' .. buf_lines .. '; Col: ' .. cur_col_char_idx .. ' of ' .. cur_row_len,
    'Word: ' .. buf_counts['cursor_words'] .. ' of ' .. buf_counts['words'] .. '; Char: ' .. buf_counts['cursor_chars'] .. ' of ' .. buf_counts['chars'] .. '; Byte: ' .. buf_counts['cursor_bytes'] .. ' of ' .. buf_counts['bytes'],
    'Code: ' .. printf('"%s" {(%d)10 (%X)16 (%s)utf8}', char, charcode, charcode, charcode_utf8),
  ]
  pinfo#popup#show(output)
enddef
