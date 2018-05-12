"Load current directory as plugin if .development.vim exists.
if len(findfile(".development.vim", getcwd())) > 0
  execute 'set runtimepath+=' . getcwd()
  for plug in split(glob(getcwd() . "/*"), '\n')
    execute 'set runtimepath+=' . plug
  endfor
  echom 'loading local plugin'
endif
"
ru ./xdg.vim
ru ./keymaps.vim
ru ./plugins.vim
ru ./others.vim
ru ./local.vim
