---@type LazySpec
return {
  {
    "AstroNvim/astrocore",
    opts = {
      mappings = {
        n = {
          ["<Leader>tt"] = { function() require("tuxedo").tuxedo() end, desc = "Toggle Tuxedo" },
        },
      },
    },
  },
}
