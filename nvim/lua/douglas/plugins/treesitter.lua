return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "master",
		build = ":TSUpdate",

		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = {
					"c",
					"cpp",
					"lua",
					"vim",
					"vimdoc",
					"query",
					"javascript",
					"html",
				},

				sync_install = false,
				auto_install = true,

				highlight = {
					enable = true,
					additional_vim_regex_highlighting = false,
				},

				indent = {
					enable = false,
				},
			})
		end,
	},
}
