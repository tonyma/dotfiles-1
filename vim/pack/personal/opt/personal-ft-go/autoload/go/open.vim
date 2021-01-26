vim9script

def go#open#toggle_test(afile: string, mods: string, bang: string)
  var target_file: string
  var current_file: string
  current_file = expand(afile)
  if current_file =~# '_test\.go$'
    target_file = current_file[0 : -9] .. '.go'
  elseif current_file =~# '\.go$'
    target_file = current_file[0 : -4] .. '_test.go'
  else
    echohl WarningMsg | echo 'this is not a go file' | echohl None
    return
  endif
  if filereadable(target_file)
    if mods !=# ''
      execute mods .. ' new' .. bang .. ' ' .. target_file
    else
      execute 'edit' .. bang .. ' ' .. target_file
    endif
  endif
enddef
