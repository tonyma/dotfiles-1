let g:xdg_config_home=$XDG_CONFIG_HOME
if g:xdg_config_home == ""
  let g:xdg_config_home = $HOME."/.config"
endif

let g:xdg_data_home=$XDG_DATA_HOME
if g:xdg_data_home == ""
  let g:xdg_data_home = $HOME."/.local/share"
endif

let s:cachedir=$XDG_CACHE_HOME
if s:cachedir ==# ""
  let s:cachedir = $HOME.'/.cache'
endif

let &directory = s:cachedir."/vim/swap"
if !isdirectory(&directory)
  call mkdir(&directory, 'p')
endif
let &backupdir = s:cachedir."/vim/backup"
if !isdirectory(&backupdir)
  call mkdir(&backupdir, 'p')
endif

