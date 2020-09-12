set nocompatible
set mouse=a
set number
set expandtab
set shiftwidth=2
set softtabstop=2
set tabstop=2
set showmatch
set hidden

nnoremap <F2> :set invpaste paste?<CR>
set pastetoggle=<F2>
set showmode

let mapleader = "\<Space>"


if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
  silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.local/share/nvim/plugged')
  Plug 'easymotion/vim-easymotion'
  Plug 'mg979/vim-visual-multi'                      
  Plug 'tomtom/tcomment_vim'
  Plug 'habamax/vim-gruvbit'
  Plug 'tpope/vim-surround'
  Plug 'neoclide/coc.nvim', {'do': 'yarn install --frozen-lockfile'}
  Plug 'LnL7/vim-nix'
  Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
  Plug 'junegunn/fzf.vim'
call plug#end()

" if you think about it there are a few fundamental things i want to do when
" editing text. I want to be able to
" navigate/select, delete, copy, paste, type

" stupid Esc key
inoremap <c-l> <esc>
nnoremap <c-l> <esc>

" easymotion config
let g:EasyMotion_smartcase = 1
let g:EasyMotion_do_mapping = 1
map <Enter> <Plug>(easymotion-prefix)


" Colour scheme
set termguicolors
colorscheme gruvbit

" fzf config
nnoremap <silent> <c-g> :Files<cr>
nnoremap <silent> <c-f> :Rg<cr>

" coc.nvim config
hi Pmenu ctermfg=15 ctermbg=238
hi CocErrorSign ctermfg=15
set updatetime=200
set shortmess+=c
set signcolumn=yes
set nobackup
set nowritebackup
set cmdheight=2

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current
" position. Coc only does snippet and additional edit on confirm.
" <cr> could be remapped by other vim plugin, try `:verbose imap <CR>`.
if exists('*complete_info')
  inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
  inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif

" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> <leader><left> <Plug>(coc-diagnostic-prev)
nmap <silent> <leader><right> <Plug>(coc-diagnostic-next)

nmap <silent> <leader>d <Plug>(coc-definition)
nmap <silent> <leader>t <Plug>(coc-type-definition)
nmap <silent> <leader>i <Plug>(coc-implementation)
nmap <silent> <leader>r <Plug>(coc-references)

nnoremap <silent> K :call <SID>show_documentation()<CR>
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Remap keys for applying codeAction to the current buffer.
nmap <leader>ca  <Plug>(coc-codeaction)

nmap <leader>f   :call CocAction('format')<cr>

nnoremap <silent><nowait> <leader>o  :<C-u>CocList outline<cr>

