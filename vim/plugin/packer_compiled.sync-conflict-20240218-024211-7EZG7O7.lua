-- Automatically generated packer.nvim plugin loader code

if vim.api.nvim_call_function('has', {'nvim-0.5'}) ~= 1 then
  vim.api.nvim_command('echohl WarningMsg | echom "Invalid Neovim version for packer.nvim! | echohl None"')
  return
end

vim.api.nvim_command('packadd packer.nvim')

local no_errors, error_msg = pcall(function()

_G._packer = _G._packer or {}
_G._packer.inside_compile = true

local time
local profile_info
local should_profile = false
if should_profile then
  local hrtime = vim.loop.hrtime
  profile_info = {}
  time = function(chunk, start)
    if start then
      profile_info[chunk] = hrtime()
    else
      profile_info[chunk] = (hrtime() - profile_info[chunk]) / 1e6
    end
  end
else
  time = function(chunk, start) end
end

local function save_profiles(threshold)
  local sorted_times = {}
  for chunk_name, time_taken in pairs(profile_info) do
    sorted_times[#sorted_times + 1] = {chunk_name, time_taken}
  end
  table.sort(sorted_times, function(a, b) return a[2] > b[2] end)
  local results = {}
  for i, elem in ipairs(sorted_times) do
    if not threshold or threshold and elem[2] > threshold then
      results[i] = elem[1] .. ' took ' .. elem[2] .. 'ms'
    end
  end
  if threshold then
    table.insert(results, '(Only showing plugins that took longer than ' .. threshold .. ' ms ' .. 'to load)')
  end

  _G._packer.profile_output = results
end

time([[Luarocks path setup]], true)
local package_path_str = "/home/fernando/.cache/nvim/packer_hererocks/2.1.1707061634/share/lua/5.1/?.lua;/home/fernando/.cache/nvim/packer_hererocks/2.1.1707061634/share/lua/5.1/?/init.lua;/home/fernando/.cache/nvim/packer_hererocks/2.1.1707061634/lib/luarocks/rocks-5.1/?.lua;/home/fernando/.cache/nvim/packer_hererocks/2.1.1707061634/lib/luarocks/rocks-5.1/?/init.lua"
local install_cpath_pattern = "/home/fernando/.cache/nvim/packer_hererocks/2.1.1707061634/lib/lua/5.1/?.so"
if not string.find(package.path, package_path_str, 1, true) then
  package.path = package.path .. ';' .. package_path_str
end

if not string.find(package.cpath, install_cpath_pattern, 1, true) then
  package.cpath = package.cpath .. ';' .. install_cpath_pattern
end

time([[Luarocks path setup]], false)
time([[try_loadstring definition]], true)
local function try_loadstring(s, component, name)
  local success, result = pcall(loadstring(s), name, _G.packer_plugins[name])
  if not success then
    vim.schedule(function()
      vim.api.nvim_notify('packer.nvim: Error running ' .. component .. ' for ' .. name .. ': ' .. result, vim.log.levels.ERROR, {})
    end)
  end
  return result
end

time([[try_loadstring definition]], false)
time([[Defining packer_plugins]], true)
_G.packer_plugins = {
  ["FixCursorHold.nvim"] = {
    loaded = true,
    path = "/home/fernando/.local/share/nvim/site/pack/packer/start/FixCursorHold.nvim",
    url = "https://github.com/antoinemadec/FixCursorHold.nvim"
  },
  LuaSnip = {
    loaded = true,
    path = "/home/fernando/.local/share/nvim/site/pack/packer/start/LuaSnip",
    url = "https://github.com/L3MON4D3/LuaSnip"
  },
  ["cmp-buffer"] = {
    loaded = true,
    path = "/home/fernando/.local/share/nvim/site/pack/packer/start/cmp-buffer",
    url = "https://github.com/hrsh7th/cmp-buffer"
  },
  ["cmp-nvim-lsp"] = {
    loaded = true,
    path = "/home/fernando/.local/share/nvim/site/pack/packer/start/cmp-nvim-lsp",
    url = "https://github.com/hrsh7th/cmp-nvim-lsp"
  },
  ["cmp-nvim-lua"] = {
    loaded = true,
    path = "/home/fernando/.local/share/nvim/site/pack/packer/start/cmp-nvim-lua",
    url = "https://github.com/hrsh7th/cmp-nvim-lua"
  },
  ["cmp-path"] = {
    loaded = true,
    path = "/home/fernando/.local/share/nvim/site/pack/packer/start/cmp-path",
    url = "https://github.com/hrsh7th/cmp-path"
  },
  cmp_luasnip = {
    loaded = true,
    path = "/home/fernando/.local/share/nvim/site/pack/packer/start/cmp_luasnip",
    url = "https://github.com/saadparwaiz1/cmp_luasnip"
  },
  ["context.vim"] = {
    config = { "\27LJ\2\n1\0\0\2\0\3\0\0056\0\0\0009\0\1\0)\1\3\0=\1\2\0K\0\1\0\20context_enabled\6g\bvim\0" },
    loaded = true,
    path = "/home/fernando/.local/share/nvim/site/pack/packer/start/context.vim",
    url = "https://github.com/wellle/context.vim"
  },
  ["friendly-snippets"] = {
    loaded = true,
    path = "/home/fernando/.local/share/nvim/site/pack/packer/start/friendly-snippets",
    url = "https://github.com/rafamadriz/friendly-snippets"
  },
  ["gitsigns.nvim"] = {
    loaded = true,
    path = "/home/fernando/.local/share/nvim/site/pack/packer/start/gitsigns.nvim",
    url = "https://github.com/lewis6991/gitsigns.nvim"
  },
  ["hardtime.nvim"] = {
    config = { "\27LJ\2\n6\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\rhardtime\frequire\0" },
    loaded = true,
    path = "/home/fernando/.local/share/nvim/site/pack/packer/start/hardtime.nvim",
    url = "https://github.com/m4xshen/hardtime.nvim"
  },
  ["jq.nvim"] = {
    loaded = true,
    path = "/home/fernando/.local/share/nvim/site/pack/packer/start/jq.nvim",
    url = "https://github.com/jrop/jq.nvim"
  },
  ["lsp-zero.nvim"] = {
    config = { "\27LJ\2\nÀ\1\0\0\n\0\v\0\0236\0\0\0'\2\1\0B\0\2\0029\1\2\0005\3\n\0009\4\3\0009\4\4\0049\4\5\0045\6\a\0009\a\3\0009\a\6\a)\tüÿB\a\2\2=\a\b\0069\a\3\0009\a\6\a)\t\4\0B\a\2\2=\a\t\6B\4\2\2=\4\3\3B\1\2\1K\0\1\0\1\0\1\fmapping\0\n<C-d>\n<C-u>\1\0\2\n<C-u>\0\n<C-d>\0\16scroll_docs\vinsert\vpreset\fmapping\nsetup\bcmp\frequire\0" },
    loaded = true,
    path = "/home/fernando/.local/share/nvim/site/pack/packer/start/lsp-zero.nvim",
    url = "https://github.com/VonHeikemen/lsp-zero.nvim"
  },
  ["lualine.nvim"] = {
    config = { "\27LJ\2\n9\0\0\3\0\3\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0004\2\0\0B\0\2\1K\0\1\0\nsetup\flualine\frequire\0" },
    loaded = true,
    path = "/home/fernando/.local/share/nvim/site/pack/packer/start/lualine.nvim",
    url = "https://github.com/nvim-lualine/lualine.nvim"
  },
  ["mason-lspconfig.nvim"] = {
    loaded = true,
    path = "/home/fernando/.local/share/nvim/site/pack/packer/start/mason-lspconfig.nvim",
    url = "https://github.com/williamboman/mason-lspconfig.nvim"
  },
  ["mason.nvim"] = {
    loaded = true,
    path = "/home/fernando/.local/share/nvim/site/pack/packer/start/mason.nvim",
    url = "https://github.com/williamboman/mason.nvim"
  },
  ["mkdir.nvim"] = {
    loaded = true,
    path = "/home/fernando/.local/share/nvim/site/pack/packer/start/mkdir.nvim",
    url = "https://github.com/jghauser/mkdir.nvim"
  },
  neotest = {
    config = { "\27LJ\2\n%\0\1\3\0\3\0\0046\1\0\0009\1\1\0019\1\2\1D\1\1\0\vgetcwd\afn\bvimÜ\2\1\0\b\0\15\1\0306\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\r\0004\3\4\0006\4\0\0'\6\3\0B\4\2\2>\4\1\0036\4\0\0'\6\4\0B\4\2\0025\6\5\0003\a\6\0=\a\a\6B\4\2\2>\4\2\0036\4\0\0'\6\b\0B\4\2\0029\4\t\0045\6\v\0005\a\n\0=\a\f\6B\4\2\0?\4\0\0=\3\14\2B\0\2\1K\0\1\0\radapters\1\0\1\radapters\0\foptions\1\0\1\foptions\0\1\0\2\30persist_project_selection\2\"enable_dynamic_test_discovery\2\fadapter\23neotest-playwright\bcwd\0\1\0\2\16jestCommand\16npm test --\bcwd\0\17neotest-jest\17neotest-deno\nsetup\fneotest\frequire\a€€À™\4\0" },
    loaded = true,
    path = "/home/fernando/.local/share/nvim/site/pack/packer/start/neotest",
    url = "https://github.com/nvim-neotest/neotest"
  },
  ["neotest-deno"] = {
    loaded = true,
    path = "/home/fernando/.local/share/nvim/site/pack/packer/start/neotest-deno",
    url = "https://github.com/MarkEmmons/neotest-deno"
  },
  ["neotest-jest"] = {
    loaded = true,
    path = "/home/fernando/.local/share/nvim/site/pack/packer/start/neotest-jest",
    url = "https://github.com/haydenmeade/neotest-jest"
  },
  ["neotest-playwright"] = {
    loaded = true,
    path = "/home/fernando/.local/share/nvim/site/pack/packer/start/neotest-playwright",
    url = "https://github.com/thenbe/neotest-playwright"
  },
  ["nvim-bqf"] = {
    loaded = true,
    path = "/home/fernando/.local/share/nvim/site/pack/packer/start/nvim-bqf",
    url = "https://github.com/kevinhwang91/nvim-bqf"
  },
  ["nvim-cmp"] = {
    loaded = true,
    path = "/home/fernando/.local/share/nvim/site/pack/packer/start/nvim-cmp",
    url = "https://github.com/hrsh7th/nvim-cmp"
  },
  ["nvim-colorizer.lua"] = {
    config = { "\27LJ\2\n‚\1\0\0\4\0\6\0\t6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\4\0005\3\3\0=\3\5\2B\0\2\1K\0\1\0\25user_default_options\1\0\1\25user_default_options\0\1\0\1\rtailwind\tboth\nsetup\14colorizer\frequire\0" },
    loaded = true,
    path = "/home/fernando/.local/share/nvim/site/pack/packer/start/nvim-colorizer.lua",
    url = "https://github.com/NvChad/nvim-colorizer.lua"
  },
  ["nvim-lspconfig"] = {
    loaded = true,
    path = "/home/fernando/.local/share/nvim/site/pack/packer/start/nvim-lspconfig",
    url = "https://github.com/neovim/nvim-lspconfig"
  },
  ["nvim-treesitter"] = {
    loaded = true,
    path = "/home/fernando/.local/share/nvim/site/pack/packer/start/nvim-treesitter",
    url = "https://github.com/nvim-treesitter/nvim-treesitter"
  },
  ["nvim-web-devicons"] = {
    loaded = true,
    path = "/home/fernando/.local/share/nvim/site/pack/packer/start/nvim-web-devicons",
    url = "https://github.com/kyazdani42/nvim-web-devicons"
  },
  nvim_context_vt = {
    config = { "\27LJ\2\nA\0\0\3\0\3\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0004\2\0\0B\0\2\1K\0\1\0\nsetup\20nvim_context_vt\frequire\0" },
    loaded = true,
    path = "/home/fernando/.local/share/nvim/site/pack/packer/start/nvim_context_vt",
    url = "https://github.com/andersevenrud/nvim_context_vt"
  },
  ["overseer.nvim"] = {
    config = { "\27LJ\2\n6\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\roverseer\frequire\0" },
    loaded = true,
    path = "/home/fernando/.local/share/nvim/site/pack/packer/start/overseer.nvim",
    url = "https://github.com/stevearc/overseer.nvim"
  },
  ["packer.nvim"] = {
    loaded = true,
    path = "/home/fernando/.local/share/nvim/site/pack/packer/start/packer.nvim",
    url = "https://github.com/wbthomason/packer.nvim"
  },
  ["plenary.nvim"] = {
    loaded = true,
    path = "/home/fernando/.local/share/nvim/site/pack/packer/start/plenary.nvim",
    url = "https://github.com/nvim-lua/plenary.nvim"
  },
  ["telescope.nvim"] = {
    loaded = true,
    path = "/home/fernando/.local/share/nvim/site/pack/packer/start/telescope.nvim",
    url = "https://github.com/nvim-telescope/telescope.nvim"
  },
  ["tokyonight.nvim"] = {
    config = { "\27LJ\2\n:\0\0\3\0\3\0\0056\0\0\0009\0\1\0'\2\2\0B\0\2\1K\0\1\0\27colorscheme tokyonight\bcmd\bvim\0" },
    loaded = true,
    path = "/home/fernando/.local/share/nvim/site/pack/packer/start/tokyonight.nvim",
    url = "https://github.com/folke/tokyonight.nvim"
  },
  ["transparent.nvim"] = {
    loaded = true,
    path = "/home/fernando/.local/share/nvim/site/pack/packer/start/transparent.nvim",
    url = "https://github.com/xiyaowong/transparent.nvim"
  },
  ["trouble.nvim"] = {
    config = { "\27LJ\2\n5\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\ftrouble\frequire\0" },
    loaded = true,
    path = "/home/fernando/.local/share/nvim/site/pack/packer/start/trouble.nvim",
    url = "https://github.com/folke/trouble.nvim"
  },
  ["vim-dadbod"] = {
    loaded = true,
    path = "/home/fernando/.local/share/nvim/site/pack/packer/start/vim-dadbod",
    url = "https://github.com/tpope/vim-dadbod"
  },
  ["vim-dadbod-ui"] = {
    loaded = true,
    path = "/home/fernando/.local/share/nvim/site/pack/packer/start/vim-dadbod-ui",
    url = "https://github.com/kristijanhusak/vim-dadbod-ui"
  },
  ["vim-fugitive"] = {
    loaded = true,
    path = "/home/fernando/.local/share/nvim/site/pack/packer/start/vim-fugitive",
    url = "https://github.com/tpope/vim-fugitive"
  },
  ["vim-sleuth"] = {
    loaded = true,
    path = "/home/fernando/.local/share/nvim/site/pack/packer/start/vim-sleuth",
    url = "https://github.com/tpope/vim-sleuth"
  },
  ["which-key.nvim"] = {
    config = { "\27LJ\2\n7\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\14which-key\frequire\0" },
    loaded = true,
    path = "/home/fernando/.local/share/nvim/site/pack/packer/start/which-key.nvim",
    url = "https://github.com/folke/which-key.nvim"
  }
}

time([[Defining packer_plugins]], false)
-- Config for: nvim_context_vt
time([[Config for nvim_context_vt]], true)
try_loadstring("\27LJ\2\nA\0\0\3\0\3\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0004\2\0\0B\0\2\1K\0\1\0\nsetup\20nvim_context_vt\frequire\0", "config", "nvim_context_vt")
time([[Config for nvim_context_vt]], false)
-- Config for: neotest
time([[Config for neotest]], true)
try_loadstring("\27LJ\2\n%\0\1\3\0\3\0\0046\1\0\0009\1\1\0019\1\2\1D\1\1\0\vgetcwd\afn\bvimÜ\2\1\0\b\0\15\1\0306\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\r\0004\3\4\0006\4\0\0'\6\3\0B\4\2\2>\4\1\0036\4\0\0'\6\4\0B\4\2\0025\6\5\0003\a\6\0=\a\a\6B\4\2\2>\4\2\0036\4\0\0'\6\b\0B\4\2\0029\4\t\0045\6\v\0005\a\n\0=\a\f\6B\4\2\0?\4\0\0=\3\14\2B\0\2\1K\0\1\0\radapters\1\0\1\radapters\0\foptions\1\0\1\foptions\0\1\0\2\30persist_project_selection\2\"enable_dynamic_test_discovery\2\fadapter\23neotest-playwright\bcwd\0\1\0\2\16jestCommand\16npm test --\bcwd\0\17neotest-jest\17neotest-deno\nsetup\fneotest\frequire\a€€À™\4\0", "config", "neotest")
time([[Config for neotest]], false)
-- Config for: nvim-colorizer.lua
time([[Config for nvim-colorizer.lua]], true)
try_loadstring("\27LJ\2\n‚\1\0\0\4\0\6\0\t6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\4\0005\3\3\0=\3\5\2B\0\2\1K\0\1\0\25user_default_options\1\0\1\25user_default_options\0\1\0\1\rtailwind\tboth\nsetup\14colorizer\frequire\0", "config", "nvim-colorizer.lua")
time([[Config for nvim-colorizer.lua]], false)
-- Config for: context.vim
time([[Config for context.vim]], true)
try_loadstring("\27LJ\2\n1\0\0\2\0\3\0\0056\0\0\0009\0\1\0)\1\3\0=\1\2\0K\0\1\0\20context_enabled\6g\bvim\0", "config", "context.vim")
time([[Config for context.vim]], false)
-- Config for: tokyonight.nvim
time([[Config for tokyonight.nvim]], true)
try_loadstring("\27LJ\2\n:\0\0\3\0\3\0\0056\0\0\0009\0\1\0'\2\2\0B\0\2\1K\0\1\0\27colorscheme tokyonight\bcmd\bvim\0", "config", "tokyonight.nvim")
time([[Config for tokyonight.nvim]], false)
-- Config for: trouble.nvim
time([[Config for trouble.nvim]], true)
try_loadstring("\27LJ\2\n5\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\ftrouble\frequire\0", "config", "trouble.nvim")
time([[Config for trouble.nvim]], false)
-- Config for: lualine.nvim
time([[Config for lualine.nvim]], true)
try_loadstring("\27LJ\2\n9\0\0\3\0\3\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0004\2\0\0B\0\2\1K\0\1\0\nsetup\flualine\frequire\0", "config", "lualine.nvim")
time([[Config for lualine.nvim]], false)
-- Config for: hardtime.nvim
time([[Config for hardtime.nvim]], true)
try_loadstring("\27LJ\2\n6\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\rhardtime\frequire\0", "config", "hardtime.nvim")
time([[Config for hardtime.nvim]], false)
-- Config for: which-key.nvim
time([[Config for which-key.nvim]], true)
try_loadstring("\27LJ\2\n7\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\14which-key\frequire\0", "config", "which-key.nvim")
time([[Config for which-key.nvim]], false)
-- Config for: lsp-zero.nvim
time([[Config for lsp-zero.nvim]], true)
try_loadstring("\27LJ\2\nÀ\1\0\0\n\0\v\0\0236\0\0\0'\2\1\0B\0\2\0029\1\2\0005\3\n\0009\4\3\0009\4\4\0049\4\5\0045\6\a\0009\a\3\0009\a\6\a)\tüÿB\a\2\2=\a\b\0069\a\3\0009\a\6\a)\t\4\0B\a\2\2=\a\t\6B\4\2\2=\4\3\3B\1\2\1K\0\1\0\1\0\1\fmapping\0\n<C-d>\n<C-u>\1\0\2\n<C-u>\0\n<C-d>\0\16scroll_docs\vinsert\vpreset\fmapping\nsetup\bcmp\frequire\0", "config", "lsp-zero.nvim")
time([[Config for lsp-zero.nvim]], false)
-- Config for: overseer.nvim
time([[Config for overseer.nvim]], true)
try_loadstring("\27LJ\2\n6\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\roverseer\frequire\0", "config", "overseer.nvim")
time([[Config for overseer.nvim]], false)

_G._packer.inside_compile = false
if _G._packer.needs_bufread == true then
  vim.cmd("doautocmd BufRead")
end
_G._packer.needs_bufread = false

if should_profile then save_profiles() end

end)

if not no_errors then
  error_msg = error_msg:gsub('"', '\\"')
  vim.api.nvim_command('echohl ErrorMsg | echom "Error in packer_compiled: '..error_msg..'" | echom "Please check your config for correctness" | echohl None')
end
