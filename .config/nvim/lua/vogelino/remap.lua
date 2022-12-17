vim.g.mapleader = " "

vim.keymap.set("n", "<leader>x", vim.cmd.Ex, {
  desc = "Nvim Explorer"
})

vim.keymap.set("n", "<C-s>", vim.cmd.update, {})
vim.keymap.set("i", "<Esc>", "<Esc>`^")
vim.keymap.set("n", "<Esc>", vim.cmd.nohl)
-- Jump one half page below/up while centering the cursor on the screen
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
-- Center view on next/prev match
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")
-- Copy selection in visual mode
vim.keymap.set("v", "<C-c>", "y: call system('xclip -i -selection clipboard', getreg('\"'))<CR>")

-- Vim tabs
vim.keymap.set("n", "<leader>n", vim.cmd.enew, {
  desc = "New Buffer"
})
vim.keymap.set("n", "<leader>l", vim.cmd.bnext, {
  desc = "Next Buffer"
})
vim.keymap.set("n", "<leader>h", vim.cmd.bprevious, {
  desc = "Prev Buffer"
})
vim.keymap.set("n", "<leader>w", vim.cmd.bdelete, {
  desc = "Close Buffer"
})
vim.keymap.set("n", "<leader>bl", vim.cmd.ls, {
  desc = "List Buffers"
})

-- Spell checking
vim.keymap.set("", "<leader>ss", ":setlocal spell!<cr>", {
  desc = "Spell Check"
})
