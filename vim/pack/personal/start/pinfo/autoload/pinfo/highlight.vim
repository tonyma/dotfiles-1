def s:get_syn_id(transparent: bool): number
  const synid = synID(line('.'), col('.'), 1)
  return transparent ? synIDtrans(synid) : synid
enddef
def s:get_syn_name(synid: number): string
  return synIDattr(synid, 'name')
enddef
def s:get_highlight_info(transparent: bool): list<string>
  const syn_name = s:get_syn_name(s:get_syn_id(transparent))
  if syn_name ==# ''
    return []
  endif
  return split(execute("verbose highlight " .. syn_name), "\n")
enddef

" Show highlight info in popup 
def pinfo#highlight#show()
  # format output
  var output: list<string> = s:get_highlight_info(false) + s:get_highlight_info(true)
  if len(output) == 0
    output = ['<No highlight>']
  endif

  pinfo#popup#show(output)
enddef
