-- General setting ——————————————————————————————————————————————————————————
vim.opt.compatible = false
vim.opt.wrap = false
vim.opt.hlsearch = false
vim.opt.swapfile = false
vim.opt.backup = false

vim.opt.hidden = true
vim.opt.number = true
vim.opt.so = 7
vim.opt.cmdheight = 2
vim.opt.showmatch = true
vim.opt.linebreak = true
vim.opt.relativenumber = true
vim.opt.backspace = { "indent", "eol", "start" }
vim.opt.showmode = true
vim.opt.signcolumn = "yes"
vim.opt.smartcase = true
vim.opt.colorcolumn = "80"
vim.opt.termguicolors = true
vim.api.nvim_set_hl(0, "colorcolumn", { ctermbg = 1 })

-- Fatser redrawing
vim.opt.ttyfast = true

-- Setup indentation
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smartindent = true

-- Ignores ——————————————————————————————————————————————————————————————————
vim.opt.wildmode = "list:longest"
vim.opt.wildmenu = true -- enable ctrl-n and ctrl-p to scroll thru matches
local wildignore = { -- stuff to ignore when tab completing
  "*.o,*.obj,*~",
  "*vim/backups*",
  "*sass-cache*",
  "*DS_Store*",
  "vendor/rails/**",
  "vendor/cache/**",
  "*.gem",
  "log/**",
  "tmp/**",
  "*.png,*.jpg,*.gif",
  "*/codemetrics/*",
  "*/target/*",
  "*/node_modules/*",
  "*/node/*",
  "*/.git/*",
  "*/.next/*",
  "*/.tmp/*"
}
local allIgnores = ''
for _, v in pairs(wildignore) do
  allIgnores = allIgnores .. v
end
vim.opt.wildignore = allIgnores

vim.opt.incsearch = true
vim.opt.scrolloff = 8
vim.opt.hlsearch = true
vim.opt.ignorecase = true
