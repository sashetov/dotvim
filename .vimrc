let mapleader = ' '
let maplocalleader = ' '

call plug#begin()
set ttyfast
set termencoding=utf-8
set encoding=utf-8
set ttymouse=xterm
set mouse=a
set t_Co=256
set scroll=10
set ma
set guicursor=n-v-c:block-Cursor/lCursor,ve:ver35-Cursor,o:hor50-Cursor,i-ci:ver25-Cursor/lCursor,r-cr:hor20-Cursor/lCursor,sm:block-Cursor-blinkwait175-blinkoff150-blinkon175,a:blinkon0
set fileencoding=utf-8
set backspace=indent,eol,start
set laststatus=2
set tm=40
noremap <F7> :tabp<CR>
noremap <F8> :tabn<CR>
vnoremap <leader>y :w !xclip -sel clip -i > /dev/null<CR><CR>
set timeoutlen=3000
set updatetime=300
set nu
set cc=80
set nowrap
set list
set expandtab
set tabstop=4
set shiftwidth=4
set nocindent
set nosmartindent
set noautoindent
set hls
filetype on
filetype indent on
sy on
set splitright
set splitbelow
set tabpagemax=100
set cscopeprg=/usr/bin/cscope
set directory=$HOME/.vim/swapfiles/
set foldcolumn=5
set guioptions=
set belloff=all
set diffopt+=algorithm:histogram,indent-heuristic,vertical,internal
set fillchars+=diff:\
"colorscheme koehler
"colorscheme habamax
colorscheme zaibatsu
let g:loaded_manpager = 1
let g:loaded_matchparen = 1

" --- core LSP / completion ---
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'neoclide/coc-yaml'
Plug 'fannheyward/coc-marketplace'

" --- nav, git, ergonomics ---
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-repeat'
Plug 'justinmk/vim-sneak'
Plug 'junegunn/vim-easy-align'
Plug 'airblade/vim-gitgutter'
Plug 'airblade/vim-rooter'
Plug 'mbbill/undotree'
Plug 'vim-test/vim-test'
Plug 'preservim/nerdtree'
Plug 'itchyny/lightline.vim'
Plug 'editorconfig/editorconfig-vim'
Plug 'machakann/vim-highlightedyank'

" --- broad syntax / filetype coverage ---
Plug 'sheerun/vim-polyglot'

" --- coc extensions, auto-installed on first start ---
let g:coc_global_extensions = [
      \ 'coc-marketplace',
      \ 'coc-snippets',
      \ 'coc-pairs',
      \ 'coc-json',
      \ 'coc-yaml',
      \ 'coc-xml',
      \ 'coc-toml',
      \ 'coc-html',
      \ 'coc-css',
      \ 'coc-tsserver',
      \ 'coc-eslint',
      \ 'coc-prettier',
      \ 'coc-pyright',
      \ 'coc-go',
      \ 'coc-rust-analyzer',
      \ 'coc-clangd',
      \ 'coc-sh',
      \ 'coc-vimlsp',
      \ 'coc-java',
      \ 'coc-kotlin',
      \ 'coc-docker',
      \ 'coc-sumneko-lua',
      \ 'coc-markdownlint',
      \ 'coc-webpack',
      \ 'coc-perl',
      \ 'coc-powershell',
      \ ]

" --- fzf mappings ---
nnoremap <silent> <C-p>      :Files<CR>
nnoremap <silent> <leader>f  :Files<CR>
nnoremap <silent> <leader>b  :Buffers<CR>
nnoremap <silent> <leader>g  :GFiles<CR>
nnoremap <silent> <leader>r  :Rg<CR>
nnoremap <silent> <leader>rg :Rg<CR>
nnoremap <silent> <leader>l  :BLines<CR>
nnoremap <silent> <leader>L  :Lines<CR>
nnoremap <silent> <leader>h  :History<CR>
nnoremap <silent> <leader>c  :Commits<CR>
nnoremap <silent> <leader>*  :Rg <C-r><C-w><CR>

" --- fugitive / rhubarb ---
nnoremap <silent> <leader>gs :Git<CR>
nnoremap <silent> <leader>gd :Gdiffsplit<CR>
nnoremap <silent> <leader>gD :Gdiffsplit!<CR>
nnoremap <silent> <leader>gb :Git blame<CR>
nnoremap <silent> <leader>gl :0Gclog<CR>
nnoremap <silent> <leader>go :GBrowse<CR>
vnoremap <silent> <leader>go :GBrowse<CR>

