-- ================================================================================================
-- TITLE : oil.nvim
-- ABOUT : A file explorer that lets you edit your filesystem like a normal Neovim buffer
-- LINKS :
--   > github                 : https://github.com/stevearc/oil.nvim
--   > nvim-web-devicons (dep): https://github.com/nvim-tree/nvim-web-devicons
-- ================================================================================================

return {
	"stevearc/oil.nvim",
	-- enabled = false,
	dependencies = { "nvim-tree/nvim-web-devicons" },
	lazy = false, -- Load immediately since it's the default file explorer
	keys = {
		{ "<leader>-", "<CMD>Oil<CR>", desc = "Oil: Open parent directory" },
		{ "<leader>e", function() require("oil").toggle_float() end, desc = "Oil: Toggle float" },
	},
	opts = {
		default_file_explorer = true,
		columns = {},
		keymaps = {
			["<C-h>"] = false, -- Preserve for tmux-navigator
			["<C-c>"] = false, -- Prevent closing Oil (use as esc)
			["<M-h>"] = "actions.select_split",
			["q"] = "actions.close",
		},
		delete_to_trash = true,
		view_options = {
			show_hidden = true,
		},
		skip_confirm_for_simple_edits = true,
	},
	config = function(_, opts)
		require("oil").setup(opts)

		-- Enable cursorline in Oil buffers
		vim.api.nvim_create_autocmd("FileType", {
			pattern = "oil",
			callback = function()
				vim.opt_local.cursorline = true
			end,
		})
	end,
}