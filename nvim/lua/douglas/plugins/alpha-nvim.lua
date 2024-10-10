
return {
	"goolord/alpha-nvim",
	event = "VimEnter",
	config = function()
		local alpha = require("alpha")
		local dashboard = require("alpha.themes.dashboard")

		-- Set header to display "Hello" in ASCII art, split into lines
		dashboard.section.header.val = {
			" __        __   _                            __  __        ____                      _ _             ",
			" \\ \\      / /__| | ___ ___  _ __ ___   ___  |  \\/  |_ __  / ___|  ___ _ ____   _____| | | ___  _ __  ",
			"  \\ \\ /\\ / / _ \\ |/ __/ _ \\| '_ ` _ \\ / _ \\ | |\\/| | '__| \\___ \\ / _ \\ '__\\ \\ / / _ \\ | |/ _ \\| '_ \\ ",
			"   \\ V  V /  __/ | (_| (_) | | | | | |  __/ | |  | | |     ___) |  __/ |   \\ V /  __/ | | (_) | | | |",
			"    \\_/\\_/ \\___|_|\\___\\___/|_| |_| |_|\\___| |_|  |_|_|    |____/ \\___|_|    \\_/ \\___|_|_|\\___/|_| |_|",
			"                                                                                                     ",
		}

		-- Clear buttons to not display any
		dashboard.section.buttons.val = {}

		-- Send config to alpha
		alpha.setup(dashboard.opts)

		-- Bind Enter key to open Netrw, the default file explorer
		vim.api.nvim_create_autocmd("FileType", {
			pattern = "alpha",
			callback = function()
				-- Use ':Ex' for current window or ':Vex' for vertical split
				vim.api.nvim_buf_set_keymap(0, "n", "<CR>", "<cmd>Ex<CR>", { noremap = true, silent = true })
			end,
		})

		-- Disable folding on alpha buffer
		vim.cmd([[autocmd FileType alpha setlocal nofoldenable]])
	end,
}
