-- ================================================================================================
-- TITLE : trouble.nvim
-- ABOUT : A pretty diagnostics, references, telescope results, quickfix and location list
-- LINKS :
--   > github : https://github.com/folke/trouble.nvim
-- ================================================================================================

return {
    {
        "folke/trouble.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons", "folke/todo-comments.nvim" },
        cmd = "Trouble",
        keys = {
            -- Diagnostics
            { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Trouble: Diagnostics (Workspace)" },
            { "<leader>d", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Trouble: Buffer Diagnostics" },
            
            
            -- LSP
            { "gr", "<cmd>Trouble lsp_references toggle<cr>", desc = "Trouble: LSP References" },
            { "gd", "<cmd>Trouble lsp_definitions toggle<cr>", desc = "Trouble: LSP Definitions" },
            { "gD", "<cmd>Trouble lsp_declarations toggle<cr>", desc = "Trouble: LSP Declarations" },
            { "gi", "<cmd>Trouble lsp_implementations toggle<cr>", desc = "Trouble: LSP Implementations" },
            { "gt", "<cmd>Trouble lsp_type_definitions toggle<cr>", desc = "Trouble: LSP Type Definitions" },

           
            -- Symbols
            { "<leader>cs", "<cmd>Trouble lsp_document_symbols toggle<cr>", desc = "Trouble: Document Symbols" },
            { "<leader>cS", "<cmd>Trouble lsp_workspace_symbols toggle<cr>", desc = "Trouble: Workspace Symbols" },
            
            -- Lists
            { "<leader>xl", "<cmd>Trouble loclist toggle<cr>", desc = "Trouble: Location List" },
            { "<leader>xq", "<cmd>Trouble qflist toggle<cr>", desc = "Trouble: Quickfix List" },
            { "<leader>xt", "<cmd>Trouble todo toggle<CR>", desc = "Open todos in trouble" },
            -- Navigation
            { "[q", function() require("trouble").prev({ skip_groups = true, jump = true }) end, desc = "Trouble: Previous Item" },
            { "]q", function() require("trouble").next({ skip_groups = true, jump = true }) end, desc = "Trouble: Next Item" },
        },
        opts = {
            focus = true, -- Focus trouble window when opened
        },
    },
}