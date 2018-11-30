" Vim plugin: manpager.
" Maintainer:  alexander@vassilevski.com
" Last Change: 03/11/18 12:07:23 698501021
command! -nargs=0 MANPAGER call s:ManPager() | delcommand MANPAGER
function! s:ManPager()
  set nocompatible
  if exists('+viminfofile')
    set viminfofile=NONE
  endif
  set noswapfile
  setlocal ft=man
  runtime ftplugin/man.vim
  "setlocal buftype=nofile bufhidden=hide iskeyword+=: modifiable
  silent keepj keepp %s/\v(.)\b\ze\1?//ge   " Emulate 'col -b'
  call cursor(1, 1)
  let n = search(".*(.*)", "c")
  if n > 1
    exe "1," . n-1 . "d"
  endif
  setlocal write modifiable noreadonly
  syntax on
endfunction
