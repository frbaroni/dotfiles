-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
vim.opt.number = true -- Show line numbers
vim.opt.relativenumber = true -- Show relative line numbers
vim.opt.clipboard = "unnamedplus" -- Use system clipboard
vim.opt.wrap = false -- Disable line wrapping
vim.opt.colorcolumn = '120' -- Highlight column 120
vim.opt.smartcase = true -- Smart case search
vim.opt.ignorecase = true -- Ignore case in search
vim.opt.autoread = true -- Auto-reload files changed outside
vim.opt.scrolloff = 4 -- Keep 4 lines visible when scrolling
vim.opt.tabstop = 2 -- Set tab width to 2 spaces
vim.opt.shiftwidth = 2 -- Indent with 2 spaces
vim.opt.expandtab = true -- Use spaces instead of tabs
vim.opt.scrollback = -1 -- Unlimited scrollback in terminal
vim.g.mapleader = " " -- Set space as the leader key
vim.opt.termguicolors = true -- Enable 24-bit RGB colors
vim.opt.cursorline = true -- Highlight the current line
vim.opt.splitbelow = true -- Horizontal splits go below
vim.opt.splitright = true -- Vertical splits go right
vim.opt.mouse = "a" -- Enable mouse support

require("lazy").setup({
  spec = {
    {
      "catppuccin/nvim",
      lazy = false,
      priority = 1000,
      config = function()
        vim.cmd([[colorscheme catppuccin]])
      end,
    },
    {
      "ibhagwan/fzf-lua",
      dependencies = { "nvim-tree/nvim-web-devicons" },
      config = function()
        require("fzf-lua").setup({'fzf-vim',winopts={fullscreen=true,preview={hidden=false}}})
      end,
    },
    {
      "nvim-treesitter/nvim-treesitter",
      build = ":TSUpdate",
      config = function()
        require("nvim-treesitter.configs").setup({
          modules = { "highlight" },
          ignore_install = { },
          ensure_installed = { "lua", "python", "javascript", "typescript", "html", "css" },
          sync_install = false, -- Install parsers asynchronously (only applied to `ensure_installed`)
          auto_install = true, -- Automatically install missing parsers when entering a buffer
          highlight = { enable = true, additional_vim_regex_highlighting = false },
          indent = { enable = true },
        })
      end,
    },
    {
      "williamboman/mason.nvim",
    },
    {
      "neovim/nvim-lspconfig",
    },
    {
      "williamboman/mason-lspconfig.nvim",
      config = function()
        require("mason").setup()

        require("mason-lspconfig").setup({
          ensure_installed = { "lua_ls", "ts_ls" },
          automatic_installation = true,
        })

        local lspconfig = require("lspconfig")
        lspconfig.lua_ls.setup({})
        lspconfig.ts_ls.setup({})
      end,
    },
    {
      "folke/which-key.nvim",
      config = function()
        require("which-key").setup({})
      end,
    },
    {
      "kevinhwang91/nvim-bqf",
      ft = "qf",
    },
    {
      "tpope/vim-dadbod",
      lazy = true,
    },
    {
      "kristijanhusak/vim-dadbod-ui",
      dependencies = { "tpope/vim-dadbod" },
      cmd = { "DBUI" },
      config = function()
        vim.g.db_ui_save_location = "~/.config/nvim/db_ui/"
      end,
    },
    {
      'saghen/blink.cmp',
      dependencies = 'rafamadriz/friendly-snippets',
      version = '*',
      opts = {
        keymap = { preset = 'default' },

        appearance = {
          use_nvim_cmp_as_default = true,
          nerd_font_variant = 'mono'
        },

        sources = {
          default = { 'lsp', 'path', 'snippets', 'buffer' },
          providers = {
            buffer = {
              opts = {
                get_bufnrs = function()
                  return vim.tbl_filter(function(bufnr)
                    return vim.bo[bufnr].buftype == ''
                  end, vim.api.nvim_list_bufs())
                end
              }
            }
          }
        },
      },
      opts_extend = { "sources.default" }
    },
    {
      'neovim/nvim-lspconfig',
      dependencies = { 'saghen/blink.cmp' },
      opts = {
        servers = {
          lua_ls = {}
        }
      },
      config = function(_, opts)
        local lspconfig = require('lspconfig')
        for server, config in pairs(opts.servers) do
          config.capabilities = require('blink.cmp').get_lsp_capabilities(config.capabilities)
          lspconfig[server].setup(config)
        end
      end,
    },
    {
      'lewis6991/gitsigns.nvim',
      opts = {},
    },
    {
      'tpope/vim-fugitive',
    },
  }
})

