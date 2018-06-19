"dein Scripts-----------------------------
" Required:
set runtimepath+=/home/ildar/.config/nvim/dein/repos/github.com/Shougo/dein.vim

" Required:
if dein#load_state('/home/ildar/.config/nvim/dein/')
  call dein#begin('/home/ildar/.config/nvim/dein/')

  " Let dein manage dein
  " Required:
  call dein#add('/home/ildar/.config/nvim/dein//repos/github.com/Shougo/dein.vim')

  " Add or remove your plugins here:
  " call dein#add('Shougo/neosnippet.vim')
  " call dein#add('Shougo/neosnippet-snippets')
  call dein#add('Shougo/vimproc.vim', {'build': 'make'})
  call dein#add('vim-airline/vim-airline')

  call dein#add('altercation/vim-colors-solarized')
  call dein#add('morhetz/gruvbox')
  call dein#add('tomasr/molokai')
  call dein#add('chriskempson/base16-vim')
  call dein#add('vim-airline/vim-airline-themes')

  call dein#add('junegunn/fzf', { 'build': './install --all', 'merged': 0 })
  call dein#add('junegunn/fzf.vim', { 'depends': 'fzf' })

  call dein#add('christoomey/vim-tmux-navigator')
  call dein#add('brooth/far.vim')
  call dein#add('lambdalisue/gina.vim')
  call dein#add('chemzqm/unite-location')
  call dein#add('neoclide/denite-extra')

  " Shougo
  call dein#add('Shougo/unite.vim')
  call dein#add('Shougo/unite-outline')
  call dein#add('Shougo/denite.nvim')
  call dein#add('Shougo/neomru.vim')
  call dein#add('Shougo/vimfiler.vim')

  " GIT
  call dein#add('tpope/vim-fugitive')
  call dein#add('junegunn/gv.vim')
  call dein#add('jreybert/vimagit')
  call dein#add('sjl/splice.vim')
  call dein#add('airblade/vim-gitgutter')
  " call dein#add('hrsh7th/vim-unite-vcs')

  call dein#add('Shougo/deoplete.nvim')
  " pip2 install jedi
  call dein#add('zchee/deoplete-jedi')

  " tpope
  " call dein#add('tpope/vim-sleuth')
  call dein#add('tpope/vim-unimpaired')
  call dein#add('tpope/vim-repeat')
  call dein#add('tpope/vim-commentary')
  call dein#add('tpope/vim-surround')
  call dein#add('tpope/vim-endwise')
  call dein#add('tpope/vim-rsi')
  call dein#add('tpope/vim-obsession')
  call dein#add('tpope/vim-sensible')
  call dein#add('tpope/vim-projectionist')

  " syntax highlighting
  call dein#add('ekalinin/Dockerfile.vim')

  " working with csv
  call dein#add('chrisbra/csv.vim')

  " search plugins
  call dein#add('osyo-manga/vim-anzu')

  " xml plugins
  call dein#add('sukima/xmledit')
  call dein#add('actionshrimp/vim-xpath')

  " color, syntax
  " call dein#add('sentientmachine/Pretty-Vim-Python')
  call dein#add('hdima/python-syntax')
  call dein#add('hail2u/vim-css3-syntax')

  " trailing whitespace
  call dein#add('ntpeters/vim-better-whitespace')

  " SQL
  call dein#add('vim-scripts/SQLComplete.vim')
  call dein#add('lifepillar/pgsql.vim')
  call dein#add('vim-scripts/dbext.vim')

  " Start window, recent files
  call dein#add('mhinz/vim-startify')

  " Sayonara
  call dein#add('mhinz/vim-sayonara')

  " Linters
  call dein#add('neomake/neomake')

  " misc
  call dein#add('rhysd/clever-f.vim')
  call dein#add('sheerun/vim-polyglot')
  " call dein#add('pelodelfuego/vim-swoop')
  call dein#add('skwp/greplace.vim')

  " Required:
  call dein#end()
  call dein#save_state()
endif

" Required:
filetype plugin indent on
syntax enable

" If you want to install not installed plugins on startup.
if dein#check_install()
  call dein#install()
endif

"End dein Scripts-------------------------


" Copy from neovim to system clipboard
set clipboard+=unnamedplus

