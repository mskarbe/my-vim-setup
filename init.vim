"""""""""""""""""""""""""""
" VIM SETTINGS
"""""""""""""""""""""""""""

set encoding=utf-8

" show line numbers
set number

" enable line wrapping
set wrap
set linebreak

" syntax highlighting
syntax on
set background=dark

" use newer regex engine
set re=0

" enable search highlighting
set hlsearch

" enable incremental search
set incsearch

" smart search: if no upper-case in search string, will be case insensitive
set ignorecase
set smartcase

" autosave on file switch + confirm for quitting unsaved files
set autowrite
set confirm

" autoindentation + tab with 4 spaces
set autoindent
set smarttab
set tabstop=4
set softtabstop=4
set shiftwidth=4

" enable spell check
set spell

" filename as tab title
set titlestring=%t
set title

" show cursor position
set ruler

" remember last 150 commands
set history=150

" try to show paragraph's last line
set display+=lastline

" number of lines below and above cursor
set scrolloff=2

" show status line
set laststatus=2
set cmdheight=2
set statusline+=%#warningmsg#

" enable scroll with mouse :|
set mouse=a

" no backup
set nobackup
set nowritebackup

" decrease update time
set updatetime=500

" hidden buffer
set hidden

" splitting
set splitbelow
set splitright
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

"""""""""""""""""""""""""""
" PLUGINS INIT
"""""""""""""""""""""""""""

call plug#begin('~/.vim/plugged')

" git
Plug 'tpope/vim-fugitive'

" nodejs
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'leafgarland/typescript-vim'

" crispy comments
Plug 'preservim/nerdcommenter'

" linter (eslint)
Plug 'dense-analysis/ale'

" file tree
Plug 'preservim/nerdtree'

" status bar
Plug 'itchyny/lightline.vim'

" system clipboard
Plug 'christoomey/vim-system-copy'

" fzf finder
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" color theme
Plug 'morhetz/gruvbox'

" markdown
Plug 'godlygeek/tabular'
Plug 'preservim/vim-markdown'
Plug 'mzlogin/vim-markdown-toc'

" Graphql
Plug 'jparise/vim-graphql'

call plug#end()

"""""""""""""""""""""""""""
" PLUGINS OPTIONS
"""""""""""""""""""""""""""
set filetype
let g:system_copy_silent = 1

" set color theme
colorscheme gruvbox

" NERDTree options
nnoremap <leader>n :NERDTreeFocus<CR>
nnoremap <C-n> :NERDTree<CR>
nnoremap <C-t> :NERDTreeToggle<CR>
nnoremap <C-f> :NERDTreeFind<CR>
autocmd VimEnter * NERDTree
let NERDTreeShowHidden=1

" markdown plugin options
let g:vim_markdown_toc_autofit = 1
let g:vmt_auto_update_on_save = 0
let g:vmt_fence_text = 'TOC'
let g:vmt_fence_closing_text = 'TOC'

" lightline
let g:lightline = {
      \ 'colorscheme': 'wombat',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'FugitiveHead'
      \ },
      \ }

" commenter
let g:NERDCreateDefaultMappings = 1
let g:NERDSpaceDelims = 1
let g:NERDCompactSexyComs = 1
let g:NERDDefaultAlign = 'left'
let g:NERDAltDelims_java = 1
let g:NERDCustomDelimiters = { 'c': { 'left': '/**','right': '*/' } }
let g:NERDTrimTrailingWhitespace = 1
let g:NERDToggleCheckAllLines = 1

" prettier prettier
let g:ale_fixers = {
\   '*': ['remove_trailing_lines', 'trim_whitespace'],
\   'javascript': ['prettier', 'eslint'],
\}
let g:ale_fix_on_save = 1
autocmd BufWritePost *.js,*.jsx,*.ts,*.tsx ALEFix

augroup ale
  autocmd!

  autocmd VimEnter *
    \ let g:ale_lint_on_enter = 1 |
    \ let g:ale_lint_on_text_changed = 0
augroup END

" ts
let g:typescript_compiler_binary = 'tsc'
let g:typescript_compiler_options = '--lib es6'

" coc
let g:coc_global_extensions = ['coc-tsserver', 'coc-json', 'coc-prettier']

" :)
command! -nargs=? EduarditoBonito :echo 'nicolas cage is the best. here, eat some pickles'

"""""""""""""""""""""""""""
" COC OPTIONS FOR NODE
" copied from https://github.com/neoclide/coc.nvim#example-vim-configuration
"""""""""""""""""""""""""""

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Make <CR> auto-select the first completion item and notify coc.nvim to
" format on enter, <cr> could be remapped by other vim plugin
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Run the Code Lens action on the current line.
nmap <leader>cl  <Plug>(coc-codelens-action)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of language server.
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocActionAsync('format')
nnoremap <C-p><C-p> :Format<CR>
" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OrgImps` command for organize imports of the current buffer.
command! -nargs=0 OrgImps :call CocActionAsync('runCommand', 'editor.action.organizeImport')
nnoremap <C-p><C-o> :OrgImps<CR>

" provide custom statusline: lightline.vim, vim-airline.
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Mappings for CoCList
" Show all diagnostics.
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>