local gitsigns = require('gitsigns')
local wk = require('which-key')
local fzf_lua = require('fzf-lua')

wk.add({
    { "<Esc>", "<cmd>noh<CR><Esc>", desc = "Clear Search Highlight" },

    { "<leader>f", group = "find" },
    { "<leader>fa", fzf_lua.builtin, desc = "Find All" },
    { "<leader>fr", fzf_lua.oldfiles, desc = "Find Recent" },
    { "<leader>ff", fzf_lua.files, desc = "Find Files" },
    { "<leader>fp", fzf_lua.git_files, desc = "Find Gitfiles" },
    { "<leader>fg", fzf_lua.live_grep, desc = "Find Grep" },
    { "<leader>fb", fzf_lua.buffers, desc = "Find Buffers" },
    { "<leader>fh", fzf_lua.help_tags, desc = "Find Helptags" },
    { "<leader>fc", fzf_lua.commands, desc = "Find Commands" },
    { "gd", fzf_lua.lsp_definitions, desc = "Definition" },
    { "gr", fzf_lua.lsp_references, desc = "References" },
    { "gf", fzf_lua.grep_visual, desc = "Find Visual", mode = "v" },

    { "<leader>g", group = "Git" },
    { "<leader>gp", gitsigns.preview_hunk, desc = "Preview" },
    { "<leader>gs", gitsigns.stage_hunk, desc = "Stage" },
    { "<leader>gu", gitsigns.reset_hunk, desc = "Reset" },
    { "<leader>gb", gitsigns.toggle_current_line_blame, desc = "Toggle line blame" },
    { "<leader>gl", function() gitsigns.blame_line{full=true} end, desc = "Line blame" },
    { "[g", gitsigns.next_hunk, desc = "Gitsigns Next" },
    { "]g", gitsigns.prev_hunk, desc = "Gitsigns Prev" },

    { "<leader>c", group = "Lsp Change" },
    { "<leader>cf", vim.lsp.buf.format, desc = "Format" },
    { "<leader>ca", vim.lsp.buf.code_action, desc = "Actions" },
    { "<leader>cr", vim.lsp.buf.rename, desc = "Rename" },
    { "<leader>d", vim.diagnostic.open_float, desc = "Show Diagnostics" },
    { "[d", vim.diagnostic.goto_next, desc = "Diagnostic Next" },
    { "]d", vim.diagnostic.goto_prev, desc = "Diagnostic Prev" },
    { "ga", vim.lsp.buf.code_action, desc = "Actions" },
    { "K", vim.lsp.buf.hover, desc = "Show Hover" },
    { "<C-h>", vim.lsp.buf.signature_help, desc = "Signature Help", mode = "i" },
    { "<C-space>", "<C-\\><C-n>", desc = "Exit Terminal mode", mode = "t" },
    { "<leader>wp", function() vim.cmd("terminal make prettier -C ~/dev") end, desc = "Prettier" },
    { "<C-m>", "<cmd>cn<cr>", desc = "Quickfix Next" },
    { "<C-n>", "<cmd>cp<cr>", desc = "Quickfix Prev" },
    { "<C-h>", "<C-w>h", desc = "Go left" },
    { "<C-j>", "<C-w>j", desc = "Go down" },
    { "<C-k>", "<C-w>k", desc = "Go up" },
    { "<C-l>", "<C-w>l", desc = "Go right" },

})
