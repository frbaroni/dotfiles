let mapleader=","

if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
let g:python3_host_prog="/usr/bin/python3"

syntax on
filetype indent on
let mapleader=","
set encoding=utf-8
set backupdir=~/.vim_backup/
set undodir=~/.vim_undo/
set directory=~/.vim_swap/
set undofile
set autoindent
set smarttab
set backspace=indent,eol,start
set showcmd
set cmdheight=2
set signcolumn=yes
set colorcolumn=120
set expandtab
set incsearch
set hlsearch
set nobackup
set nowritebackup
set number
set relativenumber
set lazyredraw
set showmatch
set hidden
set clipboard=unnamedplus
set ignorecase
set smartcase
set cursorline
set cursorcolumn
set termguicolors
set background=dark
set wildmenu
set wildmode=full
set timeoutlen=400
set ttimeoutlen=0
set updatetime=300
set autoread
set title

set list
set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+
"  Disable Bells
set noerrorbells visualbell t_vb=
autocmd GUIEnter * set visualbell t_vb=

" Indent and keep selection
vnoremap > >gv
vnoremap < <gv

" w!! Allow saving of files as sudo when I forgot to start vim using sudo.
cmap w!! w !sudo tee > /dev/null %

call plug#begin()
" Vim Startify / MRU
Plug 'mhinz/vim-startify'
    let g:startify_session_autoload = 1
    let g:startify_session_persistence = 1
    let g:startify_lists = [
          \ { 'type': 'sessions',  'header': ['   Sessions']       },
          \ { 'type': 'dir',       'header': ['   MRU '. getcwd()] },
          \ { 'type': 'files',     'header': ['   MRU']            },
          \ { 'type': 'bookmarks', 'header': ['   Bookmarks']      },
          \ { 'type': 'commands',  'header': ['   Commands']       },
          \ ]


" Quick-Scope fF
Plug 'unblevable/quick-scope'

" Colorschemes
Plug 'chriskempson/base16-vim'
Plug 'xolox/vim-misc'
Plug 'xolox/vim-colorscheme-switcher'

" Lightline status bar
Plug 'itchyny/lightline.vim'  
  set noshowmode " The bar already contains the mode
  let g:lightline = {
        \ 'colorscheme': 'wombat',
        \ 'active': {
        \   'left': [ [ 'mode', 'paste' ],
        \             [ 'cocstatus', 'readonly', 'filename', 'modified' ] ]
        \ },
        \ 'component_function': {
        \   'cocstatus': 'coc#status'
        \ },
        \ }

" Indent markers
Plug 'Yggdroot/indentLine'

" Rainbow ({[]})
Plug 'luochen1990/rainbow'
  let g:rainbow_active = 1
  autocmd VimEnter * RainbowToggle

" Which-Key
Plug 'liuchengxu/vim-which-key'
  nnoremap <silent> <leader>      :<c-u>WhichKey ','<CR>
  nnoremap <silent> [      :<c-u>WhichKey '['<CR>
  nnoremap <silent> ]      :<c-u>WhichKey ']'<CR>

" Repeat
Plug 'tpope/vim-repeat'

" Unimpaired, very helpful keys
Plug 'tpope/vim-unimpaired'

" Auto tab/shiftwidth/tabstop settings based on heuristic
Plug 'tpope/vim-sleuth'

" dadbod
Plug 'tpope/vim-dadbod'

" dadbod ui
Plug 'kristijanhusak/vim-dadbod-ui'

" Fugitive xD
Plug 'tpope/vim-fugitive'

" Fugitive :GV command, commit viewer
Plug 'junegunn/gv.vim'

" Fugitive :Twiggy, branch manager
Plug 'sodapopcan/vim-twiggy'

" Git gutter
Plug 'airblade/vim-gitgutter'

" Perl Regex eregex
Plug 'othree/eregex.vim'

" Tmux integration
Plug 'christoomey/vim-tmux-navigator'

" Auto CH dir to project root (based on .git, .svn...)
" Plug 'airblade/vim-rooter'

" Polyglot - multi language syntax, indent...
Plug 'sheerun/vim-polyglot'
  let g:jsx_ext_required = 0 " Allow JSX in normal JS files

" Show Coverage
Plug 'ruanyl/coverage.vim'

