-- Customize None-ls sources

return {
  "nvimtools/none-ls.nvim",
  opts = function(_, opts)
    -- opts variable is the default configuration table for the setup function call
    local null_ls = require "null-ls"

    -- Check supported formatters and linters
    -- https://github.com/nvimtools/none-ls.nvim/tree/main/lua/null-ls/builtins/formatting
    -- https://github.com/nvimtools/none-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics

    -- Only insert new sources, do not replace the existing ones
    -- (If you wish to replace, use `opts.sources = {}` instead of the `list_insert_unique` function)
    opts.should_attach = function(bufnr) return vim.bo[bufnr].filetype ~= "toml" end

    local has_biome = function(utils) return utils.root_has_file { "biome.json", "biome.jsonc" } end

    opts.sources = require("astrocore").list_insert_unique(opts.sources, {
      -- Set a formatter
      -- null_ls.builtins.formatting.stylua,
      null_ls.builtins.formatting.prettier.with {
        condition = function(utils) return not has_biome(utils) end,
      },
      null_ls.builtins.diagnostics.stylelint.with {
        condition = function(utils)
          return utils.root_has_file {
            ".stylelintrc",
            ".stylelintrc.cjs",
            ".stylelintrc.js",
            ".stylelintrc.json",
            ".stylelintrc.mjs",
            ".stylelintrc.yaml",
            ".stylelintrc.yml",
            "stylelint.config.cjs",
            "stylelint.config.js",
            "stylelint.config.mjs",
          }
        end,
      },
    })
  end,
}
