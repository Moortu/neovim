-- ================================================================================================
-- TITLE : nvim-cmp
-- ABOUT : A completion plugin for Neovim coded in Lua
-- LINKS :
--   > github                 : https://github.com/hrsh7th/nvim-cmp
--   > cmp-nvim-lsp (dep)     : https://github.com/hrsh7th/cmp-nvim-lsp
--   > cmp-buffer (dep)       : https://github.com/hrsh7th/cmp-buffer
--   > cmp-path (dep)         : https://github.com/hrsh7th/cmp-path
--   > LuaSnip (dep)          : https://github.com/L3MON4D3/LuaSnip
--   > cmp_luasnip (dep)      : https://github.com/saadparwaiz1/cmp_luasnip
-- ================================================================================================

return {
    "hrsh7th/nvim-cmp",
    dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip",
    },
    event = "InsertEnter",
    config = function()
        local cmp = require("cmp")
        local luasnip = require("luasnip")

        cmp.setup({
            snippet = {
                expand = function(args)
                    luasnip.lsp_expand(args.body)
                end,
            },
            mapping = cmp.mapping.preset.insert({
                ["<C-p>"] = cmp.mapping.select_prev_item(),
                ["<C-n>"] = cmp.mapping.select_next_item(),
                ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                ["<C-f>"] = cmp.mapping.scroll_docs(4),
                ["<C-Space>"] = cmp.mapping.complete(),
                ["<C-e>"] = cmp.mapping.abort(),
                ["<CR>"] = cmp.mapping.confirm({ select = true }),
            }),
            sources = cmp.config.sources({
                { name = "nvim_lsp" },
                { name = "luasnip" },
                { name = "path" },
            }, {
                { name = "buffer" },
            }),
            formatting = {
                format = function(entry, vim_item)
                    vim_item.menu = ({
                        nvim_lsp = "[LSP]",
                        luasnip = "[Snippet]",
                        buffer = "[Buffer]",
                        path = "[Path]",
                    })[entry.source.name]
                    return vim_item
                end,
            },
        })
    end,
}
