return {
	-- Assuming 'ThePrimeagen/harpoon' is the plugin you're configuring
	"ThePrimeagen/harpoon",
	dependencies = { "nvim-lua/plenary.nvim" }, -- Specify dependencies here
	config = function()
		local mark = require("harpoon.mark")
		local ui = require("harpoon.ui")

		-- Adds the current file to Harpoon's mark list
		vim.keymap.set("n", "<leader>a", function()
			mark.add_file() -- Marks the current file
			-- Optional: here you could add logic to keep only the latest 4 marks
		end, { desc = "Add file to Harpoon and assign to quick access" })

		-- Toggles the Harpoon quick menu
		vim.keymap.set("n", "<C-e>", ui.toggle_quick_menu, { desc = "Toggle Harpoon quick menu" })

		-- Navigation keymaps for accessing the first four marks
		vim.keymap.set("n", "<C-h>", function()
			ui.nav_file(1)
		end, { desc = "Navigate to Harpoon mark 1" })
		vim.keymap.set("n", "<C-t>", function()
			ui.nav_file(2)
		end, { desc = "Navigate to Harpoon mark 2" })
		vim.keymap.set("n", "<C-n>", function()
			ui.nav_file(3)
		end, { desc = "Navigate to Harpoon mark 3" })
		vim.keymap.set("n", "<C-s>", function()
			ui.nav_file(4)
		end, { desc = "Navigate to Harpoon mark 4" })
	end,
}
