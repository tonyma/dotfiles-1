let g:plug_dir = expand('<sfile>:p:h:h' . 'plug')

call plug#begin(g:plug_dir)
  Plug 'arp242/gopher.vim'
  Plug 'arp242/edc.vim'
call plug#end()
