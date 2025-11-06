-- ================================================================================================
-- TITLE : harpoon
-- ABOUT : Getting you where you want with the fewest keystrokes
-- LINKS :
--   > github            : https://github.com/ThePrimeagen/harpoon
--   > plenary.nvim (dep): https://github.com/nvim-lua/plenary.nvim
-- ================================================================================================

return {
	"thePrimeagen/harpoon",
	enabled = true,
	branch = "harpoon2",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-telescope/telescope.nvim",
	},
	config = function()
		local harpoon = require("harpoon")
		local conf = require("telescope.config").values

		harpoon:setup({
			global_settings = {
				save_on_toggle = true,
				save_on_change = true,
			},
		})

		-- NOTE: Experimenting
		-- Telescope into Harpoon function
		-- comment this function if you don't like it
		-- local function toggle_telescope(harpoon_files)
		-- 	local file_paths = {}
		-- 	for _, item in ipairs(harpoon_files.items) do
		-- 		table.insert(file_paths, item.value)
		-- 	end
		-- 	require("telescope.pickers")
		-- 		.new({}, {
		-- 			prompt_title = "Harpoon",
		-- 			finder = require("telescope.finders").new_table({
		-- 				results = file_paths,
		-- 			}),
		-- 			previewer = conf.file_previewer({}),
		-- 			sorter = conf.generic_sorter({}),
		-- 		})
		-- 		:find()
		-- end

		-- Harpoon Nav Interface
		vim.keymap.set("n", "<leader>a", function()
			harpoon:list():add()
		end, { desc = "Harpoon: Add file" })
		vim.keymap.set("n", "<C-e>", function()
			harpoon.ui:toggle_quick_menu(harpoon:list())
		end, { desc = "Harpoon: Toggle menu" })

		-- Harpoon marked files (using <leader>1-4 to avoid conflicts)
		vim.keymap.set("n", "<leader>1", function()
			harpoon:list():select(1)
		end, { desc = "Harpoon: File 1" })
		vim.keymap.set("n", "<leader>2", function()
			harpoon:list():select(2)
		end, { desc = "Harpoon: File 2" })
		vim.keymap.set("n", "<leader>3", function()
			harpoon:list():select(3)
		end, { desc = "Harpoon: File 3" })
		vim.keymap.set("n", "<leader>4", function()
			harpoon:list():select(4)
		end, { desc = "Harpoon: File 4" })

		-- Toggle previous & next buffers (bracket navigation follows Vim convention)
		vim.keymap.set("n", "[h", function()
			harpoon:list():prev()
		end, { desc = "Harpoon: Previous" })
		vim.keymap.set("n", "]h", function()
			harpoon:list():next()
		end, { desc = "Harpoon: Next" })

		-- Telescope inside Harpoon Window
		-- vim.keymap.set("n", "<C-f>", function()
		-- 	toggle_telescope(harpoon:list())
		-- end)
	end,
}