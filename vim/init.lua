vim.opt.clipboard = "unnamedplus"
vim.opt.number = true
vim.opt.wrap = false
vim.opt.relativenumber = true
vim.opt.colorcolumn = '120'
vim.opt.smartcase = true
vim.opt.ignorecase = true
vim.opt.autoread = true
vim.opt.scrolloff = 4
vim.g.mapleader = " "
vim.opt.tabstop = 2
vim.opt.scrollback = -1

local ensure_packer = function()
	local fn = vim.fn
	local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
	if fn.empty(fn.glob(install_path)) > 0 then
		fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
		vim.cmd [[packadd packer.nvim]]
		return true
	end
	return false
end

local packer_bootstrap = ensure_packer()

require('packer').startup(function(use)
	use 'wbthomason/packer.nvim'

	use 'tpope/vim-fugitive'

	use 'tpope/vim-sleuth'

	use 'jghauser/mkdir.nvim'

	use 'jrop/jq.nvim'

	use 'nvim-lua/plenary.nvim'

	use {
		'folke/which-key.nvim',
		config = function()
			require('which-key').setup()
		end
	}

	use {
		'folke/tokyonight.nvim',
		config = function()
			vim.cmd('colorscheme tokyonight')
		end

	}

	use { "m4xshen/hardtime.nvim",
		config = function()
			require("hardtime").setup()
		end
	}

	use { 'kevinhwang91/nvim-bqf' }

	use {
		'VonHeikemen/lsp-zero.nvim',
		requires = {
			-- LSP Support
			{ 'neovim/nvim-lspconfig' },
			{ 'williamboman/mason.nvim' },
			{ 'williamboman/mason-lspconfig.nvim' },

			-- Autocompletion
			{ 'hrsh7th/nvim-cmp' },
			{ 'hrsh7th/cmp-buffer' },
			{ 'hrsh7th/cmp-path' },
			{ 'hrsh7th/cmp-nvim-lsp' },
		}
	}

	use {
		'nvim-treesitter/nvim-treesitter',
		run = ':TSUpdate',
	}

	use {
		'andersevenrud/nvim_context_vt',
		config = function()
			require('nvim_context_vt').setup({})
		end
	}


-- 	use {
-- 		'wellle/context.vim',
-- 		config = function()
-- 			vim.g.context_enabled = 0
-- 			-- let g:context_enabled = 3
-- 		end
-- 	}
	use {
		"fnune/recall.nvim",
		config = function()
			require("recall").setup({})
		end
	}

	use {
		"tris203/precognition.nvim",
		config = function()
			require('precognition').setup({})
		end
	}

	use {
		'folke/trouble.nvim',
		requires = 'kyazdani42/nvim-web-devicons',
		config = function()
			require('trouble').setup()
		end
	}


	use {
		'NvChad/nvim-colorizer.lua',
		config = function()
			require('colorizer').setup {
				user_default_options = { tailwind = "both" }
			}
		end
	}

	use {
		'nvim-lualine/lualine.nvim',
		requires = 'kyazdani42/nvim-web-devicons',
		config = function()
			require('lualine').setup({})
		end
	}

	use {
		'stevearc/overseer.nvim',
		config = function()
			require('overseer').setup()
		end
	}

	use {
		'tpope/vim-dadbod'
	}

	use {
		'kristijanhusak/vim-dadbod-ui'
	}

	use {
		'nvim-telescope/telescope.nvim'
	}

	use {
		'nvim-telescope/telescope-fzf-native.nvim',
		run = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build',
		config = function()
			require('telescope').load_extension('fzf')
		end
	}

	use { 'stevearc/dressing.nvim' }

	use {
		'lewis6991/gitsigns.nvim',
		config = function()
			require('gitsigns').setup()
		end
	}

	use {
		'xiyaowong/transparent.nvim',
		config = function()
			require("transparent").setup({
			})
		end
	}

	if packer_bootstrap then
		require('packer').sync()
	end
end)

local gitsigns = require('gitsigns')
local wk = require('which-key')
local telescope = require('telescope.builtin')
local recall = require("recall")

