---@type LazySpec
return {
  {
    "okuuva/auto-save.nvim",

    event = { "InsertLeave", "TextChanged" },
    opts = {
      enabled = true,
      trigger_events = {
        immediate_save = { "BufLeave", "FocusLost" },
        defer_save = { "InsertLeave", "TextChanged" },
      },
      -- Only auto-save markdown files inside ~/notes/
      condition = function(buf)
        local name = vim.api.nvim_buf_get_name(buf)
        local notes_dir = vim.fn.expand("~/notes")
        return vim.startswith(name, notes_dir) and name:match("%.md$") ~= nil
      end,
      debounce_delay = 1000,
      write_all_buffers = false,
    },
  },
}
