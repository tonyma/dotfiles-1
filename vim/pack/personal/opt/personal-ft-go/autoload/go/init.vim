vim9script

# Prepare Golang scaffolding file
def go#init#scaffold(): void
  const bytes = get(wordcount(), 'bytes', 0)
  if bytes != 0
    return
  endif

  const package_name = go#init#get_package_name()
  if package_name ==# ''
    return
  endif

  var scaffold: list<string> = ['package ' .. package_name]

  if package_name =~# '_test$'
    try
      var pkglist: list<string>
      pkglist = systemlist('go list ./' .. expand('%:h'))
      if v:shell_error == 0
        if len(pkglist) > 0
          extend(scaffold, [
                \ '',
                \ 'import (',
                \ "\t" .. '"testing"',
                \ '',
                \ "\t" .. 'testtarget "' .. pkglist[0] .. '"',
                \ ')'])
        endif
      endif
    catch
      # noop
    endtry
    extend(scaffold, ['', 'func Test(t *testing.T) {', "\t" .. 'testtarget.', '}'])
    setline(1, scaffold)
    cursor(len(scaffold) - 2, 9)
  else
    extend(scaffold, ['', ''])
    setline(1, scaffold)
    cursor(3, 1)
  endif

enddef

# Get package name for the current file path
def go#init#get_package_name(): string
  const filename = expand('%:p')
  if filename ==# ''
    return ''
  endif

  const basename = fnamemodify(filename, ':t')
  if basename !~ '\.go$'
    return ''
  endif

  const dir = fnamemodify(filename, ':h')

  var suffix = ''

  # For test file: search simbling *_test.go files and get package name from them
  if basename =~ '_test\.go$'
    # TODO: use execute('lvimgrep /^package [a-zA-Z0-9]\+$/j ' .. dir .. '/**.go') instead
    const known_pkg = s:match_package_name(glob(dir .. '/*_test.go', v:true, v:true))
    if known_pkg !=# ''
      return known_pkg
    endif
    suffix = '_test'
  endif

  # Search simbling *.go files (not *_test.go) and get package name from them
  const wildignore = &wildignore
  set wildignore=*_test.go
  const known_pkg = s:match_package_name(glob(dir .. '/*.go', v:false, v:true))
  &wildignore = wildignore
  if known_pkg !=# ''
    return known_pkg .. suffix
  endif

  const dirname = fnamemodify(dir, ':t')

  # If the file is in the dir like "main" packagee
  if s:isin_cmd(dir) || s:is_invalid_pkg_name(dir)
    return 'main' .. suffix
  endif

  return dirname .. suffix
enddef

# Search package line from files
def s:match_package_name(files: list<string>): string
  for file in files
    for line in readfile(file, v:null, get(g:, 'go_init_read_package_line_max_length', 10))
      const matches = matchlist(line, 'package \(.*\)')
      if len(matches) > 1
        return matches[1]
      endif
    endfor
  endfor
  return ''
enddef

def s:is_invalid_pkg_name(pkg_name: string): bool
  return match(pkg_name, '[^0-9a-zA-Z_]') >= 0
enddef

# Check if the dir is in the cmd/**
def s:isin_cmd(dir: string): bool
  var anc = dir
  var i = 0
  var prev = ''
  while i < 5 && anc != prev
    if fnamemodify(anc, ':t') ==# 'cmd'
      return true
    endif

    prev = anc
    anc = fnamemodify(anc, ':h')
    i = i + 1
  endwhile
  return false
enddef
