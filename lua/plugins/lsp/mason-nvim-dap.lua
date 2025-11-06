-- ================================================================================================
-- TITLE : mason-nvim-dap.nvim
-- ABOUT : Mason extension that makes it easier to use nvim-dap with Mason
-- LINKS :
--   > github             : https://github.com/jay-babu/mason-nvim-dap.nvim
--   > mason.nvim (dep)   : https://github.com/williamboman/mason.nvim
--   > nvim-dap (dep)     : https://github.com/mfussenegger/nvim-dap
-- ================================================================================================

return {
    "jay-babu/mason-nvim-dap.nvim",
    dependencies = {
        "williamboman/mason.nvim",
        "mfussenegger/nvim-dap",
    },
    event = "VeryLazy",
    cmd = { "DapInstall", "DapUninstall" },
    opts = {
        ensure_installed = { "delve" },
        automatic_installation = true,
        handlers = {
            function(config)
                require("mason-nvim-dap").default_setup(config)
            end,
            delve = function(config)
                table.insert(config.configurations, 1, {
                    type = "delve",
                    name = "Debug file",
                    request = "launch",
                    program = "${file}",
                    args = function()
                        return vim.split(vim.fn.input("Args: "), " ")
                    end,
                })
                require("mason-nvim-dap").default_setup(config)
            end,
        },
    },
}