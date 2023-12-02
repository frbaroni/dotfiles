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
			{ 'saadparwaiz1/cmp_luasnip' },
			{ 'hrsh7th/cmp-nvim-lsp' },
			{ 'hrsh7th/cmp-nvim-lua' },

			-- Snippets
			{ 'L3MON4D3/LuaSnip' },
			{ 'rafamadriz/friendly-snippets' },
		}
	}

	use {
		'nvim-treesitter/nvim-treesitter',
		run = ':TSUpdate',
	}

	use {
		'folke/trouble.nvim',
		requires = 'kyazdani42/nvim-web-devicons',
		config = function()
			require('trouble').setup()
		end
	}


	use {
		'glepnir/dashboard-nvim',
		config = function()
			local db = require('dashboard')

			db.custom_center = {
				{
					icon = '  ',
					desc = 'Recently opened files                   ',
					action = 'Telescope oldfiles',
				},
				{
					icon = '  ',
					desc = 'Find  File                              ',
					action = 'Telescope find_files find_command=rg,--hidden,--files',
				},
				{
					icon = '  ',
					desc = 'Find  word                              ',
					action = 'Telescope live_grep',
				},
			}
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
		'lewis6991/gitsigns.nvim',
		config = function()
			require('gitsigns').setup({})
		end
	}

	use {
		"nvim-neotest/neotest",
		requires = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
			"antoinemadec/FixCursorHold.nvim",
			"MarkEmmons/neotest-deno",
			"haydenmeade/neotest-jest",
			"thenbe/neotest-playwright",
		},
		config = function()
			require('neotest').setup({
				adapters = {
					require('neotest-deno'),
					require('neotest-jest')({
						jestCommand = "npm test --",
						cwd = function(path)
							return vim.fn.getcwd()
						end,
					}),
					require("neotest-playwright").adapter({
						options = {
							persist_project_selection = true,
							enable_dynamic_test_discovery = true,
						}
					}),
				}
			})
		end
	}

	use {
		'nvim-telescope/telescope.nvim'
	}


	if packer_bootstrap then
		require('packer').sync()
	end
end)

local gitsigns = require('gitsigns')
local wk = require('which-key')
local neotest = require('neotest')
local telescope = require('telescope.builtin')

wk.register({
	["<leader>f"] = {
		name = 'find',
		a = { telescope.builtin, 'Find All' },
		r = { telescope.oldfiles, 'Find Recent' },
		f = { telescope.find_files, 'Find Files' },
		p = { telescope.git_files, 'Find Gitfiles' },
		g = { telescope.live_grep, 'Find Grep' },
		b = { telescope.buffers, 'Find Buffers' },
		h = { telescope.help_tags, 'Find Helptags' },
		c = { telescope.commands, 'Find Commands' },
	},
	['gf'] = { telescope.grep_string, 'Find Visual', mode = 'v' },
	["<leader>g"] = {
		name = 'Git',
		g = { vim.cmd.Git, 'Open' },
		p = { gitsigns.preview_hunk, 'Preview' },
		s = { gitsigns.stage_hunk, 'Stage' },
		u = { gitsigns.reset_hunk, 'Stage' },
	},
	["<leader>x"] = {
		name = 'Trouble',
		x = { "<cmd>TroubleToggle<cr>", 'Toggle Trouble' },
		w = { "<cmd>TroubleToggle workspace_diagnostics<cr>", 'Workspace Trouble' },
		d = { "<cmd>TroubleToggle document_diagnostics<cr>", 'Document Trouble' },
	},
	["<leader>t"] = {
		name = 'Neotest',
		n = { function() neotest.run.run() end, 'Test nearest' },
		f = { function() neotest.run.run(vim.fn.expand("%")) end, 'Test file' },
		d = { function() neotest.run.run({ strategy = "dap" }) end, 'Debug nearest' },
	},
	['<leader>d'] = { vim.diagnostic.open_float, 'Show Diagnostics' },
	["<leader>c"] = {
		name = 'Lsp Change',
		f = { vim.lsp.buf.format, 'Format' },
		a = { vim.lsp.buf.code_action, 'Actions' },
		r = { vim.lsp.buf.rename, 'Rename' },
	},
	['<C-h>'] = { vim.lsp.buf.signature_help, 'Signature Help', mode = 'i' },
	['<C-j>'] = { "<cmd>cn<cr>", "Quickfix Next", },
	['<C-k>'] = { "<cmd>cp<cr>", "Quickfix Prev", },
	['[d'] = { vim.diagnostic.goto_next, 'Diagnostic Next' },
	[']d'] = { vim.diagnostic.goto_prev, 'Diagnostic Prev' },
	['gd'] = { telescope.lsp_definitions, 'Definition' },
	['gr'] = { telescope.lsp_references, 'References' },
	['K'] = { vim.lsp.buf.hover, 'Show Hover' },
	['<C-space>'] = { "<C-\\><C-n>", 'Exit Terminal mode', mode = 't' },
}, {})

local lsp = require('lsp-zero')
local lspconfig = require('lspconfig')

lsp.preset('recommended')

lspconfig.lua_ls.setup {
	settings = {
		Lua = {
			runtime = {
				version = 'LuaJIT',
			},
			diagnostics = {
				globals = { 'vim' },
			},
			workspace = {
				library = vim.api.nvim_get_runtime_file("", true),
			},
			telemetry = {
				enable = false,
			},
		},
	},
}

lspconfig.denols.setup {
	root_dir = lspconfig.util.root_pattern("deno.json", "deno.jsonc"),
}

lspconfig.tsserver.setup {
	root_dir = lspconfig.util.root_pattern("package.json"),
	single_file_support = false
}

vim.diagnostic.config({
	virtual_text = true,
})

lsp.setup()
