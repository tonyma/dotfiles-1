" Show buffer info in popup 
def pinfo#buffer#show()
  # format output
  const output = [
    'File type:   ' .. &filetype,
    'Encoding:    ' .. &encoding,
    'File format: ' .. &fileformat,
    'Syntax:      ' .. &syntax,
  ]
  pinfo#popup#show(output)
enddef