" --- misc plugin mappings ---
nnoremap <silent> <leader>u  :UndotreeToggle<CR>
nnoremap <silent> <leader>n  :NERDTreeToggle<CR>
nnoremap <silent> <leader>F  :NERDTreeFind<CR>
xmap     ga                  <Plug>(EasyAlign)
nmap     ga                  <Plug>(EasyAlign)

let g:sneak#label        = 1
let g:gitgutter_map_keys = 0
let g:gitgutter_max_signs = 2000
let g:NERDTreeShowHidden = 1
let g:NERDTreeMinimalUI  = 1
let g:rooter_patterns    = ['.git', 'package.json', 'go.mod', 'Cargo.toml', 'build.gradle', 'build.gradle.kts', 'pyproject.toml', 'composer.json', 'Gemfile', 'pom.xml', 'mix.exs', 'project.clj', 'deps.edn', 'flake.nix', 'shell.nix', 'main.tf', 'Chart.yaml']
let g:rooter_silent_chdir = 1

" --- coc: docs, nav, diagnostics, refactor ---
nnoremap <silent> K :call <SID>show_documentation()<CR>
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

autocmd CursorHold * silent call CocActionAsync('highlight')

nnoremap <silent> gd :call CocAction('jumpDefinition')<CR>
nnoremap <silent> gD :call CocAction('jumpDeclaration')<CR>
nnoremap <silent> gt :call CocAction('jumpTypeDefinition')<CR>
nnoremap <silent> gi :call CocAction('jumpImplementation')<CR>
nnoremap <silent> gr :call CocAction('jumpReferences')<CR>
nnoremap <silent> <leader>ca :call CocAction('codeAction')<CR>
vnoremap <silent> <leader>ca :call CocAction('codeAction')<CR>
nnoremap <silent> <leader>rn :call CocActionAsync('rename')<CR>
inoremap <silent> <C-s>     <C-o>:call CocActionAsync('showSignatureHelp')<CR>

nmap <silent> ]g <Plug>(coc-diagnostic-next)
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nnoremap <silent> <leader>d :CocDiagnostics<CR>
nnoremap <silent> <leader>q :call CocAction('diagnosticLineList')<CR>

let g:vimimprove_prewarm_files = {
\ 'terraform':  expand('~/.vim/lsp-prewarm/prewarm.tf'),
\ 'helm':       expand('~/.vim/lsp-prewarm/templates/_helpers.tpl'),
\ 'clojure':    expand('~/.vim/lsp-prewarm/prewarm.clj'),
\ 'sql':        expand('~/.vim/lsp-prewarm/prewarm.sql'),
\ 'markdown':   expand('~/.vim/lsp-prewarm/prewarm.md'),
\ 'go':         expand('~/.vim/lsp-prewarm/prewarm.go'),
\ 'python':     expand('~/.vim/lsp-prewarm/prewarm.py'),
\ 'cs':         expand('~/.vim/lsp-prewarm/prewarm.cs'),
\ 'yaml':       expand('~/.vim/lsp-prewarm/prewarm.yaml'),
\ 'json':       expand('~/.vim/lsp-prewarm/prewarm.json'),
\ 'scss':       expand('~/.vim/lsp-prewarm/prewarm.scss'),
\ 'xml':        expand('~/.vim/lsp-prewarm/prewarm.xml'),
\ 'rust':       expand('~/.vim/lsp-prewarm/prewarm.rs'),
\ 'c':          expand('~/.vim/lsp-prewarm/prewarm.c'),
\ 'cpp':        expand('~/.vim/lsp-prewarm/prewarm.cpp'),
\ 'javascript': expand('~/.vim/lsp-prewarm/prewarm.js'),
\ 'typescript': expand('~/.vim/lsp-prewarm/prewarm.ts'),
\ 'sh':         expand('~/.vim/lsp-prewarm/prewarm.sh'),
\ 'lua':        expand('~/.vim/lsp-prewarm/prewarm.lua'),
\ 'php':        expand('~/.vim/lsp-prewarm/prewarm.php'),
\ 'ruby':       expand('~/.vim/lsp-prewarm/prewarm.rb'),
\ 'java':       expand('~/.vim/lsp-prewarm/prewarm.java'),
\ 'kotlin':     expand('~/.vim/lsp-prewarm/prewarm.kt'),
\ 'nix':        expand('~/.vim/lsp-prewarm/prewarm.nix'),
\ 'toml':       expand('~/.vim/lsp-prewarm/prewarm.toml'),
\ 'dockerfile': expand('~/.vim/lsp-prewarm/Dockerfile'),
\}

