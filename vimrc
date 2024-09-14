
" basic stuff {{{
" Though the default behaviour may be surprising, 
" the backspace 'not working' can be considered a feature;
" it can prevent you from accidentally removing indentation, 
" and from removing too much text by restricting it to the current line and/or the start of the insert.
set backspace=indent,eol,start

" Set bell style
set belloff=all
set vb t_vb=

" Disable compatibility with vi which can cause unexpected issues.
set nocompatible

" Enable type file detection. Vim will be able to try to detect the type of file in use.
filetype on

" Enable plugins and load plugin for the detected file type.
filetype plugin on

" Load an indent file for the detected file type.
filetype indent on

" Turn syntax highlighting on.
syntax on

" Add numbers to each line on the left-hand side.
set number

" Highlight cursor line underneath the cursor horizontally.
set cursorline

" Highlight cursor line underneath the cursor vertically.
set cursorcolumn

" Set shift width to 4 spaces.
set shiftwidth=4

" Set tab width to 4 columns.
set tabstop=4

" Use space characters instead of tabs.
set expandtab

" Do not save backup files.
set nobackup

" Do not let cursor scroll below or above N number of lines when scrolling.
set scrolloff=10

" Do not wrap lines. Allow long lines to extend as far as the line goes.
set nowrap

" While searching though a file incrementally highlight matching characters as you type.
set incsearch

" Ignore capital letters during search.
set ignorecase

" Override the ignorecase option if searching for capital letters.
" This will allow you to search specifically for capital letters.
set smartcase

" Show partial command you type in the last line of the screen.
set showcmd

" Show the mode you are on the last line.
set showmode

" Show matching words during a search.
set showmatch

" Use highlighting when doing a search.
set hlsearch

" Set the commands to save in history default number is 20.
set history=1000

" Enable auto completion menu after pressing TAB.
set wildmenu

" Make wildmenu behave like similar to Bash completion.
set wildmode=list:longest

" There are certain files that we would never want to edit with Vim.
" Wildmenu will ignore files with these extensions.
set wildignore=*.docx,*.jpg,*.png,*.gif,*.pdf,*.pyc,*.exe,*.flv,*.img,*.xlsx

if has("win32")
    " Using the clipboard as the default register for MS Windows Only
    set clipboard=unnamed
    set t_Co=256
    set t_ut=
else
    if has("unix")
        set clipboard+=unnamedplus 
     endif
endif

" }}}

" map leader to ,
let mapleader = ","

call plug#begin()
" Plug 'morhetz/gruvbox'
Plug 'easymotion/vim-easymotion'
Plug 'ayu-theme/ayu-vim'
Plug 'Yggdroot/indentLine'
Plug 'preservim/nerdtree' 
Plug 'vim-airline/vim-airline'
Plug 'tpope/vim-commentary'
Plug 'kana/vim-textobj-user'
Plug 'kana/vim-textobj-entire'
Plug 'machakann/vim-highlightedyank'
Plug 'instant-markdown/vim-instant-markdown', {'for': 'markdown', 'do': 'yarn install'}
Plug 'liuchengxu/vim-which-key'
call plug#end()

"" basic key mappings
nnoremap <leader>s :write<CR>

" switch between windows
nnoremap <C-j> <C-W>j
nnoremap <C-k> <C-W>k
nnoremap <C-h> <C-W>h
nnoremap <C-l> <C-W>l

" switch between tabs
nnoremap <C-Right> :tabn<CR>
nnoremap <C-Left> :tabp<CR>

" vim-powered terminal in split window
map <Leader>t :term ++close<cr>
tmap <Leader>t <c-w>:term ++close<cr>

" vim-powered terminal in new tab
map <Leader>T :tab term ++close<cr>
tmap <Leader>T <c-w>:tab term ++close<cr>

" Which-Key {{{
" Timeout
let g:which_key_timeout = 500


let g:mapleader = ','
" map leader key
call which_key#register(',', "g:which_key_map")
nnoremap <silent> <leader> :silent <c-u> :silent WhichKey ','<CR>
vnoremap <silent> <leader> :silent <c-u> :silent WhichKeyVisual ','<CR>

" vim-which-key look
let g:which_key_sep = '→'
let g:which_key_use_floating_win = 0
let g:which_key_max_size = 0
autocmd! FileType which_key
autocmd FileType which_key set laststatus=0 noshowmode noruler
  \| autocmd BufLeave <buffer> set laststatus=2 noshowmode ruler

" defining keybindings
let g:which_key_map = {}
let g:which_key_map['/'] = [ 'gc' , 'comment' ]
let g:which_key_map['.'] = [ ':e $MYVIMRC' , 'open init' ]
let g:which_key_map['='] = [ '<C-W>=' , 'balance windows' ]
let g:which_key_map['h'] = [ '<C-W>s' , 'split below']
let g:which_key_map['p'] = [ ':Files' , 'search files' ]
let g:which_key_map['v'] = [ '<C-W>v' , 'split right']

let g:which_key_map.a = {
      \ 'name' : '+actions' ,
      \ 'h' : [':let @/ = ""' , 'remove search highlight'],
      \ 'S' : [':s/\%V\(.*\)\%V/"\1"/' , 'surround'],
      \ 'o' : [':set spell!' , 'orthography'],
      \ }

let g:which_key_map.b = {
      \ 'name' : '+buffer' ,
      \ 'f' : ['bfirst' , 'first-buffer'],
      \ 'l' : ['blast' , 'last buffer'],
      \ 'n' : ['bnext' , 'next-buffer'],
      \ 'p' : ['bprevious' , 'previous-buffer'],
      \ '?' : ['Buffers' , 'fzf-buffer'],
      \ }

