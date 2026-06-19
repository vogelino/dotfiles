-- Customize Mason plugins

---@type LazySpec
return {
  -- AstroNvim v6 routes all Mason installations through mason-tool-installer;
  -- mason-lspconfig.ensure_installed is nullified at config time when it is present.
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = {
      ensure_installed = {
        -- LSP servers (mason-lspconfig.ensure_installed is nullified in AstroNvim v6)
        "typescript-language-server",
        "eslint-lsp",
        "lua-language-server",
        "tailwindcss-language-server",
        -- formatters/linters
        "biome",
        "stylelint",
        "stylua",
      },
    },
  },
  -- use mason-lspconfig to configure LSP installations
  {
    "mason-org/mason-lspconfig.nvim",
    -- overrides `require("mason-lspconfig").setup(...)`
    opts = {
      ensure_installed = {},
    },
  },
  -- use mason-null-ls to configure Formatters/Linter installation for null-ls sources
  {
    "jay-babu/mason-null-ls.nvim",
    -- overrides `require("mason-null-ls").setup(...)`
    opts = {
      ensure_installed = {
        -- add more arguments for adding more null-ls sources
      },
    },
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
    -- overrides `require("mason-nvim-dap").setup(...)`
    opts = {
      ensure_installed = {
        "python",
        -- add more arguments for adding more debuggers
      },
    },
  },
}
