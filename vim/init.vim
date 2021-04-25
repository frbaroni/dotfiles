if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

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
set timeoutlen=200
set ttimeoutlen=0
set updatetime=100
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

" FZF Fuzzy file searhcer
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
  " Map FZF
  map <leader>p :Files<cr>
  map <leader>h :History<cr>
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

Plug 'takac/vim-hardtime'
    let g:hardtime_default_on = 1

" Rust Crates
Plug 'mhinz/vim-crates'
if has('nvim')
  autocmd BufRead Cargo.toml call crates#toggle()
endif

" Treesitter
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

" Nvim Lsp
Plug 'neovim/nvim-lspconfig'
Plug 'kabouzeid/nvim-lspinstall'

" Troubles
Plug 'folke/lsp-trouble.nvim'
Plug 'folke/lsp-colors.nvim'
Plug 'kyazdani42/nvim-web-devicons'

" Completion
Plug 'nvim-lua/completion-nvim'
  autocmd BufEnter * lua require'completion'.on_attach()
  " Use <Tab> and <S-Tab> to navigate through popup menu
  inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
  inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
  inoremap <expr> <C-Space> completion#trigger_completion()

  " Set completeopt to have a better completion experience
  set completeopt=menuone,noinsert,noselect

  " Avoid showing message extra message when using completion
  set shortmess+=c
call plug#end()

colorscheme base16-tomorrow-night-eighties
highlight Normal guibg=NONE, ctermbg=NONE

lua <<EOF
  function _G.dump(...)
      local objects = vim.tbl_map(vim.inspect, {...})
      print(unpack(objects))
  end

  function _G.list_contains(list, x)
    for _, v in pairs(list) do
      if v == x then
        return true
      end
    end
    return false
  end

  -- Treesitter
  require'nvim-treesitter.configs'.setup {
    ensure_installed = "maintained",
    highlight = {
      enable = true,
    },
  }
  -- Nvim Lsp


  local nvim_lsp = require('lspconfig')
  local on_attach = function(client, bufnr)
    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
    local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

    buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- Mappings.
    local opts = { noremap=true, silent=true }
    buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
    buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
    buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
    buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
    buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
    buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
    buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
    buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
    buf_set_keymap('n', '<leader>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
    buf_set_keymap('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    buf_set_keymap('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
    buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
    buf_set_keymap('n', '<leader>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
    buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
    buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
    buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)

    -- Set some keybinds conditional on server capabilities
    if client.resolved_capabilities.document_formatting then
      buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
    end
    if client.resolved_capabilities.document_range_formatting then
      buf_set_keymap("v", "<space>f", "<cmd>lua vim.lsp.buf.range_formatting()<CR>", opts)
    end

    -- Set autocommands conditional on server_capabilities
    if client.resolved_capabilities.document_highlight then
      vim.api.nvim_exec([[
        hi LspReferenceRead cterm=bold ctermbg=red guibg=LightYellow
        hi LspReferenceText cterm=bold ctermbg=red guibg=LightYellow
        hi LspReferenceWrite cterm=bold ctermbg=red guibg=LightYellow
        augroup lsp_document_highlight
          autocmd! * <buffer>
          autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
          autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
        augroup END
      ]], false)
    end
  end

  require'lspinstall'.setup() -- important

  local languages = {
    'angular', 'bash', 'cpp', 'cmake', 'css',
    'dockerfile', 'graphql', 'html', 'json', 'lua',
    'php', 'python', 'rust', 'terraform',
    'typescript', 'vim', 'vue', 'yaml'
  }
  local servers = require'lspinstall'.installed_servers()
  for _, language in ipairs(languages) do
    if not list_contains(servers, language) then
      require'lspinstall'.install_server(language)
    end
  end
  for _, server in pairs(servers) do
    require'lspconfig'[server].setup{ on_attach = on_attach }
  end
EOF
