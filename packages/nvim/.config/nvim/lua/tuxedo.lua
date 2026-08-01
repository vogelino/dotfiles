local M = {}

local win_id = nil
local buf_id = nil

local config_defaults = {
  create_todo_file = true,
  width_ratio = 0.95,
  height_ratio = 0.80,
}

M.config = {}

-- Always resolve to the git-tracked todo dir in the private dotfiles repo.
-- Deliberately no project-local fallback: a `<git root>/todo.txt` is untracked, so
-- `git clean -fdx` eats it, and when nvim's cwd isn't the git root `tuxedo` finds no
-- ./todo.txt and silently opens a sample in $TMPDIR that macOS later purges.
local function get_todo_paths()
  local private_dir = vim.env.DOTFILES_PRIVATE_DIR or (vim.env.HOME .. "/repos/dotfiles-private")
  local dir = vim.env.TODO_DIR or (private_dir .. "/data/todo")
  local todo_file = vim.env.TODO_FILE or (dir .. "/todo.txt")
  local done_file = vim.env.DONE_FILE or (dir .. "/done.txt")

  return dir, todo_file, done_file
end

local function ensure_todo_files()
  local dir, todo_file, done_file = get_todo_paths()

  if M.config.create_todo_file then
    for _, path in ipairs({ todo_file, done_file }) do
      local parent = vim.fn.fnamemodify(path, ":h")
      if vim.fn.isdirectory(parent) == 0 then vim.fn.mkdir(parent, "p") end
      if vim.fn.filereadable(path) == 0 then vim.fn.writefile({}, path) end
    end
  end

  return dir, todo_file, done_file
end

function M.tuxedo()
  if win_id and vim.api.nvim_win_is_valid(win_id) then
    vim.api.nvim_win_close(win_id, true)
    win_id = nil
    buf_id = nil
    return
  end

  local todo_dir, todo_file, done_file = ensure_todo_files()

  local uis = vim.api.nvim_list_uis()
  if #uis == 0 then return end

  local width = uis[1].width
  local height = uis[1].height

  local win_width = math.ceil(width * M.config.width_ratio)
  local win_height = math.ceil(height * M.config.height_ratio)

  local row = math.ceil((height - win_height) / 2) - 1
  local col = math.ceil((width - win_width) / 2)

  buf_id = vim.api.nvim_create_buf(false, true)

  local win_opts = {
    relative = "editor",
    width = win_width,
    height = win_height,
    row = row,
    col = col,
    style = "minimal",
    border = "rounded",
    title = " Tuxedo ",
    title_pos = "center",
  }

  win_id = vim.api.nvim_open_win(buf_id, true, win_opts)

  vim.api.nvim_set_option_value("bufhidden", "wipe", { buf = buf_id })

  -- Pass the file explicitly and re-export the env: nvim only inherits TODO_FILE when
  -- it was launched from an interactive zsh (it comes from ~/.local/bin/env via .zshrc),
  -- so a GUI/launchd/stale-tmux nvim would otherwise land in the $TMPDIR sample.
  vim.fn.termopen({ "tuxedo", todo_file }, {
    env = {
      TODO_DIR = todo_dir,
      TODO_FILE = todo_file,
      DONE_FILE = done_file,
    },
    on_exit = function()
      if win_id and vim.api.nvim_win_is_valid(win_id) then
        vim.api.nvim_win_close(win_id, true)
        win_id = nil
        buf_id = nil
      end
    end,
  })

  vim.api.nvim_set_option_value("filetype", "todo", { buf = buf_id })
  vim.cmd "startinsert"
end

function M.setup(opts)
  opts = opts or {}
  M.config = vim.tbl_deep_extend("force", {}, config_defaults, M.config, opts)
  vim.api.nvim_create_user_command("Tuxedo", function() M.tuxedo() end, {})
end

return M
