-- ================================================================================================
-- TITLE : todo-comments.nvim
-- ABOUT : Highlight, list and search todo comments in your projects
-- LINKS :
--   > github            : https://github.com/folke/todo-comments.nvim
--   > plenary.nvim (dep): https://github.com/nvim-lua/plenary.nvim
-- ================================================================================================

return {
  { 'folke/todo-comments.nvim', event = 'VimEnter', dependencies = { 'nvim-lua/plenary.nvim' }, opts = { signs = false } },
}
-- vim: ts=2 sts=2 sw=2 et
