require("telescope").setup()
local builtin = require("telescope.builtin")
vim.keymap.set('n', '<leader>fp', builtin.find_files, {
  desc = "Find Project Files",
})
vim.keymap.set('n', '<leader>ff', builtin.git_files, {
  desc = "Find Git Files",
})
vim.keymap.set('n', '<leader>ft', builtin.live_grep, {
  desc = "Find Text",
})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {
  desc = "Find Buffer",
})
