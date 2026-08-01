return {
	{
		"LazyVim/LazyVim",
		opts = {
			colorscheme = function()
				-- require("gruvbox").load()
				-- require("onedark").load()
				require("vscode").load()
			end,
		},
	},
	-- { "ellisonleao/gruvbox.nvim", priority = 1000, config = true, opts = ... },
	-- { "navarasu/onedark.nvim", priority = 1000, config = true, opts = { style = "deep" } }, -- style: dark, darker, cool, deep, warm, warmer, light
	-- { "shaunsingh/solarized.nvim", name = "solarized", priority = 1000, opts = ... },
	-- { "nyoom-engineering/oxocarbon.nvim", name = "oxocarbon" },
	{ "nyoom-engineering/oxocarbon.nvim", name = "oxocarbon" },
	{ "Mofiqul/vscode.nvim", priority = 1000, config = true, opts = ... },
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		opts = {
			no_italic = true,
			term_colors = true,
			transparent_background = false,
			styles = {
				comments = {},
				conditionals = {},
				loops = {},
				functions = {},
				keywords = {},
				strings = {},
				variables = {},
				numbers = {},
				booleans = {},
				properties = {},
				types = {},
			},
			color_overrides = {
				mocha = {
					base = "#000000",
					mantle = "#000000",
					crust = "#000000",
				},
			},
			integrations = {
				telescope = {
					enabled = true,
					style = "nvchad",
				},
				dropbar = {
					enabled = true,
					color_mode = true,
				},
			},
		},
	},
}