" FZF Fuzzy file searhcer
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
  " Map FZF
  map <leader>p :GFiles<cr>
  map <leader>h :Files<cr>
  map <leader>. :Tags<cr>
  map <leader>b :Buffers<cr>
  map <leader>g :Rg<cr>

  function! s:build_quickfix_list(lines)
    call setqflist(map(copy(a:lines), '{ "filename": v:val }'))
    copen
    cc
  endfunction
  " <C-A><C-Q> to select all and build quickfix list from FZF results
  let g:fzf_action = {
  \ 'ctrl-a': function('s:build_quickfix_list'),
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }

  " Default fzf layout
  " - down / up / left / right
  let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6 } }

  " Enable per-command history.
  " CTRL-N and CTRL-P will be automatically bound to next-history and
  " previous-history instead of down and up. If you don't like the change,
  " explicitly bind the keys to down and up in your $FZF_DEFAULT_OPTS.
  let g:fzf_history_dir = '~/.vim_fzf_history'
  let $FZF_DEFAULT_OPTS = '--bind ctrl-a:select-all'

" UltiNips - for COC
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'

" Vimspector - CoreLLDB/LLDB debugger
let g:vimspector_enable_mappings = 'HUMAN'
Plug 'puremourning/vimspector'

" Rust Crates
Plug 'mhinz/vim-crates'
if has('nvim')
  autocmd BufRead Cargo.toml call crates#toggle()
endif

" COC
Plug 'neoclide/coc.nvim', {'do': { -> coc#util#install()}}
Plug 'neoclide/coc-snippets', {'do': 'yarn install --frozen-lockfile'}
Plug 'neoclide/coc-tsserver', {'do': 'yarn install --frozen-lockfile'}
Plug 'fannheyward/coc-pyright', {'do': 'yarn install --frozen-lockfile'}
Plug 'neoclide/coc-java', {'do': 'yarn install --frozen-lockfile'}
Plug 'neoclide/coc-yaml', {'do': 'yarn install --frozen-lockfile'}
Plug 'dansomething/coc-java-debug'
  nmap <F1> :CocCommand java.debug.vimspector.start<CR>
" Config .vimspector.json per project root:
" { "adapters": { "java-debug-server": { "name": "vscode-java", "port": "${AdapterPort}" } }, "configurations": { "Java Attach": { "default": true, "adapter": "java-debug-server", "configuration": { "request": "attach", "host": "127.0.0.1", "port": "5005" }, "breakpoints": { "exception": { "caught": "N", "uncaught": "N" } } } } }
Plug 'neoclide/coc-emmet', {'do': 'yarn install --frozen-lockfile'}
Plug 'neoclide/coc-css', {'do': 'yarn install --frozen-lockfile'}
Plug 'neoclide/coc-prettier', {'do': 'yarn install --frozen-lockfile'}
Plug 'neoclide/coc-rls', {'do': 'yarn install --frozen-lockfile'}
  inoremap <silent><expr> <TAB>
        \ pumvisible() ? coc#_select_confirm() :
        \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
        \ <SID>check_back_space() ? "\<TAB>" :
        \ coc#refresh()
  inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

  function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~# '\s'
  endfunction

  let g:coc_snippet_next = '<tab>'
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

  " Use `[g` and `]g` to navigate diagnostics
  " Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
  nmap <silent> [g <Plug>(coc-diagnostic-prev)
  nmap <silent> ]g <Plug>(coc-diagnostic-next)

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

  " Applying codeAction to the selected region.
  " Example: `<leader>aap` for current paragraph
  xmap <leader>a  <Plug>(coc-codeaction-selected)
  nmap <leader>a  <Plug>(coc-codeaction-selected)

  " Remap keys for applying codeAction to the current buffer.
  nmap <leader>ac  <Plug>(coc-codeaction)
  " Apply AutoFix to problem on the current line.
  nmap <leader>qf  <Plug>(coc-fix-current)

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

  " Remap <C-f> and <C-b> for scroll float windows/popups.
  " Note coc#float#scroll works on neovim >= 0.4.0 or vim >= 8.2.0750
  nnoremap <nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"

  " NeoVim-only mapping for visual mode scroll
  " Useful on signatureHelp after jump placeholder of snippet expansion
  if has('nvim')
    vnoremap <nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#nvim_scroll(1, 1) : "\<C-f>"
    vnoremap <nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#nvim_scroll(0, 1) : "\<C-b>"
  endif

  " Use CTRL-S for selections ranges.
  " Requires 'textDocument/selectionRange' support of language server.
  nmap <silent> <C-s> <Plug>(coc-range-select)
  xmap <silent> <C-s> <Plug>(coc-range-select)

  " Add `:Format` command to format current buffer.
  command! -nargs=0 Format :call CocAction('format')

  " Add `:Fold` command to fold current buffer.
  command! -nargs=? Fold :call     CocAction('fold', <f-args>)

  " Add `:OR` command for organize imports of the current buffer.
  command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

  " Add (Neo)Vim's native statusline support.
  " NOTE: Please see `:h coc-status` for integrations with external plugins that
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

Plug 'takac/vim-hardtime'
  let g:hardtime_default_on = 0
call plug#end()

colorscheme base16-tomorrow-night-eighties

hi Normal guibg=NONE, ctermbg=NONE
