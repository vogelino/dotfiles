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

local biome_config_files = { "biome.json", "biome.jsonc" }
local oxlint_config_files = { ".oxlintrc.json", ".oxlintrc.jsonc", "oxlint.config.ts" }
local oxfmt_config_files = { ".oxfmtrc.json", ".oxfmtrc.jsonc", "oxfmt.config.ts" }
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

local function concat_lists(...)
  local result = {}
  for _, list in ipairs { ... } do
    vim.list_extend(result, list)
  end
  return result
end

local function nearest_config(bufnr, config_files)
  return vim.fs.find(config_files, {
    path = vim.api.nvim_buf_get_name(bufnr),
    type = "file",
    limit = 1,
    upward = true,
  })[1]
end

local function tool_root_dir(config_files, competing_config_files, prefer_repo_root)
  return function(bufnr, on_dir)
    local selected_config = nearest_config(bufnr, concat_lists(config_files, competing_config_files))
    if not selected_config or not vim.tbl_contains(config_files, vim.fs.basename(selected_config)) then return end

    local repo_root = vim.fs.root(bufnr, { ".git" })
    if prefer_repo_root and repo_root then
      for _, config_file in ipairs(config_files) do
        if vim.uv.fs_stat(vim.fs.joinpath(repo_root, config_file)) then
          on_dir(repo_root)
          return
        end
      end
    end

    on_dir(vim.fs.dirname(selected_config))
  end
end

local function typescript_root_dir(bufnr, on_dir)
  if vim.fs.root(bufnr, { "deno.json", "deno.jsonc", "deno.lock" }) then return end

  local path = vim.fs.dirname(vim.api.nvim_buf_get_name(bufnr))
  while path do
    if vim.uv.fs_stat(vim.fs.joinpath(path, "node_modules", "typescript", "lib", "tsserver.js")) then
      on_dir(path)
      return
    end

    local parent = vim.fs.dirname(path)
    if parent == path then break end
    path = parent
  end

  local fallback_root = vim.fs.root(bufnr, {
    { "package-lock.json", "yarn.lock", "pnpm-lock.yaml", "bun.lockb", "bun.lock" },
    { ".git" },
  })
  on_dir(fallback_root or vim.fn.getcwd())
end

local function apply_source_action(bufnr, action_kind, client_name)
  local client = vim
    .iter(vim.lsp.get_clients { bufnr = bufnr })
    :find(function(item) return item.name == client_name end)
  if not client then return end

  local params = vim.lsp.util.make_range_params(0, "utf-8")
  params.context = {
    diagnostics = {},
    only = { action_kind },
  }

  local response = client:request_sync("textDocument/codeAction", params, 1000, bufnr)
  for _, action in ipairs(response and response.result or {}) do
    if action.edit then vim.lsp.util.apply_workspace_edit(action.edit, client.offset_encoding or "utf-8") end
    if action.command then client:request_sync("workspace/executeCommand", action.command, 1000, bufnr) end
    return
  end
end

local function js_ts_imports_and_format_on_save(args)
  if not js_ts_filetypes[vim.bo[args.buf].filetype] then return end

  local clients = vim.lsp.get_clients { bufnr = args.buf }
  local has_oxlint = vim.iter(clients):any(function(c) return c.name == "oxlint" end)
  if has_oxlint then apply_source_action(args.buf, "source.fixAll.oxc", "oxlint") end

  local astrolsp = require "astrolsp"
  local autoformat = astrolsp.config.formatting.format_on_save
  local buffer_autoformat = vim.b[args.buf].autoformat
  if buffer_autoformat == nil then buffer_autoformat = autoformat.enabled end

  if buffer_autoformat then
    vim.lsp.buf.format(vim.tbl_deep_extend("force", astrolsp.format_opts, { bufnr = args.buf }))
  end
end

---@type LazySpec
return {
  "AstroNvim/astrolsp",
  ---@type AstroLSPOpts
  opts = {
    config = {
      ts_ls = {
        -- Start at the nearest package that provides TypeScript so the language
        -- server uses the project's SDK instead of Mason's bundled version.
        root_dir = typescript_root_dir,
      },
      eslint = {
        -- root_dir uses the nvim-lspconfig >=0.11 callback signature: it must call
        -- on_dir(root) to start the server, and simply return to skip it.
        root_dir = function(bufnr, on_dir)
          local selected_config =
            nearest_config(bufnr, concat_lists(eslint_config_files, biome_config_files, oxlint_config_files))
          if not selected_config or not vim.tbl_contains(eslint_config_files, vim.fs.basename(selected_config)) then
            return
          end

          -- Prefer the project root (lock file / .git) so monorepos resolve correctly
          local root_markers = { "package-lock.json", "yarn.lock", "pnpm-lock.yaml", "bun.lockb", "bun.lock", ".git" }
          local project_root = vim.fs.root(bufnr, root_markers) or vim.fn.getcwd()
          on_dir(project_root)
        end,
      },
      biome = {
        root_dir = tool_root_dir(
          biome_config_files,
          concat_lists(eslint_config_files, oxlint_config_files, oxfmt_config_files),
          false
        ),
      },
      oxlint = {
        root_dir = tool_root_dir(oxlint_config_files, concat_lists(eslint_config_files, biome_config_files), true),
      },
      oxfmt = {
        root_dir = tool_root_dir(oxfmt_config_files, biome_config_files, true),
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
          desc = "Apply Oxlint fixes and format JS/TS files on save",
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
