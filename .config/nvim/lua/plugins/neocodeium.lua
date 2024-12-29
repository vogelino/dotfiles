
return {
  "monkoose/neocodeium",
  event = "VeryLazy",
  config = function()
    local neocodeium = require("neocodeium")
    neocodeium.setup()

    vim.keymap.set("i", "<C-l>", neocodeium.accept)
    vim.keymap.set("i", "<C-j>", neocodeium.accept_word, { remap = true, silent = true })
    vim.keymap.set("i", "<C-h>", neocodeium.accept_line)
    vim.keymap.set("i", "<C-x>", neocodeium.cycle_or_complete)
    -- vim.keymap.set("i", "<C-p>", function()
    --   require("neocodeium").cycle_or_complete(-1)
    -- end)
    vim.keymap.set("i", "<C-o>", neocodeium.clear)
  end,
}


