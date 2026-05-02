-- Tailwind CSS language tooling

---@type LazySpec
return {
  {
    "AstroNvim/astrolsp",
    ---@type AstroLSPOpts
    opts = {
      config = {
        eslint = {
          settings = {
            workingDirectories = { mode = "auto" },
          },
        },
        tailwindcss = {
          filetypes = {
            "astro",
            "css",
            "html",
            "javascript",
            "javascriptreact",
            "less",
            "mdx",
            "postcss",
            "sass",
            "scss",
            "svelte",
            "typescript",
            "typescriptreact",
            "vue",
          },
          settings = {
            tailwindCSS = {
              codeActions = true,
              colorDecorators = true,
              hovers = true,
              suggestions = true,
              validate = true,
              classAttributes = {
                "class",
                "className",
                "class:list",
                "classList",
                "ngClass",
                ".*ClassName",
              },
              classFunctions = {
                "clsx",
                "cn",
                "cva",
                "cx",
                "tw",
                "twMerge",
              },
              includeLanguages = {
                eelixir = "html-eex",
                elixir = "html-eex",
                eruby = "erb",
                heex = "html-eex",
                htmlangular = "html",
                javascriptreact = "javascript",
                templ = "html",
                typescriptreact = "typescript",
              },
              lint = {
                cssConflict = "warning",
                invalidApply = "error",
                invalidConfigPath = "error",
                invalidScreen = "error",
                invalidTailwindDirective = "error",
                invalidVariant = "error",
                recommendedVariantOrder = "warning",
              },
            },
          },
        },
      },
    },
  },
  {
    "NvChad/nvim-colorizer.lua",
    opts = function(_, opts)
      opts.user_default_options = require("astrocore").extend_tbl(opts.user_default_options, {
        tailwind = "lsp",
        tailwind_opts = {
          update_names = true,
        },
      })
    end,
  },
}
