return {
    "hrsh7th/nvim-cmp",
    optional = true,
    opts = function(_, opts)
        local cmp = require("cmp")

        if not opts.mapping then
            opts.mapping = {}
        end

        opts.mapping["<Tab>"] = cmp.mapping(function(fallback)
            -- First try AI completion
            if vim.g.ai_accept and vim.g.ai_accept() then
                return
            end
            -- Then try cmp
            if cmp.visible() then
                cmp.select_next_item()
                -- Then try snippet
            elseif vim.snippet and vim.snippet.active({ direction = 1 }) then
                vim.snippet.jump(1)
            else
                fallback()
            end
        end, { "i", "s" })

        opts.mapping["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif vim.snippet and vim.snippet.active({ direction = -1 }) then
                vim.snippet.jump(-1)
            else
                fallback()
            end
        end, { "i", "s" })

        return opts
    end,
}
