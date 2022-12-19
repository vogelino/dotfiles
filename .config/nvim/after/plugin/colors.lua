function ColorMyPencils(color)
  color = color or "tokyonight-night"
  require("lualine").setup({
    options = {
      theme = "tokyonight-night"
    }
  })
  vim.cmd.colorscheme(color)
end

ColorMyPencils()