set nobackup       "no backup files
set nowritebackup  "only in case you don't want a backup file while editing
set noswapfile     "no swap files

let mapleader = "\<Space>"
let maplocalleader = ","

" Ctrol-Tab to switch between 2 last buffers
nmap <leader><Tab> :b#<cr>

nmap <leader>w :w<cr>

let g:gruvbox_italic=1
colorscheme gruvbox
set background=dark
" colorscheme base16-gruvbox-dark-medium

let g:airline_powerline_fonts = 1
augroup Fix_airline_with_unite
    autocmd FileType unite AirlineRefresh
    autocmd FileType vimfiler AirlineRefresh
augroup END
let g:airline_theme='tomorrow' " dark simple badwolf solarized solarized2
let g:airline#extensions#tabline#enabled = 1

set noshowmode

nmap <leader>ff :Files<cr>

nmap <leader>o :Unite -no-split -buffer-name=outline -start-insert outline<cr>

if executable("ag") && ('' == $FZF_DEFAULT_COMMAND)
  let $FZF_DEFAULT_COMMAND = "ag --follow --nocolor --nogroup -g ''"
endif

" deoplete
call deoplete#enable()
autocmd CompleteDone * pclose " To close preview window of deoplete automagically
let g:deoplete#enable_at_startup = 1
let g:deoplete#enable_smart_case = 1
let g:deoplete#auto_completion_start_length = 3
let g:deoplete#sources#jedi#python_path = '/usr/bin/python2'

let g:airline#extensions#anzu#enabled = 1
" mapping
nmap n <Plug>(anzu-n-with-echo)
nmap N <Plug>(anzu-N-with-echo)
nmap * <Plug>(anzu-star-with-echo)
nmap # <Plug>(anzu-sharp-with-echo)
" clear status
nmap <Esc><Esc> <Plug>(anzu-clear-search-status)

nmap <leader>b :Denite buffer<cr>
" Change mappings.
call denite#custom#map(
  \ 'insert',
  \ '<C-j>',
  \ '<denite:move_to_next_line>',
  \ 'noremap'
\)
call denite#custom#map(
  \ 'insert',
  \ '<C-k>',
  \ '<denite:move_to_previous_line>',
  \ 'noremap'
\)
nmap <leader>* :Ag <c-r>=expand("<cword>")<cr><cr>
nmap <leader>// :Ag<space>

nnoremap <silent> <space>p  :<C-u>Denite -resume<CR>
nnoremap <silent> <space>j  :call execute('Denite -resume -select=+'.v:count1.' -immediately')<CR>
nnoremap <silent> <space>k  :call execute('Denite -resume -select=-'.v:count1.' -immediately')<CR>
nnoremap <silent> <space>q  :<C-u>Denite -mode=normal -auto-resize quickfix<CR>
nnoremap <silent> <space>l  :<C-u>Denite -mode=normal -auto-resize location_list<CR>


" VimFiler
nmap <leader>\ :VimFiler<cr>
nmap <leader>\\ :VimFiler -find<cr>
let g:vimfiler_as_default_explorer = 1
let g:vimfiler_restore_alternate_file = 1
let g:vimfiler_tree_indentation = 1
let g:vimfiler_tree_leaf_icon = ''
let g:vimfiler_tree_opened_icon = '▼'
let g:vimfiler_tree_closed_icon = '▷'
let g:vimfiler_file_icon = ''
let g:vimfiler_readonly_file_icon = '*'
let g:vimfiler_marked_file_icon = '√'
let g:vimfiler_ignore_pattern = [
            \ '^\.git$',
            \ '^\.DS_Store$',
            \ '^\.init\.vim-rplugin\~$',
            \ '^\.netrwhist$',
            \ '\%(^\.\|\.pyc$\)',
            \ '\.class$'
            \]
" let g:vimfiler_quick_look_command = 'gloobus-preview'
call vimfiler#custom#profile('default', 'context', {
            \ 'explorer' : 1,
            \ 'winwidth' : 30,
            \ 'winminwidth' : 30,
            \ 'toggle' : 1,
            \ 'columns' : 'type',
            \ 'auto_expand': 1,
            \ 'direction' : 'topleft',
            \ 'parent': 0,
            \ 'explorer_columns' : 'type',
            \ 'status' : 1,
            \ 'safe' : 0,
            \ 'split' : 1,
            \ 'hidden': 1,
            \ 'no_quit' : 1,
            \ 'force_hide' : 0,
            \ })
