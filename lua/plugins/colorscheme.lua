return {

	-- tokyonight
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		-- opts = { style = "moon" },
		config = function()
			vim.cmd([[colorscheme tokyonight-night]])
		end,
	},

	-- catppuccin
	{
		"catppuccin/nvim",
		-- lazy = true,
		lazy = false,
		name = "catppuccin",
	},
}
