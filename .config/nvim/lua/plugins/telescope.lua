---@type LazySpec
return {
  "nvim-telescope/telescope.nvim",
  opts = {
    extensions = {
      fzf = {
        fuzzy = true,
        override_file_sorter = true,
        override_generic_sorter = true,
        case_mode = "smart_case",
      },
    },
  },
}
