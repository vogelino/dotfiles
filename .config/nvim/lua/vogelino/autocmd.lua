-- Delete trailing white space on save ——————————————————————————————————————
function DeleteTrailingWS()
  vim.cmd("exe 'normal mz'")
  vim.cmd("%s/\\s\\+$//ge")
  vim.cmd("exe 'normal `z'")
end

vim.api.nvim_create_autocmd({ "BufWrite" }, {
  callback = DeleteTrailingWS
})
