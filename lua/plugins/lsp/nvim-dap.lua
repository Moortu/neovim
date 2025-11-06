-- ================================================================================================
-- TITLE : nvim-dap
-- ABOUT : Debug Adapter Protocol client implementation for Neovim
-- LINKS :
--   > github : https://github.com/mfussenegger/nvim-dap
-- ================================================================================================

return {
    "mfussenegger/nvim-dap",
    event = "VeryLazy",
    config = function()
        local dap = require("dap")
        dap.set_log_level("DEBUG")

        -- Keymaps (using F-keys as per nvim-dap official recommendations)
        vim.keymap.set("n", "<F8>", dap.continue, { desc = "Debug: Continue" })
        vim.keymap.set("n", "<F10>", dap.step_over, { desc = "Debug: Step Over" })
        vim.keymap.set("n", "<F11>", dap.step_into, { desc = "Debug: Step Into" })
        vim.keymap.set("n", "<F12>", dap.step_out, { desc = "Debug: Step Out" })
        
        -- Breakpoint keymaps
        vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "Debug: Toggle Breakpoint" })
        vim.keymap.set("n", "<leader>dB", function()
            dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
        end, { desc = "Debug: Conditional Breakpoint" })
    end,
}