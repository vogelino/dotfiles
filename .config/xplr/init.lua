version = '0.20.1'

local home = os.getenv("HOME")
local xpm_path = home .. "/.local/share/xplr/dtomvan/xpm.xplr"
local xpm_url = "https://github.com/dtomvan/xpm.xplr"

package.path = package.path
    .. ";"
    .. xpm_path
    .. "/?.lua;"
    .. xpm_path
    .. "/?/init.lua"

os.execute(
  string.format(
    "[ -e '%s' ] || git clone '%s' '%s'",
    xpm_path,
    xpm_url,
    xpm_path
  )
)

local home = os.getenv("HOME")
package.path = home
    .. "/.config/xplr/plugins/?/init.lua;"
    .. home
    .. "/.config/xplr/plugins/?.lua;"
    .. package.path

require("xpm").setup({
  plugins = {
    'dtomvan/xpm.xplr',
    { name = 'sayanarijit/fzf.xplr' },
    'prncss-xyz/icons.xplr',
    {
      'dtomvan/extra-icons.xplr',
      after = function()
        xplr.config.general.table.row.cols[2] = {
          format = "custom.icons_dtomvan_col_1"
        }
      end
    },
    {
      'sayanarijit/tri-pane.xplr',
      after = function()
        require("tri-pane").setup()
      end
    },
    {
      'sayanarijit/zentable.xplr',
      after = function()
        require("zentable").setup()
      end
    },
  },
  auto_install = true,
  auto_cleanup = true,
})

xplr.config.general.panel_ui.default.borders = { "Top", "Right", "Bottom", "Left" }
xplr.config.general.panel_ui.default.border_type = "Rounded"
xplr.config.general.panel_ui.default.border_style.fg = "Black"
-- xplr.config.general.panel_ui.default.border_style.bg = "Gray"

local function stat(node)
  return node.mime_essence
end

local function read(path, height)
  local p = io.open(path)

  if p == nil then
    return nil
  end

  local i = 0
  local res = ""
  for line in p:lines() do
    if line:match("[^ -~\n\t]") then
      p:close()
      return
    end

    res = res .. line .. "\n"
    if i == height then
      break
    end
    i = i + 1
  end
  p:close()

  return res
end

xplr.config.layouts.builtin.default = {
  Horizontal = {
    config = {
      constraints = {
        { Percentage = 60 },
        { Percentage = 40 },
      },
    },
    splits = {
      "Table",
      {
        CustomContent = {
          title = "preview",
          body = { DynamicParagraph = { render = "custom.preview_pane.render" } },
        },
      },
    },
  },
}

xplr.fn.custom.preview_pane = {}
xplr.fn.custom.preview_pane.render = function(ctx)
  local n = ctx.app.focused_node

  if n and n.canonical then
    n = n.canonical
  end

  if n then
    if n.is_file then
      return read(n.absolute_path, ctx.layout_size.height)
    else
      return stat(n)
    end
  else
    return ""
  end
end
