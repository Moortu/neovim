-- ================================================================================================
-- TITLE : fidget.nvim
-- ABOUT : Extensible UI for Neovim notifications and LSP progress messages
-- LINKS :
--   > github : https://github.com/j-hui/fidget.nvim
-- ================================================================================================

return {
    "j-hui/fidget.nvim",
    event = "LspAttach",
    opts = {
        notification = {
            window = {
                winblend = 0,
            },
        },
    },
}
