---@diagnostic disable: undefined-global

-- This will run last in the setup process and is a good place to configure
-- things like custom filetypes. This is just pure lua so anything that doesn't
-- fit in the normal config locations above can go here

-- Create an autocommand group for Markdown settings
vim.api.nvim_create_augroup("MarkdownSettings", { clear = true })

-- Define the autocommand for Markdown files
vim.api.nvim_create_autocmd("FileType", {
  group = "MarkdownSettings",
  pattern = "markdown",
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
    vim.opt_local.spelllang = { "en_us" }

    -- Auto-enable zen-mode for better reading experience
    vim.defer_fn(function()
      require("zen-mode").open({
        window = {
          width = .6
        }
      })
    end, 100)
  end,
})
