":version ":SET all ":HELP options.txt ".vimrc:
"COMMAND! VimColorTest 
command! VimColorTest call VimColorTest('/tmp/vimctest',25, 25)
"SET ttyfast,termencoding,encoding,ttymouse,t_Co,scroll,ma,guicursor,fileencoding,fileencodings,backspace
set ttyfast
set termencoding=utf-8
set encoding=utf-8
set ttymouse=xterm
set mouse=a
set t_Co=256
set scroll=10
set ma
set guicursor=n-v-c:block-Cursor/lCursor,ve:ver35-Cursor,o:hor50-Cursor,i-ci:ver25-Cursor/lCursor,r-cr:hor20-Cursor/lCursor,sm:block-Cursor-blinkwait175-blinkoff150-blinkon175,a:blinkon0
set guicursor=
set fileencoding=utf-8
set fileencodings=ucs-bom,utf-8,latin1
set backspace=indent,eol,start
"FUN! DoManualFolds DoSyntaxFolds
fun! DoSyntaxFolds()
  set foldenable
  set foldcolumn=1
  set foldmethod=syntax
  set foldlevelstart=0
  set foldlevel=99
  augroup javascript_folding
    au!
    au FileType javascript setglobal foldmethod=syntax
  au
  let g:javascript_fold=1    "javascript
  let g:javaScript_fold=0    "javaScript
  let g:perl_fold=1          "Perl
  let g:php_folding=2        "PHP
  let g:php_sync_method=0
  let g:php_baselib=1
  let g:r_syntax_folding=1   "R
  let g:ruby_fold=1          "Ruby
  let g:sh_fold_enabled=1    "sh
  let g:vimsyn_folding='af'  "Vim script
  let g:xml_syntax_folding=1 "XML
endf
fun! DoManualFolds()
  set nofoldenable
  set foldenable
  set foldcolumn=1
  let g:foldColumn=1
  set foldmethod=manual
endf
"FUN! InitStatusLine ChangeStatuslineColor FileSize ReadOnly GitInfo
fun! InitStatusLine()
  let g:currentmode={
  \ 'n'  : 'N ',
  \ 'no' : 'N·Operator Pending ',
  \ 'v'  : 'V ',
  \ 'V'  : 'V·Line ',
  \ '^V' : 'V·Block ',
  \ 's'  : 'Select ',
  \ 'S'  : 'S·Line ',
  \ '^S' : 'S·Block ',
  \ 'i'  : 'I ',
  \ 'R'  : 'R ',
  \ 'Rv' : 'V·Replace ',
  \ 'c'  : 'Command ',
  \ 'cv' : 'Vim Ex ',
  \ 'ce' : 'Ex ',
  \ 'r'  : 'Prompt ',
  \ 'rm' : 'More ',
  \ 'r?' : 'Confirm ',
  \ '!'  : 'Shell ',
  \ 't'  : 'Terminal '
  \}
  set laststatus=2
  set statusline=
  set statusline+=%{ChangeStatuslineColor()}
  set statusline+=%0*\ %{toupper(g:currentmode[mode()])}
  set statusline+=%8*\ [%n]
  set statusline+=%8*\ %{GitInfo()}
  set statusline+=%8*\ %<%F\ %{ReadOnly()}\ %m\ %w\
  set statusline+=%#warningmsg#
  set statusline+=%{SyntasticStatuslineFlag()}
  set statusline+=%*
  set statusline+=%9*\ %=
  set statusline+=%8*\ %y\
  set statusline+=%7*\ %{(&fenc!=''?&fenc:&enc)}\[%{&ff}]\
  set statusline+=%8*\ %-3(%{FileSize()}%)
  set statusline+=%0*\ %3p%%\ \ %l:\ %3c\
  hi User1 ctermfg=15 ctermbg=20
  hi User2 ctermfg=15 ctermbg=20
  hi User3 ctermfg=15 ctermbg=20
  hi User4 ctermfg=15 ctermbg=20
  hi User5 ctermfg=15 ctermbg=20
  hi User7 ctermfg=15 ctermbg=20
  hi User8 ctermfg=15 ctermbg=20
  hi User9 ctermfg=15 ctermbg=20
