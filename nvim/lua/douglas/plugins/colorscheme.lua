return {
	{
		"morhetz/gruvbox",
		config = function()
			vim.g.gruvbox_italic = 1 -- Enable italicize for certain keywords
			vim.cmd("colorscheme gruvbox")
		end,
	},
	-- Other plugins configurations can go here
}