let g:which_key_map.f = {
      \ 'name' : '+fuzzy-find' ,
      \ '/' : [':History/' , 'history'],
      \ ';' : [':Commands' , 'commands'],
      \ 'B' : [':Buffers' , 'opened buffers'],
      \ 'f' : [':Files' , 'files'],
      \ 'h' : [':History' , 'file history'],
      \ 'H' : [':History:' , 'command history'],
      \ 'l' : [':Lines' , 'loaded buffers'] ,
      \ 'b' : [':BLines' , 'current buffer'],
      \ 'M' : [':Maps' , 'normal maps'] ,
      \ 'p' : [':Helptags' , 'help tags'] ,
      \ 'c' : [':Colors' , 'color schemes'],
      \ 'g' : [':Rg' , 'text Rg'],
      \ 'w' : [':Windows' , 'search windows'],
      \ 'z' : [':FZF ~' , 'files in home'],
      \ 't' : [':Telescope builtin' , 'telescope'],
      \ }

let g:which_key_map.t = {
      \ 'name' : '+terminal' ,
      \ ';' : [':FloatermNew --wintype=normal --height=6' , 'terminal'],
      \ 'f' : [':FloatermNew fzf' , 'fzf'],
      \ 'p' : [':FloatermNew python' , 'python'],
      \ 'r' : [':FloatermNew ranger' , 'ranger'],
      \ 't' : [':FloatermToggle' , 'toggle'],
      \ }

let g:which_key_map.g = {
    \ 'name' : '+go_to' ,
    \ 'x' : ['gx' , 'go to link under the cursor and use BROWSER'],
    \ 'e' : ['ge' , 'go to link under the cursor and use vim'],
    \ }

let g:which_key_map.c = {
    \ 'name' : '+Columnize-Selected' ,
    \}

let g:which_key_map.d = {
    \ 'name' : '+diagnostic' ,
    \}

let g:which_key_map.u = {
    \ 'name' : '+ultisnips' ,
    \}

let g:which_key_map.l = {
    \ 'name' : '+lsp' ,
    \}

let g:which_key_map.l.w = {
    \ 'name' : '+workspace' ,
    \}
" }}}

" IndentLine {{{
let g:indentLine_char =  '┊'   
let g:indentLine_first_char = '┊'   
let g:indentLine_showFirstIndentLevel = 1
let g:indentLine_setColors = 0
" }}}

" instant_markdown {{{
"Uncomment to override defaults:
"let g:instant_markdown_slow = 1
"let g:instant_markdown_autostart = 0
"let g:instant_markdown_open_to_the_world = 1
"let g:instant_markdown_allow_unsafe_content = 1
"let g:instant_markdown_allow_external_content = 0
let g:instant_markdown_mathjax = 1
"let g:instant_markdown_mermaid = 1
"let g:instant_markdown_logfile = '/tmp/instant_markdown.log'
"let g:instant_markdown_autoscroll = 0
"let g:instant_markdown_port = 8888
"let g:instant_markdown_python = 1
let g:instant_markdown_theme = 'dark'
" }}}

" NERDTree {{{
let NERDTreeShowHidden = 1

" Start NERDTree when Vim starts with a directory argument.
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists('s:std_in') |
    \ execute 'NERDTree' argv()[0] | wincmd p | enew | execute 'cd '.argv()[0] | endif
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | call feedkeys(":quit\<CR>:\<BS>") | endif
let g:NERDTreeDirArrowExpandable = '▸'
let g:NERDTreeDirArrowCollapsible = '▾'
let g:NERDTreeFileLines = 1
" Open the existing NERDTree on each new tab.
autocmd BufWinEnter * if &buftype != 'quickfix' && getcmdwintype() == '' | silent NERDTreeMirror | endif
" If another buffer tries to replace NERDTree, put it in the other window, and bring back NERDTree.
autocmd BufEnter * if winnr() == winnr('h') && bufname('#') =~ 'NERD_tree_\d\+' && bufname('%') !~ 'NERD_tree_\d\+' && winnr('$') > 1 |
    \ let buf=bufnr() | buffer# | execute "normal! \<C-W>w" | execute 'buffer'.buf | endif

" NREDTree Key Mappings
map <leader>tt :NERDTreeToggle<CR>
map <leader>tc :NERDTreeClose<CR>
map <leader>to :NERDTreeFocus<CR>
map <leader>tf :NERDTreeFind<CR>
map <leader>tr :NERDTreeRefreshRoot<CR>
" }}}

" ColorScheme Ayu {{{
colorscheme ayu
set termguicolors     " enable true colors support
" let ayucolor="light"  " for light version of theme
" let ayucolor="mirage" " for mirage version of theme
let ayucolor="dark"   " for dark version of theme
" }}}

" VIMSCRIPT -------------------------------------------------------------- {{{

" This will enable code folding.
" autocmd vimenter * ++nested colorscheme gruvbox
" set bg=dark

" Use the marker method of folding.
augroup filetype_vim
    autocmd!
    autocmd FileType vim setlocal foldmethod=marker
augroup END

" More Vimscripts code goes here.

" If your intention is just to avoid working outside of Vim 
" The first line maps escape to the caps lock key when you enter Vim, and the second line returns normal functionality to caps lock when you quit. 
" This requires Linux with the xorg-xmodmap package installed.
" if has('Unix')
"     au VimEnter * !xmodmap -e 'clear Lock' -e 'keycode 0x42 = Escape'
"     au VimLeave * !xmodmap -e 'clear Lock' -e 'keycode 0x42 = Caps_Lock'
" endif

" }}}

