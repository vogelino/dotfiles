local function code_first_lsp_entry_maker()
  local entry_display = require "telescope.pickers.entry_display"
  local make_entry = require "telescope.make_entry"

  local displayer = entry_display.create {
    items = {
      { remaining = true },
    },
  }

  local function make_display(entry)
    local text = vim.trim(entry.text or "")
    text = text:gsub(".* | ", "")

    return displayer { text }
  end

  return function(entry)
    local filename = entry.filename
    if not filename and entry.bufnr then filename = vim.api.nvim_buf_get_name(entry.bufnr) end

    return make_entry.set_default_entry_mt({
      value = entry,
      ordinal = string.format("%s %s", entry.text or "", filename or ""),
      display = make_display,

      bufnr = entry.bufnr,
      filename = filename,
      lnum = entry.lnum,
      col = entry.col,
      text = entry.text,
      start = entry.start,
      finish = entry.finish,
    }, {})
  end
end

local function lsp_location_picker_opts()
  return {
    entry_maker = code_first_lsp_entry_maker(),
    show_path_in_preview = true,
  }
end

---@type LazySpec
return {
  "AstroNvim/astrolsp",
  ---@type AstroLSPOpts
  opts = {
    mappings = {
      n = {
        gd = {
          function() require("telescope.builtin").lsp_definitions(lsp_location_picker_opts()) end,
          desc = "Show the definition of current symbol",
          cond = "textDocument/definition",
        },
        gI = {
          function() require("telescope.builtin").lsp_implementations(lsp_location_picker_opts()) end,
          desc = "Implementation of current symbol",
          cond = "textDocument/implementation",
        },
        gy = {
          function() require("telescope.builtin").lsp_type_definitions(lsp_location_picker_opts()) end,
          desc = "Definition of current type",
          cond = "textDocument/typeDefinition",
        },
        ["<Leader>lG"] = {
          function() require("telescope.builtin").lsp_workspace_symbols() end,
          desc = "Search workspace symbols",
          cond = "workspace/symbol",
        },
        ["<Leader>lR"] = {
          function() require("telescope.builtin").lsp_references(lsp_location_picker_opts()) end,
          desc = "Search references",
          cond = "textDocument/references",
        },
      },
    },
  },
}