" Markers (in cwd or any parent up to $HOME) → filetype to prewarm.
" Filetypes without a marker here (markdown/yaml/json/sql/xml/scss/toml/sh/lua)
" are cheap to start cold and skipped from prewarm entirely.
let g:vimimprove_prewarm_markers = {
\ 'rust':       ['Cargo.toml'],
\ 'go':         ['go.mod', 'go.sum'],
\ 'python':     ['pyproject.toml', 'requirements.txt', 'setup.py', 'setup.cfg', 'Pipfile'],
\ 'typescript': ['tsconfig.json'],
\ 'javascript': ['package.json'],
\ 'php':        ['composer.json'],
\ 'ruby':       ['Gemfile', '*.gemspec'],
\ 'terraform':  ['*.tf', '.terraform.lock.hcl'],
\ 'helm':       ['Chart.yaml'],
\ 'clojure':    ['project.clj', 'deps.edn', 'shadow-cljs.edn'],
\ 'java':       ['pom.xml', 'build.gradle', 'build.gradle.kts', '*.java'],
\ 'kotlin':     ['build.gradle.kts', 'settings.gradle.kts', '*.kt', '*.kts'],
\ 'cs':         ['*.csproj', '*.sln', '*.fsproj'],
\ 'cpp':        ['CMakeLists.txt', 'compile_commands.json', '*.cpp', '*.hpp', '*.cc'],
\ 'c':          ['configure.ac', 'compile_commands.json', '*.c', '*.h'],
\ 'dockerfile': ['Dockerfile', 'Containerfile'],
\ 'nix':        ['flake.nix', 'default.nix', 'shell.nix'],
\}

function! s:VimImproveHasMarker(root, patterns) abort
  let l:home = expand('~')
  " Wildcard patterns (e.g. '*.cpp'): only check the cwd itself,
  " and require a real file (skip directory names like 'llama.cpp/').
  for l:pat in a:patterns
    if l:pat =~# '\*'
      for l:p in glob(a:root . '/' . l:pat, 1, 1)
        if filereadable(l:p) | return 1 | endif
      endfor
    endif
  endfor
  " Exact-name patterns (e.g. 'Cargo.toml'): walk up toward $HOME.
  let l:dir = a:root
  while !empty(l:dir) && l:dir !=# '/' && l:dir !=# l:home
    for l:pat in a:patterns
      if l:pat !~# '\*' && filereadable(l:dir . '/' . l:pat)
        return 1
      endif
    endfor
    let l:parent = fnamemodify(l:dir, ':h')
    if l:parent ==# l:dir | break | endif
    let l:dir = l:parent
  endwhile
  return 0
endfunction

function! s:VimImproveDetectFiletypes() abort
  let l:root = getcwd()
  let l:detected = []
  for [l:ft, l:patterns] in items(g:vimimprove_prewarm_markers)
    if s:VimImproveHasMarker(l:root, l:patterns)
      call add(l:detected, l:ft)
    endif
  endfor
  return l:detected
endfunction

function! s:VimImprovePrewarmLSP() abort
  let l:targets = s:VimImproveDetectFiletypes()
  for ft in l:targets
    let l:path = get(g:vimimprove_prewarm_files, ft, '')
    if empty(l:path) || !filereadable(l:path) | continue | endif
    let l:bnr = bufadd(l:path)
    if l:bnr > 0
      call bufload(l:bnr)
      call setbufvar(l:bnr, '&buflisted', 0)
      call setbufvar(l:bnr, '&swapfile', 0)
      if ft ==# 'helm'
        call setbufvar(l:bnr, '&filetype', 'helm')
      endif
    endif
  endfor
endfunction

command! VimImprovePrewarmLSP            call s:VimImprovePrewarmLSP()
command! VimImprovePrewarmShow           echo s:VimImproveDetectFiletypes()
autocmd User CocNvimInit ++once call timer_start(800, {-> s:VimImprovePrewarmLSP()})

call plug#end()