wk.add({
    { "<Esc>", "<cmd>noh<CR><Esc>", desc = "Clear Search Highlight" },

    { "<leader>f", group = "find" },
    { "<leader>fa", function() telescope.builtin() end, desc = "Find All" },
    { "<leader>fr", telescope.oldfiles, desc = "Find Recent" },
    { "<leader>ff", telescope.find_files, desc = "Find Files" },
    { "<leader>fp", telescope.git_files, desc = "Find Gitfiles" },
    { "<leader>fg", telescope.live_grep, desc = "Find Grep" },
    { "<leader>fb", telescope.buffers, desc = "Find Buffers" },
    { "<leader>fh", telescope.help_tags, desc = "Find Helptags" },
    { "<leader>fc", telescope.commands, desc = "Find Commands" },

    { "<leader>m", group = "Recall" },
    { "<leader>mm", recall.toggle, desc = "Toggle" },
    { "<leader>mn", recall.goto_next, desc = "Next" },
    { "<leader>mp", recall.goto_prev, desc = "Prev" },
    { "<leader>mc", recall.clear, desc = "Clear" },
    { "<leader>ml", ":Telescope recall<CR>", desc = "Telescope" },

    { "<leader>g", group = "Git" },
    { "<leader>gg", vim.cmd.Git, desc = "Open" },
    { "<leader>gp", gitsigns.preview_hunk, desc = "Preview" },
    { "<leader>gs", gitsigns.stage_hunk, desc = "Stage" },
    { "<leader>gu", gitsigns.reset_hunk, desc = "Reset" },
    { "<leader>gb", gitsigns.toggle_current_line_blame, desc = "Toggle line blame" },
    { "<leader>gl", function() gitsigns.blame_line{full=true} end, desc = "Line blame" },

    { "[g", gitsigns.next_hunk, desc = "Gitsigns Next" },
    { "]g", gitsigns.prev_hunk, desc = "Gitsigns Prev" },

    { "<leader>o", group = "Overseer" },
    { "<leader>oo", "<cmd>OverseerTaskAction<cr>", desc = "Run" },
    { "<leader>on", "<cmd>OverseerBuild<cr>", desc = "New" },
    { "<leader>ow", "<cmd>OverseerSaveBundle<cr>", desc = "Save" },
    { "<leader>ol", "<cmd>OverseerLoadBundle!<cr>", desc = "Load" },
    { "<leader>ot", "<cmd>OverseerToggle<cr>", desc = "Toggle" },

    { "<leader>x", group = "Trouble" },
    { "<leader>xx", "<cmd>TroubleToggle<cr>", desc = "Toggle Trouble" },
    { "<leader>xw", "<cmd>TroubleToggle workspace_diagnostics<cr>", desc = "Workspace Trouble" },
    { "<leader>xd", "<cmd>TroubleToggle document_diagnostics<cr>", desc = "Document Trouble" },

    { "<leader>d", vim.diagnostic.open_float, desc = "Show Diagnostics" },

    { "<leader>c", group = "Lsp Change" },
    { "<leader>cf", vim.lsp.buf.format, desc = "Format" },
    { "<leader>ca", vim.lsp.buf.code_action, desc = "Actions" },
    { "<leader>cr", vim.lsp.buf.rename, desc = "Rename" },

    { "<C-h>", vim.lsp.buf.signature_help, desc = "Signature Help", mode = "i" },
    { "<C-j>", "<cmd>cn<cr>", desc = "Quickfix Next" },
    { "<C-k>", "<cmd>cp<cr>", desc = "Quickfix Prev" },
    { "[d", vim.diagnostic.goto_next, desc = "Diagnostic Next" },
    { "]d", vim.diagnostic.goto_prev, desc = "Diagnostic Prev" },

    { "gd", telescope.lsp_definitions, desc = "Definition" },
    { "gr", telescope.lsp_references, desc = "References" },
    { "ga", vim.lsp.buf.code_action, desc = "Actions" },
    { "gf", telescope.grep_string, desc = "Find Visual", mode = "v" },
    { "K", vim.lsp.buf.hover, desc = "Show Hover" },
    { "<C-space>", "<C-\\><C-n>", desc = "Exit Terminal mode", mode = "t" },
})

-- Triger `autoread` when files changes on disk
-- https://unix.stackexchange.com/questions/149209/refresh-changed-content-of-file-opened-in-vim/383044#383044
-- https://vi.stackexchange.com/questions/13692/prevent-focusgained-autocmd-running-in-command-line-editing-mode
vim.api.nvim_create_autocmd({ 'FocusGained', 'BufEnter', 'CursorHold', 'CursorHoldI' }, {
	pattern = '*',
	command = "if mode() !~ '\v(c|r.?|!|t)' && getcmdwintype() == '' | checktime | endif",
})

-- Notification after file change
-- https://vi.stackexchange.com/questions/13091/autocmd-event-for-autoread
vim.api.nvim_create_autocmd({ 'FileChangedShellPost' }, {
	pattern = '*',
	command = "echohl WarningMsg | echo 'File changed on disk. Buffer reloaded.' | echohl None",
})


-- Mason/LSPZero
local lsp_zero = require('lsp-zero').preset({})

lsp_zero.on_attach(function(client, bufnr)
	-- see :help lsp-zero-keybindings
	-- to learn the available actions
	lsp_zero.default_keymaps({ buffer = bufnr })
end)

--- if you want to know more about lsp-zero and mason.nvim
--- read this: https://github.com/VonHeikemen/lsp-zero.nvim/blob/v3.x/doc/md/guides/integrate-with-mason-nvim.md
require('mason').setup({})
require('mason-lspconfig').setup({
	ensure_installed = {},
	handlers = {
		lsp_zero.default_setup
	}
})

---
-- Autocompletion config
---
local cmp = require('cmp')
local cmp_action = lsp_zero.cmp_action()

cmp.setup({
  mapping = cmp.mapping.preset.insert({
    -- `Enter` key to confirm completion
    ['<CR>'] = cmp.mapping.confirm({select = false}),

    -- Ctrl+Space to trigger completion menu
    ['<C-Space>'] = cmp.mapping.complete(),

    -- Navigate between snippet placeholder
    ['<C-f>'] = cmp_action.luasnip_jump_forward(),
    ['<C-b>'] = cmp_action.luasnip_jump_backward(),

    -- Scroll up and down in the completion documentation
    ['<C-u>'] = cmp.mapping.scroll_docs(-4),
    ['<C-d>'] = cmp.mapping.scroll_docs(4),
  })
})

local lspconfig = require('lspconfig')
lsp_zero.setup()
			lspconfig.biome.setup {
				root_dir = lspconfig.util.root_pattern("deno.json", "deno.jsonc")
			}

			lspconfig.ts_ls.setup {
				root_dir = lspconfig.util.root_pattern("package.json"),
			}
