-- Toggle current line or with count
vim.keymap.set('n', '/', function()
  return vim.v.count == 0
      and '<Plug>(comment_toggle_linewise_current)'
      or '<Plug>(comment_toggle_linewise_count)'
end, { expr = true })

-- Toggle in Op-pending mode (/[count][motion])
-- vim.keymap.set('n', '/', '<Plug>(comment_toggle_linewise)')

-- Toggle in VISUAL mode
vim.keymap.set('x', '/', '<Plug>(comment_toggle_linewise_visual)')
