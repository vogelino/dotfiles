-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  -- Telescope for Fuzzy Finder Prompt
  use({
    'nvim-telescope/telescope.nvim', tag = '0.1.0',
    requires = { { 'nvim-lua/plenary.nvim' } }
  })

  -- Colorscheme
  use 'folke/tokyonight.nvim'

  -- Better color for different language features
  use(
    'nvim-treesitter/nvim-treesitter',
    { run = ':TSUpdate' }
  )

  -- Tree Sidebar
  use({
    'nvim-tree/nvim-tree.lua',
    requires = {
      'nvim-tree/nvim-web-devicons', -- optional, for file icons
    },
    tag = 'nightly' -- optional, updated every week. (see issue #1193)
  })

  -- LSP
  use({
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
  })

  -- Easily find with movements way further
  use("easymotion/vim-easymotion")

  -- Display colors in their color
  use("norcalli/nvim-colorizer.lua")

  -- Wrap selection
  use({
    "kylechui/nvim-surround",
    tag = "*", -- Use for stability; omit to use `main` branch for the latest features
    config = function()
      require("nvim-surround").setup({
        -- Configuration here, or leave empty to use defaults
      })
    end
  })

  -- Comment in and out
  use({
    'numToStr/Comment.nvim',
    config = function()
      require('Comment').setup()
    end
  })
  use({
    "JoosepAlviste/nvim-ts-context-commentstring",
    config = function()
      require('nvim-treesitter.configs').setup({
        context_commentstring = {
          enable = true
        }
      })
    end
  })

  -- Automatically close quotes
  use({
    "windwp/nvim-autopairs",
    config = function()
      require("nvim-autopairs").setup()
    end
  })

  -- Automatically close XML Tags
  use({
    "windwp/nvim-ts-autotag",
    config = function()
      require("nvim-ts-autotag").setup({
        autotag = {
          enable = true
        }
      })
    end
  })

  -- Dev icons
  use({ 'nvim-tree/nvim-web-devicons' })

  -- Git support
  use({
    "lewis6991/gitsigns.nvim",
    config = function()
      require('gitsigns').setup()
    end
  })
  use({
    'akinsho/bufferline.nvim',
    tag = "v3.*",
    requires = 'nvim-tree/nvim-web-devicons',
    config = function()
      require("bufferline").setup()
    end
  })

  -- Snippets
  use("L3MON4D3/LuaSnip")
  use("rafamadriz/friendly-snippets")

  -- Indentation higlighting
  use({
    "lukas-reineke/indent-blankline.nvim",
    config = function()
      require("indent_blankline").setup()
    end
  })

  -- Lua Line
  use({
    'nvim-lualine/lualine.nvim',
    requires = { 'kyazdani42/nvim-web-devicons', opt = true }
  })

  -- Status line with code context
  use({
    "SmiteshP/nvim-navic",
    requires = "neovim/nvim-lspconfig"
  })

  -- Show help of possible command with started key
  use({
    "folke/which-key.nvim",
    config = function()
      require("which-key").setup()
    end
  })

  -- Highlight other instances of a word
  use("RRethy/vim-illuminate")

  -- Terminal Integration
  use({
    "akinsho/toggleterm.nvim",
    tag = '*',
    config = function()
      require("toggleterm").setup()
    end
  })
end)
