-- ================================================================================================
-- TITLE : neotest
-- ABOUT : An extensible framework for interacting with tests within Neovim
-- LINKS :
--   > github                    : https://github.com/nvim-neotest/neotest
--   > nvim-nio (dep)            : https://github.com/nvim-neotest/nvim-nio
--   > plenary.nvim (dep)        : https://github.com/nvim-lua/plenary.nvim
--   > nvim-treesitter (dep)     : https://github.com/nvim-treesitter/nvim-treesitter
--   > neotest-java (adapter)    : https://github.com/rcasia/neotest-java
--   > neotest-kotlin (adapter)  : https://github.com/codymikol/neotest-kotlin
--   > neotest-gradle (adapter)  : https://github.com/weilbith/neotest-gradle
-- ================================================================================================

return {
    "nvim-neotest/neotest",
    dependencies = {
        "nvim-neotest/nvim-nio",
        "nvim-lua/plenary.nvim",
        "antoinemadec/FixCursorHold.nvim",
        "nvim-treesitter/nvim-treesitter",
        "rcasia/neotest-java",
        "codymikol/neotest-kotlin",
        "weilbith/neotest-gradle",
    },
    keys = {
        { "<leader>tr", function() require("neotest").run.run() end, desc = "Test: Run Nearest" },
        { "<leader>ts", function() require("neotest").run.run({ suite = true }) end, desc = "Test: Run Suite" },
        { "<leader>td", function() require("neotest").run.run({ strategy = "dap" }) end, desc = "Test: Debug Nearest" },
        { "<leader>ta", function() require("neotest").run.run(vim.fn.getcwd()) end, desc = "Test: Run All" },
        { "<leader>tv", function() require("neotest").summary.toggle() end, desc = "Test: Toggle Summary" },
        { "<leader>to", function() require("neotest").output.open() end, desc = "Test: Open Output" },
        { "<leader>tO", function() require("neotest").output_panel.toggle() end, desc = "Test: Toggle Output Panel" },
        { "<leader>tS", function() require("neotest").run.stop() end, desc = "Test: Stop" },
    },
    config = function()
        require("neotest").setup({
            adapters = {
                require("neotest-java")({
                    dap = { justMyCode = false },
                }),
                require("neotest-kotlin")({
                    dap = { justMyCode = false },
                }),
                require("neotest-gradle")({
                    dap = { justMyCode = false },
                }),
            },
        })
    end,
}