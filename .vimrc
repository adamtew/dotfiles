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
set shiftwidth=2
set expandtab
set shiftwidth=2 " when indenting with '>', use 2 spaces width
:set mouse=a
" set clipboard=unnamed
set clipboard=unnamedplus
set colorcolumn=80
set undofile " so undoing is persisted to a file
set undolevels=1000   " Maximum number of changes that can be undone
set undoreload=10000  " Maximum number lines to save for undo on a buffer reload
set relativenumber
set hlsearch " Highlights searched words
set showmatch
" Pasting
" https://stackoverflow.com/questions/2514445/turning-off-auto-indent-when-pasting-text-into-vim/38258720#38258720
" let &t_SI .= "\<Esc>[?2004h"
" let &t_EI .= "\<Esc>[?2004l"

inoremap <special> <expr> <Esc>[200~ XTermPasteBegin()

function! XTermPasteBegin()
  set pastetoggle=<Esc>[201~
  set paste
  return ""
endfunction

" filetype indent plugin on
set nofoldenable " Enables code folding
set foldmethod=syntax
"set foldlevel=1
" autocmd InsertEnter,InsertLeave * set cul!
set cul
set tags=tags
set hidden
if has('nvim')
  set shada='1000,f1,<500 " The shared data
endif

let mapleader = ","
"nmap <Leader>e :e %:h<CR>
" nmap <Leader>e :Ranger<CR>
map <leader>T :Test<CR>
map <leader>F :Format<CR>
map <leader>f :e %:h<CR>
map <leader>v :tabf ~/.vimrc<CR>
map <leader>S :source $MYVIMRC<CR>
" Remove the highlights
map <leader>q :noh<CR> 

" Copy file name directory/name
nmap <Leader>yp :let @+=expand('%:p')<CR>
" Copy file name 'tail'
nmap <Leader>yt :let @+=expand('%:t')<CR>

map <leader>gb :Git blame<CR>


" Abbreviations
" :iabbrev csl console.log(
autocmd FileType javascript iabbrev <buffer> csl console.log()<left>
" autocmd FileType elixir iabbrev <buffer> iop IO.inspect()
autocmd FileType elixir iabbrev <buffer> pry require IEx; IEx.pry()

"""""""
" Commands
"""""""
command! Format !mix format %
command! Test !mix test %
command! FormatJSON %!python -m json.tool

" Autocommands
" autocmd TermOpen * startinsert

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
call plug#begin() " PlugInstall
" Deoplete for autocompletion
" if has('nvim')
"   Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
" else
"   Plug 'Shougo/deoplete.nvim'
"   Plug 'roxma/nvim-yarp'
"   Plug 'roxma/vim-hug-neovim-rpc'
" endif

" using the elixir-ls version of elixir support https://www.mitchellhanberg.com/post/2018/10/18/how-to-use-elixir-ls-with-vim/
Plug 'elixir-editors/vim-elixir' " Elixir support for vim
Plug 'slashmili/alchemist.vim' " Elixir support for vim
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' } " fzf
Plug 'junegunn/fzf.vim' " fzf
Plug 'morhetz/gruvbox' " gruvbox colorscheme
"Plug 'godlygeek/tabular' " used with vim-markdown
"Plug 'plasticboy/vim-markdown'
"Plug 'junegunn/goyo.vim' " To make distractions go away
"Plug 'mxw/vim-jsx' " Jsx support for vim
Plug 'pangloss/vim-javascript'
Plug 'leafgarland/typescript-vim' " Typescript support
Plug 'maxmellon/vim-jsx-pretty'
Plug 'terryma/vim-multiple-cursors' " Multicursor
Plug 'scrooloose/nerdcommenter' " getting comments to work
" Plug 'ludovicchabant/vim-gutentags' " tags for goto definition
Plug 'sheerun/vim-polyglot' " syntax (and other features) for all the languages
Plug 'dense-analysis/ale' " linting
" Plug 'francoiscabrol/ranger.vim'
Plug 'tpope/vim-fugitive' " git management
" Plug 'chrisbra/csv.vim'
Plug 'OmniSharp/omnisharp-vim'
" Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'madox2/vim-ai', { 'do': './install.sh' }
Plug 'vim-scripts/svg.vim'
call plug#end()

""""""""""""""" Go """""""""""""""


" vim-go (using native package manager in  ~/.vim/pack/plugins/start/vim-go)
" au FileType go nmap <leader>r <Plug>(go-run)
" au FileType go nmap <leader>b <Plug>(go-build)
" au FileType go nmap <leader>t <Plug>(go-test)
" au FileType go nmap <leader>c <Plug>(go-coverage-toggle)
" au FileType go nmap <Leader>e <Plug>(go-rename)
" au FileType go nmap <Leader>s <Plug>(go-implements)
" au FileType go nmap <Leader>i <Plug>(go-info)

"gutentags
" let g:gutentags_ctags_exclude = [
"       \ '*.git', '*.svg', '*.hg',
"       \ '_build', 'deps', 'node_modules'
" ]
" let g:gutentags_project_root = ['.git']
" let g:gutentags_generate_on_write = 1
" let g:gutentags_generate_on_missing = 1
" let g:gutentags_generate_on_write = 1
" let g:gutentags_generate_on_empty_buffer = 0

" Ranger
"let g:NERDTreeHijackNetrw = 0 " add this line if you use NERDTree
" let g:ranger_replace_netrw = 1 " open ranger when vim open a directory

" deoplete
" let g:deoplete#enable_at_startup = 1
" call deoplete#custom#option('ignore_sources', {'_': ['around', 'buffer']})
" maximum candidate window length
" call deoplete#custom#source('_', 'max_menu_width', 80)
"let g:deoplete#enable_at_startup = 1
"call deoplete#custom#option('smart_case', v:true)
"inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
"function! s:my_cr_function() abort
  "return deoplete#close_popup() . "\<CR>"
"endfunction

" Goyo
"function! s:goyo_enter()
  "if executable('tmux') && strlen($TMUX)
    "silent !tmux set status off
    "silent !tmux list-panes -F '\#F' | grep -q Z || tmux resize-pane -Z
  "endif
  "set noshowmode
  "set noshowcmd
  "set scrolloff=999
  "" Limelight
  "" ...
"endfunction

"function! s:goyo_leave()
  "if executable('tmux') && strlen($TMUX)
    "silent !tmux set status on
    "silent !tmux list-panes -F '\#F' | grep -q Z && tmux resize-pane -Z
  "endif
  "set showmode
  "set showcmd
  "set scrolloff=5
  "" Limelight!
  "" ...
"endfunction

"autocmd! User GoyoEnter nested call <SID>goyo_enter()
"autocmd! User GoyoLeave nested call <SID>goyo_leave()

"map <Leader>q :Goyo<CR>
"let g:goyo_height = 100
"let g:goyo_width = 100

" vim-markdown
" Folding
"let g:vim_markdown_folding_disabled = 1
"let g:vim_markdown_toc_autofit = 1
"set conceallevel=2
"let g:vim_markdown_fenced_languages = ['elixir', 'elixir=ex']

" Theme
set termguicolors
colorscheme gruvbox
set background=dark    " Setting dark mode

" alchemist
" let g:alchemist#elixir_erlang_src = "/usr/local/share/src"
" autocmd BufWritePost *.exs,*.ex silent :!mix format %


" """"
" NerdCommenter
" """"
let g:NERDSpaceDelims = 1
let g:NERDDefaultAlign = 'left'
let g:NERDTrimTrailingWhitespace = 1
"noremap <C-c> :NERDCommenterToggle<CR>

" """""
" FZF
" """""
let $FZF_DEFAULT_COMMAND = 'ag --hidden --ignore .git -l ""'
" Default options are --nogroup --column --color
let s:ag_options = ' --hidden '
" noremap <C-i>i :Files<CR>
noremap <C-p> :Ag<CR>
noremap <leader>af :Files<CR>
noremap <leader>ab :Buffers<CR>
" noremap <leader>ab :Buffers<CR>
noremap <leader>agf :GFiles<CR>
" noremap <leader>b :Buffers<CR>
noremap <leader>ah :History<CR>
noremap <leader>a/ :History/<CR>
noremap <leader>ac :Commits<CR>
noremap <leader>at :Tags<CR>
noremap <leader>aT :BTags<CR>
noremap <leader>aq :Helptags<CR>
noremap <leader>al :Lines<CR>
noremap <leader>aL :BLines<CR>
nnoremap <leader>aw :call fzf#vim#tags('^' . expand('<cword>'), fzf#vim#with_preview({'options': '--exact --select-1 --exit-0 +i'}))<CR>

let g:fzf_history_dir = '~/.local/share/fzf-history'
" let g:fzf_layout = { 'down': '~40%' } " default
let g:fzf_layout = { 'down': '~60%' }
let g:fzf_tags_command = 'ctags -R --exclude=deps --exclude=_build --exclude=node_modules' 

:call fzf#run({'source': 'find .', 'options': '--exclude=*.log*', 'sink': 'e'})

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

"command! -bang -nargs=* Ag
  "\ call fzf#vim#ag(<q-args>,
  "\                 <bang>0 ? fzf#vim#with_preview('up:60%')
  "\                         : fzf#vim#with_preview('right:50%:hidden', '?'),
  "\                 <bang>0)

" command! -bang -nargs=* Ag call fzf#vim#ag(<q-args>, fzf#vim#with_preview('right:50%'), <bang>0)
" command! -bang -nargs=* Ag call fzf#vim#ag(<q-args>, {'options': '--delimiter : --nth 4..'}, <bang>0)
command! -bang -nargs=* Ag call fzf#vim#ag(<q-args>, fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}), <bang>0)
command! -bang -nargs=* Tags call fzf#vim#tags(<q-args>, fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}), <bang>0)

" Likewise, Files command with preview window
command! -bang -nargs=? -complete=dir Files
  \ call fzf#vim#files(<q-args>, fzf#vim#with_preview('right:50%'), <bang>0)

" Likewise, Files command with preview window
"command! -bang -nargs=? -complete=dir GFiles
  "\ call fzf#vim#gfiles(<q-args>, fzf#vim#with_preview('right:50%'), <bang>0)

"command! -bang -nargs=? -complete=dir History
  "\ call fzf#vim#history(<q-args>, fzf#vim#with_preview('right:50%'), <bang>0)

command! -bang -nargs=? -complete=dir Buffers 
  \ call fzf#vim#buffers(<q-args>, fzf#vim#with_preview('right:50%'), <bang>0)

