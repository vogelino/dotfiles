-- Automatically generated packer.nvim plugin loader code

if vim.api.nvim_call_function('has', { 'nvim-0.5' }) ~= 1 then
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
      sorted_times[#sorted_times + 1] = { chunk_name, time_taken }
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
  local package_path_str = "/Users/lucasvogel/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?.lua;/Users/lucasvogel/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?/init.lua;/Users/lucasvogel/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?.lua;/Users/lucasvogel/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?/init.lua"
  local install_cpath_pattern = "/Users/lucasvogel/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/lua/5.1/?.so"
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
        vim.api.nvim_notify('packer.nvim: Error running ' .. component .. ' for ' .. name .. ': ' .. result,
          vim.log.levels.ERROR, {})
      end)
    end
    return result
  end

  time([[try_loadstring definition]], false)
  time([[Defining packer_plugins]], true)
  _G.packer_plugins = {
    ["Comment.nvim"] = {
      config = { "\27LJ\2\n5\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\fComment\frequire\0" },
      loaded = true,
      path = "/Users/lucasvogel/.local/share/nvim/site/pack/packer/start/Comment.nvim",
      url = "https://github.com/numToStr/Comment.nvim"
    },
    LuaSnip = {
      loaded = true,
      path = "/Users/lucasvogel/.local/share/nvim/site/pack/packer/start/LuaSnip",
      url = "https://github.com/L3MON4D3/LuaSnip"
    },
    ["bufferline.nvim"] = {
      config = { "\27LJ\2\n8\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\15bufferline\frequire\0" },
      loaded = true,
      path = "/Users/lucasvogel/.local/share/nvim/site/pack/packer/start/bufferline.nvim",
      url = "https://github.com/akinsho/bufferline.nvim"
    },
    ["cmp-buffer"] = {
      loaded = true,
      path = "/Users/lucasvogel/.local/share/nvim/site/pack/packer/start/cmp-buffer",
      url = "https://github.com/hrsh7th/cmp-buffer"
    },
    ["cmp-nvim-lsp"] = {
      loaded = true,
      path = "/Users/lucasvogel/.local/share/nvim/site/pack/packer/start/cmp-nvim-lsp",
      url = "https://github.com/hrsh7th/cmp-nvim-lsp"
    },
    ["cmp-nvim-lua"] = {
      loaded = true,
      path = "/Users/lucasvogel/.local/share/nvim/site/pack/packer/start/cmp-nvim-lua",
      url = "https://github.com/hrsh7th/cmp-nvim-lua"
    },
    ["cmp-path"] = {
      loaded = true,
      path = "/Users/lucasvogel/.local/share/nvim/site/pack/packer/start/cmp-path",
      url = "https://github.com/hrsh7th/cmp-path"
    },
    cmp_luasnip = {
      loaded = true,
      path = "/Users/lucasvogel/.local/share/nvim/site/pack/packer/start/cmp_luasnip",
      url = "https://github.com/saadparwaiz1/cmp_luasnip"
    },
    ["friendly-snippets"] = {
      loaded = true,
      path = "/Users/lucasvogel/.local/share/nvim/site/pack/packer/start/friendly-snippets",
      url = "https://github.com/rafamadriz/friendly-snippets"
    },
    ["gitsigns.nvim"] = {
      config = { "\27LJ\2\n6\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\rgitsigns\frequire\0" },
      loaded = true,
      path = "/Users/lucasvogel/.local/share/nvim/site/pack/packer/start/gitsigns.nvim",
      url = "https://github.com/lewis6991/gitsigns.nvim"
    },
    ["indent-blankline.nvim"] = {
      config = { "\27LJ\2\n>\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\21indent_blankline\frequire\0" },
      loaded = true,
      path = "/Users/lucasvogel/.local/share/nvim/site/pack/packer/start/indent-blankline.nvim",
      url = "https://github.com/lukas-reineke/indent-blankline.nvim"
    },
    ["lsp-zero.nvim"] = {
      loaded = true,
      path = "/Users/lucasvogel/.local/share/nvim/site/pack/packer/start/lsp-zero.nvim",
      url = "https://github.com/VonHeikemen/lsp-zero.nvim"
    },
    ["lualine.nvim"] = {
      loaded = true,
      path = "/Users/lucasvogel/.local/share/nvim/site/pack/packer/start/lualine.nvim",
      url = "https://github.com/nvim-lualine/lualine.nvim"
    },
    ["mason-lspconfig.nvim"] = {
      loaded = true,
      path = "/Users/lucasvogel/.local/share/nvim/site/pack/packer/start/mason-lspconfig.nvim",
      url = "https://github.com/williamboman/mason-lspconfig.nvim"
    },
    ["mason.nvim"] = {
      loaded = true,
      path = "/Users/lucasvogel/.local/share/nvim/site/pack/packer/start/mason.nvim",
      url = "https://github.com/williamboman/mason.nvim"
    },
    ["nvim-autopairs"] = {
      config = { "\27LJ\2\n<\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\19nvim-autopairs\frequire\0" },
      loaded = true,
      path = "/Users/lucasvogel/.local/share/nvim/site/pack/packer/start/nvim-autopairs",
      url = "https://github.com/windwp/nvim-autopairs"
    },
    ["nvim-cmp"] = {
      loaded = true,
      path = "/Users/lucasvogel/.local/share/nvim/site/pack/packer/start/nvim-cmp",
      url = "https://github.com/hrsh7th/nvim-cmp"
    },
    ["nvim-colorizer.lua"] = {
      loaded = true,
      path = "/Users/lucasvogel/.local/share/nvim/site/pack/packer/start/nvim-colorizer.lua",
      url = "https://github.com/norcalli/nvim-colorizer.lua"
    },
    ["nvim-lspconfig"] = {
      loaded = true,
      path = "/Users/lucasvogel/.local/share/nvim/site/pack/packer/start/nvim-lspconfig",
      url = "https://github.com/neovim/nvim-lspconfig"
    },
    ["nvim-navic"] = {
      loaded = true,
      path = "/Users/lucasvogel/.local/share/nvim/site/pack/packer/start/nvim-navic",
      url = "https://github.com/SmiteshP/nvim-navic"
    },
    ["nvim-surround"] = {
      config = { "\27LJ\2\n?\0\0\3\0\3\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0004\2\0\0B\0\2\1K\0\1\0\nsetup\18nvim-surround\frequire\0" },
      loaded = true,
      path = "/Users/lucasvogel/.local/share/nvim/site/pack/packer/start/nvim-surround",
      url = "https://github.com/kylechui/nvim-surround"
    },
    ["nvim-tree.lua"] = {
      loaded = true,
      path = "/Users/lucasvogel/.local/share/nvim/site/pack/packer/start/nvim-tree.lua",
      url = "https://github.com/nvim-tree/nvim-tree.lua"
    },
    ["nvim-treesitter"] = {
      loaded = true,
      path = "/Users/lucasvogel/.local/share/nvim/site/pack/packer/start/nvim-treesitter",
      url = "https://github.com/nvim-treesitter/nvim-treesitter"
    },
    ["nvim-ts-autotag"] = {
      config = { "\27LJ\2\n_\0\0\4\0\6\0\t6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\4\0005\3\3\0=\3\5\2B\0\2\1K\0\1\0\fautotag\1\0\0\1\0\1\venable\2\nsetup\20nvim-ts-autotag\frequire\0" },
      loaded = true,
      path = "/Users/lucasvogel/.local/share/nvim/site/pack/packer/start/nvim-ts-autotag",
      url = "https://github.com/windwp/nvim-ts-autotag"
    },
    ["nvim-ts-context-commentstring"] = {
      config = { "\27LJ\2\nu\0\0\4\0\6\0\t6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\4\0005\3\3\0=\3\5\2B\0\2\1K\0\1\0\26context_commentstring\1\0\0\1\0\1\venable\2\nsetup\28nvim-treesitter.configs\frequire\0" },
      loaded = true,
      path = "/Users/lucasvogel/.local/share/nvim/site/pack/packer/start/nvim-ts-context-commentstring",
      url = "https://github.com/JoosepAlviste/nvim-ts-context-commentstring"
    },
    ["nvim-web-devicons"] = {
      loaded = true,
      path = "/Users/lucasvogel/.local/share/nvim/site/pack/packer/start/nvim-web-devicons",
      url = "https://github.com/nvim-tree/nvim-web-devicons"
    },
    ["packer.nvim"] = {
      loaded = true,
      path = "/Users/lucasvogel/.local/share/nvim/site/pack/packer/start/packer.nvim",
      url = "https://github.com/wbthomason/packer.nvim"
    },
    ["plenary.nvim"] = {
      loaded = true,
      path = "/Users/lucasvogel/.local/share/nvim/site/pack/packer/start/plenary.nvim",
      url = "https://github.com/nvim-lua/plenary.nvim"
    },
    ["telescope.nvim"] = {
      loaded = true,
      path = "/Users/lucasvogel/.local/share/nvim/site/pack/packer/start/telescope.nvim",
      url = "https://github.com/nvim-telescope/telescope.nvim"
    },
    ["toggleterm.nvim"] = {
      config = { "\27LJ\2\n8\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\15toggleterm\frequire\0" },
      loaded = true,
      path = "/Users/lucasvogel/.local/share/nvim/site/pack/packer/start/toggleterm.nvim",
      url = "https://github.com/akinsho/toggleterm.nvim"
    },
    ["tokyonight.nvim"] = {
      loaded = true,
      path = "/Users/lucasvogel/.local/share/nvim/site/pack/packer/start/tokyonight.nvim",
      url = "https://github.com/folke/tokyonight.nvim"
    },
    ["vim-easymotion"] = {
      loaded = true,
      path = "/Users/lucasvogel/.local/share/nvim/site/pack/packer/start/vim-easymotion",
      url = "https://github.com/easymotion/vim-easymotion"
    },
    ["vim-illuminate"] = {
      loaded = true,
      path = "/Users/lucasvogel/.local/share/nvim/site/pack/packer/start/vim-illuminate",
      url = "https://github.com/RRethy/vim-illuminate"
    },
    ["which-key.nvim"] = {
      config = { "\27LJ\2\n7\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\14which-key\frequire\0" },
      loaded = true,
      path = "/Users/lucasvogel/.local/share/nvim/site/pack/packer/start/which-key.nvim",
      url = "https://github.com/folke/which-key.nvim"
    }
  }

  time([[Defining packer_plugins]], false)
  -- Config for: bufferline.nvim
  time([[Config for bufferline.nvim]], true)
  try_loadstring("\27LJ\2\n8\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\15bufferline\frequire\0"
    , "config", "bufferline.nvim")
  time([[Config for bufferline.nvim]], false)
  -- Config for: which-key.nvim
  time([[Config for which-key.nvim]], true)
  try_loadstring("\27LJ\2\n7\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\14which-key\frequire\0",
    "config", "which-key.nvim")
  time([[Config for which-key.nvim]], false)
  -- Config for: toggleterm.nvim
  time([[Config for toggleterm.nvim]], true)
  try_loadstring("\27LJ\2\n8\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\15toggleterm\frequire\0"
    , "config", "toggleterm.nvim")
  time([[Config for toggleterm.nvim]], false)
  -- Config for: nvim-ts-context-commentstring
  time([[Config for nvim-ts-context-commentstring]], true)
  try_loadstring("\27LJ\2\nu\0\0\4\0\6\0\t6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\4\0005\3\3\0=\3\5\2B\0\2\1K\0\1\0\26context_commentstring\1\0\0\1\0\1\venable\2\nsetup\28nvim-treesitter.configs\frequire\0"
    , "config", "nvim-ts-context-commentstring")
  time([[Config for nvim-ts-context-commentstring]], false)
  -- Config for: gitsigns.nvim
  time([[Config for gitsigns.nvim]], true)
  try_loadstring("\27LJ\2\n6\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\rgitsigns\frequire\0",
    "config", "gitsigns.nvim")
  time([[Config for gitsigns.nvim]], false)
  -- Config for: nvim-autopairs
  time([[Config for nvim-autopairs]], true)
  try_loadstring("\27LJ\2\n<\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\19nvim-autopairs\frequire\0"
    , "config", "nvim-autopairs")
  time([[Config for nvim-autopairs]], false)
  -- Config for: indent-blankline.nvim
  time([[Config for indent-blankline.nvim]], true)
  try_loadstring("\27LJ\2\n>\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\21indent_blankline\frequire\0"
    , "config", "indent-blankline.nvim")
  time([[Config for indent-blankline.nvim]], false)
  -- Config for: nvim-ts-autotag
  time([[Config for nvim-ts-autotag]], true)
  try_loadstring("\27LJ\2\n_\0\0\4\0\6\0\t6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\4\0005\3\3\0=\3\5\2B\0\2\1K\0\1\0\fautotag\1\0\0\1\0\1\venable\2\nsetup\20nvim-ts-autotag\frequire\0"
    , "config", "nvim-ts-autotag")
  time([[Config for nvim-ts-autotag]], false)
  -- Config for: Comment.nvim
  time([[Config for Comment.nvim]], true)
  try_loadstring("\27LJ\2\n5\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\fComment\frequire\0",
    "config", "Comment.nvim")
  time([[Config for Comment.nvim]], false)
  -- Config for: nvim-surround
  time([[Config for nvim-surround]], true)
  try_loadstring("\27LJ\2\n?\0\0\3\0\3\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0004\2\0\0B\0\2\1K\0\1\0\nsetup\18nvim-surround\frequire\0"
    , "config", "nvim-surround")
  time([[Config for nvim-surround]], false)

  _G._packer.inside_compile = false
  if _G._packer.needs_bufread == true then
    vim.cmd("doautocmd BufRead")
  end
  _G._packer.needs_bufread = false

  if should_profile then save_profiles() end

end)

if not no_errors then
  error_msg = error_msg:gsub('"', '\\"')
  vim.api.nvim_command('echohl ErrorMsg | echom "Error in packer_compiled: ' ..
    error_msg .. '" | echom "Please check your config for correctness" | echohl None')
end
