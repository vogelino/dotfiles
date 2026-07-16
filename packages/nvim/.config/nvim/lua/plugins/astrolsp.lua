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

local js_ts_filetypes = {
  javascript = true,
  javascriptreact = true,
  typescript = true,
  typescriptreact = true,
}

local function apply_ts_source_action(bufnr, action_kind, client_names)
  client_names = client_names or { "ts_ls", "vtsls" }
  local params = vim.lsp.util.make_range_params(0, "utf-8")
  params.context = {
    diagnostics = {},
    only = { action_kind },
  }

  local results = vim.lsp.buf_request_sync(bufnr, "textDocument/codeAction", params, 1000)
  if not results then return end

  for client_id, response in pairs(results) do
    local client = vim.lsp.get_client_by_id(client_id)
    if client and vim.tbl_contains(client_names, client.name) then
      for _, action in ipairs(response.result or {}) do
        if action.edit then vim.lsp.util.apply_workspace_edit(action.edit, client.offset_encoding or "utf-8") end
        if action.command then client.request_sync("workspace/executeCommand", action.command, 1000, bufnr) end
        return
      end
    end
  end
end

local function js_ts_imports_and_format_on_save(args)
  if not js_ts_filetypes[vim.bo[args.buf].filetype] then return end

  local clients = vim.lsp.get_clients { bufnr = args.buf }
  local has_biome = vim.iter(clients):any(function(c) return c.name == "biome" end)

  apply_ts_source_action(args.buf, "source.removeUnusedImports.ts")
  if has_biome then
    apply_ts_source_action(args.buf, "source.organizeImports.biome", { "biome" })
  else
    apply_ts_source_action(args.buf, "source.organizeImports")
  end

  local astrolsp = require "astrolsp"
  local autoformat = astrolsp.config.formatting.format_on_save
  local buffer_autoformat = vim.b[args.buf].autoformat
  if buffer_autoformat == nil then buffer_autoformat = autoformat.enabled end

  if buffer_autoformat then vim.lsp.buf.format(vim.tbl_deep_extend("force", astrolsp.format_opts, { bufnr = args.buf })) end
end

---@type LazySpec
return {
  "AstroNvim/astrolsp",
  ---@type AstroLSPOpts
  opts = {
    config = {
      eslint = {
        -- root_dir uses the nvim-lspconfig >=0.11 callback signature: it must call
        -- on_dir(root) to start the server, and simply return to skip it.
        root_dir = function(bufnr, on_dir)
          -- Don't start eslint when biome.json is present; biome handles linting
          if vim.fs.root(bufnr, { "biome.json", "biome.jsonc" }) then return end

          -- Prefer the project root (lock file / .git) so monorepos resolve correctly
          local root_markers =
            { "package-lock.json", "yarn.lock", "pnpm-lock.yaml", "bun.lockb", "bun.lock", ".git" }
          local project_root = vim.fs.root(bufnr, root_markers) or vim.fn.getcwd()

          -- Only start eslint if the buffer actually has an eslint config in its tree
          local eslint_config_files = {
            ".eslintrc",
            ".eslintrc.js",
            ".eslintrc.cjs",
            ".eslintrc.mjs",
            ".eslintrc.yaml",
            ".eslintrc.yml",
            ".eslintrc.json",
            "eslint.config.js",
            "eslint.config.mjs",
            "eslint.config.cjs",
            "eslint.config.ts",
            "eslint.config.mts",
            "eslint.config.cts",
          }
          local fname = vim.api.nvim_buf_get_name(bufnr)
          local using_eslint = vim.fs.find(eslint_config_files, {
            path = fname,
            type = "file",
            limit = 1,
            upward = true,
            stop = vim.fs.dirname(project_root),
          })[1]
          if not using_eslint then return end

          on_dir(project_root)
        end,
      },
      biome = {
        root_dir = function(bufnr, on_dir)
          local root = vim.fs.root(bufnr, { "biome.json", "biome.jsonc" })
          if root then on_dir(root) end
        end,
      },
    },
    formatting = {
      disabled = { "ts_ls", "vtsls" },
      format_on_save = {
        enabled = true,
        filter = function(bufnr)
          return not vim.tbl_contains({
            "javascript",
            "javascriptreact",
            "typescript",
            "typescriptreact",
          }, vim.bo[bufnr].filetype)
        end,
      },
    },
    autocmds = {
      js_ts_imports_and_format_on_save = {
        cond = "textDocument/codeAction",
        {
          event = "BufWritePre",
          desc = "Remove unused imports, organize imports, and format JS/TS files on save",
          callback = js_ts_imports_and_format_on_save,
        },
      },
    },
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
