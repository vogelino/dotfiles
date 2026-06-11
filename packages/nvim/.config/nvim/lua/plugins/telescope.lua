---@type LazySpec
return {
  "nvim-telescope/telescope.nvim",
  opts = function(_, opts)
    opts.defaults = opts.defaults or {}
    opts.defaults.mappings = vim.tbl_deep_extend("force", opts.defaults.mappings or {}, {
      i = {
        ["<C-j>"] = "move_selection_next",
        ["<C-k>"] = "move_selection_previous",
      },
      n = {
        ["<C-j>"] = "move_selection_next",
        ["<C-k>"] = "move_selection_previous",
      },
    })

    opts.defaults.qflist_previewer = function(previewer_opts)
      local previewer = require("telescope.previewers").vim_buffer_qflist.new(previewer_opts)
      if not previewer_opts.show_path_in_preview then return previewer end

      local preview_fn = previewer.preview_fn
      previewer.preview_fn = function(self, entry, status)
        local result = preview_fn(self, entry, status)

        vim.schedule(function()
          if not self.state or not self.state.winid or not vim.api.nvim_win_is_valid(self.state.winid) then return end

          local filename = entry.filename
          if not filename and entry.bufnr then filename = vim.api.nvim_buf_get_name(entry.bufnr) end
          if not filename or filename == "" then return end

          local location = string.format("%s:%d:%d", vim.fn.fnamemodify(filename, ":."), entry.lnum, entry.col)
          local escaped_location = location:gsub("%%", "%%%%")
          vim.api.nvim_set_option_value("winbar", "%#TelescopeResultsComment#%=" .. escaped_location, {
            win = self.state.winid,
          })
        end)

        return result
      end

      return previewer
    end

    opts.extensions = opts.extensions or {}
    opts.extensions.fzf = vim.tbl_deep_extend("force", opts.extensions.fzf or {}, {
      fuzzy = true,
      override_file_sorter = true,
      override_generic_sorter = true,
      case_mode = "smart_case",
    })

    return opts
  end,
}
