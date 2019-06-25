" Core

imap jj <Esc>
syntax enable
set backspace=indent,eol,start
set incsearch
set number
set autoread " Auto-reload changed files
set ignorecase " ignore case in search
set smartcase " honor case if capital present
set noswapfile " Disable .swp files
set tabstop=2 " show existing tab with 2 spaces width
set shiftwidth=2 " when indenting with '>', use 2 spaces width
set clipboard=unnamed
" filetype indent plugin on
set nofoldenable " Enables code folding
"set foldmethod=syntax
"set foldlevel=1

let mapleader = ","
nmap <Leader>e :e %:h<CR>

" Plugins

" plug
" Automatically install plug if it doesn't exist
" Note: This require curl

if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" install plugs
call plug#begin()
Plug 'elixir-editors/vim-elixir' " Elixir support for vim
Plug 'slashmili/alchemist.vim' " Elixir support for vim
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' } " fzf
Plug 'junegunn/fzf.vim' " fzf
Plug 'morhetz/gruvbox' " gruvbox colorscheme
Plug 'godlygeek/tabular' " used with vim-markdown
Plug 'plasticboy/vim-markdown'
Plug 'junegunn/goyo.vim' " To make distractions go away
call plug#end()

" Goyo
function! s:goyo_enter()
  if executable('tmux') && strlen($TMUX)
    silent !tmux set status off
    silent !tmux list-panes -F '\#F' | grep -q Z || tmux resize-pane -Z
  endif
  set noshowmode
  set noshowcmd
  set scrolloff=999
  " Limelight
  " ...
endfunction

function! s:goyo_leave()
  if executable('tmux') && strlen($TMUX)
    silent !tmux set status on
    silent !tmux list-panes -F '\#F' | grep -q Z && tmux resize-pane -Z
  endif
  set showmode
  set showcmd
  set scrolloff=5
  " Limelight!
  " ...
endfunction

autocmd! User GoyoEnter nested call <SID>goyo_enter()
autocmd! User GoyoLeave nested call <SID>goyo_leave()

map <Leader>q :Goyo<CR>
let g:goyo_height = 100
let g:goyo_width = 100

" vim-markdown
" Folding
let g:vim_markdown_folding_disabled = 1
let g:vim_markdown_toc_autofit = 1
set conceallevel=2
let g:vim_markdown_fenced_languages = ['elixir=ex']

" Theme
set termguicolors
colorscheme gruvbox
set background=dark    " Setting dark mode

" alchemist
" let g:alchemist#elixir_erlang_src = "/usr/local/share/src"

" """""
" FZF
" """""
let $FZF_DEFAULT_COMMAND = 'ag --hidden --ignore .git -l ""'
" Default options are --nogroup --column --color
let s:ag_options = ' --hidden '
noremap <leader>t :Files<CR>
noremap <leader>r :Ag<CR>
noremap ; :Buffers<CR>

let g:fzf_history_dir = '~/.local/share/fzf-history'

" Customize fzf colors to match your color scheme
let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }

command! -bang -nargs=* Ag
  \ call fzf#vim#ag(<q-args>,
  \                 <bang>0 ? fzf#vim#with_preview('up:60%')
  \                         : fzf#vim#with_preview('right:50%:hidden', '?'),
  \                 <bang>0)

" Likewise, Files command with preview window
command! -bang -nargs=? -complete=dir Files
  \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)
