---@type LazySpec
return {
  "MagicDuck/grug-far.nvim",
  cmd = { "GrugFar", "GrugFarWithin" },
  opts = {},
  keys = {
    { "<Leader>sr", "<cmd>GrugFar<cr>", desc = "Search and replace" },
    { "<Leader>sr", ":GrugFar<cr>", mode = "x", desc = "Search and replace selection" },
    {
      "<Leader>sR",
      function() require("grug-far").open { prefills = { paths = vim.fn.expand "%" } } end,
      mode = { "n", "x" },
      desc = "Search and replace in current file",
    },
  },
}
