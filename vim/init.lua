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


	use {
		'wellle/context.vim',
		config = function()
			vim.g.context_enabled = 3
			-- let g:context_enabled = 3
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
	["<leader>g"] = {
		name = 'Git',
		g = { vim.cmd.Git, 'Open' },
		p = { gitsigns.preview_hunk, 'Preview' },
		s = { gitsigns.stage_hunk, 'Stage' },
		u = { gitsigns.reset_hunk, 'Stage' },
	},
	["<leader>o"] = {
		name = 'Overseer',
		o = { "<cmd>OverseerTaskAction<cr>", 'Run' },
		n = { "<cmd>OverseerBuild<cr>", 'New' },
		w = { "<cmd>OverseerSaveBundle<cr>", 'Save' },
		l = { "<cmd>OverseerLoadBundle!<cr>", 'Load' },
		t = { "<cmd>OverseerToggle<cr>", 'Toggle' },
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
	['ga'] = { vim.lsp.buf.code_action, 'Actions' },
	['gf'] = { telescope.grep_string, 'Find Visual', mode = 'v' },
	['K'] = { vim.lsp.buf.hover, 'Show Hover' },
	['<C-space>'] = { "<C-\\><C-n>", 'Exit Terminal mode', mode = 't' },
}, {})

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

lsp_zero.setup()
--			lspconfig.biome.setup {
--				root_dir = lspconfig.util.root_pattern("deno.json", "deno.jsonc")
--			}
--
--			lspconfig.tsserver.setup {
--				root_dir = lspconfig.util.root_pattern("package.json"),
--			}
