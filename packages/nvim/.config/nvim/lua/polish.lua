---@diagnostic disable: undefined-global

-- g:is_notes_pane and g:notes_select_title are set via `nvim --cmd` in notes-toggle.sh.
-- --cmd runs before init.lua, so these globals are available for the entire startup sequence.

vim.api.nvim_create_augroup("MarkdownSettings", { clear = true })

-- New notes only: register a one-shot BufEnter that visually selects the H1 title.
-- --cmd + BufEnter is reliable; VimEnter can be clobbered by AstroNvim plugin init.
if vim.g.notes_select_title then
  vim.api.nvim_create_autocmd("BufEnter", {
    group = "MarkdownSettings",
    once = true,
    pattern = vim.fn.expand("~") .. "/notes/*.md",
    callback = function()
      vim.g.notes_select_title = nil
      -- schedule defers until all BufEnter callbacks for this buffer have run
      vim.schedule(function()
        vim.cmd("normal! ggWvg_")
      end)
    end,
  })
end

vim.api.nvim_create_autocmd("FileType", {
  group = "MarkdownSettings",
  pattern = "markdown",
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
    vim.opt_local.spelllang = { "en_us" }
  end,
})

-- Zen mode for notes: no spell, no numbers, no gutter, no chrome
vim.api.nvim_create_autocmd("BufEnter", {
  group = "MarkdownSettings",
  pattern = vim.fn.expand("~") .. "/notes/*.md",
  callback = function()
    vim.opt_local.autoread = true
    vim.cmd("silent! checktime")
    vim.opt_local.spell = false
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.signcolumn = "no"
    if vim.g.is_notes_pane then
      vim.opt.showtabline = 0
      vim.opt.laststatus = 0
      -- AstroNvim's <leader>c calls :bd, which leaves nvim alive with an empty buffer.
      -- Override it to :qa so VimLeave fires and the sidebar closes cleanly.
      vim.keymap.set("n", "<leader>c", "<cmd>qa<cr>", { buffer = true, silent = true })
    end
  end,
})

-- In the notes sidebar, redirect any non-notes buffer to a new note
vim.api.nvim_create_autocmd("BufEnter", {
  group = "MarkdownSettings",
  callback = function()
    if not vim.g.is_notes_pane then return end
    local name = vim.api.nvim_buf_get_name(0)
    local notes_dir = vim.fn.expand("~/notes")
    if name == "" then return end
    if vim.bo.buftype ~= "" then return end
    if vim.startswith(name, notes_dir) and name:match("%.md$") then return end
    local slug = "new-note-" .. os.date("%Y%m%d-%H%M%S")
    local new_file = notes_dir .. "/" .. slug .. ".md"
    local f = io.open(new_file, "w")
    if f then f:write("# New Note\n\n"); f:close() end
    vim.fn.system("tmux set-environment @notes_last_file " .. vim.fn.shellescape(new_file) .. " 2>/dev/null")
    vim.schedule(function()
      vim.cmd("edit " .. vim.fn.fnameescape(new_file))
      vim.cmd("normal! ggWvg_")
    end)
  end,
})

-- Force-save notes on quit so AstroNvim's confirm=true never fires
vim.api.nvim_create_autocmd("QuitPre", {
  group = "MarkdownSettings",
  pattern = vim.fn.expand("~") .. "/notes/*.md",
  callback = function()
    if vim.bo.modified then vim.cmd("silent! write") end
  end,
})

-- :bd in notes pane leaves nvim alive with [No Name]; quit entirely instead so VimLeave fires
vim.api.nvim_create_autocmd("BufDelete", {
  group = "MarkdownSettings",
  callback = function(ev)
    if not vim.g.is_notes_pane then return end
    if vim.g.notes_closing then return end
    vim.g.notes_closing = true
    -- Save before the buffer disappears
    if vim.api.nvim_buf_is_valid(ev.buf) and vim.bo[ev.buf].modified then
      vim.api.nvim_buf_call(ev.buf, function() vim.cmd("silent! write") end)
    end
    vim.schedule(function() vim.cmd("silent! qa") end)
  end,
})

-- When the notes sidebar exits naturally (not via toggle), close all other notes panes
vim.api.nvim_create_autocmd("VimLeave", {
  group = "MarkdownSettings",
  callback = function()
    if not vim.g.is_notes_pane then return end
    vim.fn.system(vim.fn.expand("~/.dotfiles/packages/tmux/scripts/notes-close-others.sh"))
  end,
})

-- Auto-rename notes based on their H1 heading when saved
vim.api.nvim_create_autocmd("BufWritePost", {
  group = "MarkdownSettings",
  pattern = vim.fn.expand("~") .. "/notes/*.md",
  callback = function()
    local bufname = vim.api.nvim_buf_get_name(0)
    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    local h1
    for _, line in ipairs(lines) do
      h1 = line:match("^# (.+)")
      if h1 then break end
    end
    if not h1 or h1 == "" then return end

    local slug = h1:lower():gsub("[^%w%s%-]", ""):gsub("%s+", "-"):gsub("^%-+", ""):gsub("%-+$", "")
    if slug == "" then return end

    local dir = vim.fn.fnamemodify(bufname, ":h")
    local new_path = dir .. "/" .. slug .. ".md"
    if new_path == bufname then return end

    local final_path = new_path
    local i = 2
    while vim.fn.filereadable(final_path) == 1 and final_path ~= bufname do
      final_path = dir .. "/" .. slug .. "-" .. i .. ".md"
      i = i + 1
    end

    if vim.fn.rename(bufname, final_path) == 0 then
      vim.cmd("silent! keepalt file " .. vim.fn.fnameescape(final_path))
      vim.cmd("silent! write")
      vim.fn.system("tmux set-environment -g @notes_last_file " .. vim.fn.shellescape(final_path) .. " 2>/dev/null")
      vim.notify("Note renamed → " .. vim.fn.fnamemodify(final_path, ":t"), vim.log.levels.INFO)
    end
  end,
})