augroup vfinit
    au!
    autocmd FileType vimfiler call s:vimfilerinit()
    autocmd BufEnter * if (winnr('$') == 1 && &filetype ==# 'vimfiler') |
                \ q | endif
augroup END
function! s:vimfilerinit()
    set nonumber
    set norelativenumber

    silent! nunmap <buffer> <Space>
    silent! nunmap <buffer> <C-l>
    silent! nunmap <buffer> <C-j>
    silent! nunmap <buffer> gr
    silent! nunmap <buffer> gf
    silent! nunmap <buffer> -
    silent! nunmap <buffer> s

    nnoremap <silent><buffer> gr  :<C-u>Denite grep:<C-R>=<SID>selected()<CR> -buffer-name=grep<CR>
    nnoremap <silent><buffer> gf  :<C-u>Denite file_rec:<C-R>=<SID>selected()<CR><CR>
    nnoremap <silent><buffer> gd  :<C-u>call <SID>change_vim_current_dir()<CR>
    nnoremap <silent><buffer><expr> sg  vimfiler#do_action('vsplit')
    nnoremap <silent><buffer><expr> sv  vimfiler#do_action('split')
    nnoremap <silent><buffer><expr> st  vimfiler#do_action('tabswitch')
    nmap <buffer> gx     <Plug>(vimfiler_execute_vimfiler_associated)
    nmap <buffer> '      <Plug>(vimfiler_toggle_mark_current_line)
    " nmap <buffer> v      <Plug>(vimfiler_quick_look)
    " nmap <buffer> p      <Plug>(vimfiler_preview_file)
    nmap <buffer> V      <Plug>(vimfiler_clear_mark_all_lines)
    nmap <buffer> i      <Plug>(vimfiler_switch_to_history_directory)
    nmap <buffer> <Tab>  <Plug>(vimfiler_switch_to_other_window)
    nmap <buffer> <C-r>  <Plug>(vimfiler_redraw_screen)
endf


" call dein#add('hdima/python-syntax')
let python_highlight_all = 1

let base16colorspace=256

" vim-startify
let g:startify_change_to_vcs_root = 1

" Sayonara
nmap <leader>bd :Sayonara!<cr>
nmap <leader>bdd :Sayonara<cr>

" Denite
" Change mappings.
call denite#custom#map(
  \ 'insert',
  \ '<C-j>',
  \ '<denite:move_to_next_line>',
  \ 'noremap'
\)
call denite#custom#map(
  \ 'insert',
  \ '<C-k>',
  \ '<denite:move_to_previous_line>',
  \ 'noremap'
\)

" set termguicolors

" Neomake
nmap <leader>m :Neomake<cr>

" Projectionistk
" let g:projectionist_heuristics = {
"       \   "controllers/*.py": {"type": "controller"},
"       \   "models/*.py": {"type": "model"},
"       \   "views/*.py": {"type": "view"}
"       \ }
" autocmd User ProjectionistDetect
"       \ call projectionist#append(getcwd(),
"       \ {
"       \   "controllers/*.py": {"type": "controller"},
"       \   "models/*.py": {"type": "model"}
"       \ }

" SQL
let g:sql_type_default = 'pgsql'

function! RestoreRegister()
    let @" = s:restore_reg
    return ''
endfunction

function! PasteOver()
    let s:restore_reg = @"
    return "p@=RestoreRegister()\<cr>"
endfunction

vnoremap <silent> <expr>  zp PasteOver()
nmap <silent> zp viwzp

" greplace
set grepprg=ag
let g:grep_cmd_opts = '--line-numbers --noheading'

au FileType xml setlocal equalprg=xmllint\ --format\ --recover\ -\ 2>/dev/null
" let g:xml_syntax_folding=1
" au FileType xml setlocal foldmethod=syntax
au FileType xml :set sw=2 ts=2 et
au FileType javascript :set sw=4 ts=4 et

" CSV
let b:csv_arrange_align = 'l*'
