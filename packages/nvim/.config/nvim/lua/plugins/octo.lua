---@type LazySpec
return {
  {
    "pwntester/octo.nvim",
    dependencies = {
      {
        "AstroNvim/astrocore",
        opts = function(_, opts)
          local maps = opts.mappings
          local prefix = "<Leader>O"
          maps.n[prefix .. "z"] = {
            desc = "Personal PRs",
          }
          maps.n[prefix .. "zo"] = {
            "<Cmd>Octo search author:@me is:pr is:open<CR>",
            desc = "Open PRs authored by me",
          }
        end,
      },
    },
  },
  {
    "folke/which-key.nvim",
    optional = true,
    opts = function(_, opts)
      opts.spec = opts.spec or {}
      table.insert(opts.spec, {
        { "<Leader>Oz", group = "Personal PRs" },
        {
          "<Leader>Ozo",
          "<Cmd>Octo search author:@me is:pr is:open<CR>",
          desc = "Open PRs authored by me",
          mode = "n",
        },
      })
    end,
  },
  {
    "AstroNvim/astrocore",
    opts = function(_, opts)
      local maps = opts.mappings
      maps.n["<Leader>Om"] = false
      maps.n["<Leader>Oz"] = {
        desc = "Personal PRs",
      }
      maps.n["<Leader>Ozo"] = {
        "<Cmd>Octo search author:@me is:pr is:open<CR>",
        desc = "Open PRs authored by me",
      }
    end,
  },
}
