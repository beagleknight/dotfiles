"" Load pathogen
call pathogen#infect()

"" --------------------- General configuration
set nocompatible                " choose no compatibility with legacy vi
syntax enable
set encoding=utf-8
colorscheme delek
set showcmd                     " display incomplete commands
filetype plugin indent on       " load file type plugins + indentation

" Show line numbers with custom highlight
set number
set numberwidth=4 " Default is 4
highlight LineNr ctermfg=gray

"" Whitespace
set wrap                        " wrap lines
set tabstop=2 shiftwidth=2      " a tab is two spaces (or set this to 4)
set expandtab                   " use spaces, not tabs (optional)
set backspace=indent,eol,start  " backspace through everything in insert mode

"" Searching
set hlsearch                    " highlight matches
set incsearch                   " incremental searching
set ignorecase                  " searches are case insensitive...
set smartcase                   " ... unless they contain at least one capital letter

" use comma as <Leader> key instead of backslash
let mapleader=","

" don't use swap
set noswapfile

" double percentage sign in command mode is expanded
" to directory of current file - http://vimcasts.org/e/14
cnoremap %% <C-R>=expand('%:h').'/'<cr>

" map <leader>f :CommandTFlush<cr>\|:CommandT<cr>
" map <leader>F :CommandTFlush<cr>\|:CommandT %%<cr>
map <leader>t :CtrlP<cr>
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files']

"" --------------------- LaTeX configuration
" IMPORTANT: grep will sometimes skip displaying the file name if you
" search in a singe file. This will confuse Latex-Suite. Set your grep
" program to always generate a file-name.
set grepprg=grep\ -nH\ $*

" OPTIONAL: Starting with Vim 7, the filetype of empty .tex files defaults to
" 'plaintex' instead of 'tex', which results in vim-latex not being loaded.
" The following changes the default filetype back to 'tex':
let g:tex_flavor='latex'
let g:Tex_DefaultTargetFormat='pdf'

" Match as ErrorMsg character after certain column
" \%> Match after column with the number right after this
" 73  The number
" v   On virtual columns only
" .\+ Match one or more of any character
" match ErrorMsg /\%>79v.\+/

" Match as ErrorMsg any tabs that are not at the beginning of the line
" [^   Begin of non-capture group
" ]    End of non-capture group
" \zs  zero-width match that places the matching at the beginning of the line
"      ignore whitespaces
" \t\+ One or more tabs in a row
" match ErrorMsg /[^\t]\zs\t\+/

" Set status bar format
set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [ASCII=\%03.3b]\ [HEX=\%02.2B]\ [POS=%04l,%04v]\ [%p%%]\ [LEN=%L]

" Make sure status line is always shown as the second-last line
set laststatus=2

" Cursor tracking
set cursorline
" highlight CursorLine ctermbg=Blue
" highlight CursorColumn ctermbg=Blue

" Load custom abbreviations
" source $HOME/.vim/abbreviations.vim

" tmux will send xterm-style keys when its xterm-keys option is on
if &term =~ '^screen'
  execute "set <xUp>=\e[1;*A"
  execute "set <xDown>=\e[1;*B"
  execute "set <xRight>=\e[1;*C"
  execute "set <xLeft>=\e[1;*D"
endif

" Map Ctrl+s for saving file
map <C-s> :w<cr>
imap <C-s> <esc>:w<cr>a
" Map Ctrl+c for copying text
vmap <C-c> y
" Map Ctrl+v for pastinig clipboard contents
imap <C-v> <esc>P
" Map Ctrl+x for cutting text
vmap <C-x> x

" Map Enter to navigate through links
nmap <CR> <C-]>
" Map Backspace to go back
nmap <BS> <C-T>

" Map <C-right> to go next buffer
map <C-right> <ESC>:bn<CR>
" Map <C-left> to go previous buffer
map <C-left> <ESC>:bp<CR>

" Using templates
" function! LoadTemplate(extension)
"   silent! :execute '0r $HOME/.vim/templates/' . a:extension . '.tpl'
"   silent! execute 'source $HOME/.vim/templates/' . a:extension .
"   '.patterns.tpl'
" endfunction
" 
" autocmd BufNewFile * silent! call LoadTemplate('%:e')

" Map Ctrl+j for jumping between templates placeholders
nnoremap <c-j> /<+.\{-1,}+><cr>c/+>/e<cr>
inoremap <c-j> <ESC>/<+.\{-1,}+><cr>c/+>/e<cr>

" Match template placeholders
" match Todo /<+.\++>/

" Taglist management
" set tags=/path/to/tags
nmap <F7> <C-]>
nmap <S-F7> <C-T>
nmap <A-F7> :ptselect<cr>
nmap <F8> :tnext<cr>
nmap <C-F8> :tprev<cr>

" Working with dictionaries
" set dictionary+=/path/to/dictionary/file/with/words

" Omnicompletion
" set omnifunc=MyCompleteFunction

" Extending CleverTab and map Tab to autocompletion
function! SuperCleverTab()
  " check if at beginning of line or after a space
  if strpart(getline('.'), 0, col('.') - 1) =~ '^\s*$'
    return "\<Tab>"
  else
    " do we have omni completion available
    if &omnifunc != ''
      " use omni-completion 1. priority
      return "\<C-X>\<C-O>"
    elseif &dictionary != ''
      " no omni-completion, try dictionary completion
      return "\<C-K>"
    else
      " use known-word completion
      return "\<C-N>"
    endif
  endif
endfunction
" bind funciton to the tab key
inoremap <Tab> <C-R>=SuperCleverTab()<cr>

" Preserve noeol (missing trailing eol) when saving file. In order
" to do this we need to temporarily 'set binary' for the duration of
" file writing, and for DOS line endings, add the CRs manually.
" For Mac line endings, also must join everything to one line since it doesn't
" use a LF character anywhere and 'binary' writes everything as if it were Unix.
 
" This works because 'eol' is set properly no matter what file format is used,
" even if it is only used when 'binary' is set.
 
augroup automatic_noeol
  au!
  au BufWritePre  * call <SID>TempSetBinaryForNoeol()
  au BufWritePost * call <SID>TempRestoreBinaryForNoeol()
augroup END
 
function! s:TempSetBinaryForNoeol()
  let s:save_binary = &binary
  if ! &eol && ! &binary
    let s:save_view = winsaveview()
    setlocal binary
    if &ff == "dos" || &ff == "mac"
      if line('$') > 1
        undojoin | exec "silent 1,$-1normal! A\<C-V>\<C-M>"
      endif
    endif
    if &ff == "mac"
      undojoin | %join!
      " mac format does not use a \n anywhere, so we don't add one when writing
      " in binary (which uses unix format always). However, inside the outer
      " if statement, we already know that 'noeol' is set, so no special logic
      " is needed.
    endif
  endif
endfunction
 
function! s:TempRestoreBinaryForNoeol()
  if ! &eol && ! s:save_binary
    if &ff == "dos"
      if line('$') > 1
        " Sometimes undojoin gives errors here, even when it shouldn't.
        " Suppress them for now...if you can figure out and fix them instead,
        " please update http://vim.wikia.com/wiki/VimTip1369
        silent! undojoin | silent 1,$-1s/\r$//e
      endif
    elseif &ff == "mac"
      " Sometimes undojoin gives errors here, even when it shouldn't.
      " Suppress them for now...if you can figure out and fix them instead,
      " please update http://vim.wikia.com/wiki/VimTip1369
      silent! undojoin | silent %s/\r/\r/ge
    endif
    setlocal nobinary
    call winrestview(s:save_view)
  endif
endfunction
