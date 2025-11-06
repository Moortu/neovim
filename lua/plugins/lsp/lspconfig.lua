-- ================================================================================================
-- TITLE : nvim-lspconfig
-- ABOUT : Quickstart configurations for the Neovim LSP client
-- LINKS :
--   > github                  : https://github.com/neovim/nvim-lspconfig
--   > mason.nvim (dep)        : https://github.com/williamboman/mason.nvim
--   > mason-lspconfig (dep)   : https://github.com/williamboman/mason-lspconfig.nvim
--   > cmp-nvim-lsp (dep)      : https://github.com/hrsh7th/cmp-nvim-lsp
-- ================================================================================================

return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "williamboman/mason.nvim",
        "mason-org/mason-lspconfig.nvim",
        "hrsh7th/cmp-nvim-lsp",
    },
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        local languages = require("config.languages")
        local cmp_nvim_lsp = require("cmp_nvim_lsp")

        -- Ensure LSP servers are installed via mason-lspconfig
        require("mason-lspconfig").setup({
            ensure_installed = languages.get_lsp_servers(),
            automatic_installation = true,
        })

        -- Get capabilities from completion plugin
        local capabilities = vim.lsp.protocol.make_client_capabilities()
        capabilities = cmp_nvim_lsp.default_capabilities(capabilities)

        -- LSP Keymaps (set on LSP attach)
        local function on_attach(client, bufnr)
            local opts = { buffer = bufnr, silent = true }

            -- Note: Navigation keymaps (gd, gr, gi, etc.) are handled by Trouble plugin
            -- to provide a better UI for viewing definitions/references/implementations
            
            -- Hover documentation
            vim.keymap.set('n', 'K', function()
                vim.lsp.buf.hover { border = "rounded", max_height = 25, max_width = 120 }
            end, { desc = "Hover documentation" })
            -- Actions
            vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { buffer = bufnr, desc = "LSP: Rename" })
            vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { buffer = bufnr, desc = "LSP: Code Action" })

            -- Diagnostic navigation (using native LSP for quick jumping, Trouble for viewing)
            vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { buffer = bufnr, desc = "LSP: Previous Diagnostic" })
            vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { buffer = bufnr, desc = "LSP: Next Diagnostic" })
        end

        -- Diagnostic configuration
        vim.diagnostic.config({
            virtual_text = true,
            signs = true,
            underline = true,
            update_in_insert = false,
            severity_sort = true,
            float = {
                focusable = false,
                style = "minimal",
                border = "rounded",
                source = "always",
                header = "",
                prefix = "",
            },
        })

        -- Diagnostic signs
        local signs = {
            { name = "DiagnosticSignError", text = "" },
            { name = "DiagnosticSignWarn", text = "" },
            { name = "DiagnosticSignHint", text = "󰠠" },
            { name = "DiagnosticSignInfo", text = "" },
        }

        for _, sign in ipairs(signs) do
            vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
        end

        -- Setup LSP servers using Neovim's new API when available
        local languages = require("config.languages")
        local servers = languages.get_lsp_servers()

        local has_new_api = vim.lsp and vim.lsp.config and vim.lsp.enable
        local lspconfig_lib = nil
        if not has_new_api then
            lspconfig_lib = require("lspconfig")
        end

        for _, server in ipairs(servers) do
            local opts = { capabilities = capabilities, on_attach = on_attach }

            if server == "lua_ls" then
                opts.settings = {
                    Lua = {
                        diagnostics = { globals = { "vim" } },
                        workspace = { library = vim.api.nvim_get_runtime_file("", true) },
                    },
                }
            elseif server == "clangd" then
                opts.cmd = {
                    "clangd",
                    "--background-index",
                    "--clang-tidy",
                    "--header-insertion=iwyu",
                    "--completion-style=detailed",
                    "--function-arg-placeholders",
                }
            end

            if has_new_api then
                vim.lsp.config(server, opts)
                vim.lsp.enable(server)
            elseif lspconfig_lib and lspconfig_lib[server] then
                -- Fallback for Neovim versions without the new API
                lspconfig_lib[server].setup(opts)
            end
        end
    end,
}
