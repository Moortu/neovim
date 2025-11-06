-- ================================================================================================
-- TITLE : mason.nvim
-- ABOUT : Portable package manager for Neovim that installs LSP servers, DAP servers, linters, and formatters
-- LINKS :
--   > github                        : https://github.com/mason-org/mason.nvim
--   > mason-lspconfig.nvim (dep)    : https://github.com/mason-org/mason-lspconfig.nvim
--   > mason-tool-installer.nvim (dep): https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim
-- ================================================================================================

return {
    "mason-org/mason.nvim",
    dependencies = {
        "mason-org/mason-lspconfig.nvim",
        "WhoIsSethDaniel/mason-tool-installer.nvim",
    },
    lazy = false,  -- Mason recommends not lazy-loading
    priority = 999,
    opts = {
        ui = {
            icons = {
                package_installed = "✓",
                package_pending = "➜",
                package_uninstalled = "✗",
            },
        },
    },

}
