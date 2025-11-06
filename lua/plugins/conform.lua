-- ================================================================================================
-- TITLE : conform.nvim
-- ABOUT : Lightweight yet powerful formatter plugin for Neovim
-- LINKS :
--   > github : https://github.com/stevearc/conform.nvim
-- ================================================================================================

return {
  { -- Autoformat
    'stevearc/conform.nvim',
    dependencies = {
      "WhoIsSethDaniel/mason-tool-installer.nvim",
    },
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<leader>f',
        function()
          require('conform').format { async = true, lsp_format = 'fallback' }
        end,
        mode = '',
        desc = '[F]ormat buffer',
      },
    },
    opts = function()
      local languages = require("config.languages")
      
      return {
        notify_on_error = false,
        format_on_save = function(bufnr)
          local disable_filetypes = languages.format_on_save_exclude
          if disable_filetypes[vim.bo[bufnr].filetype] then
            return nil
          else
            return {
              timeout_ms = 5000,
              lsp_format = 'fallback',
            }
          end
        end,
        formatters_by_ft = languages.get_formatters_by_ft(),
        formatters = languages.formatter_configs,
      }
    end,
    config = function(_, opts)
      require('conform').setup(opts)
      
      -- Ensure formatters are installed
      require("mason-tool-installer").setup({
        ensure_installed = require("config.languages").get_formatters(),
        auto_update = false,
      })
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
