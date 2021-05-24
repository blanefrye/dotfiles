if has('python3')
  silent! python3 1
endif

set nocompatible

" Color stuff
set t_Co=256
filetype on
filetype plugin on
syntax enable

" Tab/indent stuff
set autoindent
set expandtab
set smarttab
set shiftwidth=4
set softtabstop=4
filetype plugin indent on

" Mouse support in console
set mouse=a

" Line numbers
set number

" Hidden buffers
set hidden

" Search
set incsearch
set hlsearch

" Case stuff
set ignorecase
set smartcase

" set Terminal title
set title

" move swap/temp files
set backupdir=~/.vim/backup
set directory=~/.vim/backup

" Delete trailing whitespace when writing buffer.
autocmd BufWritePre * %s/\s\+$//e

" best font
set guifont=Menlo\ Regular:h14

" Cycle through buffers with tab.
nnoremap <Tab> :bnext<CR>
nnoremap <S-Tab> :bprevious<CR>

"---------
" Pathogen
"---------
execute pathogen#infect()

"---------
" Color
"---------
colorscheme dracula

"---------
" CtrlP
"---------
let g:ctrlp_cache_dir = $HOME . '/.cache/ctrlp'
let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
let g:ctrlp_by_filename = 0
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'

"---------
" Airline
"---------
let g:airline_theme='dracula'
set noshowmode
set laststatus=2 "make visible
" let g:airline#extensions#syntastic#enabled = 0
" let g:airline#extensions#syntastic_check_on_open = 0
let g:airline#extensions#tabline#enabled = 1

"---------
" youcompleteme
"---------
let g:ycm_extra_conf_globlist=['/Users/bfrye/Documents/firmware/*']
let g:ycm_global_ycm_extra_conf='~/.vim/bundle/YouCompleteMe/third_party/ycmd/cpp/ycm/.ycm_extra_conf.py'
let g:ycm_show_diagnostics_ui = 0

"---------
" NERDTree
"---------
map <silent> <C-n> :NERDTreeToggle<CR>

"---------
" cscope
"---------
" search up directory tree for cscope.out file
"function! LoadCscope()
"    let db = findfile("cscope.out", ".;")
"    if (!empty(db))
"        let path = strpart(db, 0, match(db, "/cscope.out$"))
"        set nocscopeverbose " suppress 'duplicate connection' error
"        exe "cs add " . db . " " . path
"        set cscopeverbose
"    endif
"endfunction
"au BufEnter /* call LoadCscope()