endf
fun! ChangeStatuslineColor()
  if (mode() =~# '\v(n|no)')
    exe 'hi! StatusLine ctermfg=001 ctermbg=20'
  elseif (mode() =~# '\v(v|V)' || g:currentmode[mode()] ==# 'V·Block' || get(g:currentmode, mode(), '') ==# 't')
    exe 'hi! StatusLine ctermfg=005 ctermbg=16'
  elseif (mode() ==# 'i')
    exe 'hi! StatusLine ctermfg=004 ctermbg=16'
  else
    exe 'hi! StatusLine ctermfg=006 ctermbg=16'
  endif
  return ''
endf
fun! FileSize()
  let bytes = getfsize(expand('%:p'))
  if (bytes >= 1024)
    let kbytes = bytes / 1024
  endif
  if (exists('kbytes') && kbytes >= 1000)
    let mbytes = kbytes / 1000
  endif
  if bytes <= 0
    return '0'
  endif
  if (exists('mbytes'))
    return mbytes . 'MB '
  elseif (exists('kbytes'))
    return kbytes . 'KB '
  else
    return bytes . 'B '
  endif
endf
fun! ReadOnly()
  if &readonly || !&modifiable
    return ''
  else
    return ''
endf
fun! GitInfo()
  execute '!git status . expand('%:p') . | head -c 10 && git branch '. expand('%:p') . ' | head -c 10 '
endf
"FUN! TabMessage PuppetValidateAndLintCurrentBuffer
fun! TabMessage(cmd)
  redir => message
  silent execute a:cmd
  redir END
  if empty(message)
    echoerr "no output"
  else
    tabnew
    setlocal buftype=nofile bufhidden=wipe noswapfile
    silent put=message
  endif
endf
fun! PuppetValidateAndLintCurrentBuffer()
  execute '!puppet-lint ' . expand('%:p') .' && puppet parser validate '. expand('%:p')
endf
"FUN! AirlinieThemePatch
function! AirlineThemePatch(palette)
  if g:airline_theme == 'hybrid'
    for colors in values(a:palette.inactive)
      let colors[3] = 245
    endfor
  endif
endfunction
"LET {g,w}:airline_* SET laststatus tm
set laststatus=2
set tm=40 "Þ∥Ξ¶␊»«Ꞩ
let g:airline_left_sep='>'
let g:airline_right_sep='<'
let g:airline_left_alt_sep = '▶'
let g:airline_right_alt_sep = '◀'
let g:airline_detect_modified=1
let g:airline_detect_paste=1
let g:airline_detect_crypt=1
let g:airline_detect_spell=1
let g:airline_detect_iminsert=0
let g:airline_inactive_collapse=0
let g:airline_theme='badcat'
let g:airline_theme_patch_func = 'AirlineThemePatch'
let g:airline_powerline_fonts = 1
let g:airline_symbols_ascii = 1
let g:airline_mode_map = {
    \ '__' : '-',
    \ 'n'  : 'N',
    \ 'i'  : 'I',
    \ 'R'  : 'R',
    \ 'c'  : 'C',
    \ 'v'  : 'V',
    \ 'V'  : 'V',
    \ '' : 'V',
    \ 's'  : 'S',
    \ 'S'  : 'S',
    \ '' : 'S',
    \ }
let g:airline_exclude_preview = 0
let w:airline_disabled = 0
let g:airline_skip_empty_sections = 0
let w:airline_skip_empty_sections = 0
if !exists('g:airline_symbols')     
  let g:airline_symbols = {}
  let g:airline_symbols.crypt = '🔒'
  let g:airline_symbols.linenr = '␤'    
  let g:airline_symbols.maxlinenr = '☰'
  let g:airline_symbols.branch = '⎇'
  let g:airline_symbols.paste = 'ρ'
  let g:airline_symbols.notexists = '∄' 
  let g:airline_symbols.readonly = ''
endif
"MAP f7 f8 f2 f3 VNOREMAP c-f
map <F7> :tabp<CR>
map <F8> :tabn<CR>
map <F2> :call DoSyntaxFolds()<CR>
map <F3> :call DoManualFolds()<CR>
vnoremap <buffer> <c-f> :call RangeJsBeautify()<cr>
"DISPLAY OPTS: SET nu,cc,nowrap,list,expandtab,tabstop,shiftwidth,nocindent,nosmartindent,noautoindent,filetype indent on, hls
set nu
set cc=80
set nowrap
set list
set expandtab
set tabstop=2
set shiftwidth=2
set nocindent
set nosmartindent
set noautoindent
set hls
filetype indent on
"SY on
sy on
"SET splitright splitbelow
set splitright
set splitbelow
"SET tabpagemax
set tabpagemax=100
"SET cscopeprg
set cscopeprg=/usr/bin/cscope
"SET g:html_*
:let g:html_ingore_folding=0
:let g:html_use_css=1
:let g:html_dynamic_folds=1
:let g:html_hover_unfold=1
:let g:html_use_css=1
:let g:html_number_lines = 0
:let g:html_no_progress = 1
:let g:html_diff_one_file = 1
"SET g:nerdtree_tabs_*
let g:nerdtree_tabs_open_on_gui_startup = 0
let g:nerdtree_tabs_open_on_console_startup = 0
let g:nerdtree_tabs_no_startup_for_diff = 1
let g:nerdtree_tabs_smart_startup_focus = 1
let g:nerdtree_tabs_open_on_new_tab = 0
let g:nerdtree_tabs_meaningful_tab_names = 1
let g:nerdtree_tabs_autoclose = 1
let g:nerdtree_tabs_synchronize_view = 0
let g:nerdtree_tabs_synchronize_focus = 0
let g:nerdtree_tabs_focus_on_files = 0
"LET h:ycm_global_ycm_extra_conf
let g:ycm_global_ycm_extra_conf='~/.vim/bundle/YouCompleteMe/third_party/ycmd/cpp/ycm/.ycm_extra_conf.py'
"SET directory
set directory=$HOME/.vim/swapfiles/
"EXECUTE pathogen#infect IF empty LET $MANWIDTH g:ft_man_folding_enable RUNTIME ftplugin/man.vim :CALL InitStatusLine DoManualFolds
execute pathogen#infect()
"COLORSCHEME
colorscheme darkblack
colorscheme sasho
"PYTHON interpreter
let g:syntastic_python_python_exec = 'python3'
"MANPAGER
if empty($MANWIDTH)
  let $MANWIDTH = 460
endif
let g:ft_man_folding_enable=1
runtime ftplugin/man.vim
" status line
:call InitStatusLine()
:call DoManualFolds()
