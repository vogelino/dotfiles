---@type LazySpec
return {
  "AstroNvim/astrolsp",
  ---@type AstroLSPOpts
  opts = {
    mappings = {
      n = {
        gd = {
          function() require("telescope.builtin").lsp_definitions() end,
          desc = "Show the definition of current symbol",
          cond = "textDocument/definition",
        },
        gI = {
          function() require("telescope.builtin").lsp_implementations() end,
          desc = "Implementation of current symbol",
          cond = "textDocument/implementation",
        },
        gy = {
          function() require("telescope.builtin").lsp_type_definitions() end,
          desc = "Definition of current type",
          cond = "textDocument/typeDefinition",
        },
        ["<Leader>lG"] = {
          function() require("telescope.builtin").lsp_workspace_symbols() end,
          desc = "Search workspace symbols",
          cond = "workspace/symbol",
        },
        ["<Leader>lR"] = {
          function() require("telescope.builtin").lsp_references() end,
          desc = "Search references",
          cond = "textDocument/references",
        },
      },
    },
  },
}
