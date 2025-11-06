-- ================================================================================================
-- TITLE : nvim-treesitter
-- ABOUT : Treesitter configurations and abstraction layer for Neovim
-- LINKS :
--   > github                       : https://github.com/nvim-treesitter/nvim-treesitter
--   > nvim-treesitter-context (opt): https://github.com/nvim-treesitter/nvim-treesitter-context
-- ================================================================================================

return {
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        event = { "BufReadPost", "BufNewFile" },
        cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
        config = function()
            require("nvim-treesitter.configs").setup({
                ensure_installed = {
                    "vimdoc",
                    "javascript",
                    "typescript",
                    "c",
                    "lua",
                    "rust",
                    "jsdoc",
                    "bash",
                    "go",
                    "markdown",
                    "markdown_inline",
                },
                sync_install = false,
                auto_install = true,
                indent = {
                    enable = true,
                },
                highlight = {
                    enable = true,
                    disable = function(lang, buf)
                        -- Disable HTML highlighting if needed
                        if lang == "html" then
                            return true
                        end

                        -- Disable for large files (>100KB)
                        local max_filesize = 100 * 1024
                        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
                        if ok and stats and stats.size > max_filesize then
                            vim.notify(
                                "File larger than 100KB, treesitter disabled for performance",
                                vim.log.levels.WARN,
                                { title = "Treesitter" }
                            )
                            return true
                        end
                    end,
                    additional_vim_regex_highlighting = { "markdown" },
                },
            })

            -- Custom parser for templ (Go templating)
            local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
            parser_config.templ = {
                install_info = {
                    url = "https://github.com/vrischmann/tree-sitter-templ.git",
                    files = { "src/parser.c", "src/scanner.c" },
                    branch = "master",
                },
            }
            vim.treesitter.language.register("templ", "templ")
        end,
    },

    {
        "nvim-treesitter/nvim-treesitter-context",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        event = { "BufReadPost", "BufNewFile" },
        opts = {
            enable = true,
            multiwindow = false,
            max_lines = 0,
            min_window_height = 0,
            line_numbers = true,
            multiline_threshold = 20,
            trim_scope = "outer",
            mode = "cursor",
            separator = nil,
            zindex = 20,
        },
    },
}
