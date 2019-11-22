set nocompatible              " be iMproved, required
set nomodeline              " No modelines
set modelines=0
filetype off                  " required


filetype plugin indent on    " required
colorscheme default

" To ignore plugin indent changes, instead use:
"filetype plugin on

set encoding=utf8
set guifont=Neep\ 16
set guioptions-=T

" Folding settings
setlocal foldmethod=syntax
setlocal nofoldenable
setlocal foldlevelstart=99

" Whitespace
set smarttab " smart tabulatin and backspace
set smartindent
set ts=2 sw=2
set expandtab
set autoindent

set fo=tcrq
set title " show title
set wildmenu
set wildchar=<Tab> " Expand the command line using tab
set nowrap
set clipboard+=unnamed

" show line numbers
set number

" enable all features
set nocompatible

set laststatus=2

" highlight the searchterms
set hlsearch

" jump to the matches while typing
set incsearch

" ignore case while searching
set ignorecase

" don't wrap words
set textwidth=80

" history
set history=50

" 1000 undo levels
set undolevels=1000

" show a ruler
set ruler

" show partial commands
set showcmd

" show matching braces
set showmatch
set mat=5

" write before hiding a buffer
set autowrite

" allows hidden buffers to stay unsaved, but we do not want this, so comment
" it out:
set hidden

"set wmh=0

" auto-detect the filetype
filetype plugin indent on

" syntax highlight
syntax on

" Always show the menu, insert longest match
set completeopt=menuone,longest

" When editing a file, always jump to the last known cursor position.
" Don't do it when the position is invalid or when inside an event handler
" (happens when dropping a file on gvim).

function! ClosePair(char)
  if getline('.')[col('.') - 1] == a:char
    return "\<Right>"
  else
    return a:char
  endif
endf

function! QuoteDelim(char)
  let line = getline('.')
  let col = col('.')
  if line[col - 2] == "\\"
    "Inserting a quoted quotation mark into the string
    return a:char
  elseif line[col - 1] == a:char
    "Escaping out of the string
    return "\<Right>"
  else
    "Starting a string
    return a:char.a:char."\<Left>"
  endif
endf

function! MapAutoCloseQuotesAndBrackets()
  inoremap " ""<Left>
  inoremap ' ''<Left>
  inoremap ( ()<Left>
  inoremap [ []<Left>
  inoremap { {}<Left>
  inoremap ) <c-r>=ClosePair(')')<CR>
  inoremap ] <c-r>=ClosePair(']')<CR>
  inoremap } <c-r>=ClosePair('}')<CR>
  inoremap " <c-r>=QuoteDelim('"')<CR>
  inoremap ' <c-r>=QuoteDelim("'")<CR>
  inoremap <C-CR> <Esc>A<CR>
  inoremap <C-e> <Esc>A<CR>
endfunction

if has("autocmd")
  autocmd BufReadPost *
        \ if line("'\"") > 0 && line("'\"") <= line("$") |
        \   exe "normal g`\"" |
        \ endif

  autocmd BufNewFile,BufRead *.vb set ft=vbnet
  autocmd FileType ruby,perl,python,dosbatch :call MapAutoCloseQuotesAndBrackets()
endif

"if $COLORTERM == 'gnome-terminal'
"   set term=gnome-256color
"endif

" Auto match string and block chars


"Set the key to toggle NERDTree


"Snippet Settings
let g:snips_author = 'Mike West'

" functions
command! -complete=file -nargs=+ Shell call RunShellCommand(<q-args>)
function! RunShellCommand(cmdline)
  botright new
  setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile nowrap
  call setline(1,a:cmdline)
  call setline(2,substitute(a:cmdline,'.','=','g'))
  execute 'silent $read !'.escape(a:cmdline,'%#')
  setlocal nomodifiable
  1
endfunction

" Visually select the text that was last edited/pasted
nmap gV `[v`]

nmap <Leader>a= :Tabularize /=<CR>
vmap <Leader>a= :Tabularize /=<CR>
nmap <Leader>a  :Tabularize /
vmap <Leader>a  :Tabularize /

inoremap <silent>  <Bar>   <Bar><Esc>:call <SID>align()<CR>a
function! s:align()
  let p = '^\s*|\s.*\s|\s*$'
  if exists(':Tabularize') && getline('.') =~# '^\s*|' && (getline(line('.')-1) =~# p || getline(line('.')+1) =~# p)
    let column = strlen(substitute(getline('.')[0:col('.')],'[^|]','','g'))
    let position = strlen(matchstr(getline('.')[0:col('.')],'.*|\s*\zs.*'))
    Tabularize/|/l1
    normal! 0
    call search(repeat('[^|]*|',column).'\s\{-\}'.repeat('.',position),'ce',line('.'))
  endif
endfunction

" Gundo Plugin Mapping
nnoremap <F5> :GundoToggle<CR>
" Shortcut to rapidly toggle `set list`
nmap <leader>l :set list!<CR>
" Use the same symbols as TextMate for tabstops and EOLs
set listchars=tab:?\ ,eol:�
"Invisible character colors
highlight NonText guifg=#4a4a59
highlight SpecialKey guifg=#4a4a59

map <F6> :set spell!<CR>
redraw

"set inccommand=nosplit

let g:vimwiki_list = [{'path': '~/vimwiki/', 'auto_toc': 1, 'ext': 'md', 'syntax': 'markdown'}]

let g:UltiSnipsExpandTrigger="<c-j>"

command! PackUpdate packadd minpac | source $MYVIMRC | redraw | call minpac#update()
command! PackClean  packadd minpac | source $MYVIMRC | call minpac#clean()

" make YCM compatible with UltiSnips (using supertab)
let g:ycm_key_list_select_completion = ['<C-n>', '<Down>']
let g:ycm_key_list_previous_completion = ['<C-p>', '<Up>']
let g:SuperTabDefaultCompletionType = '<C-n>'

" better key bindings for UltiSnipsExpandTrigger
let g:UltiSnipsExpandTrigger = "<tab>"
let g:UltiSnipsJumpForwardTrigger = "<tab>"
let g:UltiSnipsJumpBackwardTrigger = "<s-tab>"

let wiki = {}
let wiki.nested_syntaxes = {'python': 'python', 'c++': 'cpp'}
" fzf map ctrl-p to fuzzy find files
nnoremap <C-f> :Files<CR>
nnoremap <C-g> :Rg<CR>
let g:vim_http_split_vertically = 1
let g:vim_http_tempbuffer = 1

if !exists('*minpac#init')
  finish
endif

call minpac#init()

call minpac#add('k-takata/minpac', {'type': 'opt'})
call minpac#add('tpope/vim-fugitive')
"call minpac#add('git://git.wincent.com/command-t.git')
call minpac#add('godlygeek/tabular')
call minpac#add('tpope/vim-vinegar')
call minpac#add('vim-syntastic/syntastic')
call minpac#add('sjl/gundo.vim')
call minpac#add('machakann/vim-highlightedyank')
call minpac#add('vim-airline/vim-airline')
call minpac#add('vim-airline/vim-airline-themes')
call minpac#add('vimwiki/vimwiki')
call minpac#add('SirVer/ultisnips')
call minpac#add('honza/vim-snippets')
call minpac#add('Valloric/YouCompleteMe')
call minpac#add('mattn/emmet-vim')
call minpac#add('ervandew/supertab')
call minpac#add('junegunn/fzf.vim')
call minpac#add('nicwest/vim-http')
