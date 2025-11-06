-- ================================================================================================
-- TITLE : indent-blankline.nvim
-- ABOUT : Adds indentation guides to all lines (including empty lines)
-- LINKS :
--   > github : https://github.com/lukas-reineke/indent-blankline.nvim
-- ================================================================================================

return {
  { -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    -- Enable `lukas-reineke/indent-blankline.nvim`
    -- See `:help ibl`
    main = 'ibl',
    opts = {
       -- prevent scope highlight/guide, keep indent guides
    },
  },
}
