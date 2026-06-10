return {
  "L3MON4D3/LuaSnip",
  config = function(plugin, opts)
    require("astronvim.plugins.configs.luasnip")(plugin, opts)

    local luasnip = require("luasnip")

    -- Load custom Lua snippets from snippets directory
    require("luasnip.loaders.from_lua").lazy_load({
      paths = { vim.fn.stdpath("config") .. "/lua/snippets" },
    })

    -- Extend filetypes
    luasnip.filetype_extend("typescript", { "typescriptreact" })
    luasnip.filetype_extend("javascript", { "javascriptreact" })
  end,
}
